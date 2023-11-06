from example.mod_a.impl import maths
from example.tests.util import assert_true


fn main() raises:
    test_maths()
    test_maths_more()
    test_maths_lotsmore()


fn test_maths() raises:
    print("# maths")
    let result = maths(8)
    let expect = 64
    assert_true(result == expect, "maths unexpected result: " + String(result))


fn test_maths_more() raises:
    print("# maths more")
    let result = maths(9)
    let expect = 81
    assert_true(result == expect, "maths unexpected result: " + String(result))


fn test_maths_lotsmore() raises:
    for i in range(40, 50):
        print("# maths more: " + String(i))
        let result = maths(i)
        if result == i:
            raise Error("bad maths: " + String(i))
