/*
Copyright (C) 2013 Lucas Beyer (http://lucasb.eyer.be)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to
deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
sell copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
IN THE SOFTWARE.
*/

%{
#include <cstdio>
#include <iostream>

// stuff from flex that bison needs to know about:
extern "C" int yylex();
extern "C" int yyparse();
extern "C" FILE *yyin;

void yyerror(const char *s);

#define YYSTYPE int
%}

%token FALSE NONE TRUE AND AS ASSERT BREAK CLASS CONTINUE DEF DEL ELIF ELSE EXCEPT FINALLY FOR FROM GLOBAL IF IMPORT IN IS LAMBDA NONLOCAL NOT OR PASS RAISE RETURN TRY WHILE WITH YIELD ADD SUB MUL POW DIV FDIV MOD LSHIFT RSHIFT BITWISEAND BITWISEOR BITWISEXOR BITWISENOT LT GT LE GE EQ NEQ COMMA COLON DOT SEMICOLON AT ASSIGNMENT ANNOTATIONRETURN RADD RSUB RMUL RDIV RFDIV RMOD RAND ROR RXOR RRSHIFT RLSHIFT RPOW LPARENTHESIS RPARENTHESIS LSQUAREBRACE RSQUAREBRACE LCURLYBRACE RCURLYBRACE ELLIPSIS 

%token NAME
%token NUMBER
%token NEWLINE
%token ENDMARKER
%token INDENT
%token DEDENT
%token STRING

%locations

 /* %debug */

%start file_input

%%

newline__or__stmt: NEWLINE  {printf("Parser: Reducing <NEWLINE> to <newline__or__stmt>\n");}
    |  stmt {printf("Parser: Reducing <stmt> to <newline__or__stmt>\n");}
zeroormore__newline__or__stmt:   {printf("Parser: Reducing <> to <zeroormore__newline__or__stmt>\n");}
    |  newline__or__stmt  zeroormore__newline__or__stmt {printf("Parser: Reducing <newline__or__stmt  zeroormore__newline__or__stmt> to <zeroormore__newline__or__stmt>\n");}

file_input: zeroormore__newline__or__stmt ENDMARKER {printf("Parser: Reducing <zeroormore__newline__or__stmt ENDMARKER> to <file_input>\n");}

optional__arglist:   {printf("Parser: Reducing <> to <optional__arglist>\n");}
    |  arglist {printf("Parser: Reducing <arglist> to <optional__arglist>\n");}
optional__lparenthesis_optional__arglist_rparenthesis:   {printf("Parser: Reducing <> to <optional__lparenthesis_optional__arglist_rparenthesis>\n");}
    |  LPARENTHESIS optional__arglist RPARENTHESIS {printf("Parser: Reducing <LPARENTHESIS optional__arglist RPARENTHESIS> to <optional__lparenthesis_optional__arglist_rparenthesis>\n");}

decorator: AT dotted_name optional__lparenthesis_optional__arglist_rparenthesis NEWLINE {printf("Parser: Reducing <AT dotted_name optional__lparenthesis_optional__arglist_rparenthesis NEWLINE> to <decorator>\n");}

oneormore__decorator: decorator  oneormore__decorator  {printf("Parser: Reducing <decorator  oneormore__decorator> to <oneormore__decorator>\n");}
    |  decorator  {printf("Parser: Reducing <decorator> to <oneormore__decorator>\n");}

decorators: oneormore__decorator {printf("Parser: Reducing <oneormore__decorator> to <decorators>\n");}

classdef__or__funcdef: classdef  {printf("Parser: Reducing <classdef> to <classdef__or__funcdef>\n");}
    |  funcdef {printf("Parser: Reducing <funcdef> to <classdef__or__funcdef>\n");}

decorated: decorators classdef__or__funcdef {printf("Parser: Reducing <decorators classdef__or__funcdef> to <decorated>\n");}

optional__annotationreturn_test:   {printf("Parser: Reducing <> to <optional__annotationreturn_test>\n");}
    |  ANNOTATIONRETURN test {printf("Parser: Reducing <ANNOTATIONRETURN test> to <optional__annotationreturn_test>\n");}

funcdef: DEF NAME parameters optional__annotationreturn_test COLON suite {printf("Parser: Reducing <DEF NAME parameters optional__annotationreturn_test COLON suite> to <funcdef>\n");}

optional__typedargslist:   {printf("Parser: Reducing <> to <optional__typedargslist>\n");}
    |  typedargslist {printf("Parser: Reducing <typedargslist> to <optional__typedargslist>\n");}

parameters: LPARENTHESIS optional__typedargslist RPARENTHESIS {printf("Parser: Reducing <LPARENTHESIS optional__typedargslist RPARENTHESIS> to <parameters>\n");}

optional__comma:   {printf("Parser: Reducing <> to <optional__comma>\n");}
    |  COMMA {printf("Parser: Reducing <COMMA> to <optional__comma>\n");}
optional__assignment_test:   {printf("Parser: Reducing <> to <optional__assignment_test>\n");}
    |  ASSIGNMENT test {printf("Parser: Reducing <ASSIGNMENT test> to <optional__assignment_test>\n");}
comma_tfpdef_optional__assignment_test: COMMA tfpdef optional__assignment_test {printf("Parser: Reducing <COMMA tfpdef optional__assignment_test> to <comma_tfpdef_optional__assignment_test>\n");}
zeroormore__comma_tfpdef_optional__assignment_test:   {printf("Parser: Reducing <> to <zeroormore__comma_tfpdef_optional__assignment_test>\n");}
    |  comma_tfpdef_optional__assignment_test  zeroormore__comma_tfpdef_optional__assignment_test {printf("Parser: Reducing <comma_tfpdef_optional__assignment_test  zeroormore__comma_tfpdef_optional__assignment_test> to <zeroormore__comma_tfpdef_optional__assignment_test>\n");}
optional__comma_pow_tfpdef:   {printf("Parser: Reducing <> to <optional__comma_pow_tfpdef>\n");}
    |  COMMA POW tfpdef {printf("Parser: Reducing <COMMA POW tfpdef> to <optional__comma_pow_tfpdef>\n");}
optional__tfpdef:   {printf("Parser: Reducing <> to <optional__tfpdef>\n");}
    |  tfpdef {printf("Parser: Reducing <tfpdef> to <optional__tfpdef>\n");}
mul_optional__tfpdef_zeroormore__comma_tfpdef_optional__assignment_test_optional__comma_pow_tfpdef__or__pow_tfpdef: MUL optional__tfpdef zeroormore__comma_tfpdef_optional__assignment_test optional__comma_pow_tfpdef  {printf("Parser: Reducing <MUL optional__tfpdef zeroormore__comma_tfpdef_optional__assignment_test optional__comma_pow_tfpdef> to <mul_optional__tfpdef_zeroormore__comma_tfpdef_optional__assignment_test_optional__comma_pow_tfpdef__or__pow_tfpdef>\n");}
    |  POW tfpdef {printf("Parser: Reducing <POW tfpdef> to <mul_optional__tfpdef_zeroormore__comma_tfpdef_optional__assignment_test_optional__comma_pow_tfpdef__or__pow_tfpdef>\n");}
