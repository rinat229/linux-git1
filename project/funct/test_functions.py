import numpy as np
from functions import *
import pytest

def test_function_add():
    a, b = np.random.randn(10), np.random.randn(10)
    np.testing.assert_almost_equal(add_two_arrays(a, b), a+b, decimal=2)

def test_function_scalar_mult():
    a, b = np.random.randn(10), np.random.randn(10)
    np.testing.assert_almost_equal(scalar_mult(a, b), a@b, decimal=2)

def test_function_outer():
    a, b = np.random.randn(10), np.random.randn(10)
    np.testing.assert_almost_equal(outer_product(a, b), np.outer(a, b), decimal=2)