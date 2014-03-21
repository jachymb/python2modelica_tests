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
 */

%}

%union {
  long int ival;
  float    fval;
  char    *sval;
}

%start mod

%token <sval> string
%token <sval> object
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
mod                  : Module '(' '[' listof_stmt ']' ')'
                       { cout << "Reducing <Module '(' '[' listof_stmt ']' ')'> to mod" << endl; }
;
stmt                 : FunctionDef '(' string ',' arguments ',' '[' listof_stmt ']' ',' '[' listof_expr ']' ',' optional_expr ')'
                       { cout << "Reducing <FunctionDef '(' string ',' arguments ',' '[' listof_stmt ']' ',' '[' listof_expr ']' ',' optional_expr ')'> to stmt" << endl; }
                     | ClassDef '(' string ',' '[' listof_expr ']' ',' '[' listof_keyword ']' ',' optional_expr ',' optional_expr ',' '[' listof_stmt ']' ',' '[' listof_expr ']' ')'
                       { cout << "Reducing <ClassDef '(' string ',' '[' listof_expr ']' ',' '[' listof_keyword ']' ',' optional_expr ',' optional_expr ',' '[' listof_stmt ']' ',' '[' listof_expr ']' ')'> to stmt" << endl; }
                     | Return '(' optional_expr ')'
                       { cout << "Reducing <Return '(' optional_expr ')'> to stmt" << endl; }
                     | Delete '(' '[' listof_expr ']' ')'
                       { cout << "Reducing <Delete '(' '[' listof_expr ']' ')'> to stmt" << endl; }
                     | Assign '(' '[' listof_expr ']' ',' expr ')'
                       { cout << "Reducing <Assign '(' '[' listof_expr ']' ',' expr ')'> to stmt" << endl; }
                     | AugAssign '(' expr ',' operator ',' expr ')'
                       { cout << "Reducing <AugAssign '(' expr ',' operator ',' expr ')'> to stmt" << endl; }
                     | For '(' expr ',' expr ',' '[' listof_stmt ']' ',' '[' listof_stmt ']' ')'
                       { cout << "Reducing <For '(' expr ',' expr ',' '[' listof_stmt ']' ',' '[' listof_stmt ']' ')'> to stmt" << endl; }
                     | While '(' expr ',' '[' listof_stmt ']' ',' '[' listof_stmt ']' ')'
                       { cout << "Reducing <While '(' expr ',' '[' listof_stmt ']' ',' '[' listof_stmt ']' ')'> to stmt" << endl; }
                     | If '(' expr ',' '[' listof_stmt ']' ',' '[' listof_stmt ']' ')'
                       { cout << "Reducing <If '(' expr ',' '[' listof_stmt ']' ',' '[' listof_stmt ']' ')'> to stmt" << endl; }
                     | With '(' '[' listof_withitem ']' ',' '[' listof_stmt ']' ')'
                       { cout << "Reducing <With '(' '[' listof_withitem ']' ',' '[' listof_stmt ']' ')'> to stmt" << endl; }
                     | Raise '(' optional_expr ',' optional_expr ')'
                       { cout << "Reducing <Raise '(' optional_expr ',' optional_expr ')'> to stmt" << endl; }
                     | Try '(' '[' listof_stmt ']' ',' '[' listof_excepthandler ']' ',' '[' listof_stmt ']' ',' '[' listof_stmt ']' ')'
                       { cout << "Reducing <Try '(' '[' listof_stmt ']' ',' '[' listof_excepthandler ']' ',' '[' listof_stmt ']' ',' '[' listof_stmt ']' ')'> to stmt" << endl; }
                     | Assert '(' expr ',' optional_expr ')'
                       { cout << "Reducing <Assert '(' expr ',' optional_expr ')'> to stmt" << endl; }
                     | Import '(' '[' listof_alias ']' ')'
                       { cout << "Reducing <Import '(' '[' listof_alias ']' ')'> to stmt" << endl; }
                     | ImportFrom '(' optional_identifier ',' '[' listof_alias ']' ',' optional_object ')'
                       { cout << "Reducing <ImportFrom '(' optional_identifier ',' '[' listof_alias ']' ',' optional_object ')'> to stmt" << endl; }
                     | Global '(' '[' listof_identifier ']' ')'
                       { cout << "Reducing <Global '(' '[' listof_identifier ']' ')'> to stmt" << endl; }
                     | Nonlocal '(' '[' listof_identifier ']' ')'
                       { cout << "Reducing <Nonlocal '(' '[' listof_identifier ']' ')'> to stmt" << endl; }
                     | Expr '(' expr ')'
                       { cout << "Reducing <Expr '(' expr ')'> to stmt" << endl; }
                     | Pass '(' ')'
                       { cout << "Reducing <Pass '(' ')'> to stmt" << endl; }
                     | Break '(' ')'
                       { cout << "Reducing <Break '(' ')'> to stmt" << endl; }
                     | Continue '(' ')'
                       { cout << "Reducing <Continue '(' ')'> to stmt" << endl; }
