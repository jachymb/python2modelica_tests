# constant function which concanates 2 matrices

from numpy import concatenate,array

def cat0009():
    matrixa = array([[1,2],[3,4]])
    matrixb = array([[5,6],[7,8]])
    return concatenate([matrixa, matrixb])
