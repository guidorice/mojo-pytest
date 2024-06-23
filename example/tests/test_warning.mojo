from example.tests.util import MojoTest


def main():
    test_warning_is_collected()


fn test_warning_is_collected():
    """
    Cause a compiler warning.

    > warning: unreachable code after return statement

    This can be captured by running `pytest -W error` (warning -> error mode).
    """
    var test = MojoTest("compiler warning")
    return
    var x = 100
    print(x)
