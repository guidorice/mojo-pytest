from python import Python
from testing import assert_equal
from my_package.fibonacci import fibonacci


def test_fibonacci():
    """
    Test fibonacci 10th number.
    """
    var expect = 55
    var got = fibonacci(10)
    assert_equal(got, expect)


def test_fibonacci_reference():
    """
    Test mojo fibonacci versus python "reference" implementation.
    """
    var py = Python.import_module("my_package.fibonacci")
    for n in range(0, 10):
        var expect = py.fibonacci(n)
        var got = fibonacci(n)
        assert_equal(got, expect)
