# Tests behaviour of empty arrays
# Should always return 1-dim empty array
# Regardless of parameter, which is 
# a 3-element array. (Size must be inferred)

from numpy import array

def test0016(r):
    empty1 = array([]) # Dimensions: (0,)
    
    # Note: function empty creates with unspecified
    # values, not necessarilly empty array.
    empty2 = empty((3,0)) # Dimensions: (3,0)
    
    return r.dot(empty2) + empty1
