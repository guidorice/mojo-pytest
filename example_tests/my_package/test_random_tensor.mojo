from testing import assert_true, assert_false
from utils.numerics import isfinite, isnan
from my_package.random_tensor import random_tensor

def test_random_tensor():
    """
    Validate the random_tensor module in my_package.
    """
    alias T = DType.float64
    t = random_tensor[T]()
    sample_value = t[0]
    assert_false(isnan(sample_value))
    assert_true(isfinite(sample_value))
