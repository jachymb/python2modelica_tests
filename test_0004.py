# A simple test of while loop.
# Finds the fractional part of a positive 'float'
# using a dumb loop.
# Note: The algotithm returns a variable which is a parameter.
# That's not possible in modelica, transaltion must generate 
# a new name for the output variable.

def fractional0004(r):
    while r >= 1. :
        r -= 1.
    return r
