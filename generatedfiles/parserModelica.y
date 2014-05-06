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

%token ADD
%token ALIAS
%token AND
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
%token BITAND
%token BITOR
%token BITXOR
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
%token DIV
%token ELLIPSIS
%token EQ
%token EXCEPTHANDLER
%token EXPR
%token EXTSLICE
%token FALSE
%token FLOORDIV
%token FOR
%token FUNCTIONDEF
%token GENERATOREXP
%token GLOBAL
%token GT
%token GTE
%token IF
%token IFEXP
%token IMPORT
%token IMPORTFROM
%token IN
%token INDEX
%token INVERT
%token IS
%token ISNOT
%token KEYWORD
%token LAMBDA
%token LIST
%token LISTCOMP
%token LOAD
%token LSHIFT
%token LT
%token LTE
%token MOD
%token MODULE
%token MULT
%token NAME
%token NAMECONSTANT
%token NONE
%token NONLOCAL
%token NOT
%token NOTEQ
%token NOTIN
%token NUM
%token OR
%token PARAM
%token PASS
%token POW
%token RAISE
%token RETURN
%token RSHIFT
%token SET
%token SETCOMP
%token SLICE
%token STARRED
%token STORE
%token STR
%token SUB
%token SUBSCRIPT
%token TRUE
%token TRY
%token TUPLE
%token UADD
%token UNARYOP
%token USUB
%token WHILE
%token WITH
%token WITHITEM
%token YIELD
%token YIELDFROM


%%

mod                  : MODULE LPAREN LBRACE listof_stmt RBRACE RPAREN
                       { (absyntree)[mod] = Absyn.MODULE($4[listof_stmt]); }

stmt                 : FUNCTIONDEF LPAREN STRING COMMA arguments COMMA LBRACE listof_stmt RBRACE COMMA LBRACE listof_expr RBRACE COMMA optional_expr RPAREN
                       { $$[stmt] = Absyn.FUNCTIONDEF_ST($3, $5[arguments], $8[listof_stmt], $12[listof_expr], $15[optional_expr]); }
                     | CLASSDEF LPAREN STRING COMMA LBRACE listof_expr RBRACE COMMA LBRACE listof_keyword RBRACE COMMA optional_expr COMMA optional_expr COMMA LBRACE listof_stmt RBRACE COMMA LBRACE listof_expr RBRACE RPAREN
                       { $$[stmt] = Absyn.CLASSDEF_ST($3, $6[listof_expr], $10[listof_keyword], $13[optional_expr], $15[optional_expr], $18[listof_stmt], $22[listof_expr]); }
                     | RETURN LPAREN optional_expr RPAREN
                       { $$[stmt] = Absyn.RETURN_ST($3[optional_expr]); }
                     | DELETE LPAREN LBRACE listof_expr RBRACE RPAREN
                       { $$[stmt] = Absyn.DELETE_ST($4[listof_expr]); }
                     | ASSIGN LPAREN LBRACE listof_expr RBRACE COMMA expr RPAREN
                       { $$[stmt] = Absyn.ASSIGN_ST($4[listof_expr], $7[expr]); }
                     | AUGASSIGN LPAREN expr COMMA arithmeticop COMMA expr RPAREN
                       { $$[stmt] = Absyn.AUGASSIGN_ST($3[expr], $5[arithmeticop], $7[expr]); }
                     | FOR LPAREN expr COMMA expr COMMA LBRACE listof_stmt RBRACE COMMA LBRACE listof_stmt RBRACE RPAREN
                       { $$[stmt] = Absyn.FOR_ST($3[expr], $5[expr], $8[listof_stmt], $12[listof_stmt]); }
                     | WHILE LPAREN expr COMMA LBRACE listof_stmt RBRACE COMMA LBRACE listof_stmt RBRACE RPAREN
                       { $$[stmt] = Absyn.WHILE_ST($3[expr], $6[listof_stmt], $10[listof_stmt]); }
                     | IF LPAREN expr COMMA LBRACE listof_stmt RBRACE COMMA LBRACE listof_stmt RBRACE RPAREN
                       { $$[stmt] = Absyn.IF_ST($3[expr], $6[listof_stmt], $10[listof_stmt]); }
                     | WITH LPAREN LBRACE listof_withitem RBRACE COMMA LBRACE listof_stmt RBRACE RPAREN
                       { $$[stmt] = Absyn.WITH_ST($4[listof_withitem], $8[listof_stmt]); }
                     | RAISE LPAREN optional_expr COMMA optional_expr RPAREN
                       { $$[stmt] = Absyn.RAISE_ST($3[optional_expr], $5[optional_expr]); }
                     | TRY LPAREN LBRACE listof_stmt RBRACE COMMA LBRACE listof_excepthandler RBRACE COMMA LBRACE listof_stmt RBRACE COMMA LBRACE listof_stmt RBRACE RPAREN
                       { $$[stmt] = Absyn.TRY_ST($4[listof_stmt], $8[listof_excepthandler], $12[listof_stmt], $16[listof_stmt]); }
                     | ASSERT LPAREN expr COMMA optional_expr RPAREN
                       { $$[stmt] = Absyn.ASSERT_ST($3[expr], $5[optional_expr]); }
                     | IMPORT LPAREN LBRACE listof_alias RBRACE RPAREN
                       { $$[stmt] = Absyn.IMPORT_ST($4[listof_alias]); }
                     | IMPORTFROM LPAREN optional_identifier COMMA LBRACE listof_alias RBRACE COMMA optional_object RPAREN
                       { $$[stmt] = Absyn.IMPORTFROM_ST($3[optional_identifier], $6[listof_alias], $9[optional_object]); }
                     | GLOBAL LPAREN LBRACE listof_identifier RBRACE RPAREN
                       { $$[stmt] = Absyn.GLOBAL_ST($4[listof_identifier]); }
                     | NONLOCAL LPAREN LBRACE listof_identifier RBRACE RPAREN
                       { $$[stmt] = Absyn.NONLOCAL_ST($4[listof_identifier]); }
                     | EXPR LPAREN expr RPAREN
                       { $$[stmt] = Absyn.EXPR_ST($3[expr]); }
                     | PASS LPAREN RPAREN
                       { $$[stmt] = Absyn.PASS_ST(); }
                     | BREAK LPAREN RPAREN
                       { $$[stmt] = Absyn.BREAK_ST(); }
                     | CONTINUE LPAREN RPAREN
                       { $$[stmt] = Absyn.CONTINUE_ST(); }

