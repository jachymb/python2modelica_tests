%{

/* This parser works for Python 3.4.0. For earlier versions, the AST
 * library unfortunately produces slightly different tree, but if suppport
 * for older versions of Python is required, it shouldn't be so difficult
 * to change the underlying abstract grammar.
 *
 * Changes to actual grammar in documentation:
 * http://docs.python.org/3.4/library/ast.html
 *
 * Some tokens would collide with rules. These tokens have added
 * an underscore to the end of their name, but represent string
 * without it in the python AST. They are:
 * alias_, arg_, arguments_, comprehension_, keyword_, slice_, withitem_
 *
 * Tokens string and identifer are indistinguishable by lexer.
 * identifer was removed and replaced by string.
 * Token bytes is replaced by string preceded by 'b', for convenience.
 * 
 * Tokens int and object are (in practice) also indistinguishable.
 * Token int was replaced by object. Note that token int only appears in
 * import levels. This change has no effect on numerical constants.
 * This could in special occasions cause the parser accept invalid imports,
 * but import levels are seldom used and are of no interest to the translator.
 * 
 x Type singleton has only three values (True, False, None) and can only 
 * appear within NameConstant. 
 *
 * Parameter name for node constructor changes (due to conflicts):
 * slice -> subscriptslice
 * arg -> argid
 */

%}

%start mod

%token string
%token object

%token True
%token False

%token LPAREN
%token RPAREN
%token LBRACE
%token RBRACE
%token COMMA
%token B

%token Add
%token And
%token Assert
%token Assign
%token Attribute
%token AugAssign
%token AugLoad
%token AugStore
%token BinOp
%token BitAnd
%token BitOr
%token BitXor
%token BoolOp
%token Break
%token Bytes
%token Call
%token ClassDef
%token Compare
%token Continue
%token Del
%token Delete
%token Dict
%token DictComp
%token Div
%token Ellipsis
%token Eq
%token ExceptHandler
%token Expr
%token ExtSlice
%token FloorDiv
%token For
%token FunctionDef
%token GeneratorExp
%token Global
%token Gt
%token GtE
%token If
%token IfExp
%token Import
%token ImportFrom
%token In
%token Index
%token Invert
%token Is
%token IsNot
%token LShift
%token Lambda
%token List
%token ListComp
%token Load
%token Lt
%token LtE
%token Mod
%token Module
%token Mult
%token Name
%token NameConstant
%token None
%token Nonlocal
%token Not
%token NotEq
%token NotIn
%token Num
%token Or
%token Param
%token Pass
%token Pow
%token RShift
%token Raise
%token Return
%token Set
%token SetComp
%token Slice
%token Starred
%token Store
%token Str
%token Sub
%token Subscript
%token Try
%token Tuple
%token UAdd
%token USub
%token UnaryOp
%token While
%token With
%token Yield
%token YieldFrom
%token alias_
%token arg_
%token arguments_
%token comprehension_
%token keyword_
%token withitem_

%%
mod                  : Module LPAREN LBRACE listof_stmt RBRACE RPAREN
                       { $$[mod] = Absyn.MODULE($4[body]); }
