import testing


fn assert_true(cond: Bool, message: String) raises:
    """
    Wraps testing.assert_true, raises Error on assertion failure.
    """
    if not testing.assert_true(cond, message):
        raise Error(message)