expr                 : BOOLOP LPAREN boolop COMMA LBRACE listof_expr RBRACE RPAREN
                       { $$[expr] = Absyn.BOOLOP_EX($3[boolop], $6[listof_expr]); }
                     | BINOP LPAREN expr COMMA arithmeticop COMMA expr RPAREN
                       { $$[expr] = Absyn.BINOP_EX($3[expr], $5[arithmeticop], $7[expr]); }
                     | UNARYOP LPAREN unaryop COMMA expr RPAREN
                       { $$[expr] = Absyn.UNARYOP_EX($3[unaryop], $5[expr]); }
                     | LAMBDA LPAREN arguments COMMA expr RPAREN
                       { $$[expr] = Absyn.LAMBDA_EX($3[arguments], $5[expr]); }
                     | IFEXP LPAREN expr COMMA expr COMMA expr RPAREN
                       { $$[expr] = Absyn.IFEXP_EX($3[expr], $5[expr], $7[expr]); }
                     | DICT LPAREN LBRACE listof_expr RBRACE COMMA LBRACE listof_expr RBRACE RPAREN
                       { $$[expr] = Absyn.DICT_EX($4[listof_expr], $8[listof_expr]); }
                     | SET LPAREN LBRACE listof_expr RBRACE RPAREN
                       { $$[expr] = Absyn.SET_EX($4[listof_expr]); }
                     | LISTCOMP LPAREN expr COMMA LBRACE listof_comprehension RBRACE RPAREN
                       { $$[expr] = Absyn.LISTCOMP_EX($3[expr], $6[listof_comprehension]); }
                     | SETCOMP LPAREN expr COMMA LBRACE listof_comprehension RBRACE RPAREN
                       { $$[expr] = Absyn.SETCOMP_EX($3[expr], $6[listof_comprehension]); }
                     | DICTCOMP LPAREN expr COMMA expr COMMA LBRACE listof_comprehension RBRACE RPAREN
                       { $$[expr] = Absyn.DICTCOMP_EX($3[expr], $5[expr], $8[listof_comprehension]); }
                     | GENERATOREXP LPAREN expr COMMA LBRACE listof_comprehension RBRACE RPAREN
                       { $$[expr] = Absyn.GENERATOREXP_EX($3[expr], $6[listof_comprehension]); }
                     | YIELD LPAREN optional_expr RPAREN
                       { $$[expr] = Absyn.YIELD_EX($3[optional_expr]); }
                     | YIELDFROM LPAREN expr RPAREN
                       { $$[expr] = Absyn.YIELDFROM_EX($3[expr]); }
                     | COMPARE LPAREN expr COMMA LBRACE listof_cmpop RBRACE COMMA LBRACE listof_expr RBRACE RPAREN
                       { $$[expr] = Absyn.COMPARE_EX($3[expr], $6[listof_cmpop], $10[listof_expr]); }
                     | CALL LPAREN expr COMMA LBRACE listof_expr RBRACE COMMA LBRACE listof_keyword RBRACE COMMA optional_expr COMMA optional_expr RPAREN
                       { $$[expr] = Absyn.CALL_EX($3[expr], $6[listof_expr], $10[listof_keyword], $13[optional_expr], $15[optional_expr]); }
                     | NUM LPAREN OBJECT RPAREN
                       { $$[expr] = Absyn.NUM_EX($3); }
                     | STR LPAREN STRING RPAREN
                       { $$[expr] = Absyn.STR_EX($3); }
                     | BYTES LPAREN B STRING RPAREN
                       { $$[expr] = Absyn.BYTES_EX($4); }
                     | NAMECONSTANT LPAREN singleton RPAREN
                       { $$[expr] = Absyn.NAMECONSTANT_EX($3[singleton]); }
                     | ELLIPSIS LPAREN RPAREN
                       { $$[expr] = Absyn.ELLIPSIS_EX(); }
                     | ATTRIBUTE LPAREN expr COMMA STRING COMMA expr_context RPAREN
                       { $$[expr] = Absyn.ATTRIBUTE_EX($3[expr], $5, $7[expr_context]); }
                     | SUBSCRIPT LPAREN expr COMMA slice COMMA expr_context RPAREN
                       { $$[expr] = Absyn.SUBSCRIPT_EX($3[expr], $5[slice], $7[expr_context]); }
                     | STARRED LPAREN expr COMMA expr_context RPAREN
                       { $$[expr] = Absyn.STARRED_EX($3[expr], $5[expr_context]); }
                     | NAME LPAREN STRING COMMA expr_context RPAREN
                       { $$[expr] = Absyn.NAME_EX($3, $5[expr_context]); }
                     | LIST LPAREN LBRACE listof_expr RBRACE COMMA expr_context RPAREN
                       { $$[expr] = Absyn.LIST_EX($4[listof_expr], $7[expr_context]); }
                     | TUPLE LPAREN LBRACE listof_expr RBRACE COMMA expr_context RPAREN
                       { $$[expr] = Absyn.TUPLE_EX($4[listof_expr], $7[expr_context]); }

