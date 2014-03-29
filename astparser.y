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
                       { cout << "Reducing <Module LPAREN LBRACE listof_stmt RBRACE RPAREN> to mod" << endl; }
;
stmt                 : FunctionDef LPAREN string COMMA arguments COMMA LBRACE listof_stmt RBRACE COMMA LBRACE listof_expr RBRACE COMMA optional_expr RPAREN
                       { cout << "Reducing <FunctionDef LPAREN string COMMA arguments COMMA LBRACE listof_stmt RBRACE COMMA LBRACE listof_expr RBRACE COMMA optional_expr RPAREN> to stmt" << endl; }
                     | ClassDef LPAREN string COMMA LBRACE listof_expr RBRACE COMMA LBRACE listof_keyword RBRACE COMMA optional_expr COMMA optional_expr COMMA LBRACE listof_stmt RBRACE COMMA LBRACE listof_expr RBRACE RPAREN
                       { cout << "Reducing <ClassDef LPAREN string COMMA LBRACE listof_expr RBRACE COMMA LBRACE listof_keyword RBRACE COMMA optional_expr COMMA optional_expr COMMA LBRACE listof_stmt RBRACE COMMA LBRACE listof_expr RBRACE RPAREN> to stmt" << endl; }
                     | Return LPAREN optional_expr RPAREN
                       { cout << "Reducing <Return LPAREN optional_expr RPAREN> to stmt" << endl; }
                     | Delete LPAREN LBRACE listof_expr RBRACE RPAREN
                       { cout << "Reducing <Delete LPAREN LBRACE listof_expr RBRACE RPAREN> to stmt" << endl; }
                     | Assign LPAREN LBRACE listof_expr RBRACE COMMA expr RPAREN
                       { cout << "Reducing <Assign LPAREN LBRACE listof_expr RBRACE COMMA expr RPAREN> to stmt" << endl; }
                     | AugAssign LPAREN expr COMMA operator COMMA expr RPAREN
                       { cout << "Reducing <AugAssign LPAREN expr COMMA operator COMMA expr RPAREN> to stmt" << endl; }
                     | For LPAREN expr COMMA expr COMMA LBRACE listof_stmt RBRACE COMMA LBRACE listof_stmt RBRACE RPAREN
                       { cout << "Reducing <For LPAREN expr COMMA expr COMMA LBRACE listof_stmt RBRACE COMMA LBRACE listof_stmt RBRACE RPAREN> to stmt" << endl; }
                     | While LPAREN expr COMMA LBRACE listof_stmt RBRACE COMMA LBRACE listof_stmt RBRACE RPAREN
                       { cout << "Reducing <While LPAREN expr COMMA LBRACE listof_stmt RBRACE COMMA LBRACE listof_stmt RBRACE RPAREN> to stmt" << endl; }
                     | If LPAREN expr COMMA LBRACE listof_stmt RBRACE COMMA LBRACE listof_stmt RBRACE RPAREN
                       { cout << "Reducing <If LPAREN expr COMMA LBRACE listof_stmt RBRACE COMMA LBRACE listof_stmt RBRACE RPAREN> to stmt" << endl; }
                     | With LPAREN LBRACE listof_withitem RBRACE COMMA LBRACE listof_stmt RBRACE RPAREN
                       { cout << "Reducing <With LPAREN LBRACE listof_withitem RBRACE COMMA LBRACE listof_stmt RBRACE RPAREN> to stmt" << endl; }
                     | Raise LPAREN optional_expr COMMA optional_expr RPAREN
                       { cout << "Reducing <Raise LPAREN optional_expr COMMA optional_expr RPAREN> to stmt" << endl; }
                     | Try LPAREN LBRACE listof_stmt RBRACE COMMA LBRACE listof_excepthandler RBRACE COMMA LBRACE listof_stmt RBRACE COMMA LBRACE listof_stmt RBRACE RPAREN
                       { cout << "Reducing <Try LPAREN LBRACE listof_stmt RBRACE COMMA LBRACE listof_excepthandler RBRACE COMMA LBRACE listof_stmt RBRACE COMMA LBRACE listof_stmt RBRACE RPAREN> to stmt" << endl; }
                     | Assert LPAREN expr COMMA optional_expr RPAREN
                       { cout << "Reducing <Assert LPAREN expr COMMA optional_expr RPAREN> to stmt" << endl; }
                     | Import LPAREN LBRACE listof_alias RBRACE RPAREN
                       { cout << "Reducing <Import LPAREN LBRACE listof_alias RBRACE RPAREN> to stmt" << endl; }
                     | ImportFrom LPAREN optional_identifier COMMA LBRACE listof_alias RBRACE COMMA optional_object RPAREN
                       { cout << "Reducing <ImportFrom LPAREN optional_identifier COMMA LBRACE listof_alias RBRACE COMMA optional_object RPAREN> to stmt" << endl; }
                     | Global LPAREN LBRACE listof_identifier RBRACE RPAREN
                       { cout << "Reducing <Global LPAREN LBRACE listof_identifier RBRACE RPAREN> to stmt" << endl; }
                     | Nonlocal LPAREN LBRACE listof_identifier RBRACE RPAREN
                       { cout << "Reducing <Nonlocal LPAREN LBRACE listof_identifier RBRACE RPAREN> to stmt" << endl; }
                     | Expr LPAREN expr RPAREN
                       { cout << "Reducing <Expr LPAREN expr RPAREN> to stmt" << endl; }
                     | Pass LPAREN RPAREN
                       { cout << "Reducing <Pass LPAREN RPAREN> to stmt" << endl; }
                     | Break LPAREN RPAREN
                       { cout << "Reducing <Break LPAREN RPAREN> to stmt" << endl; }
                     | Continue LPAREN RPAREN
                       { cout << "Reducing <Continue LPAREN RPAREN> to stmt" << endl; }
