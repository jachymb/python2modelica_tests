# Assigns ones to a matrix to the upper-left
# 2x2 submatrix using various assignments.
# Using syntax alternatives.

from numpy import ones

def asgn0015(m):
    m[0,:2] = [0,0] # assins zeros to first row of submatrix
    m[:2][0] = (1,1) # assigns ones to first col of submatrix (alt. syntax)
    m[1][1] = m[0,0] # copes 00 element to 11 element
    m[:1,1:2] = ones((1,1)) # assigns 1x1 ones matrix to element 01
    # Notice no return value.
    # The function works by directly modifying the array. (It's NOT passed by copy.)
