# simple function to test functions ones, zeros, fill
# returns 2x2 matrix with all elements identical to parameter
# Note: here zeros/ones use different parameter sytax
# both syntaxes are possible for both.

from numpy import ones,zeros
def test0011(r):
    matrix = zeros((2,2))
    matrix += (r * ones([2,2]))
    return matrix



