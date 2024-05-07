from builtin._location import __call_location


@value
struct MojoTest:
    """
    A utility struct for testing.
    """

    var test_name: String

    fn __init__(inout self, test_name: String):
        self.test_name = test_name
        print("# " + test_name)

    @always_inline("nodebug")
    fn assert_true(self, cond: Bool, message: String):
        """
        If the condition is false, prints MojoPytestError and call location.
        """
        if not cond:
            var call_loc = __call_location()
            print(call_loc.file_name, ":", str(call_loc.line), ":", str(call_loc.col), ": ", "AssertionError: " , message, sep="")
