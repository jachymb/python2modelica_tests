# Indexing test.
# Returns sum of the elements of a matrix using 
# various indexing operations.
# dimensions of matrix are general, but at least 2x2
# 
# Beware: numpy.sum behaves differently on multidimmensional 
# arrays than  __builtins__.sum !!!


from numpy import sum

def sum0013(m):
    first_row = m[0]
    # alternative using Ellipsis:
    # first_row = m[0, ...]
    
    first_col = m[:, 0]
    
    right_down_square = m[1:, 1:]

    return sum(first_row) + first_col.sum() + sum(right_down_square) - m[0][0]

