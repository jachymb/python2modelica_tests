%{
import Absyn;
type AstTree = Absyn.mod;

type stmt = Absyn.stmt;
type expr = Absyn.expr;
type expr_context = Absyn.expr_context;
type slice = Absyn.slice;
type boolop = Absyn.boolop;
type arithmeticop = Absyn.arithmeticop;
type unaryop = Absyn.unaryop;
type cmpop = Absyn.cmpop;
type comprehension = Absyn.comprehension;
type excepthandler = Absyn.excepthandler;
type arguments = Absyn.arguments;
type arg = Absyn.arg;
type keyword = Absyn.keyword;
type alias = Absyn.alias;
type withitem = Absyn.withitem;
type singleton = Absyn.singleton;
type optional_expr = Option<expr>;
type optional_identifier = Option<String>;
type optional_object = Option<String>;
type optional_arg = Option<arg>;
type listof_stmt = list<stmt>;
type listof_expr = list<expr>;
type listof_keyword = list<keyword>;
type listof_withitem = list<withitem>;
type listof_excepthandler = list<excepthandler>;
type listof_alias = list<alias>;
type listof_identifier = list<String>;
type listof_comprehension = list<comprehension>;
type listof_cmpop = list<cmpop>;
type listof_slice = list<slice>;
type listof_arg = list<arg>;

%}

%token OBJECT
%token STRING

%token COMMA
%token LBRACE
%token LPAREN
%token RBRACE
%token RPAREN

%token ADD_OP
%token ALIAS
%token AND_OP
%token ARG
%token ARGUMENTS
%token ASSERT
%token ASSIGN
%token ATTRIBUTE
%token AUGASSIGN
%token AUGLOAD
%token AUGSTORE
%token B
%token BINOP
%token BITAND_OP
%token BITOR_OP
%token BITXOR_OP
%token BOOLOP
%token BREAK
%token BYTES
%token CALL
%token CLASSDEF
%token COMPARE
%token COMPREHENSION
%token CONTINUE
%token DEL
%token DELETE
%token DICT
%token DICTCOMP
%token DIV_OP
%token ELLIPSIS
%token EQ_OP
%token EXCEPTHANDLER
%token EXPR
%token EXTSLICE
%token FALSE
%token FLOORDIV_OP
%token FOR
%token FUNCTIONDEF
%token GENERATOREXP
%token GLOBAL
%token GTE_OP
%token GT_OP
%token IF
%token IFEXP
%token IMPORT
%token IMPORTFROM
%token INDEX
%token INVERT_OP
%token IN_OP
%token ISNOT_OP
%token IS_OP
%token KEYWORD
%token LAMBDA
%token LIST
%token LISTCOMP
%token LOAD
%token LSHIFT_OP
%token LTE_OP
%token LT_OP
%token MODULE
%token MOD_OP
%token MULT_OP
%token NAME
%token NAMECONSTANT
%token NONE
%token NONLOCAL
%token NOTEQ_OP
%token NOTIN_OP
%token NOT_OP
%token NUM
%token OR_OP
%token PARAM
%token PASS
%token POW_OP
%token RAISE
%token RETURN
%token RSHIFT_OP
%token SET
%token SETCOMP
%token SLICE
%token STARRED
%token STORE
%token STR
%token SUBSCRIPT
%token SUB_OP
%token TRUE
%token TRY
%token TUPLE
%token UADD_OP
%token UNARYOP
%token USUB_OP
%token WHILE
%token WITH
%token WITHITEM
%token YIELD
%token YIELDFROM


%%

mod                  : MODULE LPAREN LBRACE listof_stmt RBRACE RPAREN
                       { (absyntree)[mod] = Absyn.MODULE($4[listof_stmt]); }