tfpdef_optional__assignment_test_comma: tfpdef optional__assignment_test COMMA {printf("Parser: Reducing <tfpdef optional__assignment_test COMMA> to <tfpdef_optional__assignment_test_comma>\n");}
zeroormore__tfpdef_optional__assignment_test_comma:   {printf("Parser: Reducing <> to <zeroormore__tfpdef_optional__assignment_test_comma>\n");}
    |  tfpdef_optional__assignment_test_comma  zeroormore__tfpdef_optional__assignment_test_comma {printf("Parser: Reducing <tfpdef_optional__assignment_test_comma  zeroormore__tfpdef_optional__assignment_test_comma> to <zeroormore__tfpdef_optional__assignment_test_comma>\n");}

typedargslist: zeroormore__tfpdef_optional__assignment_test_comma mul_optional__tfpdef_zeroormore__comma_tfpdef_optional__assignment_test_optional__comma_pow_tfpdef__or__pow_tfpdef  {printf("Parser: Reducing <zeroormore__tfpdef_optional__assignment_test_comma mul_optional__tfpdef_zeroormore__comma_tfpdef_optional__assignment_test_optional__comma_pow_tfpdef__or__pow_tfpdef> to <typedargslist>\n");}
    |  tfpdef optional__assignment_test zeroormore__comma_tfpdef_optional__assignment_test optional__comma {printf("Parser: Reducing <tfpdef optional__assignment_test zeroormore__comma_tfpdef_optional__assignment_test optional__comma> to <typedargslist>\n");}

optional__colon_test:   {printf("Parser: Reducing <> to <optional__colon_test>\n");}
    |  COLON test {printf("Parser: Reducing <COLON test> to <optional__colon_test>\n");}

tfpdef: NAME optional__colon_test {printf("Parser: Reducing <NAME optional__colon_test> to <tfpdef>\n");}

comma_vfpdef_optional__assignment_test: COMMA vfpdef optional__assignment_test {printf("Parser: Reducing <COMMA vfpdef optional__assignment_test> to <comma_vfpdef_optional__assignment_test>\n");}
zeroormore__comma_vfpdef_optional__assignment_test:   {printf("Parser: Reducing <> to <zeroormore__comma_vfpdef_optional__assignment_test>\n");}
    |  comma_vfpdef_optional__assignment_test  zeroormore__comma_vfpdef_optional__assignment_test {printf("Parser: Reducing <comma_vfpdef_optional__assignment_test  zeroormore__comma_vfpdef_optional__assignment_test> to <zeroormore__comma_vfpdef_optional__assignment_test>\n");}
optional__comma_pow_vfpdef:   {printf("Parser: Reducing <> to <optional__comma_pow_vfpdef>\n");}
    |  COMMA POW vfpdef {printf("Parser: Reducing <COMMA POW vfpdef> to <optional__comma_pow_vfpdef>\n");}
optional__vfpdef:   {printf("Parser: Reducing <> to <optional__vfpdef>\n");}
    |  vfpdef {printf("Parser: Reducing <vfpdef> to <optional__vfpdef>\n");}
mul_optional__vfpdef_zeroormore__comma_vfpdef_optional__assignment_test_optional__comma_pow_vfpdef__or__pow_vfpdef: MUL optional__vfpdef zeroormore__comma_vfpdef_optional__assignment_test optional__comma_pow_vfpdef  {printf("Parser: Reducing <MUL optional__vfpdef zeroormore__comma_vfpdef_optional__assignment_test optional__comma_pow_vfpdef> to <mul_optional__vfpdef_zeroormore__comma_vfpdef_optional__assignment_test_optional__comma_pow_vfpdef__or__pow_vfpdef>\n");}
    |  POW vfpdef {printf("Parser: Reducing <POW vfpdef> to <mul_optional__vfpdef_zeroormore__comma_vfpdef_optional__assignment_test_optional__comma_pow_vfpdef__or__pow_vfpdef>\n");}
vfpdef_optional__assignment_test_comma: vfpdef optional__assignment_test COMMA {printf("Parser: Reducing <vfpdef optional__assignment_test COMMA> to <vfpdef_optional__assignment_test_comma>\n");}
zeroormore__vfpdef_optional__assignment_test_comma:   {printf("Parser: Reducing <> to <zeroormore__vfpdef_optional__assignment_test_comma>\n");}
    |  vfpdef_optional__assignment_test_comma  zeroormore__vfpdef_optional__assignment_test_comma {printf("Parser: Reducing <vfpdef_optional__assignment_test_comma  zeroormore__vfpdef_optional__assignment_test_comma> to <zeroormore__vfpdef_optional__assignment_test_comma>\n");}

varargslist: zeroormore__vfpdef_optional__assignment_test_comma mul_optional__vfpdef_zeroormore__comma_vfpdef_optional__assignment_test_optional__comma_pow_vfpdef__or__pow_vfpdef  {printf("Parser: Reducing <zeroormore__vfpdef_optional__assignment_test_comma mul_optional__vfpdef_zeroormore__comma_vfpdef_optional__assignment_test_optional__comma_pow_vfpdef__or__pow_vfpdef> to <varargslist>\n");}
    |  vfpdef optional__assignment_test zeroormore__comma_vfpdef_optional__assignment_test optional__comma {printf("Parser: Reducing <vfpdef optional__assignment_test zeroormore__comma_vfpdef_optional__assignment_test optional__comma> to <varargslist>\n");}


vfpdef: NAME {printf("Parser: Reducing <NAME> to <vfpdef>\n");}


stmt: simple_stmt  {printf("Parser: Reducing <simple_stmt> to <stmt>\n");}
    |  compound_stmt {printf("Parser: Reducing <compound_stmt> to <stmt>\n");}

optional__semicolon:   {printf("Parser: Reducing <> to <optional__semicolon>\n");}
    |  SEMICOLON {printf("Parser: Reducing <SEMICOLON> to <optional__semicolon>\n");}
semicolon_small_stmt: SEMICOLON small_stmt {printf("Parser: Reducing <SEMICOLON small_stmt> to <semicolon_small_stmt>\n");}
zeroormore__semicolon_small_stmt:   {printf("Parser: Reducing <> to <zeroormore__semicolon_small_stmt>\n");}
    |  semicolon_small_stmt  zeroormore__semicolon_small_stmt {printf("Parser: Reducing <semicolon_small_stmt  zeroormore__semicolon_small_stmt> to <zeroormore__semicolon_small_stmt>\n");}

