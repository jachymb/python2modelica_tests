# constant function which concanates 2 matrices
# Note: in python, the default value for concatenation
# dimmension is 0, which corresponds to modelica's 1.

from numpy import concatenate,array

def cat0009():
    matrixa = array([[1,2],[3,4]])
    matrixb = array([[5,6],[7,8]])
    return concatenate([matrixa, matrixb])