stmt                 : FUNCTIONDEF LPAREN STRING COMMA arguments COMMA LBRACE listof_stmt RBRACE COMMA LBRACE listof_expr RBRACE COMMA optional_expr RPAREN
                       { $$[stmt] = Absyn.FUNCTIONDEF($3[STRING], $5[arguments], $8[listof_stmt], $12[listof_expr], $15[optional_expr]); }
                     | CLASSDEF LPAREN STRING COMMA LBRACE listof_expr RBRACE COMMA LBRACE listof_keyword RBRACE COMMA optional_expr COMMA optional_expr COMMA LBRACE listof_stmt RBRACE COMMA LBRACE listof_expr RBRACE RPAREN
                       { $$[stmt] = Absyn.CLASSDEF($3[STRING], $6[listof_expr], $10[listof_keyword], $13[optional_expr], $15[optional_expr], $18[listof_stmt], $22[listof_expr]); }
                     | RETURN LPAREN optional_expr RPAREN
                       { $$[stmt] = Absyn.RETURN($3[optional_expr]); }
                     | DELETE LPAREN LBRACE listof_expr RBRACE RPAREN
                       { $$[stmt] = Absyn.DELETE($4[listof_expr]); }
                     | ASSIGN LPAREN LBRACE listof_expr RBRACE COMMA expr RPAREN
                       { $$[stmt] = Absyn.ASSIGN($4[listof_expr], $7[expr]); }
                     | AUGASSIGN LPAREN expr COMMA arithmeticop COMMA expr RPAREN
                       { $$[stmt] = Absyn.AUGASSIGN($3[expr], $5[arithmeticop], $7[expr]); }
                     | FOR LPAREN expr COMMA expr COMMA LBRACE listof_stmt RBRACE COMMA LBRACE listof_stmt RBRACE RPAREN
                       { $$[stmt] = Absyn.FOR($3[expr], $5[expr], $8[listof_stmt], $12[listof_stmt]); }
                     | WHILE LPAREN expr COMMA LBRACE listof_stmt RBRACE COMMA LBRACE listof_stmt RBRACE RPAREN
                       { $$[stmt] = Absyn.WHILE($3[expr], $6[listof_stmt], $10[listof_stmt]); }
                     | IF LPAREN expr COMMA LBRACE listof_stmt RBRACE COMMA LBRACE listof_stmt RBRACE RPAREN
                       { $$[stmt] = Absyn.IF($3[expr], $6[listof_stmt], $10[listof_stmt]); }
                     | WITH LPAREN LBRACE listof_withitem RBRACE COMMA LBRACE listof_stmt RBRACE RPAREN
                       { $$[stmt] = Absyn.WITH($4[listof_withitem], $8[listof_stmt]); }
                     | RAISE LPAREN optional_expr COMMA optional_expr RPAREN
                       { $$[stmt] = Absyn.RAISE($3[optional_expr], $5[optional_expr]); }
                     | TRY LPAREN LBRACE listof_stmt RBRACE COMMA LBRACE listof_excepthandler RBRACE COMMA LBRACE listof_stmt RBRACE COMMA LBRACE listof_stmt RBRACE RPAREN
                       { $$[stmt] = Absyn.TRY($4[listof_stmt], $8[listof_excepthandler], $12[listof_stmt], $16[listof_stmt]); }
                     | ASSERT LPAREN expr COMMA optional_expr RPAREN
                       { $$[stmt] = Absyn.ASSERT($3[expr], $5[optional_expr]); }
                     | IMPORT LPAREN LBRACE listof_alias RBRACE RPAREN
                       { $$[stmt] = Absyn.IMPORT($4[listof_alias]); }
                     | IMPORTFROM LPAREN optional_identifier COMMA LBRACE listof_alias RBRACE COMMA optional_object RPAREN
                       { $$[stmt] = Absyn.IMPORTFROM($3[optional_identifier], $6[listof_alias], $9[optional_object]); }
                     | GLOBAL LPAREN LBRACE listof_identifier RBRACE RPAREN
                       { $$[stmt] = Absyn.GLOBAL($4[listof_identifier]); }
                     | NONLOCAL LPAREN LBRACE listof_identifier RBRACE RPAREN
                       { $$[stmt] = Absyn.NONLOCAL($4[listof_identifier]); }
                     | EXPR LPAREN expr RPAREN
                       { $$[stmt] = Absyn.EXPR($3[expr]); }
                     | PASS LPAREN RPAREN
                       { $$[stmt] = Absyn.PASS(); }
                     | BREAK LPAREN RPAREN
                       { $$[stmt] = Absyn.BREAK(); }
                     | CONTINUE LPAREN RPAREN
                       { $$[stmt] = Absyn.CONTINUE(); }

