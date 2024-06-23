from example.tests.util import MojoTest


def main():
    test_assertion_is_collected()


fn test_assertion_is_collected():
    """
    Cause a debug assertion.

    > Assert Error:Intentional debug_assert failure

    This can be captured by running `pytest --mojo-assertions` (warning -> error mode).
    """
    var test = MojoTest("debug_assert")

    var condition = False
    debug_assert(condition, "Intentional debug_assert failure")