simple_stmt: small_stmt zeroormore__semicolon_small_stmt optional__semicolon NEWLINE {printf("Parser: Reducing <small_stmt zeroormore__semicolon_small_stmt optional__semicolon NEWLINE> to <simple_stmt>\n");}


small_stmt: expr_stmt  {printf("Parser: Reducing <expr_stmt> to <small_stmt>\n");}
    |  del_stmt  {printf("Parser: Reducing <del_stmt> to <small_stmt>\n");}
    |  pass_stmt  {printf("Parser: Reducing <pass_stmt> to <small_stmt>\n");}
    |  flow_stmt  {printf("Parser: Reducing <flow_stmt> to <small_stmt>\n");}
    |  import_stmt  {printf("Parser: Reducing <import_stmt> to <small_stmt>\n");}
    |  global_stmt  {printf("Parser: Reducing <global_stmt> to <small_stmt>\n");}
    |  nonlocal_stmt  {printf("Parser: Reducing <nonlocal_stmt> to <small_stmt>\n");}
    |  assert_stmt {printf("Parser: Reducing <assert_stmt> to <small_stmt>\n");}

yield_expr__or__testlist: yield_expr  {printf("Parser: Reducing <yield_expr> to <yield_expr__or__testlist>\n");}
    |  testlist {printf("Parser: Reducing <testlist> to <yield_expr__or__testlist>\n");}
assignment_yield_expr__or__testlist: ASSIGNMENT yield_expr__or__testlist {printf("Parser: Reducing <ASSIGNMENT yield_expr__or__testlist> to <assignment_yield_expr__or__testlist>\n");}
zeroormore__assignment_yield_expr__or__testlist:   {printf("Parser: Reducing <> to <zeroormore__assignment_yield_expr__or__testlist>\n");}
    |  assignment_yield_expr__or__testlist  zeroormore__assignment_yield_expr__or__testlist {printf("Parser: Reducing <assignment_yield_expr__or__testlist  zeroormore__assignment_yield_expr__or__testlist> to <zeroormore__assignment_yield_expr__or__testlist>\n");}
augassign_yield_expr__or__testlist__or__zeroormore__assignment_yield_expr__or__testlist: augassign yield_expr__or__testlist  {printf("Parser: Reducing <augassign yield_expr__or__testlist> to <augassign_yield_expr__or__testlist__or__zeroormore__assignment_yield_expr__or__testlist>\n");}
    |  zeroormore__assignment_yield_expr__or__testlist {printf("Parser: Reducing <zeroormore__assignment_yield_expr__or__testlist> to <augassign_yield_expr__or__testlist__or__zeroormore__assignment_yield_expr__or__testlist>\n");}

expr_stmt: testlist augassign_yield_expr__or__testlist__or__zeroormore__assignment_yield_expr__or__testlist {printf("Parser: Reducing <testlist augassign_yield_expr__or__testlist__or__zeroormore__assignment_yield_expr__or__testlist> to <expr_stmt>\n");}


augassign: RADD  {printf("Parser: Reducing <RADD> to <augassign>\n");}
    |  RSUB  {printf("Parser: Reducing <RSUB> to <augassign>\n");}
    |  RMUL  {printf("Parser: Reducing <RMUL> to <augassign>\n");}
    |  RDIV  {printf("Parser: Reducing <RDIV> to <augassign>\n");}
    |  RMOD  {printf("Parser: Reducing <RMOD> to <augassign>\n");}
    |  RAND  {printf("Parser: Reducing <RAND> to <augassign>\n");}
    |  ROR  {printf("Parser: Reducing <ROR> to <augassign>\n");}
    |  RXOR  {printf("Parser: Reducing <RXOR> to <augassign>\n");}
    |  RLSHIFT  {printf("Parser: Reducing <RLSHIFT> to <augassign>\n");}
    |  RRSHIFT  {printf("Parser: Reducing <RRSHIFT> to <augassign>\n");}
    |  RPOW  {printf("Parser: Reducing <RPOW> to <augassign>\n");}
    |  RFDIV {printf("Parser: Reducing <RFDIV> to <augassign>\n");}


del_stmt: DEL exprlist {printf("Parser: Reducing <DEL exprlist> to <del_stmt>\n");}


pass_stmt: PASS {printf("Parser: Reducing <PASS> to <pass_stmt>\n");}


flow_stmt: break_stmt  {printf("Parser: Reducing <break_stmt> to <flow_stmt>\n");}
    |  continue_stmt  {printf("Parser: Reducing <continue_stmt> to <flow_stmt>\n");}
    |  return_stmt  {printf("Parser: Reducing <return_stmt> to <flow_stmt>\n");}
    |  raise_stmt  {printf("Parser: Reducing <raise_stmt> to <flow_stmt>\n");}
    |  yield_stmt {printf("Parser: Reducing <yield_stmt> to <flow_stmt>\n");}


break_stmt: BREAK {printf("Parser: Reducing <BREAK> to <break_stmt>\n");}


continue_stmt: CONTINUE {printf("Parser: Reducing <CONTINUE> to <continue_stmt>\n");}

optional__testlist:   {printf("Parser: Reducing <> to <optional__testlist>\n");}
    |  testlist {printf("Parser: Reducing <testlist> to <optional__testlist>\n");}

return_stmt: RETURN optional__testlist {printf("Parser: Reducing <RETURN optional__testlist> to <return_stmt>\n");}


yield_stmt: yield_expr {printf("Parser: Reducing <yield_expr> to <yield_stmt>\n");}

optional__from_test:   {printf("Parser: Reducing <> to <optional__from_test>\n");}
    |  FROM test {printf("Parser: Reducing <FROM test> to <optional__from_test>\n");}
optional__test_optional__from_test:   {printf("Parser: Reducing <> to <optional__test_optional__from_test>\n");}
    |  test optional__from_test {printf("Parser: Reducing <test optional__from_test> to <optional__test_optional__from_test>\n");}

raise_stmt: RAISE optional__test_optional__from_test {printf("Parser: Reducing <RAISE optional__test_optional__from_test> to <raise_stmt>\n");}


import_stmt: import_name  {printf("Parser: Reducing <import_name> to <import_stmt>\n");}
    |  import_from {printf("Parser: Reducing <import_from> to <import_stmt>\n");}


import_name: IMPORT dotted_as_names {printf("Parser: Reducing <IMPORT dotted_as_names> to <import_name>\n");}

mul__or__lparenthesis_import_as_names_rparenthesis__or__import_as_names: MUL  {printf("Parser: Reducing <MUL> to <mul__or__lparenthesis_import_as_names_rparenthesis__or__import_as_names>\n");}
    |  LPARENTHESIS import_as_names RPARENTHESIS  {printf("Parser: Reducing <LPARENTHESIS import_as_names RPARENTHESIS> to <mul__or__lparenthesis_import_as_names_rparenthesis__or__import_as_names>\n");}
    |  import_as_names {printf("Parser: Reducing <import_as_names> to <mul__or__lparenthesis_import_as_names_rparenthesis__or__import_as_names>\n");}