expr                 : BOOLOP LPAREN boolop COMMA LBRACE listof_expr RBRACE RPAREN
                       { $$[expr] = Absyn.BOOLOP($3[boolop], $6[listof_expr]); }
                     | BINOP LPAREN expr COMMA arithmeticop COMMA expr RPAREN
                       { $$[expr] = Absyn.BINOP($3[expr], $5[arithmeticop], $7[expr]); }
                     | UNARYOP LPAREN unaryop COMMA expr RPAREN
                       { $$[expr] = Absyn.UNARYOP($3[unaryop], $5[expr]); }
                     | LAMBDA LPAREN arguments COMMA expr RPAREN
                       { $$[expr] = Absyn.LAMBDA($3[arguments], $5[expr]); }
                     | IFEXP LPAREN expr COMMA expr COMMA expr RPAREN
                       { $$[expr] = Absyn.IFEXP($3[expr], $5[expr], $7[expr]); }
                     | DICT LPAREN LBRACE listof_expr RBRACE COMMA LBRACE listof_expr RBRACE RPAREN
                       { $$[expr] = Absyn.DICT($4[listof_expr], $8[listof_expr]); }
                     | SET LPAREN LBRACE listof_expr RBRACE RPAREN
                       { $$[expr] = Absyn.SET($4[listof_expr]); }
                     | LISTCOMP LPAREN expr COMMA LBRACE listof_comprehension RBRACE RPAREN
                       { $$[expr] = Absyn.LISTCOMP($3[expr], $6[listof_comprehension]); }
                     | SETCOMP LPAREN expr COMMA LBRACE listof_comprehension RBRACE RPAREN
                       { $$[expr] = Absyn.SETCOMP($3[expr], $6[listof_comprehension]); }
                     | DICTCOMP LPAREN expr COMMA expr COMMA LBRACE listof_comprehension RBRACE RPAREN
                       { $$[expr] = Absyn.DICTCOMP($3[expr], $5[expr], $8[listof_comprehension]); }
                     | GENERATOREXP LPAREN expr COMMA LBRACE listof_comprehension RBRACE RPAREN
                       { $$[expr] = Absyn.GENERATOREXP($3[expr], $6[listof_comprehension]); }
                     | YIELD LPAREN optional_expr RPAREN
                       { $$[expr] = Absyn.YIELD($3[optional_expr]); }
                     | YIELDFROM LPAREN expr RPAREN
                       { $$[expr] = Absyn.YIELDFROM($3[expr]); }
                     | COMPARE LPAREN expr COMMA LBRACE listof_cmpop RBRACE COMMA LBRACE listof_expr RBRACE RPAREN
                       { $$[expr] = Absyn.COMPARE($3[expr], $6[listof_cmpop], $10[listof_expr]); }
                     | CALL LPAREN expr COMMA LBRACE listof_expr RBRACE COMMA LBRACE listof_keyword RBRACE COMMA optional_expr COMMA optional_expr RPAREN
                       { $$[expr] = Absyn.CALL($3[expr], $6[listof_expr], $10[listof_keyword], $13[optional_expr], $15[optional_expr]); }
                     | NUM LPAREN OBJECT RPAREN
                       { $$[expr] = Absyn.NUM($3[OBJECT]); }
                     | STR LPAREN STRING RPAREN
                       { $$[expr] = Absyn.STR($3[STRING]); }
                     | BYTES LPAREN B STRING RPAREN
                       { $$[expr] = Absyn.BYTES($4[STRING]); }
                     | NAMECONSTANT LPAREN singleton RPAREN
                       { $$[expr] = Absyn.NAMECONSTANT($3[singleton]); }
                     | ELLIPSIS LPAREN RPAREN
                       { $$[expr] = Absyn.ELLIPSIS(); }
                     | ATTRIBUTE LPAREN expr COMMA STRING COMMA expr_context RPAREN
                       { $$[expr] = Absyn.ATTRIBUTE($3[expr], $5[STRING], $7[expr_context]); }
                     | SUBSCRIPT LPAREN expr COMMA slice COMMA expr_context RPAREN
                       { $$[expr] = Absyn.SUBSCRIPT($3[expr], $5[slice], $7[expr_context]); }
                     | STARRED LPAREN expr COMMA expr_context RPAREN
                       { $$[expr] = Absyn.STARRED($3[expr], $5[expr_context]); }
                     | NAME LPAREN STRING COMMA expr_context RPAREN
                       { $$[expr] = Absyn.NAME($3[STRING], $5[expr_context]); }
                     | LIST LPAREN LBRACE listof_expr RBRACE COMMA expr_context RPAREN
                       { $$[expr] = Absyn.LIST($4[listof_expr], $7[expr_context]); }
                     | TUPLE LPAREN LBRACE listof_expr RBRACE COMMA expr_context RPAREN
                       { $$[expr] = Absyn.TUPLE($4[listof_expr], $7[expr_context]); }

