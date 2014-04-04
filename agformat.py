#!/usr/bin/python
# This script formats the grammar to better readable form and generates list of tokens
from functools import reduce
from operator import add
import sys

SPECIALTOKENS = {"LPAREN": '(', "RPAREN": ')', "COMMA": ",", "LBRACE": '[', "RBRACE": ']̈́'}

GRAMMAR = """mod : Module LPAREN LBRACE listof_stmt RBRACE RPAREN
stmt : FunctionDef LPAREN string COMMA arguments COMMA LBRACE listof_stmt RBRACE COMMA LBRACE listof_expr RBRACE COMMA optional_expr RPAREN | ClassDef LPAREN string COMMA LBRACE listof_expr RBRACE COMMA LBRACE listof_keyword RBRACE COMMA optional_expr COMMA optional_expr COMMA LBRACE listof_stmt RBRACE COMMA LBRACE listof_expr RBRACE RPAREN | Return LPAREN optional_expr RPAREN | Delete LPAREN LBRACE listof_expr RBRACE RPAREN | Assign LPAREN LBRACE listof_expr RBRACE COMMA expr RPAREN | AugAssign LPAREN expr COMMA pyoperator COMMA expr RPAREN | For LPAREN expr COMMA expr COMMA LBRACE listof_stmt RBRACE COMMA LBRACE listof_stmt RBRACE RPAREN | While LPAREN expr COMMA LBRACE listof_stmt RBRACE COMMA LBRACE listof_stmt RBRACE RPAREN | If LPAREN expr COMMA LBRACE listof_stmt RBRACE COMMA LBRACE listof_stmt RBRACE RPAREN | With LPAREN LBRACE listof_withitem RBRACE COMMA LBRACE listof_stmt RBRACE RPAREN | Raise LPAREN optional_expr COMMA optional_expr RPAREN | Try LPAREN LBRACE listof_stmt RBRACE COMMA LBRACE listof_excepthandler RBRACE COMMA LBRACE listof_stmt RBRACE COMMA LBRACE listof_stmt RBRACE RPAREN | Assert LPAREN expr COMMA optional_expr RPAREN | Import LPAREN LBRACE listof_alias RBRACE RPAREN | ImportFrom LPAREN optional_identifier COMMA LBRACE listof_alias RBRACE COMMA optional_object RPAREN | Global LPAREN LBRACE listof_identifier RBRACE RPAREN | Nonlocal LPAREN LBRACE listof_identifier RBRACE RPAREN | Expr LPAREN expr RPAREN | Pass LPAREN RPAREN | Break LPAREN RPAREN | Continue LPAREN RPAREN
expr : BoolOp LPAREN boolop COMMA LBRACE listof_expr RBRACE RPAREN | BinOp LPAREN expr COMMA pyoperator COMMA expr RPAREN | UnaryOp LPAREN unaryop COMMA expr RPAREN | Lambda LPAREN arguments COMMA expr RPAREN | IfExp LPAREN expr COMMA expr COMMA expr RPAREN | Dict LPAREN LBRACE listof_expr RBRACE COMMA LBRACE listof_expr RBRACE RPAREN | Set LPAREN LBRACE listof_expr RBRACE RPAREN | ListComp LPAREN expr COMMA LBRACE listof_comprehension RBRACE RPAREN | SetComp LPAREN expr COMMA LBRACE listof_comprehension RBRACE RPAREN | DictComp LPAREN expr COMMA expr COMMA LBRACE listof_comprehension RBRACE RPAREN | GeneratorExp LPAREN expr COMMA LBRACE listof_comprehension RBRACE RPAREN | Yield LPAREN optional_expr RPAREN | YieldFrom LPAREN expr RPAREN | Compare LPAREN expr COMMA LBRACE listof_cmpop RBRACE COMMA LBRACE listof_expr RBRACE RPAREN | Call LPAREN expr COMMA LBRACE listof_expr RBRACE COMMA LBRACE listof_keyword RBRACE COMMA optional_expr COMMA optional_expr RPAREN | Num LPAREN object RPAREN | Str LPAREN string RPAREN | Bytes LPAREN b string RPAREN | NameConstant LPAREN singleton RPAREN | Ellipsis LPAREN RPAREN | Attribute LPAREN expr COMMA string COMMA expr_context RPAREN | Subscript LPAREN expr COMMA slice COMMA expr_context RPAREN | Starred LPAREN expr COMMA expr_context RPAREN | Name LPAREN string COMMA expr_context RPAREN | List LPAREN LBRACE listof_expr RBRACE COMMA expr_context RPAREN | Tuple LPAREN LBRACE listof_expr RBRACE COMMA expr_context RPAREN
expr_context : Load LPAREN RPAREN | Store LPAREN RPAREN | Del LPAREN RPAREN | AugLoad LPAREN RPAREN | AugStore LPAREN RPAREN | Param LPAREN RPAREN
slice : Slice LPAREN optional_expr COMMA optional_expr COMMA optional_expr RPAREN | ExtSlice LPAREN LBRACE listof_slice RBRACE RPAREN | Index LPAREN expr RPAREN
boolop : OpAnd LPAREN RPAREN | OpOr LPAREN RPAREN
pyoperator : OpAdd LPAREN RPAREN | OpSub LPAREN RPAREN | OpMult LPAREN RPAREN | OpDiv LPAREN RPAREN | OpMod LPAREN RPAREN | OpPow LPAREN RPAREN | OpLShift LPAREN RPAREN | OpRShift LPAREN RPAREN | OpBitOr LPAREN RPAREN | OpBitXor LPAREN RPAREN | OpBitAnd LPAREN RPAREN | OpFloorDiv LPAREN RPAREN
unaryop : OpInvert LPAREN RPAREN | OpNot LPAREN RPAREN | OpUAdd LPAREN RPAREN | OpUSub LPAREN RPAREN
cmpop : OpEq LPAREN RPAREN | OpNotEq LPAREN RPAREN | OpLt LPAREN RPAREN | OpLtE LPAREN RPAREN | OpGt LPAREN RPAREN | OpGtE LPAREN RPAREN | OpIs LPAREN RPAREN | OpIsNot LPAREN RPAREN | OpIn LPAREN RPAREN | OpNotIn LPAREN RPAREN
comprehension : comprehension_ LPAREN expr COMMA expr COMMA LBRACE listof_expr RBRACE RPAREN
excepthandler : ExceptHandler LPAREN optional_expr COMMA optional_identifier COMMA LBRACE listof_stmt RBRACE RPAREN
arguments : arguments_ LPAREN LBRACE listof_arg RBRACE COMMA optional_arg COMMA LBRACE listof_arg RBRACE COMMA LBRACE listof_expr RBRACE COMMA optional_arg COMMA LBRACE listof_expr RBRACE RPAREN
arg : arg_ LPAREN string COMMA optional_expr RPAREN
keyword : keyword_ LPAREN string COMMA expr RPAREN
alias : alias_ LPAREN string COMMA optional_identifier RPAREN
withitem : withitem_ LPAREN expr COMMA optional_expr RPAREN
singleton : True | False | None
optional_expr : expr | None
optional_identifier : string | None
optional_object : object | None
optional_arg : arg | None
listof_stmt : stmt COMMA listof_stmt | stmt |
listof_expr : expr COMMA listof_expr | expr |
listof_keyword : keyword COMMA listof_keyword | keyword |
listof_withitem : withitem COMMA listof_withitem | withitem |
listof_excepthandler : excepthandler COMMA listof_excepthandler | excepthandler |
listof_alias : alias COMMA listof_alias | alias |
listof_identifier : string COMMA listof_identifier | string |
listof_comprehension : comprehension COMMA listof_comprehension | comprehension |
listof_cmpop : cmpop COMMA listof_cmpop | cmpop |
listof_slice : slice COMMA listof_slice | slice |
listof_arg : arg COMMA listof_arg | arg |"""