;
stmt                 : FunctionDef LPAREN string COMMA arguments COMMA LBRACE listof_stmt RBRACE COMMA LBRACE listof_expr RBRACE COMMA optional_expr RPAREN
                       { $$[stmt] = Absyn.FUNCTIONDEF($3[name], $5[args], $8[body], $12[decorator_list], $15[returns]); }
                     | ClassDef LPAREN string COMMA LBRACE listof_expr RBRACE COMMA LBRACE listof_keyword RBRACE COMMA optional_expr COMMA optional_expr COMMA LBRACE listof_stmt RBRACE COMMA LBRACE listof_expr RBRACE RPAREN
                       { $$[stmt] = Absyn.CLASSDEF($3[name], $6[bases], $10[keywords], $13[starargs], $15[kwargs], $18[body], $22[decorator_list]); }
                     | Return LPAREN optional_expr RPAREN
                       { $$[stmt] = Absyn.RETURN($3[value]); }
                     | Delete LPAREN LBRACE listof_expr RBRACE RPAREN
                       { $$[stmt] = Absyn.DELETE($4[targets]); }
                     | Assign LPAREN LBRACE listof_expr RBRACE COMMA expr RPAREN
                       { $$[stmt] = Absyn.ASSIGN($4[targets], $7[value]); }
                     | AugAssign LPAREN expr COMMA operator COMMA expr RPAREN
                       { $$[stmt] = Absyn.AUGASSIGN($3[target], $5[op], $7[value]); }
                     | For LPAREN expr COMMA expr COMMA LBRACE listof_stmt RBRACE COMMA LBRACE listof_stmt RBRACE RPAREN
                       { $$[stmt] = Absyn.FOR($3[target], $5[iter], $8[body], $12[orelse]); }
                     | While LPAREN expr COMMA LBRACE listof_stmt RBRACE COMMA LBRACE listof_stmt RBRACE RPAREN
                       { $$[stmt] = Absyn.WHILE($3[test], $6[body], $10[orelse]); }
                     | If LPAREN expr COMMA LBRACE listof_stmt RBRACE COMMA LBRACE listof_stmt RBRACE RPAREN
                       { $$[stmt] = Absyn.IF($3[test], $6[body], $10[orelse]); }
                     | With LPAREN LBRACE listof_withitem RBRACE COMMA LBRACE listof_stmt RBRACE RPAREN
                       { $$[stmt] = Absyn.WITH($4[items], $8[body]); }
                     | Raise LPAREN optional_expr COMMA optional_expr RPAREN
                       { $$[stmt] = Absyn.RAISE($3[exc], $5[cause]); }
                     | Try LPAREN LBRACE listof_stmt RBRACE COMMA LBRACE listof_excepthandler RBRACE COMMA LBRACE listof_stmt RBRACE COMMA LBRACE listof_stmt RBRACE RPAREN
                       { $$[stmt] = Absyn.TRY($4[body], $8[handlers], $12[orelse], $16[finalbody]); }
                     | Assert LPAREN expr COMMA optional_expr RPAREN
                       { $$[stmt] = Absyn.ASSERT($3[test], $5[msg]); }
                     | Import LPAREN LBRACE listof_alias RBRACE RPAREN
                       { $$[stmt] = Absyn.IMPORT($4[names]); }
                     | ImportFrom LPAREN optional_identifier COMMA LBRACE listof_alias RBRACE COMMA optional_object RPAREN
                       { $$[stmt] = Absyn.IMPORTFROM($3[module], $6[names], $9[level]); }
                     | Global LPAREN LBRACE listof_identifier RBRACE RPAREN
                       { $$[stmt] = Absyn.GLOBAL($4[names]); }
                     | Nonlocal LPAREN LBRACE listof_identifier RBRACE RPAREN
                       { $$[stmt] = Absyn.NONLOCAL($4[names]); }
                     | Expr LPAREN expr RPAREN
                       { $$[stmt] = Absyn.EXPR($3[value]); }
                     | Pass LPAREN RPAREN
                       { $$[stmt] = Absyn.PASS(); }
                     | Break LPAREN RPAREN
                       { $$[stmt] = Absyn.BREAK(); }
                     | Continue LPAREN RPAREN
                       { $$[stmt] = Absyn.CONTINUE(); }