expr_context         : LOAD LPAREN RPAREN
                       { $$[expr_context] = Absyn.LOAD(); }
                     | STORE LPAREN RPAREN
                       { $$[expr_context] = Absyn.STORE(); }
                     | DEL LPAREN RPAREN
                       { $$[expr_context] = Absyn.DEL(); }
                     | AUGLOAD LPAREN RPAREN
                       { $$[expr_context] = Absyn.AUGLOAD(); }
                     | AUGSTORE LPAREN RPAREN
                       { $$[expr_context] = Absyn.AUGSTORE(); }
                     | PARAM LPAREN RPAREN
                       { $$[expr_context] = Absyn.PARAM(); }

slice                : SLICE LPAREN optional_expr COMMA optional_expr COMMA optional_expr RPAREN
                       { $$[slice] = Absyn.SLICE($3[optional_expr], $5[optional_expr], $7[optional_expr]); }
                     | EXTSLICE LPAREN LBRACE listof_slice RBRACE RPAREN
                       { $$[slice] = Absyn.EXTSLICE($4[listof_slice]); }
                     | INDEX LPAREN expr RPAREN
                       { $$[slice] = Absyn.INDEX($3[expr]); }

boolop               : AND_OP LPAREN RPAREN
                       { $$[boolop] = Absyn.AND_OP(); }
                     | OR_OP LPAREN RPAREN
                       { $$[boolop] = Absyn.OR_OP(); }

arithmeticop         : ADD_OP LPAREN RPAREN
                       { $$[arithmeticop] = Absyn.ADD_OP(); }
                     | SUB_OP LPAREN RPAREN
                       { $$[arithmeticop] = Absyn.SUB_OP(); }
                     | MULT_OP LPAREN RPAREN
                       { $$[arithmeticop] = Absyn.MULT_OP(); }
                     | DIV_OP LPAREN RPAREN
                       { $$[arithmeticop] = Absyn.DIV_OP(); }
                     | MOD_OP LPAREN RPAREN
                       { $$[arithmeticop] = Absyn.MOD_OP(); }
                     | POW_OP LPAREN RPAREN
                       { $$[arithmeticop] = Absyn.POW_OP(); }
                     | LSHIFT_OP LPAREN RPAREN
                       { $$[arithmeticop] = Absyn.LSHIFT_OP(); }
                     | RSHIFT_OP LPAREN RPAREN
                       { $$[arithmeticop] = Absyn.RSHIFT_OP(); }
                     | BITOR_OP LPAREN RPAREN
                       { $$[arithmeticop] = Absyn.BITOR_OP(); }
                     | BITXOR_OP LPAREN RPAREN
                       { $$[arithmeticop] = Absyn.BITXOR_OP(); }
                     | BITAND_OP LPAREN RPAREN
                       { $$[arithmeticop] = Absyn.BITAND_OP(); }
                     | FLOORDIV_OP LPAREN RPAREN
                       { $$[arithmeticop] = Absyn.FLOORDIV_OP(); }