expr_context         : LOAD LPAREN RPAREN
                       { $$[expr_context] = Absyn.LOAD_EC(); }
                     | STORE LPAREN RPAREN
                       { $$[expr_context] = Absyn.STORE_EC(); }
                     | DEL LPAREN RPAREN
                       { $$[expr_context] = Absyn.DEL_EC(); }
                     | AUGLOAD LPAREN RPAREN
                       { $$[expr_context] = Absyn.AUGLOAD_EC(); }
                     | AUGSTORE LPAREN RPAREN
                       { $$[expr_context] = Absyn.AUGSTORE_EC(); }
                     | PARAM LPAREN RPAREN
                       { $$[expr_context] = Absyn.PARAM_EC(); }

slice                : SLICE LPAREN optional_expr COMMA optional_expr COMMA optional_expr RPAREN
                       { $$[slice] = Absyn.SLICE($3[optional_expr], $5[optional_expr], $7[optional_expr]); }
                     | EXTSLICE LPAREN LBRACE listof_slice RBRACE RPAREN
                       { $$[slice] = Absyn.EXTSLICE($4[listof_slice]); }
                     | INDEX LPAREN expr RPAREN
                       { $$[slice] = Absyn.INDEX($3[expr]); }

boolop               : AND LPAREN RPAREN
                       { $$[boolop] = Absyn.AND_OP(); }
                     | OR LPAREN RPAREN
                       { $$[boolop] = Absyn.OR_OP(); }