;
expr                 : BoolOp LPAREN boolop COMMA LBRACE listof_expr RBRACE RPAREN
                       { $$[expr] = Absyn.BOOLOP($3[op], $6[values]); }
                     | BinOp LPAREN expr COMMA operator COMMA expr RPAREN
                       { $$[expr] = Absyn.BINOP($3[left], $5[op], $7[right]); }
                     | UnaryOp LPAREN unaryop COMMA expr RPAREN
                       { $$[expr] = Absyn.UNARYOP($3[op], $5[operand]); }
                     | Lambda LPAREN arguments COMMA expr RPAREN
                       { $$[expr] = Absyn.LAMBDA($3[args], $5[body]); }
                     | IfExp LPAREN expr COMMA expr COMMA expr RPAREN
                       { $$[expr] = Absyn.IFEXP($3[test], $5[body], $7[orelse]); }
                     | Dict LPAREN LBRACE listof_expr RBRACE COMMA LBRACE listof_expr RBRACE RPAREN
                       { $$[expr] = Absyn.DICT($4[keys], $8[values]); }
                     | Set LPAREN LBRACE listof_expr RBRACE RPAREN
                       { $$[expr] = Absyn.SET($4[elts]); }
                     | ListComp LPAREN expr COMMA LBRACE listof_comprehension RBRACE RPAREN
                       { $$[expr] = Absyn.LISTCOMP($3[elt], $6[generators]); }
                     | SetComp LPAREN expr COMMA LBRACE listof_comprehension RBRACE RPAREN
                       { $$[expr] = Absyn.SETCOMP($3[elt], $6[generators]); }
                     | DictComp LPAREN expr COMMA expr COMMA LBRACE listof_comprehension RBRACE RPAREN
                       { $$[expr] = Absyn.DICTCOMP($3[key], $5[value], $8[generators]); }
                     | GeneratorExp LPAREN expr COMMA LBRACE listof_comprehension RBRACE RPAREN
                       { $$[expr] = Absyn.GENERATOREXP($3[elt], $6[generators]); }
                     | Yield LPAREN optional_expr RPAREN
                       { $$[expr] = Absyn.YIELD($3[value]); }
                     | YieldFrom LPAREN expr RPAREN
                       { $$[expr] = Absyn.YIELDFROM($3[value]); }
                     | Compare LPAREN expr COMMA LBRACE listof_cmpop RBRACE COMMA LBRACE listof_expr RBRACE RPAREN
                       { $$[expr] = Absyn.COMPARE($3[left], $6[ops], $10[comparators]); }
                     | Call LPAREN expr COMMA LBRACE listof_expr RBRACE COMMA LBRACE listof_keyword RBRACE COMMA optional_expr COMMA optional_expr RPAREN
                       { $$[expr] = Absyn.CALL($3[func], $6[args], $10[keywords], $13[starargs], $15[kwargs]); }
                     | Num LPAREN object RPAREN
                       { $$[expr] = Absyn.NUM($3[n]); }
                     | Str LPAREN string RPAREN
                       { $$[expr] = Absyn.STR($3[s]); }
                     | Bytes LPAREN B string RPAREN
                       { $$[expr] = Absyn.BYTES($4[s]); }
                     | NameConstant LPAREN singleton RPAREN
                       { $$[expr] = Absyn.NAMECONSTANT($3[value]); }
                     | Ellipsis LPAREN RPAREN
                       { $$[expr] = Absyn.ELLIPSIS(); }
                     | Attribute LPAREN expr COMMA string COMMA expr_context RPAREN
                       { $$[expr] = Absyn.ATTRIBUTE($3[value], $5[attr], $7[ctx]); }
                     | Subscript LPAREN expr COMMA slice COMMA expr_context RPAREN
                       { $$[expr] = Absyn.SUBSCRIPT($3[value], $5[subscriptslice], $7[ctx]); }
                     | Starred LPAREN expr COMMA expr_context RPAREN
                       { $$[expr] = Absyn.STARRED($3[value], $5[ctx]); }
                     | Name LPAREN string COMMA expr_context RPAREN
                       { $$[expr] = Absyn.NAME($3[id], $5[ctx]); }
                     | List LPAREN LBRACE listof_expr RBRACE COMMA expr_context RPAREN
                       { $$[expr] = Absyn.LIST($4[elts], $7[ctx]); }
                     | Tuple LPAREN LBRACE listof_expr RBRACE COMMA expr_context RPAREN
                       { $$[expr] = Absyn.TUPLE($4[elts], $7[ctx]); }
;
expr_context         : Load LPAREN RPAREN
                       { $$[expr_context] = Absyn.LOAD(); }
                     | Store LPAREN RPAREN
                       { $$[expr_context] = Absyn.STORE(); }
                     | Del LPAREN RPAREN
                       { $$[expr_context] = Absyn.DEL(); }
                     | AugLoad LPAREN RPAREN
                       { $$[expr_context] = Absyn.AUGLOAD(); }
                     | AugStore LPAREN RPAREN
                       { $$[expr_context] = Absyn.AUGSTORE(); }
                     | Param LPAREN RPAREN
                       { $$[expr_context] = Absyn.PARAM(); }
