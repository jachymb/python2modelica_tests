# simple test of for cycle using a range.
# for cycle can iterate over many kinds of objects
# but ranges are common for enumeration and easily
# translated to modelica.
#
# This function computes the sum of even numbers 
# lesser than parameter. It requires int values.

def sum_even0003(n):
    result = 0;
    for x in range(0, n, 2):
        result += x
    return result
