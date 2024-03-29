from example.mod_a.impl import maths, convert_different
from example.tests.util import MojoTest


fn main() raises:
    test_convert_different()


fn test_convert_different() raises:
    var test = MojoTest("convert_different")
    var x: Int = 8
    var expect = SIMD[DType.float16](8)
    var result = convert_different(x)
    test.assert_true(result == expect, "convert unexpected result: " + String(result))
