%{
#include <stdio.h>
#include <stdlib.h>
#include <stack>
#define YY_DECL extern "C" int yylex()

#include "parser.tab.h"
extern void yyerror(char *);

int parentheses_lvl = 0;
int squarebraces_lvl = 0;
int curlybraces_lvl = 0;

// FEATURES NOT CURRENTLY SUPPORTED:
// Long strings.
// String escape sequences. 
// Strings and identifiers with special characters may or may not work.

// Indentation analysis inspired by https://github.com/lucasb-eyer/flex-bison-indentation

int current_line_indent = 0;
bool is_fake_dedent_symbol = false;
char stringquote;

std::stack<int> indentstack;
#define YY_USER_INIT { \
  indentstack.push(0); \
}


#define END_PARENTHESES_AND_BRACES() \
  if (parentheses_lvl == 0 && squarebraces_lvl == 0 && curlybraces_lvl == 0) \
    BEGIN(INITIAL)
%}


%s PARENTHESES_OR_BRACES
%s INDENTATION

eol           [\n\r(\r\n)]
comment       #.*
linewhitespce [ \t\f]*

stringprefix      (r|u|R|U|b|B|br|Br|bR|BR|rb|rB|Rb|RB)
longstring        (\"\"\".*|\'\'\'.*)
shortstring       (\"([^\"\n\r]|\\\")*\"|\'([^\'\n\r]|\\\')*?\')
shortstringliteral     {stringprefix}?{shortstring}
longstringliteral {stringprefix}?{longstring}

bininteger       0[bB][01]+
octinteger       0[oO][0-7]+
hexinteger       0[xX][0-9a-fA-F]+
decimalinteger   ([1-9][0-9]*|0+)
integer          ({decimalinteger}|{octinteger}|{hexinteger}|{bininteger})

intpart        [0-9]+
fraction       \.[0-9]+
exponent       [eE][+-]?[0-9]+
exponentfloat  ({intpart}|{pointfloat}){exponent}
pointfloat     {intpart}?{fraction}|{intpart}\.
floatnumber    ({pointfloat}|{exponentfloat})

imagnumber     ({floatnumber}|{intpart})[jJ]

number         ({integer}|{floatnumber}|{imagnumber})

identifier     [a-zA-Z_][a-zA-Z0-9_]*

%%


"False" {printf("Lexer: FALSE found \n"); return FALSE;}
"None" {printf("Lexer: NONE found \n"); return NONE;}
"True" {printf("Lexer: TRUE found \n"); return TRUE;}
"and" {printf("Lexer: AND found \n"); return AND;}
"as" {printf("Lexer: AS found \n"); return AS;}
"assert" {printf("Lexer: ASSERT found \n"); return ASSERT;}
"break" {printf("Lexer: BREAK found \n"); return BREAK;}
"class" {printf("Lexer: CLASS found \n"); return CLASS;}
"continue" {printf("Lexer: CONTINUE found \n"); return CONTINUE;}
"def" {printf("Lexer: DEF found \n"); return DEF;}
"del" {printf("Lexer: DEL found \n"); return DEL;}
"elif" {printf("Lexer: ELIF found \n"); return ELIF;}
"else" {printf("Lexer: ELSE found \n"); return ELSE;}
"except" {printf("Lexer: EXCEPT found \n"); return EXCEPT;}
"finally" {printf("Lexer: FINALLY found \n"); return FINALLY;}
"for" {printf("Lexer: FOR found \n"); return FOR;}
"from" {printf("Lexer: FROM found \n"); return FROM;}
"global" {printf("Lexer: GLOBAL found \n"); return GLOBAL;}
"if" {printf("Lexer: IF found \n"); return IF;}
"import" {printf("Lexer: IMPORT found \n"); return IMPORT;}
"in" {printf("Lexer: IN found \n"); return IN;}
"is" {printf("Lexer: IS found \n"); return IS;}
"lambda" {printf("Lexer: LAMBDA found \n"); return LAMBDA;}
"nonlocal" {printf("Lexer: NONLOCAL found \n"); return NONLOCAL;}
"not" {printf("Lexer: NOT found \n"); return NOT;}
"or" {printf("Lexer: OR found \n"); return OR;}
"pass" {printf("Lexer: PASS found \n"); return PASS;}
"raise" {printf("Lexer: RAISE found \n"); return RAISE;}
"return" {printf("Lexer: RETURN found \n"); return RETURN;}
"try" {printf("Lexer: TRY found \n"); return TRY;}
"while" {printf("Lexer: WHILE found \n"); return WHILE;}
"with" {printf("Lexer: WITH found \n"); return WITH;}
"yield" {printf("Lexer: YIELD found \n"); return YIELD;}
"->" {printf("Lexer: ANNOTATIONRETURN found \n"); return ANNOTATIONRETURN;}
"+=" {printf("Lexer: RADD found \n"); return RADD;}
"-=" {printf("Lexer: RSUB found \n"); return RSUB;}
"*=" {printf("Lexer: RMUL found \n"); return RMUL;}
"/=" {printf("Lexer: RDIV found \n"); return RDIV;}
"//=" {printf("Lexer: RFDIV found \n"); return RFDIV;}
"%=" {printf("Lexer: RMOD found \n"); return RMOD;}
"&=" {printf("Lexer: RAND found \n"); return RAND;}
"|=" {printf("Lexer: ROR found \n"); return ROR;}
"^=" {printf("Lexer: RXOR found \n"); return RXOR;}
">>=" {printf("Lexer: RRSHIFT found \n"); return RRSHIFT;}
"<<=" {printf("Lexer: RLSHIFT found \n"); return RLSHIFT;}
"**=" {printf("Lexer: RPOW found \n"); return RPOW;}
"..." {printf("Lexer: ELLIPSIS found \n"); return ELLIPSIS;}
"+" {printf("Lexer: ADD found \n"); return ADD;}
"-" {printf("Lexer: SUB found \n"); return SUB;}
"**" {printf("Lexer: POW found \n"); return POW;}
"*" {printf("Lexer: MUL found \n"); return MUL;}
"//" {printf("Lexer: FDIV found \n"); return FDIV;}
"/" {printf("Lexer: DIV found \n"); return DIV;}
"%" {printf("Lexer: MOD found \n"); return MOD;}
"<<" {printf("Lexer: LSHIFT found \n"); return LSHIFT;}
">>" {printf("Lexer: RSHIFT found \n"); return RSHIFT;}
"&" {printf("Lexer: BITWISEAND found \n"); return BITWISEAND;}
"|" {printf("Lexer: BITWISEOR found \n"); return BITWISEOR;}
"^" {printf("Lexer: BITWISEXOR found \n"); return BITWISEXOR;}
"~" {printf("Lexer: BITWISENOT found \n"); return BITWISENOT;}
"<=" {printf("Lexer: LE found \n"); return LE;}
">=" {printf("Lexer: GE found \n"); return GE;}
"==" {printf("Lexer: EQ found \n"); return EQ;}
"<" {printf("Lexer: LT found \n"); return LT;}
">" {printf("Lexer: GT found \n"); return GT;}
"!=" {printf("Lexer: NEQ found \n"); return NEQ;}
"," {printf("Lexer: COMMA found \n"); return COMMA;}
":" {printf("Lexer: COLON found \n"); return COLON;}
"." {printf("Lexer: DOT found \n"); return DOT;}
";" {printf("Lexer: SEMICOLON found \n"); return SEMICOLON;}
"@" {printf("Lexer: AT found \n"); return AT;}
"=" {printf("Lexer: ASSIGNMENT found \n"); return ASSIGNMENT;}

"["                        {printf("Lexer: LSQUAREBRACE found.\n");
                            ++squarebraces_lvl;
                            BEGIN(PARENTHESES_OR_BRACES);
                            return LSQUAREBRACE;}

"]"                        {printf("Lexer: RSQUAREBRACE found.\n");
                            --squarebraces_lvl;
                            END_PARENTHESES_AND_BRACES();
                            return RSQUAREBRACE;}

"("                        {printf("Lexer: LPARENTHESIS found.\n");
                            ++parentheses_lvl;
                            BEGIN(PARENTHESES_OR_BRACES);
                            return LPARENTHESIS;}

")"                        {printf("Lexer: RPARENTHESIS found.\n");
                            --parentheses_lvl;
                            END_PARENTHESES_AND_BRACES();
                            return RPARENTHESIS;}

"{"                        {printf("Lexer: LCURLYBRACE found.\n");
                            ++curlybraces_lvl;
                            BEGIN(PARENTHESES_OR_BRACES);
                            return LCURLYBRACE;}

"}"                        {printf("Lexer: RCURLYBRACE found.\n");
                            --curlybraces_lvl;
                            END_PARENTHESES_AND_BRACES();
                            return RCURLYBRACE;}

<INITIAL,PARENTHESES_OR_BRACES>{comment}   { /* Comment */}
<INITIAL>"\\"{eol}{linewhitespce}          { /* Joined lines - no NOEWLINE*/ }
<INITIAL>^{linewhitespce}{comment}?{eol}   { /* Blank line - igored */}
<INITIAL>^.                                { unput(*yytext);
                                             current_line_indent = 0;
                                             BEGIN(INDENTATION); }
<INDENTATION>" "                           { ++current_line_indent; }
<INDENTATION>"\t"                          { current_line_indent = (current_line_indent + 8) & ~7;}
<INDENTATION>{eol}                         { current_line_indent = 0; }
<<EOF>>                                    { if (indentstack.top() != 0) {
                                               indentstack.pop();
                                               if (current_line_indent != indentstack.top()) {
                                                 unput('\n');
                                                 for (size_t i = 0; i < indentstack.top(); ++i) {
                                                   unput(' '); }
                                               } else {
                                                 BEGIN(INITIAL); }
                                               printf("Lexer: DEDENT found\n");
                                               return DEDENT;
                                             } else {
                                               printf("Lexer: ENDMARKER found\n");
                                               return ENDMARKER;}
                                           }
<INDENTATION>.                             { //printf("Lexer: Stack top: %d, indentation level: %d\n", indentstack.top(), current_line_indent);
                                             if (!is_fake_dedent_symbol) {
                                               unput(*yytext); }
                                             if (is_fake_dedent_symbol && current_line_indent > indentstack.top()) {
                                               // Tabs and spaces mixed in an inappropriate way!
                                               // Do better error reporting.
                                               printf("Lexer: Lexical error: Inconsistent tabs and spaces!\n");
                                               exit(EXIT_FAILURE);
                                             }
                                             if (current_line_indent > indentstack.top()) {
                                               indentstack.push(current_line_indent);
                                               BEGIN(INITIAL);
                                               is_fake_dedent_symbol = false;
                                               printf("Lexer: INDENT found\n");
                                               return INDENT;
                                             } else if (current_line_indent < indentstack.top()) {
                                               indentstack.pop();
                                               is_fake_dedent_symbol = false;
                                               if (current_line_indent != indentstack.top()) {
                                                 for (size_t i = 0; i < current_line_indent; ++i) {
                                                   unput(' '); }
                                                 unput('\n');
                                                 unput('?');
                                                 is_fake_dedent_symbol = true;
                                                 for (size_t i = 0; i < indentstack.top(); ++i) {
                                                   unput(' '); }
                                                 unput('\n');
                                               } else {
                                                 BEGIN(INITIAL);
                                               }
                                               printf("Lexer: DEDENT found\n");
                                               return DEDENT;
                                             } else {
                                               if (!is_fake_dedent_symbol) {
                                                 is_fake_dedent_symbol = false;
                                                 BEGIN(INITIAL);}
                                             }
                                           }
                                               
                                                 

<INITIAL>{eol}                      {printf("Lexer: NEWLINE found.\n"); return NEWLINE;}
<INITIAL>{linewhitespce}            { /* Whitespace not part of indentation*/ }
<PARENTHESES_OR_BRACES>{eol}        { /* Newline inside parentheses or braces - ignored */ }
{longstringliteral}                 {printf("Lexer: Longstrings not supported!\n"); exit(EXIT_FAILURE);}
{shortstringliteral}                {printf("Lexer: STRING found %s.\n",yytext); return STRING;}
{number}                            {printf("Lexer: NUMBER found %s.\n",yytext); return NUMBER;}
{identifier}                        {printf("Lexer: NAME found %s.\n", yytext); return NAME;}



<*>.                                { }
%% 

main() {
  while (yylex()!=ENDMARKER) {}
  }