ARGNAMES = {'List': ('elts', 'ctx'), 'Attribute': ('value', 'attr', 'ctx'), 'Import': ('names',), 'If': ('test', 'body', 'orelse'), 'Name': ('id', 'ctx'), 'Is': (), 'Store': (), 'Not': (), 'ListComp': ('elt', 'generators'), 'comprehension_': ('target', 'iter', 'ifs'), 'Assert': ('test', 'msg'), 'FunctionDef': ('name', 'args', 'body', 'decorator_list', 'returns'), 'GeneratorExp': ('elt', 'generators'), 'Assign': ('targets', 'value'), 'Try': ('body', 'handlers', 'orelse', 'finalbody'), 'AugAssign': ('target', 'op', 'value'), 'Mult': (), 'Lambda': ('args', 'body'), 'IsNot': (), 'keyword_': ('argid', 'value'), 'arguments_': ('args', 'vararg', 'kwonlyargs', 'kw_defaults', 'kwarg', 'defaults'), 'USub': (), 'IfExp': ('test', 'body', 'orelse'), 'Sub': (), 'DictComp': ('key', 'value', 'generators'), 'Ellipsis': (), 'Num': ('n',), 'Del': (), 'UnaryOp': ('op', 'operand'), 'NameConstant': ('value',), 'Gt': (), 'Subscript': ('value', 'subscriptslice', 'ctx'), 'Load': (), 'Pow': (), 'YieldFrom': ('value',), 'With': ('items', 'body'), 'NotEq': (), 'While': ('test', 'body', 'orelse'), 'Eq': (), 'BitXor': (), 'Delete': ('targets',), 'Pass': (), 'Raise': ('exc', 'cause'), 'Invert': (), 'FloorDiv': (), 'NotIn': (), 'SetComp': ('elt', 'generators'), 'Module': ('body',), 'Add': (), 'arg_': ('argid', 'annotation'), 'alias_': ('name', 'asname'), 'GtE': (), 'ImportFrom': ('module', 'names', 'level'), 'Div': (), 'ExtSlice': ('dims',), 'Nonlocal': ('names',), 'Yield': ('value',), 'Str': ('s',), 'Slice': ('lower', 'upper', 'step'), 'AugLoad': (), 'In': (), 'BitAnd': (), 'withitem_': ('context_expr', 'optional_vars'), 'Global': ('names',), 'Continue': (), 'Dict': ('keys', 'values'), 'LShift': (), 'Set': ('elts',), 'Starred': ('value', 'ctx'), 'Call': ('func', 'args', 'keywords', 'starargs', 'kwargs'), 'Return': ('value',), 'Mod': (), 'Tuple': ('elts', 'ctx'), 'BitOr': (), 'Expr': ('value',), 'For': ('target', 'iter', 'body', 'orelse'), 'And': (), 'Compare': ('left', 'ops', 'comparators'), 'Lt': (), 'Break': (), 'BinOp': ('left', 'op', 'right'), 'LtE': (), 'ClassDef': ('name', 'bases', 'keywords', 'starargs', 'kwargs', 'body', 'decorator_list'), 'Param': (), 'Or': (), 'BoolOp': ('op', 'values'), 'AugStore': (), 'ExceptHandler': ('type', 'name', 'body'), 'UAdd': (), 'RShift': (), 'Bytes': ('s',), 'Index': ('value',), "singleton": ()}
#dict([ (l[:l.find("(")], tuple(map(lambda x: x.split(" ")[1] , l[l.find("(")+1:-2].split(", ") if l.find("(") != -1 else []) )) for l in open("fullgrammar.txt").read().splitlines()])

