# List indexing operations

def listtest0022(lst):
    del lst[0] # Side effect
    first = lst[0]
    last = lst[-1]
    return first + last