arithmeticop         : ADD LPAREN RPAREN
                       { $$[arithmeticop] = Absyn.ADD_OP(); }
                     | SUB LPAREN RPAREN
                       { $$[arithmeticop] = Absyn.SUB_OP(); }
                     | MULT LPAREN RPAREN
                       { $$[arithmeticop] = Absyn.MULT_OP(); }
                     | DIV LPAREN RPAREN
                       { $$[arithmeticop] = Absyn.DIV_OP(); }
                     | MOD LPAREN RPAREN
                       { $$[arithmeticop] = Absyn.MOD_OP(); }
                     | POW LPAREN RPAREN
                       { $$[arithmeticop] = Absyn.POW_OP(); }
                     | LSHIFT LPAREN RPAREN
                       { $$[arithmeticop] = Absyn.LSHIFT_OP(); }
                     | RSHIFT LPAREN RPAREN
                       { $$[arithmeticop] = Absyn.RSHIFT_OP(); }
                     | BITOR LPAREN RPAREN
                       { $$[arithmeticop] = Absyn.BITOR_OP(); }
                     | BITXOR LPAREN RPAREN
                       { $$[arithmeticop] = Absyn.BITXOR_OP(); }
                     | BITAND LPAREN RPAREN
                       { $$[arithmeticop] = Absyn.BITAND_OP(); }
                     | FLOORDIV LPAREN RPAREN
                       { $$[arithmeticop] = Absyn.FLOORDIV_OP(); }

unaryop              : INVERT LPAREN RPAREN
                       { $$[unaryop] = Absyn.INVERT_OP(); }
                     | NOT LPAREN RPAREN
                       { $$[unaryop] = Absyn.NOT_OP(); }
                     | UADD LPAREN RPAREN
                       { $$[unaryop] = Absyn.UADD_OP(); }
                     | USUB LPAREN RPAREN
                       { $$[unaryop] = Absyn.USUB_OP(); }

cmpop                : EQ LPAREN RPAREN
                       { $$[cmpop] = Absyn.EQ_OP(); }
                     | NOTEQ LPAREN RPAREN
                       { $$[cmpop] = Absyn.NOTEQ_OP(); }
                     | LT LPAREN RPAREN
                       { $$[cmpop] = Absyn.LT_OP(); }
                     | LTE LPAREN RPAREN
                       { $$[cmpop] = Absyn.LTE_OP(); }
                     | GT LPAREN RPAREN
                       { $$[cmpop] = Absyn.GT_OP(); }
                     | GTE LPAREN RPAREN
                       { $$[cmpop] = Absyn.GTE_OP(); }
                     | IS LPAREN RPAREN
                       { $$[cmpop] = Absyn.IS_OP(); }
                     | ISNOT LPAREN RPAREN
                       { $$[cmpop] = Absyn.ISNOT_OP(); }
                     | IN LPAREN RPAREN
                       { $$[cmpop] = Absyn.IN_OP(); }
                     | NOTIN LPAREN RPAREN
                       { $$[cmpop] = Absyn.NOTIN_OP(); }

comprehension        : COMPREHENSION LPAREN expr COMMA expr COMMA LBRACE listof_expr RBRACE RPAREN
                       { $$[comprehension] = Absyn.COMPREHENSION($3[expr], $5[expr], $8[listof_expr]); }

excepthandler        : EXCEPTHANDLER LPAREN optional_expr COMMA optional_identifier COMMA LBRACE listof_stmt RBRACE RPAREN
                       { $$[excepthandler] = Absyn.EXCEPTHANDLER($3[optional_expr], $5[optional_identifier], $8[listof_stmt]); }

arguments            : ARGUMENTS LPAREN LBRACE listof_arg RBRACE COMMA optional_arg COMMA LBRACE listof_arg RBRACE COMMA LBRACE listof_expr RBRACE COMMA optional_arg COMMA LBRACE listof_expr RBRACE RPAREN
                       { $$[arguments] = Absyn.ARGUMENTS($4[listof_arg], $7[optional_arg], $10[listof_arg], $14[listof_expr], $17[optional_arg], $20[listof_expr]); }

arg                  : ARG LPAREN STRING COMMA optional_expr RPAREN
                       { $$[arg] = Absyn.ARG($3, $5[optional_expr]); }

keyword              : KEYWORD LPAREN STRING COMMA expr RPAREN
                       { $$[keyword] = Absyn.KEYWORD($3, $5[expr]); }

