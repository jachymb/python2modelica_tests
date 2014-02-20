# rather simple test of built-in functions

from numpy import linspace, identity, product, sum


def test0019(n):
    m = identity(n)
    m += linspace(0,1,n)
    return sum(m)