unaryop              : INVERT_OP LPAREN RPAREN
                       { $$[unaryop] = Absyn.INVERT_OP(); }
                     | NOT_OP LPAREN RPAREN
                       { $$[unaryop] = Absyn.NOT_OP(); }
                     | UADD_OP LPAREN RPAREN
                       { $$[unaryop] = Absyn.UADD_OP(); }
                     | USUB_OP LPAREN RPAREN
                       { $$[unaryop] = Absyn.USUB_OP(); }

cmpop                : EQ_OP LPAREN RPAREN
                       { $$[cmpop] = Absyn.EQ_OP(); }
                     | NOTEQ_OP LPAREN RPAREN
                       { $$[cmpop] = Absyn.NOTEQ_OP(); }
                     | LT_OP LPAREN RPAREN
                       { $$[cmpop] = Absyn.LT_OP(); }
                     | LTE_OP LPAREN RPAREN
                       { $$[cmpop] = Absyn.LTE_OP(); }
                     | GT_OP LPAREN RPAREN
                       { $$[cmpop] = Absyn.GT_OP(); }
                     | GTE_OP LPAREN RPAREN
                       { $$[cmpop] = Absyn.GTE_OP(); }
                     | IS_OP LPAREN RPAREN
                       { $$[cmpop] = Absyn.IS_OP(); }
                     | ISNOT_OP LPAREN RPAREN
                       { $$[cmpop] = Absyn.ISNOT_OP(); }
                     | IN_OP LPAREN RPAREN
                       { $$[cmpop] = Absyn.IN_OP(); }
                     | NOTIN_OP LPAREN RPAREN
                       { $$[cmpop] = Absyn.NOTIN_OP(); }

comprehension        : COMPREHENSION LPAREN expr COMMA expr COMMA LBRACE listof_expr RBRACE RPAREN
                       { $$[comprehension] = Absyn.COMPREHENSION($3[expr], $5[expr], $8[listof_expr]); }

excepthandler        : EXCEPTHANDLER LPAREN optional_expr COMMA optional_identifier COMMA LBRACE listof_stmt RBRACE RPAREN
                       { $$[excepthandler] = Absyn.EXCEPTHANDLER($3[optional_expr], $5[optional_identifier], $8[listof_stmt]); }

arguments            : ARGUMENTS LPAREN LBRACE listof_arg RBRACE COMMA optional_arg COMMA LBRACE listof_arg RBRACE COMMA LBRACE listof_expr RBRACE COMMA optional_arg COMMA LBRACE listof_expr RBRACE RPAREN
                       { $$[arguments] = Absyn.ARGUMENTS($4[listof_arg], $7[optional_arg], $10[listof_arg], $14[listof_expr], $17[optional_arg], $20[listof_expr]); }

arg                  : ARG LPAREN STRING COMMA optional_expr RPAREN
                       { $$[arg] = Absyn.ARG($3[STRING], $5[optional_expr]); }

keyword              : KEYWORD LPAREN STRING COMMA expr RPAREN
                       { $$[keyword] = Absyn.KEYWORD($3[STRING], $5[expr]); }

alias                : ALIAS LPAREN STRING COMMA optional_identifier RPAREN
                       { $$[alias] = Absyn.ALIAS($3[STRING], $5[optional_identifier]); }

withitem             : WITHITEM LPAREN expr COMMA optional_expr RPAREN
                       { $$[withitem] = Absyn.WITHITEM($3[expr], $5[optional_expr]); }

