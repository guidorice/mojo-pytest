from example.tests.util import MojoTest


fn main() raises:
    test_warning_is_collected()


fn test_warning_is_collected():
    """
    Cause a compiler warning.

    > warning: unreachable code after return statement

    This can be captured by running `pytest -W error` (warning -> error mode).
    """
    let test = MojoTest("compiler warning")
    return
    let x = 100
    print(x)
