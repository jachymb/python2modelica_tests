#!/usr/bin/python
# This script formats the grammar to better readable form and generates list of tokens
from functools import reduce
from operator import add
import sys

def semanticRule(production, head, indent):
    return '%s\n%s{ cout << "Reducing <%s> to %s" << endl; }' % (production, " "*(indent+2), production, head)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: %s [infile] [tokenoutfile]")
        sys.exit()

    with open(sys.argv[1]) as agf:
        rules = [l.replace(";","").split(":",1) for l in agf.read().splitlines()]
        rules = [(l[0].strip(), list(map(str.strip, l[1].split("|")))) for l in rules]
    heads, prods =  tuple(zip(*rules))
    indentsize = max(map(len, heads)) + 1
    for head, productions in rules:
        print(("{0:<%s}: {1}" % indentsize).format(head, semanticRule(productions[0], head, indentsize)))
        for production in productions[1:]:
            print(" "*indentsize + "| " + semanticRule(production, head, indentsize)) 
        print(";")

    nottokens = set(heads).union({"'('", "')'", "'['", "']'", "','", "/*", "*/", "empty", "'b'"})
    # Also do not print tokens for data types
    nottokens = nottokens.union({"string", "object", "singleton"})

    tokens = set(reduce(add, [p.split(" ") for p in reduce(add, prods)]))
    with open(sys.argv[2], "w") as tf:
        print("\n".join(sorted(tokens.difference(nottokens))), file=tf)

