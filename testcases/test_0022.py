# List indexing operations

def listtest0022(lst):
    lst.append(0.0) # Side effect
    del lst[0] # Side effect
    first = lst[0]
    last = lst[-1]
    return first + last
