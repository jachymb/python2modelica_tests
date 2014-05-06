#!/usr/bin/python
# This script formats the grammar to better readable form and generates list of tokens
import sys

SPECIALTOKENS = {"LPAREN": '(', "RPAREN": ')', "COMMA": ",", "LBRACE": '[', "RBRACE": ']'}


# Changes to grammar
# Name conflicts:
#   operator -> arithmeticop
# Added singleton as nonterminal instead token
# bytes changed to B STRING
# identifier changed to STRINg
#
# Tokens that have conflicting names with nonterminals
# have added trailing underscore to distinguish them.
# Changed names: call, classdef, ifexp, import, list, tuple, param, subscript
GRAMMAR_PYTHON = \
[('mod', [
            ['Module', 'LPAREN', 'LBRACE', 'listof_stmt', 'RBRACE', 'RPAREN']]),
 ('stmt', [
            ['FunctionDef', 'LPAREN', 'STRING', 'COMMA', 'arguments', 'COMMA', 'LBRACE', 'listof_stmt', 'RBRACE', 'COMMA', 'LBRACE', 'listof_expr', 'RBRACE', 'COMMA', 'optional_expr', 'RPAREN'],
            ['ClassDef', 'LPAREN', 'STRING', 'COMMA', 'LBRACE', 'listof_expr', 'RBRACE', 'COMMA', 'LBRACE', 'listof_keyword', 'RBRACE', 'COMMA', 'optional_expr', 'COMMA', 'optional_expr', 'COMMA', 'LBRACE', 'listof_stmt', 'RBRACE', 'COMMA', 'LBRACE', 'listof_expr', 'RBRACE', 'RPAREN'],
            ['Return', 'LPAREN', 'optional_expr', 'RPAREN'],
            ['Delete', 'LPAREN', 'LBRACE', 'listof_expr', 'RBRACE', 'RPAREN'],
            ['Assign', 'LPAREN', 'LBRACE', 'listof_expr', 'RBRACE', 'COMMA', 'expr', 'RPAREN'],
            ['AugAssign', 'LPAREN', 'expr', 'COMMA', 'arithmeticop', 'COMMA', 'expr', 'RPAREN'],
            ['For', 'LPAREN', 'expr', 'COMMA', 'expr', 'COMMA', 'LBRACE', 'listof_stmt', 'RBRACE', 'COMMA', 'LBRACE', 'listof_stmt', 'RBRACE', 'RPAREN'],
            ['While', 'LPAREN', 'expr', 'COMMA', 'LBRACE', 'listof_stmt', 'RBRACE', 'COMMA', 'LBRACE', 'listof_stmt', 'RBRACE', 'RPAREN'],
            ['If', 'LPAREN', 'expr', 'COMMA', 'LBRACE', 'listof_stmt', 'RBRACE', 'COMMA', 'LBRACE', 'listof_stmt', 'RBRACE', 'RPAREN'],
            ['With', 'LPAREN', 'LBRACE', 'listof_withitem', 'RBRACE', 'COMMA', 'LBRACE', 'listof_stmt', 'RBRACE', 'RPAREN'],
            ['Raise', 'LPAREN', 'optional_expr', 'COMMA', 'optional_expr', 'RPAREN'],
            ['Try', 'LPAREN', 'LBRACE', 'listof_stmt', 'RBRACE', 'COMMA', 'LBRACE', 'listof_excepthandler', 'RBRACE', 'COMMA', 'LBRACE', 'listof_stmt', 'RBRACE', 'COMMA', 'LBRACE', 'listof_stmt', 'RBRACE', 'RPAREN'],
            ['Assert', 'LPAREN', 'expr', 'COMMA', 'optional_expr', 'RPAREN'],
            ['Import', 'LPAREN', 'LBRACE', 'listof_alias', 'RBRACE', 'RPAREN'],
            ['ImportFrom', 'LPAREN', 'optional_identifier', 'COMMA', 'LBRACE', 'listof_alias', 'RBRACE', 'COMMA', 'optional_object', 'RPAREN'],
            ['Global', 'LPAREN', 'LBRACE', 'listof_identifier', 'RBRACE', 'RPAREN'],
            ['Nonlocal', 'LPAREN', 'LBRACE', 'listof_identifier', 'RBRACE', 'RPAREN'],
            ['Expr', 'LPAREN', 'expr', 'RPAREN'],
            ['Pass', 'LPAREN', 'RPAREN'],
            ['Break', 'LPAREN', 'RPAREN'],
            ['Continue', 'LPAREN', 'RPAREN']]),
 ('expr', [
            ['BoolOp', 'LPAREN', 'boolop', 'COMMA', 'LBRACE', 'listof_expr', 'RBRACE', 'RPAREN'],
            ['BinOp', 'LPAREN', 'expr', 'COMMA', 'arithmeticop', 'COMMA', 'expr', 'RPAREN'],
            ['UnaryOp', 'LPAREN', 'unaryop', 'COMMA', 'expr', 'RPAREN'],
            ['Lambda', 'LPAREN', 'arguments', 'COMMA', 'expr', 'RPAREN'],
            ['IfExp', 'LPAREN', 'expr', 'COMMA', 'expr', 'COMMA', 'expr', 'RPAREN'],
            ['Dict', 'LPAREN', 'LBRACE', 'listof_expr', 'RBRACE', 'COMMA', 'LBRACE', 'listof_expr', 'RBRACE', 'RPAREN'],
            ['Set', 'LPAREN', 'LBRACE', 'listof_expr', 'RBRACE', 'RPAREN'],
            ['ListComp', 'LPAREN', 'expr', 'COMMA', 'LBRACE', 'listof_comprehension', 'RBRACE', 'RPAREN'],
            ['SetComp', 'LPAREN', 'expr', 'COMMA', 'LBRACE', 'listof_comprehension', 'RBRACE', 'RPAREN'],
            ['DictComp', 'LPAREN', 'expr', 'COMMA', 'expr', 'COMMA', 'LBRACE', 'listof_comprehension', 'RBRACE', 'RPAREN'],
            ['GeneratorExp', 'LPAREN', 'expr', 'COMMA', 'LBRACE', 'listof_comprehension', 'RBRACE', 'RPAREN'],
            ['Yield', 'LPAREN', 'optional_expr', 'RPAREN'],
            ['YieldFrom', 'LPAREN', 'expr', 'RPAREN'],
            ['Compare', 'LPAREN', 'expr', 'COMMA', 'LBRACE', 'listof_cmpop', 'RBRACE', 'COMMA', 'LBRACE', 'listof_expr', 'RBRACE', 'RPAREN'],
            ['Call', 'LPAREN', 'expr', 'COMMA', 'LBRACE', 'listof_expr', 'RBRACE', 'COMMA', 'LBRACE', 'listof_keyword', 'RBRACE', 'COMMA', 'optional_expr', 'COMMA', 'optional_expr', 'RPAREN'],
            ['Num', 'LPAREN', 'OBJECT', 'RPAREN'],
            ['Str', 'LPAREN', 'STRING', 'RPAREN'],
            ['Bytes', 'LPAREN', 'b', 'STRING', 'RPAREN'],
            ['NameConstant', 'LPAREN', 'singleton', 'RPAREN'],
            ['Ellipsis', 'LPAREN', 'RPAREN'],
            ['Attribute', 'LPAREN', 'expr', 'COMMA', 'STRING', 'COMMA', 'expr_context', 'RPAREN'],
            ['Subscript', 'LPAREN', 'expr', 'COMMA', 'slice', 'COMMA', 'expr_context', 'RPAREN'],
            ['Starred', 'LPAREN', 'expr', 'COMMA', 'expr_context', 'RPAREN'],
            ['Name', 'LPAREN', 'STRING', 'COMMA', 'expr_context', 'RPAREN'],
            ['List', 'LPAREN', 'LBRACE', 'listof_expr', 'RBRACE', 'COMMA', 'expr_context', 'RPAREN'],
            ['Tuple', 'LPAREN', 'LBRACE', 'listof_expr', 'RBRACE', 'COMMA', 'expr_context', 'RPAREN']]),
 ('expr_context', [
            ['Load', 'LPAREN', 'RPAREN'],
            ['Store', 'LPAREN', 'RPAREN'],
            ['Del', 'LPAREN', 'RPAREN'],
            ['AugLoad', 'LPAREN', 'RPAREN'],
            ['AugStore', 'LPAREN', 'RPAREN'],
            ['Param', 'LPAREN', 'RPAREN']]),
 ('slice', [
            ['Slice', 'LPAREN', 'optional_expr', 'COMMA', 'optional_expr', 'COMMA', 'optional_expr', 'RPAREN'],
            ['ExtSlice', 'LPAREN', 'LBRACE', 'listof_slice', 'RBRACE', 'RPAREN'],
            ['Index', 'LPAREN', 'expr', 'RPAREN']]),
 ('boolop', [
            ['And', 'LPAREN', 'RPAREN'],
            ['Or', 'LPAREN', 'RPAREN']]),
 ('arithmeticop', [
            ['Add', 'LPAREN', 'RPAREN'],
            ['Sub', 'LPAREN', 'RPAREN'],
            ['Mult', 'LPAREN', 'RPAREN'],
            ['Div', 'LPAREN', 'RPAREN'],
            ['Mod', 'LPAREN', 'RPAREN'],
            ['Pow', 'LPAREN', 'RPAREN'],
            ['LShift', 'LPAREN', 'RPAREN'],
            ['RShift', 'LPAREN', 'RPAREN'],
            ['BitOr', 'LPAREN', 'RPAREN'],
            ['BitXor', 'LPAREN', 'RPAREN'],
            ['BitAnd', 'LPAREN', 'RPAREN'],
            ['FloorDiv', 'LPAREN', 'RPAREN']]),
 ('unaryop', [
            ['Invert', 'LPAREN', 'RPAREN'],
            ['Not', 'LPAREN', 'RPAREN'],
            ['UAdd', 'LPAREN', 'RPAREN'],
            ['USub', 'LPAREN', 'RPAREN']]),
 ('cmpop', [
            ['Eq', 'LPAREN', 'RPAREN'],
            ['NotEq', 'LPAREN', 'RPAREN'],
            ['Lt', 'LPAREN', 'RPAREN'],
            ['LtE', 'LPAREN', 'RPAREN'],
            ['Gt', 'LPAREN', 'RPAREN'],
            ['GtE', 'LPAREN', 'RPAREN'],
            ['Is', 'LPAREN', 'RPAREN'],
            ['IsNot', 'LPAREN', 'RPAREN'],
            ['In', 'LPAREN', 'RPAREN'],
            ['NotIn', 'LPAREN', 'RPAREN']]),
 ('comprehension', [
            ['comprehension_', 'LPAREN', 'expr', 'COMMA', 'expr', 'COMMA', 'LBRACE', 'listof_expr', 'RBRACE', 'RPAREN']]),
 ('excepthandler', [
            ['ExceptHandler', 'LPAREN', 'optional_expr', 'COMMA', 'optional_identifier', 'COMMA', 'LBRACE', 'listof_stmt', 'RBRACE', 'RPAREN']]),
 ('arguments', [
            ['arguments_', 'LPAREN', 'LBRACE', 'listof_arg', 'RBRACE', 'COMMA', 'optional_arg', 'COMMA', 'LBRACE', 'listof_arg', 'RBRACE', 'COMMA', 'LBRACE', 'listof_expr', 'RBRACE', 'COMMA', 'optional_arg', 'COMMA', 'LBRACE', 'listof_expr', 'RBRACE', 'RPAREN']]),
 ('arg', [
            ['arg_', 'LPAREN', 'STRING', 'COMMA', 'optional_expr', 'RPAREN']]),
 ('keyword', [
            ['keyword_', 'LPAREN', 'STRING', 'COMMA', 'expr', 'RPAREN']]),
 ('alias', [
            ['alias_', 'LPAREN', 'STRING', 'COMMA', 'optional_identifier', 'RPAREN']]),
 ('withitem', [
            ['withitem_', 'LPAREN', 'expr', 'COMMA', 'optional_expr', 'RPAREN']]),
 ('singleton', [
            ['True'],
            ['False'],
            ['None']]),
 ('optional_expr', [
            ['expr'],
            ['None']]),
 ('optional_identifier', [
            ['STRING'],
            ['None']]),
 ('optional_object', [
            ['OBJECT'],
            ['None']]),
 ('optional_arg', [
            ['arg'],
            ['None']]),
 ('listof_stmt', [
            ['stmt', 'COMMA', 'listof_stmt'],
            ['stmt'],
            []]),
 ('listof_expr', [
            ['expr', 'COMMA', 'listof_expr'],
            ['expr'],
            []]),
 ('listof_keyword', [
            ['keyword', 'COMMA', 'listof_keyword'],
            ['keyword'],
            []]),
 ('listof_withitem', [
            ['withitem', 'COMMA', 'listof_withitem'],
            ['withitem'],
            []]),
 ('listof_excepthandler', [
            ['excepthandler', 'COMMA', 'listof_excepthandler'],
            ['excepthandler'],
            []]),
 ('listof_alias', [
            ['alias', 'COMMA', 'listof_alias'],
            ['alias'],
            []]),
 ('listof_identifier', [
            ['STRING', 'COMMA', 'listof_identifier'],
            ['STRING'],
            []]),
 ('listof_comprehension', [
            ['comprehension', 'COMMA', 'listof_comprehension'],
            ['comprehension'],
            []]),
 ('listof_cmpop', [
            ['cmpop', 'COMMA', 'listof_cmpop'],
            ['cmpop'],
            []]),
 ('listof_slice', [
            ['slice', 'COMMA', 'listof_slice'],
            ['slice'],
            []]),
 ('listof_arg', [
            ['arg', 'COMMA', 'listof_arg'],
            ['arg'],
            []])]

