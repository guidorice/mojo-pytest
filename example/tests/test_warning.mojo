from example.tests.util import MojoTest


fn main() raises:
    test_warning_is_collected()


fn test_warning_is_collected():
    """
    Cause a compiler warning.

    > warning: 'x' was declared as a 'var' but never mutated, consider switching to a 'let'")

    This can be captured by running `pytest -W error` (warning -> error mode).
    """
    let test = MojoTest("compiler warning")
    var x = 100
    print(x)