dot__or__ellipsis: DOT  {printf("Parser: Reducing <DOT> to <dot__or__ellipsis>\n");}
    |  ELLIPSIS {printf("Parser: Reducing <ELLIPSIS> to <dot__or__ellipsis>\n");}
oneormore__dot__or__ellipsis: dot__or__ellipsis  oneormore__dot__or__ellipsis  {printf("Parser: Reducing <dot__or__ellipsis  oneormore__dot__or__ellipsis> to <oneormore__dot__or__ellipsis>\n");}
    |  dot__or__ellipsis  {printf("Parser: Reducing <dot__or__ellipsis> to <oneormore__dot__or__ellipsis>\n");}
zeroormore__dot__or__ellipsis:   {printf("Parser: Reducing <> to <zeroormore__dot__or__ellipsis>\n");}
    |  dot__or__ellipsis  zeroormore__dot__or__ellipsis {printf("Parser: Reducing <dot__or__ellipsis  zeroormore__dot__or__ellipsis> to <zeroormore__dot__or__ellipsis>\n");}
zeroormore__dot__or__ellipsis_dotted_name__or__oneormore__dot__or__ellipsis: zeroormore__dot__or__ellipsis dotted_name  {printf("Parser: Reducing <zeroormore__dot__or__ellipsis dotted_name> to <zeroormore__dot__or__ellipsis_dotted_name__or__oneormore__dot__or__ellipsis>\n");}
    |  oneormore__dot__or__ellipsis {printf("Parser: Reducing <oneormore__dot__or__ellipsis> to <zeroormore__dot__or__ellipsis_dotted_name__or__oneormore__dot__or__ellipsis>\n");}

import_from: FROM zeroormore__dot__or__ellipsis_dotted_name__or__oneormore__dot__or__ellipsis IMPORT mul__or__lparenthesis_import_as_names_rparenthesis__or__import_as_names {printf("Parser: Reducing <FROM zeroormore__dot__or__ellipsis_dotted_name__or__oneormore__dot__or__ellipsis IMPORT mul__or__lparenthesis_import_as_names_rparenthesis__or__import_as_names> to <import_from>\n");}

optional__as_name:   {printf("Parser: Reducing <> to <optional__as_name>\n");}
    |  AS NAME {printf("Parser: Reducing <AS NAME> to <optional__as_name>\n");}

import_as_name: NAME optional__as_name {printf("Parser: Reducing <NAME optional__as_name> to <import_as_name>\n");}


dotted_as_name: dotted_name optional__as_name {printf("Parser: Reducing <dotted_name optional__as_name> to <dotted_as_name>\n");}

comma_import_as_name: COMMA import_as_name {printf("Parser: Reducing <COMMA import_as_name> to <comma_import_as_name>\n");}
zeroormore__comma_import_as_name:   {printf("Parser: Reducing <> to <zeroormore__comma_import_as_name>\n");}
    |  comma_import_as_name  zeroormore__comma_import_as_name {printf("Parser: Reducing <comma_import_as_name  zeroormore__comma_import_as_name> to <zeroormore__comma_import_as_name>\n");}

import_as_names: import_as_name zeroormore__comma_import_as_name optional__comma {printf("Parser: Reducing <import_as_name zeroormore__comma_import_as_name optional__comma> to <import_as_names>\n");}

comma_dotted_as_name: COMMA dotted_as_name {printf("Parser: Reducing <COMMA dotted_as_name> to <comma_dotted_as_name>\n");}
zeroormore__comma_dotted_as_name:   {printf("Parser: Reducing <> to <zeroormore__comma_dotted_as_name>\n");}
    |  comma_dotted_as_name  zeroormore__comma_dotted_as_name {printf("Parser: Reducing <comma_dotted_as_name  zeroormore__comma_dotted_as_name> to <zeroormore__comma_dotted_as_name>\n");}

dotted_as_names: dotted_as_name zeroormore__comma_dotted_as_name {printf("Parser: Reducing <dotted_as_name zeroormore__comma_dotted_as_name> to <dotted_as_names>\n");}

dot_name: DOT NAME {printf("Parser: Reducing <DOT NAME> to <dot_name>\n");}
zeroormore__dot_name:   {printf("Parser: Reducing <> to <zeroormore__dot_name>\n");}
    |  dot_name  zeroormore__dot_name {printf("Parser: Reducing <dot_name  zeroormore__dot_name> to <zeroormore__dot_name>\n");}

dotted_name: NAME zeroormore__dot_name {printf("Parser: Reducing <NAME zeroormore__dot_name> to <dotted_name>\n");}

comma_name: COMMA NAME {printf("Parser: Reducing <COMMA NAME> to <comma_name>\n");}
zeroormore__comma_name:   {printf("Parser: Reducing <> to <zeroormore__comma_name>\n");}
    |  comma_name  zeroormore__comma_name {printf("Parser: Reducing <comma_name  zeroormore__comma_name> to <zeroormore__comma_name>\n");}

global_stmt: GLOBAL NAME zeroormore__comma_name {printf("Parser: Reducing <GLOBAL NAME zeroormore__comma_name> to <global_stmt>\n");}


nonlocal_stmt: NONLOCAL NAME zeroormore__comma_name {printf("Parser: Reducing <NONLOCAL NAME zeroormore__comma_name> to <nonlocal_stmt>\n");}

optional__comma_test:   {printf("Parser: Reducing <> to <optional__comma_test>\n");}
    |  COMMA test {printf("Parser: Reducing <COMMA test> to <optional__comma_test>\n");}

assert_stmt: ASSERT test optional__comma_test {printf("Parser: Reducing <ASSERT test optional__comma_test> to <assert_stmt>\n");}


compound_stmt: if_stmt  {printf("Parser: Reducing <if_stmt> to <compound_stmt>\n");}
    |  while_stmt  {printf("Parser: Reducing <while_stmt> to <compound_stmt>\n");}
    |  for_stmt  {printf("Parser: Reducing <for_stmt> to <compound_stmt>\n");}
    |  try_stmt  {printf("Parser: Reducing <try_stmt> to <compound_stmt>\n");}
    |  with_stmt  {printf("Parser: Reducing <with_stmt> to <compound_stmt>\n");}
    |  funcdef  {printf("Parser: Reducing <funcdef> to <compound_stmt>\n");}
    |  classdef  {printf("Parser: Reducing <classdef> to <compound_stmt>\n");}
    |  decorated {printf("Parser: Reducing <decorated> to <compound_stmt>\n");}

optional__else_colon_suite:   {printf("Parser: Reducing <> to <optional__else_colon_suite>\n");}
    |  ELSE COLON suite {printf("Parser: Reducing <ELSE COLON suite> to <optional__else_colon_suite>\n");}
