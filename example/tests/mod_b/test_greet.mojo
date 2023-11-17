from example.mod_b.impl import greet
from example.tests.util import MojoTest


fn main() raises:
    test_greet()


fn test_greet() raises:
    let test = MojoTest("greet result")
    let result = greet("guido")
    let expect = "Hey guido"
    test.assert_true(result == expect, "greet unexpected result: " + String(result))