START = "mod"

def converttype(s):
    if s == "object": return "String"
    elif s == "string": return "String"
    elif s == "identifier": return "String"
    else: return s


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: %s TOKENOUTFILE ABSYNOUTFILE")
        sys.exit()

    rules = [l.split(":",1) for l in GRAMMAR.splitlines()]
    rules = [(l[0].strip(), list(map(str.strip, l[1].split("|")))) for l in rules]

    heads, prods =  tuple(zip(*rules))
    indentsize = max(map(len, heads)) + 1
       

    nottokens = set(heads) #.union({"'('", "')'", "'['", "']'", "','", "/*", "*/", "empty", "'b'"})
    # Also do not print tokens for data types
    nottokens = nottokens.union({"string", "object"})

    tokens = set(reduce(add, [p.split(" ") for p in reduce(add, prods)])).difference(nottokens)
    #with open(sys.argv[1], "w") as tf:
    #    print("\n".join(sorted(tokens)), file=tf)


    # Print the head of the parser
    print("%{\nImport Absyn;\ntype AstTree = Absyn."+START+";\n")
    print("\n".join([ "type %s = %s;" % z for z in
            ( (x, ("list<%s>" % x[7:] if x.startswith("listof_") else
                  ("Option<%s>" % x[9:] if x.startswith("optional_") else
                  ("Absyn."+x))))
                for x in heads if x != START)]))
    print("\n%}\n")

    # Print all tokens
    print("%token STRING\n%token OBJECT\n")
    print("\n".join(["%token "+t.upper() for t in SPECIALTOKENS]))
    print()
    print("\n".join(["%token "+t.upper().replace("_","") for t in sorted(tokens) if t not in SPECIALTOKENS] ))
    print("\n%%\n")
    
    
    with open(sys.argv[2], "w") as aofile:
        for head, productions in rules:
            def print_a(s):
                if not (head.startswith("listof_") or head.startswith("optional_")):
                    print(s, file=aofile)

            print_a("public uniontype "+head)
            for pn,production in enumerate(productions):

                prods = production.split(" ")
                constructor = prods[0]
                recordname = constructor.upper().replace("_", "")
                if recordname == "NONE": recordname = "PYNONE" # To not confuse with Option "NONE"


                # Make records without params oneliners
                #if len(tuple(filter(lambda x: x not in tokens, prods))) == 0 and \
                #        not (head.startswith("listof_") or head.startswith("optional_")):
                #    print_a("\trecord "+recordname+" end "+recordname+";")
                #    continue

                print_a("\trecord "+recordname)
                i = 0
                constructorparams = []
                if head.startswith("optional_"):
                    semanticRule = "$$[Option<"+converttype(head[9:])+">] = %s;"
                    if pn == 0:
                        semanticRule %= "SOME($1)"
                    else:
                        semanticRule %= "NONE()"
                elif head.startswith("listof_"):
                    semanticRule = "$$[list<"+converttype(head[7:])+">] = %s;"
                    if pn == 0:
                        semanticRule %= "$1[%s]::$3[%s]" % (converttype(head[7:]), head)
                    elif pn == 1:
                        semanticRule %= "$1[%s]::{}" % converttype(head[7:])
                    else:
                        semanticRule %= "{}"

                else:
                    semanticRule = "$$["+head+"] = Absyn."+recordname+"(%s);"
                    for pi, x in enumerate(prods):
                        if x in tokens: continue
                        argname, i = ARGNAMES[constructor][i], i+1
                        assert argname not in heads
                        if x.startswith("listof_"):
                            print_a("\t\tlist<%s>\t%s;" % (converttype(x[7:]), argname))
                        elif x.startswith("optional_"):
                            print_a("\t\tOption<%s>\t%s;" % (converttype(x[9:]), argname))
                        else:
                            print_a("\t\t%s\t%s;" % (converttype(x), argname))
                        constructorparams.append("$"+str(pi+1)+"["+x+"]")
                    print_a("\tend "+recordname+";")
                    i+=1

                    semanticRule %= ", ".join(constructorparams)

                # Manage the special case of grammar start symbol properly
                if head == START:
                    semanticRule = "(absyntree)" + semanticRule[2:]

                if pn == 0:
                    print("%s: %s\n%s  { %s }" % 
                        (head.ljust(indentsize), productions[0], " "*indentsize, semanticRule))
                else:
                    print("%s| %s\n%s  { %s }" % 
                        (" "*indentsize, production, " "*indentsize, semanticRule))
            print_a("end "+head+";\n")

            print()

    print("\n%%\n")