elif_test_colon_suite: ELIF test COLON suite {printf("Parser: Reducing <ELIF test COLON suite> to <elif_test_colon_suite>\n");}
zeroormore__elif_test_colon_suite:   {printf("Parser: Reducing <> to <zeroormore__elif_test_colon_suite>\n");}
    |  elif_test_colon_suite  zeroormore__elif_test_colon_suite {printf("Parser: Reducing <elif_test_colon_suite  zeroormore__elif_test_colon_suite> to <zeroormore__elif_test_colon_suite>\n");}

if_stmt: IF test COLON suite zeroormore__elif_test_colon_suite optional__else_colon_suite {printf("Parser: Reducing <IF test COLON suite zeroormore__elif_test_colon_suite optional__else_colon_suite> to <if_stmt>\n");}


while_stmt: WHILE test COLON suite optional__else_colon_suite {printf("Parser: Reducing <WHILE test COLON suite optional__else_colon_suite> to <while_stmt>\n");}


for_stmt: FOR exprlist IN testlist COLON suite optional__else_colon_suite {printf("Parser: Reducing <FOR exprlist IN testlist COLON suite optional__else_colon_suite> to <for_stmt>\n");}

optional__finally_colon_suite:   {printf("Parser: Reducing <> to <optional__finally_colon_suite>\n");}
    |  FINALLY COLON suite {printf("Parser: Reducing <FINALLY COLON suite> to <optional__finally_colon_suite>\n");}
except_clause_colon_suite: except_clause COLON suite {printf("Parser: Reducing <except_clause COLON suite> to <except_clause_colon_suite>\n");}
oneormore__except_clause_colon_suite: except_clause_colon_suite  oneormore__except_clause_colon_suite  {printf("Parser: Reducing <except_clause_colon_suite  oneormore__except_clause_colon_suite> to <oneormore__except_clause_colon_suite>\n");}
    |  except_clause_colon_suite  {printf("Parser: Reducing <except_clause_colon_suite> to <oneormore__except_clause_colon_suite>\n");}
oneormore__except_clause_colon_suite_optional__else_colon_suite_optional__finally_colon_suite__or__finally_colon_suite: oneormore__except_clause_colon_suite optional__else_colon_suite optional__finally_colon_suite  {printf("Parser: Reducing <oneormore__except_clause_colon_suite optional__else_colon_suite optional__finally_colon_suite> to <oneormore__except_clause_colon_suite_optional__else_colon_suite_optional__finally_colon_suite__or__finally_colon_suite>\n");}
    |  FINALLY COLON suite {printf("Parser: Reducing <FINALLY COLON suite> to <oneormore__except_clause_colon_suite_optional__else_colon_suite_optional__finally_colon_suite__or__finally_colon_suite>\n");}

try_stmt: TRY COLON suite oneormore__except_clause_colon_suite_optional__else_colon_suite_optional__finally_colon_suite__or__finally_colon_suite {printf("Parser: Reducing <TRY COLON suite oneormore__except_clause_colon_suite_optional__else_colon_suite_optional__finally_colon_suite__or__finally_colon_suite> to <try_stmt>\n");}

comma_with_item: COMMA with_item {printf("Parser: Reducing <COMMA with_item> to <comma_with_item>\n");}
zeroormore__comma_with_item:   {printf("Parser: Reducing <> to <zeroormore__comma_with_item>\n");}
    |  comma_with_item  zeroormore__comma_with_item {printf("Parser: Reducing <comma_with_item  zeroormore__comma_with_item> to <zeroormore__comma_with_item>\n");}

with_stmt: WITH with_item zeroormore__comma_with_item COLON suite {printf("Parser: Reducing <WITH with_item zeroormore__comma_with_item COLON suite> to <with_stmt>\n");}

optional__as_expr:   {printf("Parser: Reducing <> to <optional__as_expr>\n");}
    |  AS expr {printf("Parser: Reducing <AS expr> to <optional__as_expr>\n");}

with_item: test optional__as_expr {printf("Parser: Reducing <test optional__as_expr> to <with_item>\n");}

optional__test_optional__as_name:   {printf("Parser: Reducing <> to <optional__test_optional__as_name>\n");}
    |  test optional__as_name {printf("Parser: Reducing <test optional__as_name> to <optional__test_optional__as_name>\n");}

except_clause: EXCEPT optional__test_optional__as_name {printf("Parser: Reducing <EXCEPT optional__test_optional__as_name> to <except_clause>\n");}

oneormore__newline_indent_stmt: NEWLINE INDENT stmt  oneormore__newline_indent_stmt  {printf("Parser: Reducing <NEWLINE INDENT stmt  oneormore__newline_indent_stmt> to <oneormore__newline_indent_stmt>\n");}
    |  NEWLINE INDENT stmt  {printf("Parser: Reducing <NEWLINE INDENT stmt> to <oneormore__newline_indent_stmt>\n");}

suite: simple_stmt  {printf("Parser: Reducing <simple_stmt> to <suite>\n");}
    |  oneormore__newline_indent_stmt DEDENT {printf("Parser: Reducing <oneormore__newline_indent_stmt DEDENT> to <suite>\n");}

optional__if_or_test_else_test:   {printf("Parser: Reducing <> to <optional__if_or_test_else_test>\n");}
    |  IF or_test ELSE test {printf("Parser: Reducing <IF or_test ELSE test> to <optional__if_or_test_else_test>\n");}

test: or_test optional__if_or_test_else_test  {printf("Parser: Reducing <or_test optional__if_or_test_else_test> to <test>\n");}
    |  lambdef {printf("Parser: Reducing <lambdef> to <test>\n");}


test_nocond: or_test  {printf("Parser: Reducing <or_test> to <test_nocond>\n");}
    |  lambdef_nocond {printf("Parser: Reducing <lambdef_nocond> to <test_nocond>\n");}

optional__varargslist:   {printf("Parser: Reducing <> to <optional__varargslist>\n");}
    |  varargslist {printf("Parser: Reducing <varargslist> to <optional__varargslist>\n");}

lambdef: LAMBDA optional__varargslist COLON test {printf("Parser: Reducing <LAMBDA optional__varargslist COLON test> to <lambdef>\n");}


lambdef_nocond: LAMBDA optional__varargslist COLON test_nocond {printf("Parser: Reducing <LAMBDA optional__varargslist COLON test_nocond> to <lambdef_nocond>\n");}

or_and_test: OR and_test {printf("Parser: Reducing <OR and_test> to <or_and_test>\n");}
zeroormore__or_and_test:   {printf("Parser: Reducing <> to <zeroormore__or_and_test>\n");}
    |  or_and_test  zeroormore__or_and_test {printf("Parser: Reducing <or_and_test  zeroormore__or_and_test> to <zeroormore__or_and_test>\n");}

or_test: and_test zeroormore__or_and_test {printf("Parser: Reducing <and_test zeroormore__or_and_test> to <or_test>\n");}