;
expr                 : BoolOp LPAREN boolop COMMA LBRACE listof_expr RBRACE RPAREN
                       { cout << "Reducing <BoolOp LPAREN boolop COMMA LBRACE listof_expr RBRACE RPAREN> to expr" << endl; }
                     | BinOp LPAREN expr COMMA operator COMMA expr RPAREN
                       { cout << "Reducing <BinOp LPAREN expr COMMA operator COMMA expr RPAREN> to expr" << endl; }
                     | UnaryOp LPAREN unaryop COMMA expr RPAREN
                       { cout << "Reducing <UnaryOp LPAREN unaryop COMMA expr RPAREN> to expr" << endl; }
                     | Lambda LPAREN arguments COMMA expr RPAREN
                       { cout << "Reducing <Lambda LPAREN arguments COMMA expr RPAREN> to expr" << endl; }
                     | IfExp LPAREN expr COMMA expr COMMA expr RPAREN
                       { cout << "Reducing <IfExp LPAREN expr COMMA expr COMMA expr RPAREN> to expr" << endl; }
                     | Dict LPAREN LBRACE listof_expr RBRACE COMMA LBRACE listof_expr RBRACE RPAREN
                       { cout << "Reducing <Dict LPAREN LBRACE listof_expr RBRACE COMMA LBRACE listof_expr RBRACE RPAREN> to expr" << endl; }
                     | Set LPAREN LBRACE listof_expr RBRACE RPAREN
                       { cout << "Reducing <Set LPAREN LBRACE listof_expr RBRACE RPAREN> to expr" << endl; }
                     | ListComp LPAREN expr COMMA LBRACE listof_comprehension RBRACE RPAREN
                       { cout << "Reducing <ListComp LPAREN expr COMMA LBRACE listof_comprehension RBRACE RPAREN> to expr" << endl; }
                     | SetComp LPAREN expr COMMA LBRACE listof_comprehension RBRACE RPAREN
                       { cout << "Reducing <SetComp LPAREN expr COMMA LBRACE listof_comprehension RBRACE RPAREN> to expr" << endl; }
                     | DictComp LPAREN expr COMMA expr COMMA LBRACE listof_comprehension RBRACE RPAREN
                       { cout << "Reducing <DictComp LPAREN expr COMMA expr COMMA LBRACE listof_comprehension RBRACE RPAREN> to expr" << endl; }
                     | GeneratorExp LPAREN expr COMMA LBRACE listof_comprehension RBRACE RPAREN
                       { cout << "Reducing <GeneratorExp LPAREN expr COMMA LBRACE listof_comprehension RBRACE RPAREN> to expr" << endl; }
                     | Yield LPAREN optional_expr RPAREN
                       { cout << "Reducing <Yield LPAREN optional_expr RPAREN> to expr" << endl; }
                     | YieldFrom LPAREN expr RPAREN
                       { cout << "Reducing <YieldFrom LPAREN expr RPAREN> to expr" << endl; }
                     | Compare LPAREN expr COMMA LBRACE listof_cmpop RBRACE COMMA LBRACE listof_expr RBRACE RPAREN
                       { cout << "Reducing <Compare LPAREN expr COMMA LBRACE listof_cmpop RBRACE COMMA LBRACE listof_expr RBRACE RPAREN> to expr" << endl; }
                     | Call LPAREN expr COMMA LBRACE listof_expr RBRACE COMMA LBRACE listof_keyword RBRACE COMMA optional_expr COMMA optional_expr RPAREN
                       { cout << "Reducing <Call LPAREN expr COMMA LBRACE listof_expr RBRACE COMMA LBRACE listof_keyword RBRACE COMMA optional_expr COMMA optional_expr RPAREN> to expr" << endl; }
                     | Num LPAREN object RPAREN
                       { cout << "Reducing <Num LPAREN object RPAREN> to expr" << endl; }
                     | Str LPAREN string RPAREN
                       { cout << "Reducing <Str LPAREN string RPAREN> to expr" << endl; }
                     | Bytes LPAREN B string RPAREN
                       { cout << "Reducing <Bytes LPAREN B string RPAREN> to expr" << endl; }
                     | NameConstant LPAREN singleton RPAREN
                       { cout << "Reducing <NameConstant LPAREN singleton RPAREN> to expr" << endl; }
                     | Ellipsis LPAREN RPAREN
                       { cout << "Reducing <Ellipsis LPAREN RPAREN> to expr" << endl; }
                     | Attribute LPAREN expr COMMA string COMMA expr_context RPAREN
                       { cout << "Reducing <Attribute LPAREN expr COMMA string COMMA expr_context RPAREN> to expr" << endl; }
                     | Subscript LPAREN expr COMMA slice COMMA expr_context RPAREN
                       { cout << "Reducing <Subscript LPAREN expr COMMA slice COMMA expr_context RPAREN> to expr" << endl; }
                     | Starred LPAREN expr COMMA expr_context RPAREN
                       { cout << "Reducing <Starred LPAREN expr COMMA expr_context RPAREN> to expr" << endl; }
                     | Name LPAREN string COMMA expr_context RPAREN
                       { cout << "Reducing <Name LPAREN string COMMA expr_context RPAREN> to expr" << endl; }
                     | List LPAREN LBRACE listof_expr RBRACE COMMA expr_context RPAREN
                       { cout << "Reducing <List LPAREN LBRACE listof_expr RBRACE COMMA expr_context RPAREN> to expr" << endl; }
                     | Tuple LPAREN LBRACE listof_expr RBRACE COMMA expr_context RPAREN
                       { cout << "Reducing <Tuple LPAREN LBRACE listof_expr RBRACE COMMA expr_context RPAREN> to expr" << endl; }
