fn test_assertion_is_collected():
    """
    Cause a debug assertion.

    > Assert Error:Intentional debug_assert failure

    """
    var condition = False
    debug_assert(condition, "Intentional debug_assert failure")
