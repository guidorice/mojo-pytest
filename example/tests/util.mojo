import testing


@value
struct MojoTest:
    """
    A utility struct for testing.
    """

    var test_name: String

    fn __init__(inout self, test_name: String):
        self.test_name = test_name
        print("# " + test_name)

    fn assert_true(self, cond: Bool, message: String):
        """
        Wraps testing.assert_true.
        """
        try:
            testing.assert_true(cond, message)
        except e:
            print(e)