;
expr_context         : Load LPAREN RPAREN
                       { cout << "Reducing <Load LPAREN RPAREN> to expr_context" << endl; }
                     | Store LPAREN RPAREN
                       { cout << "Reducing <Store LPAREN RPAREN> to expr_context" << endl; }
                     | Del LPAREN RPAREN
                       { cout << "Reducing <Del LPAREN RPAREN> to expr_context" << endl; }
                     | AugLoad LPAREN RPAREN
                       { cout << "Reducing <AugLoad LPAREN RPAREN> to expr_context" << endl; }
                     | AugStore LPAREN RPAREN
                       { cout << "Reducing <AugStore LPAREN RPAREN> to expr_context" << endl; }
                     | Param LPAREN RPAREN
                       { cout << "Reducing <Param LPAREN RPAREN> to expr_context" << endl; }
;
slice                : Slice LPAREN optional_expr COMMA optional_expr COMMA optional_expr RPAREN
                       { cout << "Reducing <Slice LPAREN optional_expr COMMA optional_expr COMMA optional_expr RPAREN> to slice" << endl; }
                     | ExtSlice LPAREN LBRACE listof_slice RBRACE RPAREN
                       { cout << "Reducing <ExtSlice LPAREN LBRACE listof_slice RBRACE RPAREN> to slice" << endl; }
                     | Index LPAREN expr RPAREN
                       { cout << "Reducing <Index LPAREN expr RPAREN> to slice" << endl; }
;
boolop               : And LPAREN RPAREN
                       { cout << "Reducing <And LPAREN RPAREN> to boolop" << endl; }
                     | Or LPAREN RPAREN
                       { cout << "Reducing <Or LPAREN RPAREN> to boolop" << endl; }
