"""
Tests the test suffix form of discovery ex: something_test.mojo
"""
from example.tests.util import MojoTest


fn main() raises:
    test()


fn test() raises:
    var test = MojoTest("test suffix discovery")
    test.assert_true(True, "")