;
expr                 : BoolOp '(' boolop ',' '[' listof_expr ']' ')'
                       { cout << "Reducing <BoolOp '(' boolop ',' '[' listof_expr ']' ')'> to expr" << endl; }
                     | BinOp '(' expr ',' operator ',' expr ')'
                       { cout << "Reducing <BinOp '(' expr ',' operator ',' expr ')'> to expr" << endl; }
                     | UnaryOp '(' unaryop ',' expr ')'
                       { cout << "Reducing <UnaryOp '(' unaryop ',' expr ')'> to expr" << endl; }
                     | Lambda '(' arguments ',' expr ')'
                       { cout << "Reducing <Lambda '(' arguments ',' expr ')'> to expr" << endl; }
                     | IfExp '(' expr ',' expr ',' expr ')'
                       { cout << "Reducing <IfExp '(' expr ',' expr ',' expr ')'> to expr" << endl; }
                     | Dict '(' '[' listof_expr ']' ',' '[' listof_expr ']' ')'
                       { cout << "Reducing <Dict '(' '[' listof_expr ']' ',' '[' listof_expr ']' ')'> to expr" << endl; }
                     | Set '(' '[' listof_expr ']' ')'
                       { cout << "Reducing <Set '(' '[' listof_expr ']' ')'> to expr" << endl; }
                     | ListComp '(' expr ',' '[' listof_comprehension ']' ')'
                       { cout << "Reducing <ListComp '(' expr ',' '[' listof_comprehension ']' ')'> to expr" << endl; }
                     | SetComp '(' expr ',' '[' listof_comprehension ']' ')'
                       { cout << "Reducing <SetComp '(' expr ',' '[' listof_comprehension ']' ')'> to expr" << endl; }
                     | DictComp '(' expr ',' expr ',' '[' listof_comprehension ']' ')'
                       { cout << "Reducing <DictComp '(' expr ',' expr ',' '[' listof_comprehension ']' ')'> to expr" << endl; }
                     | GeneratorExp '(' expr ',' '[' listof_comprehension ']' ')'
                       { cout << "Reducing <GeneratorExp '(' expr ',' '[' listof_comprehension ']' ')'> to expr" << endl; }
                     | Yield '(' optional_expr ')'
                       { cout << "Reducing <Yield '(' optional_expr ')'> to expr" << endl; }
                     | YieldFrom '(' expr ')'
                       { cout << "Reducing <YieldFrom '(' expr ')'> to expr" << endl; }
                     | Compare '(' expr ',' '[' listof_cmpop ']' ',' '[' listof_expr ']' ')'
                       { cout << "Reducing <Compare '(' expr ',' '[' listof_cmpop ']' ',' '[' listof_expr ']' ')'> to expr" << endl; }
                     | Call '(' expr ',' '[' listof_expr ']' ',' '[' listof_keyword ']' ',' optional_expr ',' optional_expr ')'
                       { cout << "Reducing <Call '(' expr ',' '[' listof_expr ']' ',' '[' listof_keyword ']' ',' optional_expr ',' optional_expr ')'> to expr" << endl; }
                     | Num '(' object ')'
                       { cout << "Reducing <Num '(' object ')'> to expr" << endl; }
                     | Str '(' string ')'
                       { cout << "Reducing <Str '(' string ')'> to expr" << endl; }
                     | Bytes '(' 'b' string ')'
                       { cout << "Reducing <Bytes '(' 'b' string ')'> to expr" << endl; }
                     | NameConstant '(' singleton ')'
                       { cout << "Reducing <NameConstant '(' singleton ')'> to expr" << endl; }
                     | Ellipsis '(' ')'
                       { cout << "Reducing <Ellipsis '(' ')'> to expr" << endl; }
                     | Attribute '(' expr ',' string ',' expr_context ')'
                       { cout << "Reducing <Attribute '(' expr ',' string ',' expr_context ')'> to expr" << endl; }
                     | Subscript '(' expr ',' slice ',' expr_context ')'
                       { cout << "Reducing <Subscript '(' expr ',' slice ',' expr_context ')'> to expr" << endl; }
                     | Starred '(' expr ',' expr_context ')'
                       { cout << "Reducing <Starred '(' expr ',' expr_context ')'> to expr" << endl; }
                     | Name '(' string ',' expr_context ')'
                       { cout << "Reducing <Name '(' string ',' expr_context ')'> to expr" << endl; }
                     | List '(' '[' listof_expr ']' ',' expr_context ')'
                       { cout << "Reducing <List '(' '[' listof_expr ']' ',' expr_context ')'> to expr" << endl; }
                     | Tuple '(' '[' listof_expr ']' ',' expr_context ')'
                       { cout << "Reducing <Tuple '(' '[' listof_expr ']' ',' expr_context ')'> to expr" << endl; }
