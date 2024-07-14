def fibonacci(n: int) -> int:
    """
    The Nth Fibonacci number.
    """
    if n <= 1:
        return n
    a = 0
    b = 1
    for _ in range(2, n + 1):
        a, b = b, a + b
    return b
