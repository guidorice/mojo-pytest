from example.mod_b.impl import greet
from example.tests.util import assert_true


fn main() raises:
    test_greet()


fn test_greet() raises:
    print("# greet result")
    let result = greet("guido")
    let expect = "Hey guido"
    assert_true(result == expect, "greet unexpected result: " + String(result))