;
operator             : Add LPAREN RPAREN
                       { cout << "Reducing <Add LPAREN RPAREN> to operator" << endl; }
                     | Sub LPAREN RPAREN
                       { cout << "Reducing <Sub LPAREN RPAREN> to operator" << endl; }
                     | Mult LPAREN RPAREN
                       { cout << "Reducing <Mult LPAREN RPAREN> to operator" << endl; }
                     | Div LPAREN RPAREN
                       { cout << "Reducing <Div LPAREN RPAREN> to operator" << endl; }
                     | Mod LPAREN RPAREN
                       { cout << "Reducing <Mod LPAREN RPAREN> to operator" << endl; }
                     | Pow LPAREN RPAREN
                       { cout << "Reducing <Pow LPAREN RPAREN> to operator" << endl; }
                     | LShift LPAREN RPAREN
                       { cout << "Reducing <LShift LPAREN RPAREN> to operator" << endl; }
                     | RShift LPAREN RPAREN
                       { cout << "Reducing <RShift LPAREN RPAREN> to operator" << endl; }
                     | BitOr LPAREN RPAREN
                       { cout << "Reducing <BitOr LPAREN RPAREN> to operator" << endl; }
                     | BitXor LPAREN RPAREN
                       { cout << "Reducing <BitXor LPAREN RPAREN> to operator" << endl; }
                     | BitAnd LPAREN RPAREN
                       { cout << "Reducing <BitAnd LPAREN RPAREN> to operator" << endl; }
                     | FloorDiv LPAREN RPAREN
                       { cout << "Reducing <FloorDiv LPAREN RPAREN> to operator" << endl; }
;
unaryop              : Invert LPAREN RPAREN
                       { cout << "Reducing <Invert LPAREN RPAREN> to unaryop" << endl; }
                     | Not LPAREN RPAREN
                       { cout << "Reducing <Not LPAREN RPAREN> to unaryop" << endl; }
                     | UAdd LPAREN RPAREN
                       { cout << "Reducing <UAdd LPAREN RPAREN> to unaryop" << endl; }
                     | USub LPAREN RPAREN
                       { cout << "Reducing <USub LPAREN RPAREN> to unaryop" << endl; }
;
cmpop                : Eq LPAREN RPAREN
                       { cout << "Reducing <Eq LPAREN RPAREN> to cmpop" << endl; }
                     | NotEq LPAREN RPAREN
                       { cout << "Reducing <NotEq LPAREN RPAREN> to cmpop" << endl; }
                     | Lt LPAREN RPAREN
                       { cout << "Reducing <Lt LPAREN RPAREN> to cmpop" << endl; }
                     | LtE LPAREN RPAREN
                       { cout << "Reducing <LtE LPAREN RPAREN> to cmpop" << endl; }
                     | Gt LPAREN RPAREN
                       { cout << "Reducing <Gt LPAREN RPAREN> to cmpop" << endl; }
                     | GtE LPAREN RPAREN
                       { cout << "Reducing <GtE LPAREN RPAREN> to cmpop" << endl; }
                     | Is LPAREN RPAREN
                       { cout << "Reducing <Is LPAREN RPAREN> to cmpop" << endl; }
                     | IsNot LPAREN RPAREN
                       { cout << "Reducing <IsNot LPAREN RPAREN> to cmpop" << endl; }
                     | In LPAREN RPAREN
                       { cout << "Reducing <In LPAREN RPAREN> to cmpop" << endl; }
                     | NotIn LPAREN RPAREN
                       { cout << "Reducing <NotIn LPAREN RPAREN> to cmpop" << endl; }
;
comprehension        : comprehension_ LPAREN expr COMMA expr COMMA LBRACE listof_expr RBRACE RPAREN
                       { cout << "Reducing <comprehension_ LPAREN expr COMMA expr COMMA LBRACE listof_expr RBRACE RPAREN> to comprehension" << endl; }
;
excepthandler        : ExceptHandler LPAREN optional_expr COMMA optional_identifier COMMA LBRACE listof_stmt RBRACE RPAREN
                       { cout << "Reducing <ExceptHandler LPAREN optional_expr COMMA optional_identifier COMMA LBRACE listof_stmt RBRACE RPAREN> to excepthandler" << endl; }
;
arguments            : arguments_ LPAREN LBRACE listof_arg RBRACE COMMA optional_arg COMMA LBRACE listof_arg RBRACE COMMA LBRACE listof_expr RBRACE COMMA optional_arg COMMA LBRACE listof_expr RBRACE RPAREN
                       { cout << "Reducing <arguments_ LPAREN LBRACE listof_arg RBRACE COMMA optional_arg COMMA LBRACE listof_arg RBRACE COMMA LBRACE listof_expr RBRACE COMMA optional_arg COMMA LBRACE listof_expr RBRACE RPAREN> to arguments" << endl; }