alias                : ALIAS LPAREN STRING COMMA optional_identifier RPAREN
                       { $$[alias] = Absyn.ALIAS($3, $5[optional_identifier]); }

withitem             : WITHITEM LPAREN expr COMMA optional_expr RPAREN
                       { $$[withitem] = Absyn.WITHITEM($3[expr], $5[optional_expr]); }

singleton            : TRUE
                       { $$[singleton] = Absyn.TRUE(); }
                     | FALSE
                       { $$[singleton] = Absyn.FALSE(); }
                     | NONE
                       { $$[singleton] = Absyn.PYNONE(); }

optional_expr        : expr
                       { $$[optional_expr] = SOME($1[expr]); }
                     | NONE
                       { $$[optional_expr] = NONE(); }

optional_identifier  : STRING
                       { $$[optional_identifier] = SOME($1[identifier]); }
                     | NONE
                       { $$[optional_identifier] = NONE(); }

optional_object      : OBJECT
                       { $$[optional_object] = SOME($1[object]); }
                     | NONE
                       { $$[optional_object] = NONE(); }

optional_arg         : arg
                       { $$[optional_arg] = SOME($1[arg]); }
                     | NONE
                       { $$[optional_arg] = NONE(); }

listof_stmt          : stmt COMMA listof_stmt
                       { $$[listof_stmt] = $1[stmt]::$3[listof_stmt]; }
                     | stmt
                       { $$[listof_stmt] = $1[stmt]::{}; }
                     | 
                       { $$[listof_stmt] = {}; }

listof_expr          : expr COMMA listof_expr
                       { $$[listof_expr] = $1[expr]::$3[listof_expr]; }
                     | expr
                       { $$[listof_expr] = $1[expr]::{}; }
                     | 
                       { $$[listof_expr] = {}; }

listof_keyword       : keyword COMMA listof_keyword
                       { $$[listof_keyword] = $1[keyword]::$3[listof_keyword]; }
                     | keyword
                       { $$[listof_keyword] = $1[keyword]::{}; }
                     | 
                       { $$[listof_keyword] = {}; }

listof_withitem      : withitem COMMA listof_withitem
                       { $$[listof_withitem] = $1[withitem]::$3[listof_withitem]; }
                     | withitem
                       { $$[listof_withitem] = $1[withitem]::{}; }
                     | 
                       { $$[listof_withitem] = {}; }

listof_excepthandler : excepthandler COMMA listof_excepthandler
                       { $$[listof_excepthandler] = $1[excepthandler]::$3[listof_excepthandler]; }
                     | excepthandler
                       { $$[listof_excepthandler] = $1[excepthandler]::{}; }
                     | 
                       { $$[listof_excepthandler] = {}; }

listof_alias         : alias COMMA listof_alias
                       { $$[listof_alias] = $1[alias]::$3[listof_alias]; }
                     | alias
                       { $$[listof_alias] = $1[alias]::{}; }
                     | 
                       { $$[listof_alias] = {}; }

listof_identifier    : STRING COMMA listof_identifier
                       { $$[listof_identifier] = $1::$3[listof_identifier]; }
                     | STRING
                       { $$[listof_identifier] = $1::{}; }
                     | 
                       { $$[listof_identifier] = {}; }

listof_comprehension : comprehension COMMA listof_comprehension
                       { $$[listof_comprehension] = $1[comprehension]::$3[listof_comprehension]; }
                     | comprehension
                       { $$[listof_comprehension] = $1[comprehension]::{}; }
                     | 
                       { $$[listof_comprehension] = {}; }

listof_cmpop         : cmpop COMMA listof_cmpop
                       { $$[listof_cmpop] = $1[cmpop]::$3[listof_cmpop]; }
                     | cmpop
                       { $$[listof_cmpop] = $1[cmpop]::{}; }
                     | 
                       { $$[listof_cmpop] = {}; }

listof_slice         : slice COMMA listof_slice
                       { $$[listof_slice] = $1[slice]::$3[listof_slice]; }
                     | slice
                       { $$[listof_slice] = $1[slice]::{}; }
                     | 
                       { $$[listof_slice] = {}; }

listof_arg           : arg COMMA listof_arg
                       { $$[listof_arg] = $1[arg]::$3[listof_arg]; }
                     | arg
                       { $$[listof_arg] = $1[arg]::{}; }
                     | 
                       { $$[listof_arg] = {}; }


%%

