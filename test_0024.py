# Test of for loop with a list
# Returns double of the sum of list elements

def fortest0024(lst):
    lst.extend(lst) # Side effect
    result = 0.0
    for elem in lst:
        result += elem
    return result