;
slice                : Slice LPAREN optional_expr COMMA optional_expr COMMA optional_expr RPAREN
                       { $$[slice] = Absyn.SLICE($3[lower], $5[upper], $7[step]); }
                     | ExtSlice LPAREN LBRACE listof_slice RBRACE RPAREN
                       { $$[slice] = Absyn.EXTSLICE($4[dims]); }
                     | Index LPAREN expr RPAREN
                       { $$[slice] = Absyn.INDEX($3[value]); }
;
boolop               : And LPAREN RPAREN
                       { $$[boolop] = Absyn.AND(); }
                     | Or LPAREN RPAREN
                       { $$[boolop] = Absyn.OR(); }
;
operator             : Add LPAREN RPAREN
                       { $$[operator] = Absyn.ADD(); }
                     | Sub LPAREN RPAREN
                       { $$[operator] = Absyn.SUB(); }
                     | Mult LPAREN RPAREN
                       { $$[operator] = Absyn.MULT(); }
                     | Div LPAREN RPAREN
                       { $$[operator] = Absyn.DIV(); }
                     | Mod LPAREN RPAREN
                       { $$[operator] = Absyn.MOD(); }
                     | Pow LPAREN RPAREN
                       { $$[operator] = Absyn.POW(); }
                     | LShift LPAREN RPAREN
                       { $$[operator] = Absyn.LSHIFT(); }
                     | RShift LPAREN RPAREN
                       { $$[operator] = Absyn.RSHIFT(); }
                     | BitOr LPAREN RPAREN
                       { $$[operator] = Absyn.BITOR(); }
                     | BitXor LPAREN RPAREN
                       { $$[operator] = Absyn.BITXOR(); }
                     | BitAnd LPAREN RPAREN
                       { $$[operator] = Absyn.BITAND(); }
                     | FloorDiv LPAREN RPAREN
                       { $$[operator] = Absyn.FLOORDIV(); }
;
unaryop              : Invert LPAREN RPAREN
                       { $$[unaryop] = Absyn.INVERT(); }
                     | Not LPAREN RPAREN
                       { $$[unaryop] = Absyn.NOT(); }
                     | UAdd LPAREN RPAREN
                       { $$[unaryop] = Absyn.UADD(); }
                     | USub LPAREN RPAREN
                       { $$[unaryop] = Absyn.USUB(); }
;
cmpop                : Eq LPAREN RPAREN
                       { $$[cmpop] = Absyn.EQ(); }
                     | NotEq LPAREN RPAREN
                       { $$[cmpop] = Absyn.NOTEQ(); }
                     | Lt LPAREN RPAREN
                       { $$[cmpop] = Absyn.LT(); }
                     | LtE LPAREN RPAREN
                       { $$[cmpop] = Absyn.LTE(); }
                     | Gt LPAREN RPAREN
                       { $$[cmpop] = Absyn.GT(); }
                     | GtE LPAREN RPAREN
                       { $$[cmpop] = Absyn.GTE(); }
                     | Is LPAREN RPAREN
                       { $$[cmpop] = Absyn.IS(); }
                     | IsNot LPAREN RPAREN
                       { $$[cmpop] = Absyn.ISNOT(); }
                     | In LPAREN RPAREN
                       { $$[cmpop] = Absyn.IN(); }
                     | NotIn LPAREN RPAREN
                       { $$[cmpop] = Absyn.NOTIN(); }
;
comprehension        : comprehension_ LPAREN expr COMMA expr COMMA LBRACE listof_expr RBRACE RPAREN
                       { $$[comprehension] = Absyn.COMPREHENSION($3[target], $5[iter], $8[ifs]); }
;
excepthandler        : ExceptHandler LPAREN optional_expr COMMA optional_identifier COMMA LBRACE listof_stmt RBRACE RPAREN
                       { $$[excepthandler] = Absyn.EXCEPTHANDLER($3[type], $5[name], $8[body]); }
;
arguments            : arguments_ LPAREN LBRACE listof_arg RBRACE COMMA optional_arg COMMA LBRACE listof_arg RBRACE COMMA LBRACE listof_expr RBRACE COMMA optional_arg COMMA LBRACE listof_expr RBRACE RPAREN
                       { $$[arguments] = Absyn.ARGUMENTS($4[args], $7[vararg], $10[kwonlyargs], $14[kw_defaults], $17[kwarg], $20[defaults]); }
