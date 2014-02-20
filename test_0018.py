# Test of a function with side effects and return value

from numpy import array

def transform0018(m):
    m += array([1,2,3]) # Sum of arrays with side effect
    m += 1 # Point-wise addition with side-effect
    m *= m # Point-wise squaring with side effect

    m = m + 1 # Point wise addition witout side-effect
    # Variable was refefined. No more side effects to it.

    m += 1 
    m *= m
    m += m + array([1,2,3]);
    return m 
