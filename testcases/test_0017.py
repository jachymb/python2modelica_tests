# Another test for array arithmetics on a 3-element array

from numpy import array

def transform0017(m):

    # Here the translator infers that m is 3*2 array
    m = m - array([[1,2],[3,4],[5,6]]) # difference of arrays
    
    # But...
    m = m - array([7,7])
    # This is valid in python. The translator must expand the RHS array.

    m = m / 2 # point-wise division
    return m