and_not_test: AND not_test {printf("Parser: Reducing <AND not_test> to <and_not_test>\n");}
zeroormore__and_not_test:   {printf("Parser: Reducing <> to <zeroormore__and_not_test>\n");}
    |  and_not_test  zeroormore__and_not_test {printf("Parser: Reducing <and_not_test  zeroormore__and_not_test> to <zeroormore__and_not_test>\n");}

and_test: not_test zeroormore__and_not_test {printf("Parser: Reducing <not_test zeroormore__and_not_test> to <and_test>\n");}


not_test: NOT not_test  {printf("Parser: Reducing <NOT not_test> to <not_test>\n");}
    |  comparison {printf("Parser: Reducing <comparison> to <not_test>\n");}

comp_op_star_expr: comp_op star_expr {printf("Parser: Reducing <comp_op star_expr> to <comp_op_star_expr>\n");}
zeroormore__comp_op_star_expr:   {printf("Parser: Reducing <> to <zeroormore__comp_op_star_expr>\n");}
    |  comp_op_star_expr  zeroormore__comp_op_star_expr {printf("Parser: Reducing <comp_op_star_expr  zeroormore__comp_op_star_expr> to <zeroormore__comp_op_star_expr>\n");}

comparison: star_expr zeroormore__comp_op_star_expr {printf("Parser: Reducing <star_expr zeroormore__comp_op_star_expr> to <comparison>\n");}


comp_op: LT  {printf("Parser: Reducing <LT> to <comp_op>\n");}
    |  GT  {printf("Parser: Reducing <GT> to <comp_op>\n");}
    |  EQ  {printf("Parser: Reducing <EQ> to <comp_op>\n");}
    |  GE  {printf("Parser: Reducing <GE> to <comp_op>\n");}
    |  LE  {printf("Parser: Reducing <LE> to <comp_op>\n");}
    |  NEQ  {printf("Parser: Reducing <NEQ> to <comp_op>\n");}
    |  IN  {printf("Parser: Reducing <IN> to <comp_op>\n");}
    |  NOT IN  {printf("Parser: Reducing <NOT IN> to <comp_op>\n");}
    |  IS  {printf("Parser: Reducing <IS> to <comp_op>\n");}
    |  IS NOT {printf("Parser: Reducing <IS NOT> to <comp_op>\n");}

optional__mul:   {printf("Parser: Reducing <> to <optional__mul>\n");}
    |  MUL {printf("Parser: Reducing <MUL> to <optional__mul>\n");}

star_expr: optional__mul expr {printf("Parser: Reducing <optional__mul expr> to <star_expr>\n");}

bitwiseor_xor_expr: BITWISEOR xor_expr {printf("Parser: Reducing <BITWISEOR xor_expr> to <bitwiseor_xor_expr>\n");}
zeroormore__bitwiseor_xor_expr:   {printf("Parser: Reducing <> to <zeroormore__bitwiseor_xor_expr>\n");}
    |  bitwiseor_xor_expr  zeroormore__bitwiseor_xor_expr {printf("Parser: Reducing <bitwiseor_xor_expr  zeroormore__bitwiseor_xor_expr> to <zeroormore__bitwiseor_xor_expr>\n");}

expr: xor_expr zeroormore__bitwiseor_xor_expr {printf("Parser: Reducing <xor_expr zeroormore__bitwiseor_xor_expr> to <expr>\n");}

bitwisexor_and_expr: BITWISEXOR and_expr {printf("Parser: Reducing <BITWISEXOR and_expr> to <bitwisexor_and_expr>\n");}
zeroormore__bitwisexor_and_expr:   {printf("Parser: Reducing <> to <zeroormore__bitwisexor_and_expr>\n");}
    |  bitwisexor_and_expr  zeroormore__bitwisexor_and_expr {printf("Parser: Reducing <bitwisexor_and_expr  zeroormore__bitwisexor_and_expr> to <zeroormore__bitwisexor_and_expr>\n");}

xor_expr: and_expr zeroormore__bitwisexor_and_expr {printf("Parser: Reducing <and_expr zeroormore__bitwisexor_and_expr> to <xor_expr>\n");}

bitwiseand_shift_expr: BITWISEAND shift_expr {printf("Parser: Reducing <BITWISEAND shift_expr> to <bitwiseand_shift_expr>\n");}
zeroormore__bitwiseand_shift_expr:   {printf("Parser: Reducing <> to <zeroormore__bitwiseand_shift_expr>\n");}
    |  bitwiseand_shift_expr  zeroormore__bitwiseand_shift_expr {printf("Parser: Reducing <bitwiseand_shift_expr  zeroormore__bitwiseand_shift_expr> to <zeroormore__bitwiseand_shift_expr>\n");}

and_expr: shift_expr zeroormore__bitwiseand_shift_expr {printf("Parser: Reducing <shift_expr zeroormore__bitwiseand_shift_expr> to <and_expr>\n");}

lshift__or__rshift: LSHIFT  {printf("Parser: Reducing <LSHIFT> to <lshift__or__rshift>\n");}
    |  RSHIFT {printf("Parser: Reducing <RSHIFT> to <lshift__or__rshift>\n");}
lshift__or__rshift_arith_expr: lshift__or__rshift arith_expr {printf("Parser: Reducing <lshift__or__rshift arith_expr> to <lshift__or__rshift_arith_expr>\n");}
zeroormore__lshift__or__rshift_arith_expr:   {printf("Parser: Reducing <> to <zeroormore__lshift__or__rshift_arith_expr>\n");}
    |  lshift__or__rshift_arith_expr  zeroormore__lshift__or__rshift_arith_expr {printf("Parser: Reducing <lshift__or__rshift_arith_expr  zeroormore__lshift__or__rshift_arith_expr> to <zeroormore__lshift__or__rshift_arith_expr>\n");}

shift_expr: arith_expr zeroormore__lshift__or__rshift_arith_expr {printf("Parser: Reducing <arith_expr zeroormore__lshift__or__rshift_arith_expr> to <shift_expr>\n");}

add__or__sub: ADD  {printf("Parser: Reducing <ADD> to <add__or__sub>\n");}
    |  SUB {printf("Parser: Reducing <SUB> to <add__or__sub>\n");}
add__or__sub_term: add__or__sub term {printf("Parser: Reducing <add__or__sub term> to <add__or__sub_term>\n");}
zeroormore__add__or__sub_term:   {printf("Parser: Reducing <> to <zeroormore__add__or__sub_term>\n");}
    |  add__or__sub_term  zeroormore__add__or__sub_term {printf("Parser: Reducing <add__or__sub_term  zeroormore__add__or__sub_term> to <zeroormore__add__or__sub_term>\n");}

arith_expr: term zeroormore__add__or__sub_term {printf("Parser: Reducing <term zeroormore__add__or__sub_term> to <arith_expr>\n");}

