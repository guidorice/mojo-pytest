"""
Tests the test suffix form of discovery ex: something_test.mojo
"""
from example.tests.util import MojoTest


def main():
    test()


fn test() raises:
    var test = MojoTest("test suffix discovery")
    test.assert_true(True, "")