TYPETOKENS = {"OBJECT", "STRING"}

# POSTFIXES are added to resolve name conflicts
POSTFIXES = {"expr": "EX", "stmt": "ST", "expr_context": "EC", "arithmeticop": "OP", "cmpop": "OP", "unaryop":"OP", "boolop":"OP"}


# Changes in argument names due to conflicts:
#   annotation -> argannotation
#   type -> extype
ARGNAMES = {
    'Add': (),
    'alias_': ('name', 'asname'),
    'And': (),
    'arg_': ('argid', 'argannotation'),
    'arguments_': ('args', 'vararg', 'kwonlyargs', 'kw_defaults', 'kwarg', 'defaults'),
    'Assert': ('test', 'msg'),
    'Assign': ('targets', 'value'),
    'Attribute': ('value', 'attr', 'ctx'),
    'AugAssign': ('target', 'op', 'value'),
    'AugLoad': (),
    'AugStore': (),
    'BinOp': ('left', 'op', 'right'),
    'BitAnd': (),
    'BitOr': (),
    'BitXor': (),
    'BoolOp': ('op', 'values'),
    'Break': (),
    'Bytes': ('s',),
    'Call': ('func', 'args', 'keywords', 'starargs', 'kwargs'),
    'ClassDef': ('name', 'bases', 'keywords', 'starargs', 'kwargs', 'body', 'decorator_list'),
    'Compare': ('left', 'ops', 'comparators'),
    'comprehension_': ('target', 'iter', 'ifs'),
    'Continue': (),
    'Del': (),
    'Delete': ('targets',),
    'DictComp': ('key', 'value', 'generators'),
    'Dict': ('keys', 'values'),
    'Div': (),
    'Ellipsis': (),
    'Eq': (),
    'ExceptHandler': ('extype', 'name', 'body'),
    'Expr': ('value',),
    'ExtSlice': ('dims',),
    'FloorDiv': (),
    'For': ('target', 'iter', 'body', 'orelse'),
    'FunctionDef': ('name', 'args', 'body', 'decorator_list', 'returns'),
    'GeneratorExp': ('elt', 'generators'),
    'Global': ('names',),
    'Gt': (),
    'GtE': (),
    'IfExp': ('test', 'body', 'orelse'),
    'If': ('test', 'body', 'orelse'),
    'ImportFrom': ('module', 'names', 'level'),
    'Import': ('names',),
    'In': (),
    'Index': ('value',),
    'Invert': (),
    'Is': (),
    'IsNot': (),
    'keyword_': ('argid', 'value'),
    'Lambda': ('args', 'body'),
    'ListComp': ('elt', 'generators'),
    'List': ('elts', 'ctx'),
    'Load': (),
    'LShift': (),
    'Lt': (),
    'LtE': (),
    'Mod': (),
    'Module': ('body',),
    'Mult': (),
    'NameConstant': ('value',),
    'Name': ('id', 'ctx'),
    'Nonlocal': ('names',),
    'Not': (),
    'NotEq': (),
    'NotIn': (),
    'Num': ('n',),
    'Or': (),
    'Param': (),
    'Pass': (),
    'Pow': (),
    'Raise': ('exc', 'cause'),
    'Return': ('value',),
    'RShift': (),
    'SetComp': ('elt', 'generators'),
    'Set': ('elts',),
    'singleton': (),
    'Slice': ('lower', 'upper', 'step'),
    'Starred': ('value', 'ctx'),
    'Store': (),
    'Str': ('s',),
    'Sub': (),
    'Subscript': ('value', 'subscriptslice', 'ctx'),
    'Try': ('body', 'handlers', 'orelse', 'finalbody'),
    'Tuple': ('elts', 'ctx'),
    'UAdd': (),
    'UnaryOp': ('op', 'operand'),
    'USub': (),
    'While': ('test', 'body', 'orelse'),
    'withitem_': ('context_expr', 'optional_vars'),
    'With': ('items', 'body'),
    'YieldFrom': ('value',),
    'Yield': ('value',)}

