import random
from tensor import Tensor


fn random_tensor[dtype: DType]() -> Tensor[dtype]:
    """
    Generate a random 100 x 1 tensor of the specified floating point type.
    """
    constrained[dtype.is_floating_point(), "dtype must be floating point"]()
    a = Tensor[dtype](100, 1)
    random.rand(a.unsafe_ptr(), a.num_elements())
    return a
