# List querying test 
# Returns true if list contains 1.

def hasone0023(lst):
    lst.extend([2,2]) # We need something like this to be sure
                      # that lst is a list, not numpy.array.
                      # Has side effect.
    return 1 in lst
