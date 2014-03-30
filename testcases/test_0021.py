# A function for testing list modification,
# just adds some elements to the end.
# Translator should infer that the parameter is a list and 
# not an array from the usage of the append method,
# which arrays don't have.

def listtest0021(lst):
    lst = lst + [1.0, 2.0] # Redefinition, no side effect. += would cause side effects
    lst.append(3.0) 
    return lst