;
arg                  : arg_ LPAREN string COMMA optional_expr RPAREN
                       { $$[arg] = Absyn.ARG($3[argid], $5[annotation]); }
;
keyword              : keyword_ LPAREN string COMMA expr RPAREN
                       { $$[keyword] = Absyn.KEYWORD($3[argid], $5[value]); }
;
alias                : alias_ LPAREN string COMMA optional_identifier RPAREN
                       { $$[alias] = Absyn.ALIAS($3[name], $5[asname]); }
;
withitem             : withitem_ LPAREN expr COMMA optional_expr RPAREN
                       { $$[withitem] = Absyn.WITHITEM($3[context_expr], $5[optional_vars]); }
;
singleton            : True
                       { $$[singleton] = Absyn.TRUE(); }
                     | False
                       { $$[singleton] = Absyn.FALSE(); }
                     | None
                       { $$[singleton] = Absyn.PYNONE(); }
;
optional_expr        : expr
                       { $$[Option<expr>] = SOME($1); }
                     | None
                       { $$[Option<expr>] = NONE; }
;
optional_identifier  : string
                       { $$[Option<identifier>] = SOME($1); }
                     | None
                       { $$[Option<identifier>] = NONE; }
;
optional_object      : object
                       { $$[Option<object>] = SOME($1); }
                     | None
                       { $$[Option<object>] = NONE; }
;
optional_arg         : arg
                       { $$[Option<arg>] = SOME($1); }
                     | None
                       { $$[Option<arg>] = NONE; }
;
listof_stmt          : stmt COMMA listof_stmt
                       { $$[list<stmt>] = $1::$3; }
                     | stmt
                       { $$[list<stmt>] = $1::{}; }
                     | 
                       { $$[list<stmt>] = {}; }
;
listof_expr          : expr COMMA listof_expr
                       { $$[list<expr>] = $1::$3; }
                     | expr
                       { $$[list<expr>] = $1::{}; }
                     | 
                       { $$[list<expr>] = {}; }
;
listof_keyword       : keyword COMMA listof_keyword
                       { $$[list<keyword>] = $1::$3; }
                     | keyword
                       { $$[list<keyword>] = $1::{}; }
                     | 
                       { $$[list<keyword>] = {}; }
;
listof_withitem      : withitem COMMA listof_withitem
                       { $$[list<withitem>] = $1::$3; }
                     | withitem
                       { $$[list<withitem>] = $1::{}; }
                     | 
                       { $$[list<withitem>] = {}; }
;
listof_excepthandler : excepthandler COMMA listof_excepthandler
                       { $$[list<excepthandler>] = $1::$3; }
                     | excepthandler
                       { $$[list<excepthandler>] = $1::{}; }
                     | 
                       { $$[list<excepthandler>] = {}; }
;
listof_alias         : alias COMMA listof_alias
                       { $$[list<alias>] = $1::$3; }
                     | alias
                       { $$[list<alias>] = $1::{}; }
                     | 
                       { $$[list<alias>] = {}; }
;
listof_identifier    : string COMMA listof_identifier
                       { $$[list<identifier>] = $1::$3; }
                     | string
                       { $$[list<identifier>] = $1::{}; }
                     | 
                       { $$[list<identifier>] = {}; }
;
listof_comprehension : comprehension COMMA listof_comprehension
                       { $$[list<comprehension>] = $1::$3; }
                     | comprehension
                       { $$[list<comprehension>] = $1::{}; }
                     | 
                       { $$[list<comprehension>] = {}; }
;
listof_cmpop         : cmpop COMMA listof_cmpop
                       { $$[list<cmpop>] = $1::$3; }
                     | cmpop
                       { $$[list<cmpop>] = $1::{}; }
                     | 
                       { $$[list<cmpop>] = {}; }
;
listof_slice         : slice COMMA listof_slice
                       { $$[list<slice>] = $1::$3; }
                     | slice
                       { $$[list<slice>] = $1::{}; }
                     | 
                       { $$[list<slice>] = {}; }
;
listof_arg           : arg COMMA listof_arg
                       { $$[list<arg>] = $1::$3; }
                     | arg
                       { $$[list<arg>] = $1::{}; }
                     | 
                       { $$[list<arg>] = {}; }
;
%%
