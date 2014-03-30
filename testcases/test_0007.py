# Simple example for usage of numpy arrays.
# The function performs some operations on a 2x2 real matrix.
# Returns a 2x3 matrix.
# The matrix dimensions have to be inferred by the translator and
# a local variable has to be created (I think).

from numpy import ones,array,dot

def transform0007(m):
    m = m + ones((2,2)) # Adds 1 to each element of m.
                     # Alernative syntax: ones([2,2])
    m = m + 1           # Again, adds 1 to each element.
    m = dot(m, array(((1,0,1),(0,2,1))))
                     # Multipilies m by aother matrix
                     # Alternative syntax: [[1,0,1],[0,2,1]]
    return m
