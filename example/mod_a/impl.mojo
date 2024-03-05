fn maths(x: Int) -> Int:
    var THE_ANSWER = 42
    if x == THE_ANSWER:
        return x
    return x**2


fn convert(x: Int) -> SIMD[DType.float64]:
    var tmp: SIMD[DType.float64] = x
    return tmp


fn convert_different(x: Int) -> SIMD[DType.float16]:
    return SIMD[DType.float16](x)
