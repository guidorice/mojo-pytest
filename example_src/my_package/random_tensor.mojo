from python import Python
from tensor import Tensor, TensorShape

var Shape = TensorShape(100, 1)

fn random_tensor[T: DType]() raises -> Tensor[T]:
    """
    Just wraps Tensor.rand().
    """
    return Tensor[T].rand(Shape) * Tensor[T].rand(Shape) * Tensor[T].rand(Shape)
