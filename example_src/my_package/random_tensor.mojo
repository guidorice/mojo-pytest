from python import Python
from tensor import Tensor, TensorShape


fn random_tensor[T: DType]() raises -> Tensor[T]:
    """
    Wraps Tensor.rand() and multiplies a few tensors.
    """
    var Shape = TensorShape(100, 1)
    return Tensor[T].rand(Shape) * Tensor[T].rand(Shape) * Tensor[T].rand(Shape)