;
expr_context         : Load '(' ')'
                       { cout << "Reducing <Load '(' ')'> to expr_context" << endl; }
                     | Store '(' ')'
                       { cout << "Reducing <Store '(' ')'> to expr_context" << endl; }
                     | Del '(' ')'
                       { cout << "Reducing <Del '(' ')'> to expr_context" << endl; }
                     | AugLoad '(' ')'
                       { cout << "Reducing <AugLoad '(' ')'> to expr_context" << endl; }
                     | AugStore '(' ')'
                       { cout << "Reducing <AugStore '(' ')'> to expr_context" << endl; }
                     | Param '(' ')'
                       { cout << "Reducing <Param '(' ')'> to expr_context" << endl; }
;
slice                : Slice '(' optional_expr ',' optional_expr ',' optional_expr ')'
                       { cout << "Reducing <Slice '(' optional_expr ',' optional_expr ',' optional_expr ')'> to slice" << endl; }
                     | ExtSlice '(' '[' listof_slice ']' ')'
                       { cout << "Reducing <ExtSlice '(' '[' listof_slice ']' ')'> to slice" << endl; }
                     | Index '(' expr ')'
                       { cout << "Reducing <Index '(' expr ')'> to slice" << endl; }
;
boolop               : And '(' ')'
                       { cout << "Reducing <And '(' ')'> to boolop" << endl; }
                     | Or '(' ')'
                       { cout << "Reducing <Or '(' ')'> to boolop" << endl; }
;
operator             : Add '(' ')'
                       { cout << "Reducing <Add '(' ')'> to operator" << endl; }
                     | Sub '(' ')'
                       { cout << "Reducing <Sub '(' ')'> to operator" << endl; }
                     | Mult '(' ')'
                       { cout << "Reducing <Mult '(' ')'> to operator" << endl; }
                     | Div '(' ')'
                       { cout << "Reducing <Div '(' ')'> to operator" << endl; }
                     | Mod '(' ')'
                       { cout << "Reducing <Mod '(' ')'> to operator" << endl; }
                     | Pow '(' ')'
                       { cout << "Reducing <Pow '(' ')'> to operator" << endl; }
                     | LShift '(' ')'
                       { cout << "Reducing <LShift '(' ')'> to operator" << endl; }
                     | RShift '(' ')'
                       { cout << "Reducing <RShift '(' ')'> to operator" << endl; }
                     | BitOr '(' ')'
                       { cout << "Reducing <BitOr '(' ')'> to operator" << endl; }
                     | BitXor '(' ')'
                       { cout << "Reducing <BitXor '(' ')'> to operator" << endl; }
                     | BitAnd '(' ')'
                       { cout << "Reducing <BitAnd '(' ')'> to operator" << endl; }
                     | FloorDiv '(' ')'
                       { cout << "Reducing <FloorDiv '(' ')'> to operator" << endl; }
