%{
#include <cstdio>
#include <iostream>
using namespace std;

// Yep, I copied it from the snazzle tutorial.
// stuff from flex that bison needs to know about:
extern "C" int yylex();
extern "C" int yyparse();
extern "C" FILE *yyin;

void yyerror(const char *s);

/* Changes to actual grammar:
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
 */

%}

%union {
  long int ival;
  float    fval;
  char    *sval;
}

%start mod

%token <sval> string
%token object
%token singleton

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
%token Expression
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
%token Interactive
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
%token Suite
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
%token annotation
%token arg_
%token args
%token arguments_
%token asname
%token attr
%token bases
%token body
%token cause
%token comparators
%token comprehension_
%token context_expr
%token ctx
%token decorator
%token decorator_list
%token defaults
%token dims
%token elt
%token elts
%token exc
%token finalbody
%token func
%token generators
%token handlers
%token id
%token ifs
%token items
%token iter
%token key
%token keys
%token keyword_
%token keywords
%token kw_defaults
%token kwarg
%token kwargs
%token kwonlyargs
%token left
%token level
%token lower
%token module
%token msg
%token n
%token name
%token names
%token op
%token operand
%token ops
%token optional_vars
%token orelse
%token returns
%token right
%token s
%token slice_
%token starargs
%token step
%token target
%token targets
%token test
%token type
%token upper
%token value
%token values
%token vararg
%token withitem_

%%
mod : Module '(' '[' listof_stmt ']' ')' ;
stmt : FunctionDef '(' string ',' arguments ',' '[' listof_stmt ']' ',' '[' listof_expr ']' ',' optional_expr ')' | ClassDef '(' string ',' '[' listof_expr ']' ',' '[' listof_keyword ']' ',' optional_expr ',' optional_expr ',' '[' listof_stmt ']' ',' '[' listof_expr ']' ')' | Return '(' optional_expr ')' | Delete '(' '[' listof_expr ']' ')' | Assign '(' '[' listof_expr ']' ',' expr ')' | AugAssign '(' expr ',' operator ',' expr ')' | For '(' expr ',' expr ',' '[' listof_stmt ']' ',' '[' listof_stmt ']' ')' | While '(' expr ',' '[' listof_stmt ']' ',' '[' listof_stmt ']' ')' | If '(' expr ',' '[' listof_stmt ']' ',' '[' listof_stmt ']' ')' | With '(' '[' listof_withitem ']' ',' '[' listof_stmt ']' ')' | Raise '(' optional_expr ',' optional_expr ')' | Try '(' '[' listof_stmt ']' ',' '[' listof_excepthandler ']' ',' '[' listof_stmt ']' ',' '[' listof_stmt ']' ')' | Assert '(' expr ',' optional_expr ')' | Import '(' '[' listof_alias ']' ')' | ImportFrom '(' optional_identifier ',' '[' listof_alias ']' ',' optional_object ')' | Global '(' '[' listof_identifier ']' ')' | Nonlocal '(' '[' listof_identifier ']' ')' | Expr '(' expr ')' | Pass '(' ')' | Break '(' ')' | Continue '(' ')' ;
expr : BoolOp '(' boolop ',' '[' listof_expr ']' ')' | BinOp '(' expr ',' operator ',' expr ')' | UnaryOp '(' unaryop ',' expr ')' | Lambda '(' arguments ',' expr ')' | IfExp '(' expr ',' expr ',' expr ')' | Dict '(' '[' listof_expr ']' ',' '[' listof_expr ']' ')' | Set '(' '[' listof_expr ']' ')' | ListComp '(' expr ',' '[' listof_comprehension ']' ')' | SetComp '(' expr ',' '[' listof_comprehension ']' ')' | DictComp '(' expr ',' expr ',' '[' listof_comprehension ']' ')' | GeneratorExp '(' expr ',' '[' listof_comprehension ']' ')' | Yield '(' optional_expr ')' | YieldFrom '(' expr ')' | Compare '(' expr ',' '[' listof_cmpop ']' ',' '[' listof_expr ']' ')' | Call '(' expr ',' '[' listof_expr ']' ',' '[' listof_keyword ']' ',' optional_expr ',' optional_expr ')' | Num '(' object ')' | Str '(' string ')' | Bytes '(' 'b' string ')' | NameConstant '(' singleton ')' | Ellipsis '(' ')' | Attribute '(' expr ',' string ',' expr_context ')' | Subscript '(' expr ',' slice ',' expr_context ')' | Starred '(' expr ',' expr_context ')' | Name '(' string ',' expr_context ')' | List '(' '[' listof_expr ']' ',' expr_context ')' | Tuple '(' '[' listof_expr ']' ',' expr_context ')' ;
expr_context : Load '(' ')' | Store '(' ')' | Del '(' ')' | AugLoad '(' ')' | AugStore '(' ')' | Param '(' ')' ;
slice : Slice '(' optional_expr ',' optional_expr ',' optional_expr ')' | ExtSlice '(' '[' listof_slice ']' ')' | Index '(' expr ')' ;
boolop : And '(' ')' | Or '(' ')' ;
operator : Add '(' ')' | Sub '(' ')' | Mult '(' ')' | Div '(' ')' | Mod '(' ')' | Pow '(' ')' | LShift '(' ')' | RShift '(' ')' | BitOr '(' ')' | BitXor '(' ')' | BitAnd '(' ')' | FloorDiv '(' ')' ;
unaryop : Invert '(' ')' | Not '(' ')' | UAdd '(' ')' | USub '(' ')' ;
cmpop : Eq '(' ')' | NotEq '(' ')' | Lt '(' ')' | LtE '(' ')' | Gt '(' ')' | GtE '(' ')' | Is '(' ')' | IsNot '(' ')' | In '(' ')' | NotIn '(' ')' ;
comprehension : comprehension_ '(' expr ',' expr ',' '[' listof_expr ']' ')' ;
excepthandler : ExceptHandler '(' optional_expr ',' optional_identifier ',' '[' listof_stmt ']' ')' ;
arguments : arguments_ '(' '[' listof_arg ']' ',' optional_arg ',' '[' listof_arg ']' ',' '[' listof_expr ']' ',' optional_arg ',' '[' listof_expr ']' ')' ;
arg : arg_ '(' string ',' optional_expr ')' ;
keyword : keyword_ '(' string ',' expr ')' ;
alias : alias_ '(' string ',' optional_identifier ')' ;
withitem : withitem_ '(' expr ',' optional_expr ')' ;

optional_expr : expr | None ;
optional_identifier : string | None ;
optional_object : object | None ;
optional_arg : arg | None ;

listof_stmt : stmt ',' listof_stmt | ;
listof_expr : expr ',' listof_expr | ;
listof_keyword : keyword ',' listof_keyword | ;
listof_withitem : withitem ',' listof_withitem | ;
listof_excepthandler : excepthandler ',' listof_excepthandler | ;
listof_alias : alias ',' listof_alias | ;
listof_identifier : string ',' listof_identifier | ;
listof_comprehension : comprehension ',' listof_comprehension | ;
listof_cmpop : cmpop ',' listof_cmpop | ;
listof_slice : slice ',' listof_slice | ;
listof_arg : arg ',' listof_arg | ;
%%

main() {
  // parse through the input until there is no more:
  do {
    yyparse();
  } while (!feof(yyin));
}

void yyerror(const char *s) {
  cout << "Parse error!  Message: " << s << endl;
  exit(1);
}

