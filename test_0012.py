# same as 0011 but using fill method instead

from numpy import empty

def test0012(r):
    matrix = empty((2,2))
    # here could be any operations on matrix that 
    # don't change it's size. 
    matrix.fill(r)
    return matrix