mul__or__div__or__mod__or__fdiv: MUL  {printf("Parser: Reducing <MUL> to <mul__or__div__or__mod__or__fdiv>\n");}
    |  DIV  {printf("Parser: Reducing <DIV> to <mul__or__div__or__mod__or__fdiv>\n");}
    |  MOD  {printf("Parser: Reducing <MOD> to <mul__or__div__or__mod__or__fdiv>\n");}
    |  FDIV {printf("Parser: Reducing <FDIV> to <mul__or__div__or__mod__or__fdiv>\n");}
mul__or__div__or__mod__or__fdiv_factor: mul__or__div__or__mod__or__fdiv factor {printf("Parser: Reducing <mul__or__div__or__mod__or__fdiv factor> to <mul__or__div__or__mod__or__fdiv_factor>\n");}
zeroormore__mul__or__div__or__mod__or__fdiv_factor:   {printf("Parser: Reducing <> to <zeroormore__mul__or__div__or__mod__or__fdiv_factor>\n");}
    |  mul__or__div__or__mod__or__fdiv_factor  zeroormore__mul__or__div__or__mod__or__fdiv_factor {printf("Parser: Reducing <mul__or__div__or__mod__or__fdiv_factor  zeroormore__mul__or__div__or__mod__or__fdiv_factor> to <zeroormore__mul__or__div__or__mod__or__fdiv_factor>\n");}

term: factor zeroormore__mul__or__div__or__mod__or__fdiv_factor {printf("Parser: Reducing <factor zeroormore__mul__or__div__or__mod__or__fdiv_factor> to <term>\n");}

add__or__sub__or__bitwisenot: ADD  {printf("Parser: Reducing <ADD> to <add__or__sub__or__bitwisenot>\n");}
    |  SUB  {printf("Parser: Reducing <SUB> to <add__or__sub__or__bitwisenot>\n");}
    |  BITWISENOT {printf("Parser: Reducing <BITWISENOT> to <add__or__sub__or__bitwisenot>\n");}

factor: add__or__sub__or__bitwisenot factor  {printf("Parser: Reducing <add__or__sub__or__bitwisenot factor> to <factor>\n");}
    |  power {printf("Parser: Reducing <power> to <factor>\n");}

optional__pow_factor:   {printf("Parser: Reducing <> to <optional__pow_factor>\n");}
    |  POW factor {printf("Parser: Reducing <POW factor> to <optional__pow_factor>\n");}
zeroormore__atom_trailer:   {printf("Parser: Reducing <> to <zeroormore__atom_trailer>\n");}
    |  atom trailer  zeroormore__atom_trailer {printf("Parser: Reducing <atom trailer  zeroormore__atom_trailer> to <zeroormore__atom_trailer>\n");}

power: zeroormore__atom_trailer optional__pow_factor {printf("Parser: Reducing <zeroormore__atom_trailer optional__pow_factor> to <power>\n");}

oneormore__string: STRING  oneormore__string  {printf("Parser: Reducing <STRING  oneormore__string> to <oneormore__string>\n");}
    |  STRING  {printf("Parser: Reducing <STRING> to <oneormore__string>\n");}
optional__dictorsetmaker:   {printf("Parser: Reducing <> to <optional__dictorsetmaker>\n");}
    |  dictorsetmaker {printf("Parser: Reducing <dictorsetmaker> to <optional__dictorsetmaker>\n");}
optional__testlist_comp:   {printf("Parser: Reducing <> to <optional__testlist_comp>\n");}
    |  testlist_comp {printf("Parser: Reducing <testlist_comp> to <optional__testlist_comp>\n");}
optional__yield_expr__or__testlist_comp:   {printf("Parser: Reducing <> to <optional__yield_expr__or__testlist_comp>\n");}
    |  yield_expr  {printf("Parser: Reducing <yield_expr> to <optional__yield_expr__or__testlist_comp>\n");}
    |  testlist_comp {printf("Parser: Reducing <testlist_comp> to <optional__yield_expr__or__testlist_comp>\n");}

atom: LPARENTHESIS optional__yield_expr__or__testlist_comp RPARENTHESIS  {printf("Parser: Reducing <LPARENTHESIS optional__yield_expr__or__testlist_comp RPARENTHESIS> to <atom>\n");}
    |  LSQUAREBRACE optional__testlist_comp RSQUAREBRACE  {printf("Parser: Reducing <LSQUAREBRACE optional__testlist_comp RSQUAREBRACE> to <atom>\n");}
    |  LCURLYBRACE optional__dictorsetmaker RCURLYBRACE  {printf("Parser: Reducing <LCURLYBRACE optional__dictorsetmaker RCURLYBRACE> to <atom>\n");}
    |  NAME  {printf("Parser: Reducing <NAME> to <atom>\n");}
    |  NUMBER  {printf("Parser: Reducing <NUMBER> to <atom>\n");}
    |  oneormore__string  {printf("Parser: Reducing <oneormore__string> to <atom>\n");}
    |  ELLIPSIS  {printf("Parser: Reducing <ELLIPSIS> to <atom>\n");}
    |  NONE  {printf("Parser: Reducing <NONE> to <atom>\n");}
    |  TRUE  {printf("Parser: Reducing <TRUE> to <atom>\n");}
    |  FALSE {printf("Parser: Reducing <FALSE> to <atom>\n");}

comma_test: COMMA test {printf("Parser: Reducing <COMMA test> to <comma_test>\n");}
zeroormore__comma_test:   {printf("Parser: Reducing <> to <zeroormore__comma_test>\n");}
    |  comma_test  zeroormore__comma_test {printf("Parser: Reducing <comma_test  zeroormore__comma_test> to <zeroormore__comma_test>\n");}
comp_for__or__zeroormore__comma_test_optional__comma: comp_for  {printf("Parser: Reducing <comp_for> to <comp_for__or__zeroormore__comma_test_optional__comma>\n");}
    |  zeroormore__comma_test optional__comma {printf("Parser: Reducing <zeroormore__comma_test optional__comma> to <comp_for__or__zeroormore__comma_test_optional__comma>\n");}

testlist_comp: test comp_for__or__zeroormore__comma_test_optional__comma {printf("Parser: Reducing <test comp_for__or__zeroormore__comma_test_optional__comma> to <testlist_comp>\n");}


trailer: LPARENTHESIS optional__arglist RPARENTHESIS  {printf("Parser: Reducing <LPARENTHESIS optional__arglist RPARENTHESIS> to <trailer>\n");}
    |  LSQUAREBRACE subscriptlist RSQUAREBRACE  {printf("Parser: Reducing <LSQUAREBRACE subscriptlist RSQUAREBRACE> to <trailer>\n");}
    |  DOT NAME {printf("Parser: Reducing <DOT NAME> to <trailer>\n");}

