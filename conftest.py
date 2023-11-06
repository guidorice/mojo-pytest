import subprocess
from pathlib import Path
from typing import Any

from pytest import Package, File, Item

MOJO_CMD = ["mojo", "run", "-I", "."]
"""
Mojo command to be run by pytest. This assumes your Mojo package is a subdirectory of cwd.
"""

TEST_PREFIX = "test_"
"""
Examples of test prefix: `test_something.mojo` or `test_xyz.🔥`
"""

TEST_ITEM_PREFIX = "#"
"""
By convention, a comment line (hashtag) signals the test item name.
"""


def pytest_collect_file(parent: Package, file_path: Path) -> File | None:
    if file_path.suffix in (".mojo", ".🔥") and file_path.name.startswith(TEST_PREFIX):
        return MojoTestFile.from_parent(parent, path=file_path)
    return None


class MojoTestFile(File):
    """
    `mojo run` the source file, then parse the stdout and exit code into one or more `MojoTestItem`.
    """

    def collect(self):
        mojo_src = str(self.path)
        shell_cmd = MOJO_CMD.copy()
        shell_cmd.append(mojo_src)

        process = subprocess.run(shell_cmd, capture_output=True, text=True)

        # early-out of there was a mojo parser error (tests cannot be discovered in this case)
        if not process.stdout and process.returncode != 0:
            raise MojoTestException(process.stderr)

        # extract result stdout into one or more MojoTestItem
        lines = process.stdout.split("\n")
        lines = [line.strip() for line in lines]
        item_stdout = []
        cur_item = None
        for line in lines:
            print(
                line
            )  # is captured by default: we can view this stdout with pytest -s

            if line.startswith(TEST_ITEM_PREFIX):
                if cur_item is not None:
                    yield MojoTestItem.from_parent(
                        self, name=cur_item, spec=dict(stdout=item_stdout, code=0)
                    )
                cur_item = line
                item_stdout = []
            else:
                if line:
                    item_stdout.append(line)
        if cur_item is not None:
            yield MojoTestItem.from_parent(
                self,
                name=cur_item,
                spec=dict(stdout=item_stdout, code=process.returncode),
            )


class MojoTestItem(Item):
    def __init__(self, *, name: str, parent, spec: dict[str, Any], **kwargs):
        super().__init__(name, parent, **kwargs)
        self.spec = spec

    def runtest(self):
        if self.spec["code"] != 0:
            raise MojoTestException(self, self.spec["stdout"][-1])

    def repr_failure(self, excinfo):
        return str(excinfo.value)

    def reportinfo(self):
        return self.path, 0, self.name


class MojoTestException(Exception):
    pass
