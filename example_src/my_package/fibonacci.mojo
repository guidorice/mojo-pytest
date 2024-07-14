fn fibonacci(n: Int) -> Int:
    """
    The Nth Fibonacci number.
    """
    if n <= 1:
        return n
    
    var a = 0
    var b = 1
    for _ in range(2, n + 1):
        a, b = b, a + b
    return b
