from example.mod_a.impl import maths
from example.tests.util import MojoTest


fn main() raises:
    test_maths()
    test_maths_more()
    test_maths_lotsmore()


fn test_maths() raises:
    let test = MojoTest("maths")
    let result = maths(8)
    let expect = 64
    test.assert_true(result == expect, "maths unexpected result: " + String(result))


fn test_maths_more() raises:
    let test = MojoTest("maths more")
    let result = maths(9)
    let expect = 81
    test.assert_true(result == expect, "maths unexpected result: " + String(result))


fn test_maths_lotsmore() raises:
    for i in range(40, 50):
        let test = MojoTest("maths more: " + String(i))
        let result = maths(i)
        if result == i:
            test.assert_true(False, "bad maths: " + String(i))
