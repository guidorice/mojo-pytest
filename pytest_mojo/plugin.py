import json
import subprocess
from pathlib import Path
from typing import Any
import shlex

from pytest import File, Item, Package, Parser


MOJO_TEST = ["mojo", "test", "--diagnostic-format", "json"]
"""
Mojo command to be run by this pytest plugin.
"""

TEST_PREFIX = "test_"
"""
Examples of test prefix: `test_something.mojo` or `test_xyz.🔥`
"""

TEST_SUFFIX = "_test"
"""
Examples of test suffix: `something_test.mojo` or `xyz_test.🔥`
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
    parser.addoption("--mojo-include",  help="Mojo package include path.")


class MojoTestFile(File):
    """
    `mojo test --collect-only` the source file, then parse the stdout and exit code into one or more `MojoTestItem`.
    """

    def collect(self):
        mojo_include_path = self.config.getoption("--mojo-include")
        mojo_src = str(self.path)
        shell_cmd = MOJO_TEST.copy()
        shell_cmd.append("--collect-only")
        if mojo_include_path:
            shell_cmd.extend(["-I", mojo_include_path])
        shell_cmd.append(mojo_src)
        process = subprocess.run(shell_cmd, capture_output=True, text=True)

        # early-out of there was a mojo parser error (tests cannot be discovered in this case)
        if not process.stdout and process.returncode != 0:
            raise MojoTestException(process.stderr)

        # parsed collected tests and generate MojoTestItems for each child
        report = json.loads(process.stdout)
        for test_metadata in report.get("children", []):
            id = test_metadata.get("id", None)
            tokens = id.split("::")
            name = tokens[1]
            yield MojoTestItem.from_parent(
                self,
                name=name,
                spec=test_metadata,
            )


class MojoTestItem(Item):
    def __init__(self, *, name: str, parent, spec: dict[str, Any], **kwargs):
        super().__init__(name, parent, **kwargs)
        self.spec = spec

    def runtest(self):
        mojo_include_path = self.config.getoption("--mojo-include")
        shell_cmd = MOJO_TEST.copy()

        if mojo_include_path:
            shell_cmd.extend(["-I", mojo_include_path])
        target = self.spec.get("id", None)

        # `mojo test`` apparently needs shell=True to work.
        shell_cmd.append(shlex.quote(target))
        shell_cmd_str = " ".join(shell_cmd)
        process = subprocess.run(shell_cmd_str, capture_output=True, text=True, shell=True)

        # early-out of there was a mojo parser error (tests cannot be discovered in this case)
        print("stdout:", process.stdout)
        print("stderr:", process.stderr)

        if not process.stdout and process.returncode != 0:
            raise MojoTestException(process.stderr)

        report = json.loads(process.stdout)
        kind = report.get("kind", None)
        error = report.get("error", None)
        if error:
            raise MojoTestException(kind + ":"+ report.get("stdErr") + report.get("stdOut"))

    def repr_failure(self, excinfo):
        return str(excinfo)

    def reportinfo(self):
        line_num = self.spec.get("startLine", 0)
        return self.path, line_num, self.name


class MojoTestException(Exception):
    pass
