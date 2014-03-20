#!/usr/bin/python
import ast
import sys

print(ast.dump(ast.parse(open(sys.argv[1]).read()), True, False))
#print(ast.dump(ast.parse(open(sys.argv[1]).read()), False, False))
