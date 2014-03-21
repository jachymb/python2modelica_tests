#!/usr/bin/python
import ast
import sys

print(ast.dump(ast.parse(open(sys.argv[1]).read()), True if len(sys.argv) > 2 else False, False))
#print(ast.dump(ast.parse(open(sys.argv[1]).read()), False, False))