;
unaryop              : Invert '(' ')'
                       { cout << "Reducing <Invert '(' ')'> to unaryop" << endl; }
                     | Not '(' ')'
                       { cout << "Reducing <Not '(' ')'> to unaryop" << endl; }
                     | UAdd '(' ')'
                       { cout << "Reducing <UAdd '(' ')'> to unaryop" << endl; }
                     | USub '(' ')'
                       { cout << "Reducing <USub '(' ')'> to unaryop" << endl; }
;
cmpop                : Eq '(' ')'
                       { cout << "Reducing <Eq '(' ')'> to cmpop" << endl; }
                     | NotEq '(' ')'
                       { cout << "Reducing <NotEq '(' ')'> to cmpop" << endl; }
                     | Lt '(' ')'
                       { cout << "Reducing <Lt '(' ')'> to cmpop" << endl; }
                     | LtE '(' ')'
                       { cout << "Reducing <LtE '(' ')'> to cmpop" << endl; }
                     | Gt '(' ')'
                       { cout << "Reducing <Gt '(' ')'> to cmpop" << endl; }
                     | GtE '(' ')'
                       { cout << "Reducing <GtE '(' ')'> to cmpop" << endl; }
                     | Is '(' ')'
                       { cout << "Reducing <Is '(' ')'> to cmpop" << endl; }
                     | IsNot '(' ')'
                       { cout << "Reducing <IsNot '(' ')'> to cmpop" << endl; }
                     | In '(' ')'
                       { cout << "Reducing <In '(' ')'> to cmpop" << endl; }
                     | NotIn '(' ')'
                       { cout << "Reducing <NotIn '(' ')'> to cmpop" << endl; }
;
comprehension        : comprehension_ '(' expr ',' expr ',' '[' listof_expr ']' ')'
                       { cout << "Reducing <comprehension_ '(' expr ',' expr ',' '[' listof_expr ']' ')'> to comprehension" << endl; }
;
excepthandler        : ExceptHandler '(' optional_expr ',' optional_identifier ',' '[' listof_stmt ']' ')'
                       { cout << "Reducing <ExceptHandler '(' optional_expr ',' optional_identifier ',' '[' listof_stmt ']' ')'> to excepthandler" << endl; }
;
arguments            : arguments_ '(' '[' listof_arg ']' ',' optional_arg ',' '[' listof_arg ']' ',' '[' listof_expr ']' ',' optional_arg ',' '[' listof_expr ']' ')'
                       { cout << "Reducing <arguments_ '(' '[' listof_arg ']' ',' optional_arg ',' '[' listof_arg ']' ',' '[' listof_expr ']' ',' optional_arg ',' '[' listof_expr ']' ')'> to arguments" << endl; }
;
arg                  : arg_ '(' string ',' optional_expr ')'
                       { cout << "Reducing <arg_ '(' string ',' optional_expr ')'> to arg" << endl; }
;
keyword              : keyword_ '(' string ',' expr ')'
                       { cout << "Reducing <keyword_ '(' string ',' expr ')'> to keyword" << endl; }
;
alias                : alias_ '(' string ',' optional_identifier ')'
                       { cout << "Reducing <alias_ '(' string ',' optional_identifier ')'> to alias" << endl; }
;
withitem             : withitem_ '(' expr ',' optional_expr ')'
                       { cout << "Reducing <withitem_ '(' expr ',' optional_expr ')'> to withitem" << endl; }
;
optional_expr        : expr
                       { cout << "Reducing <expr> to optional_expr" << endl; }
                     | None
                       { cout << "Reducing <None> to optional_expr" << endl; }
;
optional_identifier  : string
                       { cout << "Reducing <string> to optional_identifier" << endl; }
                     | None
                       { cout << "Reducing <None> to optional_identifier" << endl; }
