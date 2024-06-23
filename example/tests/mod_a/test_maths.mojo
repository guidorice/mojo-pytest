from example.mod_a.impl import maths
from example.tests.util import MojoTest


def main():
    test_maths()
    test_maths_more()
    test_maths_lotsmore()


fn test_maths() raises:
    var test = MojoTest("maths")
    var result = maths(8)
    var expect = 64
    test.assert_true(result == expect, "maths unexpected result: " + str(result))


fn test_maths_more() raises:
    var test = MojoTest("maths more")
    var result = maths(9)
    var expect = 81
    test.assert_true(result == expect, "maths unexpected result: " + str(result))


fn test_maths_lotsmore() raises:
    for i in range(40, 50):
        var test = MojoTest("maths more: " + str(i))
        var result = maths(i)
        if result == i:
            test.assert_true(False, "bad maths: " + str(i))