;
arg                  : arg_ LPAREN string COMMA optional_expr RPAREN
                       { cout << "Reducing <arg_ LPAREN string COMMA optional_expr RPAREN> to arg" << endl; }
;
keyword              : keyword_ LPAREN string COMMA expr RPAREN
                       { cout << "Reducing <keyword_ LPAREN string COMMA expr RPAREN> to keyword" << endl; }
;
alias                : alias_ LPAREN string COMMA optional_identifier RPAREN
                       { cout << "Reducing <alias_ LPAREN string COMMA optional_identifier RPAREN> to alias" << endl; }
;
withitem             : withitem_ LPAREN expr COMMA optional_expr RPAREN
                       { cout << "Reducing <withitem_ LPAREN expr COMMA optional_expr RPAREN> to withitem" << endl; }
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
listof_stmt          : stmt COMMA listof_stmt
                       { cout << "Reducing <stmt COMMA listof_stmt> to listof_stmt" << endl; }
                     | stmt
                       { cout << "Reducing <stmt> to listof_stmt" << endl; }
                     | /* empty */
                       { cout << "Reducing </* empty */> to listof_stmt" << endl; }
;
listof_expr          : expr COMMA listof_expr
                       { cout << "Reducing <expr COMMA listof_expr> to listof_expr" << endl; }
                     | expr
                       { cout << "Reducing <expr> to listof_expr" << endl; }
                     | /* empty */
                       { cout << "Reducing </* empty */> to listof_expr" << endl; }
;
listof_keyword       : keyword COMMA listof_keyword
                       { cout << "Reducing <keyword COMMA listof_keyword> to listof_keyword" << endl; }
                     | keyword
                       { cout << "Reducing <keyword> to listof_keyword" << endl; }
                     | /* empty */
                       { cout << "Reducing </* empty */> to listof_keyword" << endl; }
;
listof_withitem      : withitem COMMA listof_withitem
                       { cout << "Reducing <withitem COMMA listof_withitem> to listof_withitem" << endl; }
                     | withitem
                       { cout << "Reducing <withitem> to listof_withitem" << endl; }
                     | /* empty */
                       { cout << "Reducing </* empty */> to listof_withitem" << endl; }
;
listof_excepthandler : excepthandler COMMA listof_excepthandler
                       { cout << "Reducing <excepthandler COMMA listof_excepthandler> to listof_excepthandler" << endl; }
                     | excepthandler
                       { cout << "Reducing <excepthandler> to listof_excepthandler" << endl; }
                     | /* empty */
                       { cout << "Reducing </* empty */> to listof_excepthandler" << endl; }
;
listof_alias         : alias COMMA listof_alias
                       { cout << "Reducing <alias COMMA listof_alias> to listof_alias" << endl; }
                     | alias
                       { cout << "Reducing <alias> to listof_alias" << endl; }
                     | /* empty */
                       { cout << "Reducing </* empty */> to listof_alias" << endl; }
;
listof_identifier    : string COMMA listof_identifier
                       { cout << "Reducing <string COMMA listof_identifier> to listof_identifier" << endl; }
                     | string
                       { cout << "Reducing <string> to listof_identifier" << endl; }
                     | /* empty */
                       { cout << "Reducing </* empty */> to listof_identifier" << endl; }
;
listof_comprehension : comprehension COMMA listof_comprehension
                       { cout << "Reducing <comprehension COMMA listof_comprehension> to listof_comprehension" << endl; }
                     | comprehension
                       { cout << "Reducing <comprehension> to listof_comprehension" << endl; }
                     | /* empty */
                       { cout << "Reducing </* empty */> to listof_comprehension" << endl; }
;
listof_cmpop         : cmpop COMMA listof_cmpop
                       { cout << "Reducing <cmpop COMMA listof_cmpop> to listof_cmpop" << endl; }
                     | cmpop
                       { cout << "Reducing <cmpop> to listof_cmpop" << endl; }
                     | /* empty */
                       { cout << "Reducing </* empty */> to listof_cmpop" << endl; }
;
listof_slice         : slice COMMA listof_slice
                       { cout << "Reducing <slice COMMA listof_slice> to listof_slice" << endl; }
                     | slice
                       { cout << "Reducing <slice> to listof_slice" << endl; }
                     | /* empty */
                       { cout << "Reducing </* empty */> to listof_slice" << endl; }
;
listof_arg           : arg COMMA listof_arg
                       { cout << "Reducing <arg COMMA listof_arg> to listof_arg" << endl; }
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

