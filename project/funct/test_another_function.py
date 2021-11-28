import numpy as np
from another_function import *
import pytest

def test_function_subtract():
    a, b = np.random.randn(10), np.random.randn(10)
    np.testing.assert_almost_equal(subtract_two_arrays(a, b), a-b, decimal=2)

def test_function_matrix_mult():
    a, b = np.random.random((10, 10)), np.random.random((10, 10))
    np.testing.assert_almost_equal(matrix_mult(a, b), a@b, decimal=2)
