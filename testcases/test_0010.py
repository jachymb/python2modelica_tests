# Simillar to 0009, but concatenates on different dimension and
# uses alternative syntax.

from numpy import concatenate,array

def cat0010():
    matrixa = array(((1,2), (3,4)))
    matrixb = array(((5,6),(7,8)))
    return concatenate((matrixa, matrixb), axis=1)
    # alternative:
    # return concatenate((matrixa, matrixb), 1)