START = GRAMMAR_PYTHON[0][0] # "mod"

ABSYNHEAD, ABSYNTAIL = "Absyn.head.mo", "Absyn.tail.mo"
LEXERHEAD, LEXERTAIL = "lexer.head.l", "lexer.tail.l"

def flatten(l):
    """ Makes recursively nested list flat"""
    r = []
    for e in l:
        if type(e) != list:
            r.append(e)
        else:
            r.extend(flatten(e))
    return r


def converttype(s):
    """ Used for converting tokens which represent constant values
    from Python AST to Modelica AST types. Also for converting types
    representing lists and options"""
    if s.upper() in ["OBJECT","STRING","IDENTIFIER"]: return "String"
    elif islistof(s): return "list<%s>" % converttype(s[7:])
    elif isoptional(s): return "Option<%s>" % converttype(s[9:])
    else: return s # No change - general token

def tokenHeads(t):
    """ Returns all nonterminals which have the given token directly
    in their production """
    return { GRAMMAR_PYTHON[x][0] for x in range(len(GRAMMAR_PYTHON))
               if t in flatten(GRAMMAR_PYTHON[x][1]) }

def formatToken(t, constructor = False):
    """ Returns the proper format of token which should appear in parser
    and consequently also in lexer return values."""
    # Assuming t is either terminal or non-terminal of grammar
    # Do not format non-termials
    if t in heads: return t

    if constructor and t == "None": return "PYNONE" # To not confuse with Option "NONE"

    # We rename certain constructor tokens to avoid conflicts with Modelica operators
    th = tokenHeads(t)
    if constructor and th.intersection(POSTFIXES) != set():
        assert len(th) == 1
        t += "_" + POSTFIXES[th.pop()]
    # Trailing underscore is not needed in formated tokens
    if t.endswith("_"): t = t[:-1]
    return t.upper()