comma_subscript: COMMA subscript {printf("Parser: Reducing <COMMA subscript> to <comma_subscript>\n");}
zeroormore__comma_subscript:   {printf("Parser: Reducing <> to <zeroormore__comma_subscript>\n");}
    |  comma_subscript  zeroormore__comma_subscript {printf("Parser: Reducing <comma_subscript  zeroormore__comma_subscript> to <zeroormore__comma_subscript>\n");}

subscriptlist: subscript zeroormore__comma_subscript optional__comma {printf("Parser: Reducing <subscript zeroormore__comma_subscript optional__comma> to <subscriptlist>\n");}

optional__sliceop:   {printf("Parser: Reducing <> to <optional__sliceop>\n");}
    |  sliceop {printf("Parser: Reducing <sliceop> to <optional__sliceop>\n");}
optional__test:   {printf("Parser: Reducing <> to <optional__test>\n");}
    |  test {printf("Parser: Reducing <test> to <optional__test>\n");}

subscript: test  {printf("Parser: Reducing <test> to <subscript>\n");}
    |  optional__test COLON optional__test optional__sliceop {printf("Parser: Reducing <optional__test COLON optional__test optional__sliceop> to <subscript>\n");}


sliceop: COLON optional__test {printf("Parser: Reducing <COLON optional__test> to <sliceop>\n");}

comma_star_expr: COMMA star_expr {printf("Parser: Reducing <COMMA star_expr> to <comma_star_expr>\n");}
zeroormore__comma_star_expr:   {printf("Parser: Reducing <> to <zeroormore__comma_star_expr>\n");}
    |  comma_star_expr  zeroormore__comma_star_expr {printf("Parser: Reducing <comma_star_expr  zeroormore__comma_star_expr> to <zeroormore__comma_star_expr>\n");}

exprlist: star_expr zeroormore__comma_star_expr optional__comma {printf("Parser: Reducing <star_expr zeroormore__comma_star_expr optional__comma> to <exprlist>\n");}


testlist: test zeroormore__comma_test {printf("Parser: Reducing <test zeroormore__comma_test> to <testlist>\n");}

test_comp_for__or__zeroormore__comma_test_optional__comma: test comp_for__or__zeroormore__comma_test_optional__comma {printf("Parser: Reducing <test comp_for__or__zeroormore__comma_test_optional__comma> to <test_comp_for__or__zeroormore__comma_test_optional__comma>\n");}
comma_test_colon_test: COMMA test COLON test {printf("Parser: Reducing <COMMA test COLON test> to <comma_test_colon_test>\n");}
zeroormore__comma_test_colon_test:   {printf("Parser: Reducing <> to <zeroormore__comma_test_colon_test>\n");}
    |  comma_test_colon_test  zeroormore__comma_test_colon_test {printf("Parser: Reducing <comma_test_colon_test  zeroormore__comma_test_colon_test> to <zeroormore__comma_test_colon_test>\n");}
comp_for__or__zeroormore__comma_test_colon_test_optional__comma: comp_for  {printf("Parser: Reducing <comp_for> to <comp_for__or__zeroormore__comma_test_colon_test_optional__comma>\n");}
    |  zeroormore__comma_test_colon_test optional__comma {printf("Parser: Reducing <zeroormore__comma_test_colon_test optional__comma> to <comp_for__or__zeroormore__comma_test_colon_test_optional__comma>\n");}
test_colon_test_comp_for__or__zeroormore__comma_test_colon_test_optional__comma: test COLON test comp_for__or__zeroormore__comma_test_colon_test_optional__comma {printf("Parser: Reducing <test COLON test comp_for__or__zeroormore__comma_test_colon_test_optional__comma> to <test_colon_test_comp_for__or__zeroormore__comma_test_colon_test_optional__comma>\n");}

dictorsetmaker: test_colon_test_comp_for__or__zeroormore__comma_test_colon_test_optional__comma  {printf("Parser: Reducing <test_colon_test_comp_for__or__zeroormore__comma_test_colon_test_optional__comma> to <dictorsetmaker>\n");}
    |  test_comp_for__or__zeroormore__comma_test_optional__comma {printf("Parser: Reducing <test_comp_for__or__zeroormore__comma_test_optional__comma> to <dictorsetmaker>\n");}


classdef: CLASS NAME optional__lparenthesis_optional__arglist_rparenthesis COLON suite {printf("Parser: Reducing <CLASS NAME optional__lparenthesis_optional__arglist_rparenthesis COLON suite> to <classdef>\n");}

optional__comma_pow_test:   {printf("Parser: Reducing <> to <optional__comma_pow_test>\n");}
    |  COMMA POW test {printf("Parser: Reducing <COMMA POW test> to <optional__comma_pow_test>\n");}
comma_argument: COMMA argument {printf("Parser: Reducing <COMMA argument> to <comma_argument>\n");}
zeroormore__comma_argument:   {printf("Parser: Reducing <> to <zeroormore__comma_argument>\n");}
    |  comma_argument  zeroormore__comma_argument {printf("Parser: Reducing <comma_argument  zeroormore__comma_argument> to <zeroormore__comma_argument>\n");}

arglist: argument optional__comma  {printf("Parser: Reducing <argument optional__comma> to <arglist>\n");}
    |  MUL test zeroormore__comma_argument optional__comma_pow_test  {printf("Parser: Reducing <MUL test zeroormore__comma_argument optional__comma_pow_test> to <arglist>\n");}
    |  POW test {printf("Parser: Reducing <POW test> to <arglist>\n");}

optional__comp_for:   {printf("Parser: Reducing <> to <optional__comp_for>\n");}
    |  comp_for {printf("Parser: Reducing <comp_for> to <optional__comp_for>\n");}

argument: test optional__comp_for  {printf("Parser: Reducing <test optional__comp_for> to <argument>\n");}
    |  test ASSIGNMENT test {printf("Parser: Reducing <test ASSIGNMENT test> to <argument>\n");}


comp_iter: comp_for  {printf("Parser: Reducing <comp_for> to <comp_iter>\n");}
    |  comp_if {printf("Parser: Reducing <comp_if> to <comp_iter>\n");}

optional__comp_iter:   {printf("Parser: Reducing <> to <optional__comp_iter>\n");}
    |  comp_iter {printf("Parser: Reducing <comp_iter> to <optional__comp_iter>\n");}

comp_for: FOR exprlist IN or_test optional__comp_iter {printf("Parser: Reducing <FOR exprlist IN or_test optional__comp_iter> to <comp_for>\n");}


comp_if: IF test_nocond optional__comp_iter {printf("Parser: Reducing <IF test_nocond optional__comp_iter> to <comp_if>\n");}


yield_expr: YIELD optional__testlist {printf("Parser: Reducing <YIELD optional__testlist> to <yield_expr>\n");}

%%
main()
{
yyparse();
}

void yyerror(const char *s)
{

printf("error: %s\n",s);
}