singleton            : TRUE
                       { $$[singleton] = Absyn.TRUE(); }
                     | FALSE
                       { $$[singleton] = Absyn.FALSE(); }
                     | NONE
                       { $$[singleton] = Absyn.PYNONE(); }

optional_expr        : expr
                       { $$[Option<expr>] = SOME($1); }
                     | NONE
                       { $$[Option<expr>] = NONE(); }

optional_identifier  : STRING
                       { $$[Option<String>] = SOME($1); }
                     | NONE
                       { $$[Option<String>] = NONE(); }

optional_object      : OBJECT
                       { $$[Option<String>] = SOME($1); }
                     | NONE
                       { $$[Option<String>] = NONE(); }

optional_arg         : arg
                       { $$[Option<arg>] = SOME($1); }
                     | NONE
                       { $$[Option<arg>] = NONE(); }

listof_stmt          : stmt COMMA listof_stmt
                       { $$[list<stmt>] = $1[stmt]::$3[listof_stmt]; }
                     | stmt
                       { $$[list<stmt>] = $1[stmt]::{}; }
                     | 
                       { $$[list<stmt>] = {}; }

listof_expr          : expr COMMA listof_expr
                       { $$[list<expr>] = $1[expr]::$3[listof_expr]; }
                     | expr
                       { $$[list<expr>] = $1[expr]::{}; }
                     | 
                       { $$[list<expr>] = {}; }

listof_keyword       : keyword COMMA listof_keyword
                       { $$[list<keyword>] = $1[keyword]::$3[listof_keyword]; }
                     | keyword
                       { $$[list<keyword>] = $1[keyword]::{}; }
                     | 
                       { $$[list<keyword>] = {}; }

listof_withitem      : withitem COMMA listof_withitem
                       { $$[list<withitem>] = $1[withitem]::$3[listof_withitem]; }
                     | withitem
                       { $$[list<withitem>] = $1[withitem]::{}; }
                     | 
                       { $$[list<withitem>] = {}; }

listof_excepthandler : excepthandler COMMA listof_excepthandler
                       { $$[list<excepthandler>] = $1[excepthandler]::$3[listof_excepthandler]; }
                     | excepthandler
                       { $$[list<excepthandler>] = $1[excepthandler]::{}; }
                     | 
                       { $$[list<excepthandler>] = {}; }

listof_alias         : alias COMMA listof_alias
                       { $$[list<alias>] = $1[alias]::$3[listof_alias]; }
                     | alias
                       { $$[list<alias>] = $1[alias]::{}; }
                     | 
                       { $$[list<alias>] = {}; }

listof_identifier    : STRING COMMA listof_identifier
                       { $$[list<String>] = $1[String]::$3[listof_identifier]; }
                     | STRING
                       { $$[list<String>] = $1[String]::{}; }
                     | 
                       { $$[list<String>] = {}; }

listof_comprehension : comprehension COMMA listof_comprehension
                       { $$[list<comprehension>] = $1[comprehension]::$3[listof_comprehension]; }
                     | comprehension
                       { $$[list<comprehension>] = $1[comprehension]::{}; }
                     | 
                       { $$[list<comprehension>] = {}; }

listof_cmpop         : cmpop COMMA listof_cmpop
                       { $$[list<cmpop>] = $1[cmpop]::$3[listof_cmpop]; }
                     | cmpop
                       { $$[list<cmpop>] = $1[cmpop]::{}; }
                     | 
                       { $$[list<cmpop>] = {}; }

listof_slice         : slice COMMA listof_slice
                       { $$[list<slice>] = $1[slice]::$3[listof_slice]; }
                     | slice
                       { $$[list<slice>] = $1[slice]::{}; }
                     | 
                       { $$[list<slice>] = {}; }

listof_arg           : arg COMMA listof_arg
                       { $$[list<arg>] = $1[arg]::$3[listof_arg]; }
                     | arg
                       { $$[list<arg>] = $1[arg]::{}; }
                     | 
                       { $$[list<arg>] = {}; }


%%