def islistof(x):
    return x.startswith("listof_")
def isoptional(x):
    return x.startswith("optional_")

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: %s BISONOUTFILE ABSYNOUTFILE FLEXOUTFILE")
        sys.exit()


    heads, prods =  tuple(zip(*GRAMMAR_PYTHON))
    indentsize = max(map(len, heads)) + 1 # Indent size in the bison file for better readability

    nottokens = set(heads)
    nottokens = nottokens.union(TYPETOKENS) # We need to translate TYPETOKENS values to Modelica AST.

    tokens = set(flatten(prods)).difference(nottokens)
    nonspecialtokens = tokens.difference(SPECIALTOKENS)


    with open(sys.argv[1], "w") as bofile, \
            open(sys.argv[2], "w") as aofile, \
            open(sys.argv[3], "w") as fofile:

        # Print the head of the parser
        print("%{\nimport Absyn;\ntype AstTree = Absyn."+START+";\n", file = bofile)
        print("\n".join([ "type %s = %s;" % z for z in
                ( (x, (converttype(x) if islistof(x) or isoptional(x) else
                      ("Absyn."+x)))
                    for x in heads if x != START)]),
                file=bofile)
        print("\n%}\n", file=bofile)

        # Print all tokens to the parser
        for tokset in (TYPETOKENS, SPECIALTOKENS, nonspecialtokens):
            print("\n".join(["%token "+t for t in sorted(map(formatToken, tokset))] ), file=bofile)
            print(file=bofile)
        print("\n%%\n",file=bofile)

        # Print head of lexer file
        with open(LEXERHEAD) as h:
            fofile.write(h.read())

        # Print all tokens to the lexer file
        tokenindent = max(map(len,tokens))+2
        print("\n".join([('"%s"' % (t if not t.endswith("_") else t[:-1])).ljust(tokenindent) + \
                                "return %s;" % formatToken(t) for t in \
                            sorted(map(lambda x: x , nonspecialtokens)) ]),
                file = fofile)
        print(file=fofile)
        print("\n".join([('"%s"' % t).ljust(tokenindent) + ("return %s;" % tn) for tn,t in SPECIALTOKENS.items()]),
            file=fofile)
        print(file=fofile)

        # Write tail of lexer file, that finishes the lexer
        with open(LEXERTAIL) as t:
            fofile.write(t.read())
        fofile.close()

        # Print head of the Absyn file
        with open(ABSYNHEAD) as h:
            aofile.write(h.read())

        # This cycle generates the main parts of both Absyn and Parser files
        for head, productions in GRAMMAR_PYTHON:
            def print_a(s): # Helper function for printing to Absyn.
                if head != START and (not (islistof(head) or isoptional(head))):
                    print(s, file=aofile)

            print_a("public uniontype "+head)
            for pn,prods in enumerate(productions):

                constructorparams = []

                if isoptional(head): # Lists
                    #semanticRule = "$$[" + converttype(head) + "] = %s;"
                    semanticRule = "$$[" + head + "] = %s;"
                    if pn == 0:
                        semanticRule %= "SOME($1["+head[9:]+"])"
                    else:
                        semanticRule %= "NONE()"
                    semanticRule = semanticRule.replace("[String]","")
                elif islistof(head): # Options
                    #semanticRule = "$$[" + converttype(head) + "] = %s;"
                    semanticRule = "$$[" + head + "] = %s;"
                    if pn == 0:
                        semanticRule %= "$1[%s]::$3[%s]" % (converttype(head[7:]), head)
                    elif pn == 1:
                        semanticRule %= "$1[%s]::{}" % converttype(head[7:])
                    else:
                        semanticRule %= "{}"
                    semanticRule = semanticRule.replace("[String]","")

                else: # Ordinary attributes

                    constructor = prods[0]
                    recordname = formatToken(constructor, True)
                    semanticRule = "$$["+head+"] = Absyn."+recordname+"(%s);"

                    print_a("\trecord "+recordname)
                    i = 0

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

                        if x not in TYPETOKENS:
                            constructorparams.append("$"+str(pi+1)+"["+x+"]")
                        else:
                            constructorparams.append("$"+str(pi+1))

                    print_a("\tend "+recordname+";")

                    semanticRule %= ", ".join(constructorparams)

                # Manage the special case of grammar start symbol properly
                if head == START:
                    semanticRule = "(absyntree)" + semanticRule[2:]

                formatedRule = " ".join([formatToken(p) for p in prods])
                if pn == 0:
                    print("%s: %s\n%s  { %s }" %
                        (head.ljust(indentsize), formatedRule, " "*indentsize, semanticRule),
                        file=bofile)
                else:
                    print("%s| %s\n%s  { %s }" %
                        (" "*indentsize, formatedRule, " "*indentsize, semanticRule),
                        file=bofile)
            print_a("end "+head+";\n")

            print(file=bofile)

        print("\n%%\n", file=bofile)
        with open(ABSYNTAIL) as t:
            aofile.write(t.read())

