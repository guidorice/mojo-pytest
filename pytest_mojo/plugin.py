import subprocess
from pathlib import Path
from typing import Any

from pytest import File, Item, Package, Parser


MOJO_CMD = ["mojo", "run", "-I", "."]
"""
Mojo command to be run by pytest. This assumes your Mojo package is a subdirectory of cwd.
"""

TEST_PREFIX = "test_"
"""
Examples of test prefix: `test_something.mojo` or `test_xyz.🔥`
"""

TEST_SUFFIX = "_test"
"""
Examples of test suffix: `something_test.mojo` or `xyz_test.🔥`
"""

TEST_ITEM_PREFIX = "#"
"""
By convention, a comment line (hashtag) signals the test item name.
"""

TEST_FAILED_TAG = "AssertionError: "
"""
This is the tag used in Mojo assertions in the util.mojo module.
"""


def pytest_collect_file(parent: Package, file_path: Path) -> File | None:
    """
    Pytest hook
    """
    if file_path.suffix in (".mojo", ".🔥") and (
        file_path.stem.startswith(TEST_PREFIX) or file_path.stem.endswith(TEST_SUFFIX)
    ):
        return MojoTestFile.from_parent(parent, path=file_path)
    return None

def pytest_addoption(parser: Parser):
    """
    Pytest hook
    """
    parser.addoption("--mojo-assertions", action="store_true",  dest="mojo_assertions", help="Passes -D MOJO_ENABLE_ASSERTIONS to mojo.")


class MojoTestFile(File):
    """
    `mojo run` the source file, then parse the stdout and exit code into one or more `MojoTestItem`.
    """

    def collect(self):
        warning_mode = self.config.getoption("-W")
        assertions_mode = self.config.getoption("--mojo-assertions")
        mojo_src = str(self.path)
        shell_cmd = MOJO_CMD.copy()
        if assertions_mode:
            shell_cmd.extend(["-D", "MOJO_ENABLE_ASSERTIONS"])
        shell_cmd.append(mojo_src)

        process = subprocess.run(shell_cmd, capture_output=True, text=True)

        # early-out of there was a mojo parser error (tests cannot be discovered in this case)
        if not process.stdout and process.returncode != 0:
            raise MojoTestException(process.stderr)

        # check stderr for any compile warnings, and create new test item dynamically (just a way to surface to pytest).
        if process.stderr and warning_mode and "error" in warning_mode:
            lines = process.stderr.split("\n")
            lines = [line.strip() for line in lines]
            for line in lines:
                if "warning:" in line:
                    yield MojoTestItem.from_parent(
                        self, name="warning", spec=dict(stdout=[line], code=1)
                    )

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
                        self,
                        name=cur_item,
                        spec=dict(stdout=item_stdout, code=0),
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
        super().__init__(name.removeprefix(TEST_ITEM_PREFIX), parent, **kwargs)
        self.spec = spec

    def runtest(self):
        if self.spec.get("code") or any(
            TEST_FAILED_TAG in item for item in self.spec["stdout"]
        ):
            raise MojoTestException(self, self.spec["stdout"][-1])

    def repr_failure(self, excinfo):
        return str(excinfo.value)

    def reportinfo(self):
        return self.path, 0, self.name


class MojoTestException(Exception):
    pass
