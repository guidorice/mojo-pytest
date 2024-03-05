from example.mod_a.impl import maths, convert, convert_different
from example.tests.util import MojoTest


fn main() raises:
    test_convert()


fn test_convert() raises:
    var test = MojoTest("convert")
    var x: Int = 42
    var expect = SIMD[DType.float64](42)
    var result = convert(x)
    test.assert_true(result == expect, "convert unexpected result: " + String(result))
