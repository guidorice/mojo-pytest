from example.mod_a.impl import maths, convert_different
from example.tests.util import assert_true


fn main() raises:
    test_convert_different()


fn test_convert_different() raises:
    print("# convert_different")
    let x: Int = 8
    let expect = SIMD[DType.float16](8)
    let result = convert_different(x)
    assert_true(result == expect, "convert unexpected result: " + String(result))