;
optional_object      : object
                       { cout << "Reducing <object> to optional_object" << endl; }
                     | None
                       { cout << "Reducing <None> to optional_object" << endl; }
;
optional_arg         : arg
                       { cout << "Reducing <arg> to optional_arg" << endl; }
                     | None
                       { cout << "Reducing <None> to optional_arg" << endl; }
;
listof_stmt          : stmt ',' listof_stmt
                       { cout << "Reducing <stmt ',' listof_stmt> to listof_stmt" << endl; }
                     | stmt
                       { cout << "Reducing <stmt> to listof_stmt" << endl; }
                     | /* empty */
                       { cout << "Reducing </* empty */> to listof_stmt" << endl; }
;
listof_expr          : expr ',' listof_expr
                       { cout << "Reducing <expr ',' listof_expr> to listof_expr" << endl; }
                     | expr
                       { cout << "Reducing <expr> to listof_expr" << endl; }
                     | /* empty */
                       { cout << "Reducing </* empty */> to listof_expr" << endl; }
;
listof_keyword       : keyword ',' listof_keyword
                       { cout << "Reducing <keyword ',' listof_keyword> to listof_keyword" << endl; }
                     | keyword
                       { cout << "Reducing <keyword> to listof_keyword" << endl; }
                     | /* empty */
                       { cout << "Reducing </* empty */> to listof_keyword" << endl; }
;
listof_withitem      : withitem ',' listof_withitem
                       { cout << "Reducing <withitem ',' listof_withitem> to listof_withitem" << endl; }
                     | withitem
                       { cout << "Reducing <withitem> to listof_withitem" << endl; }
                     | /* empty */
                       { cout << "Reducing </* empty */> to listof_withitem" << endl; }
;
listof_excepthandler : excepthandler ',' listof_excepthandler
                       { cout << "Reducing <excepthandler ',' listof_excepthandler> to listof_excepthandler" << endl; }
                     | excepthandler
                       { cout << "Reducing <excepthandler> to listof_excepthandler" << endl; }
                     | /* empty */
                       { cout << "Reducing </* empty */> to listof_excepthandler" << endl; }
;
listof_alias         : alias ',' listof_alias
                       { cout << "Reducing <alias ',' listof_alias> to listof_alias" << endl; }
                     | alias
                       { cout << "Reducing <alias> to listof_alias" << endl; }
                     | /* empty */
                       { cout << "Reducing </* empty */> to listof_alias" << endl; }
;
listof_identifier    : string ',' listof_identifier
                       { cout << "Reducing <string ',' listof_identifier> to listof_identifier" << endl; }
                     | string
                       { cout << "Reducing <string> to listof_identifier" << endl; }
                     | /* empty */
                       { cout << "Reducing </* empty */> to listof_identifier" << endl; }
;
listof_comprehension : comprehension ',' listof_comprehension
                       { cout << "Reducing <comprehension ',' listof_comprehension> to listof_comprehension" << endl; }
                     | comprehension
                       { cout << "Reducing <comprehension> to listof_comprehension" << endl; }
                     | /* empty */
                       { cout << "Reducing </* empty */> to listof_comprehension" << endl; }
;
listof_cmpop         : cmpop ',' listof_cmpop
                       { cout << "Reducing <cmpop ',' listof_cmpop> to listof_cmpop" << endl; }
                     | cmpop
                       { cout << "Reducing <cmpop> to listof_cmpop" << endl; }
                     | /* empty */
                       { cout << "Reducing </* empty */> to listof_cmpop" << endl; }
;
listof_slice         : slice ',' listof_slice
                       { cout << "Reducing <slice ',' listof_slice> to listof_slice" << endl; }
                     | slice
                       { cout << "Reducing <slice> to listof_slice" << endl; }
                     | /* empty */
                       { cout << "Reducing </* empty */> to listof_slice" << endl; }
;
listof_arg           : arg ',' listof_arg
                       { cout << "Reducing <arg ',' listof_arg> to listof_arg" << endl; }
                     | arg
                       { cout << "Reducing <arg> to listof_arg" << endl; }
                     | /* empty */
                       { cout << "Reducing </* empty */> to listof_arg" << endl; }
;
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

