/*



Parts of code regarding indentation handling taken from
https://github.com/lucasb-eyer/flex-bison-indentation/blob/master/scanner.l
It contained the following copyright notice:

Copyright (C) 2013 Lucas Beyer (http://lucasb.eyer.be)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to
deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
sell copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.
*/

%{
#include <stack>
#include <stdio.h>

/* globals to track current indentation */
int current_line_indent = 0;   /* indentation of the current line */
std::stack<size_t> indent_levels;
int is_fake_symbol = false;
int finished = false;

int parentheses_lvl = 0;
int squarebraces_lvl = 0;
int curlybraces_lvl = 0;

#define endenclosed() \
  if (parentheses_lvl == 0 && squarebraces_lvl == 0 && curlybraces_lvl == 0) \
    BEGIN(normal)
/* TODO: error-out on tabs/spaces mix? */
static const unsigned int TAB_WIDTH = 8;


/* Don't mangle yylex please! */
#define YY_DECL extern "C" int yylex()
#define YYSTYPE int
#include "parser0.tab.h"

#define YY_USER_INIT { \
        indent_levels.push(0); \
    }

%}

 /* This is a sub-parser (state) for indentation-sensitive scoping */
%x indent
%x enclosed
%s normal

 /* %option 8bit reentrant bison-bridge */
%option warn
%option nodefault
%option yylineno
%option noyywrap
 /*%option debug*/

 /* Regular expressions used in the lexer more often */
eol           (\n|\r|\r\n)
linewhitespce [ \t\f]*

 /* Numbers and identifier regexps */
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

  int indent_caller = normal;
 /* This helps to keep track of the column number.
  * Note that it won't work if you have a rule which includes a newline and is
  * longer than one character because in that case that rule will be favored
  * and this one here won't get called.
  * TL;DR: If you have a rule which includes \n and more, you need to reset
  *        yycolumn inside that rule!
  */
<*>\n {  yylineno--; REJECT; }

 /* Everything runs in the <normal> mode and enters the <indent> mode
    when a newline symbol is encountered.
    There is no newline symbol before the first line, so we need to go
    into the <indent> mode by hand there.
 */
<INITIAL>.  { indent_caller = normal; yyless(0); BEGIN(indent); }
<INITIAL>\n { indent_caller = normal; yyless(0); BEGIN(indent); }

<*>#.*      { /* Comment */}
<*>"\\"{eol}{linewhitespce}          { /* Joined lines - no NOEWLINE*/ }

<normal,enclosed>{linewhitespce}     { /* Whitespace not part of indentation */ }
 /* The following are the rules that keep track of indentation. */
<indent>" "     { ++current_line_indent; }
<indent>\t      { current_line_indent = (current_line_indent + TAB_WIDTH) & ~(TAB_WIDTH-1); }
<indent>{eol}   { current_line_indent = 0; /* ignoring blank line */ }
<normal><<EOF>> { BEGIN(indent); /* Happens when file doesn't end by empty line*/ }
<indent><<EOF>> {
                    // When encountering the end of file, we want to emit an
                    // outdent for all indents currently left.
                    if(indent_levels.top() != 0) {
                        indent_levels.pop();

                        // See the same code below (<indent>.) for a rationale.
                        if(current_line_indent != indent_levels.top()) {
                            unput('\n');
                            for(size_t i = 0 ; i < indent_levels.top() ; ++i) {
                                unput(' ');
                            }
                        } else {
                            BEGIN(indent_caller);
                        }

                        printf("Lexer: DEDENT found (at EOF)\n");
                        return DEDENT;
                    } else {
                        if (!finished) {
                          printf("Lexer: ENDMARKER found\n");
                          finished = true;
                          return ENDMARKER;
                        } else {
                          printf("Lexer: Terminate!\n");
                          yyterminate();
                        }
                    }
                }

<indent>.       {
                    if(!is_fake_symbol) {
                        unput(*yytext);
                    }
                  

                    // Indentation level has increased. It can only ever
                    // increase by one level at a time. Remember how many
                    // spaces this level has and emit an indentation token.
                    if(current_line_indent > indent_levels.top()) {
                        indent_levels.push(current_line_indent);
                        BEGIN(indent_caller);
                        printf("Lexer: INDENT found\n");
                        is_fake_symbol = false;
                        return INDENT;
                    } else if(current_line_indent < indent_levels.top()) {
                        // Outdenting is the most difficult, as we might need to
                        // outdent multiple times at once, but flex doesn't allow
                        // emitting multiple tokens at once! So we fake this by
                        // 'unput'ting fake lines which will give us the next
                        // outdent.
                        indent_levels.pop();
                        is_fake_symbol = false;

                        if(current_line_indent != indent_levels.top()) {
                            // Unput the rest of the current line, including the newline.
                            // We want to keep it untouched.
                            for(size_t i = 0 ; i < current_line_indent ; ++i) {
                                unput(' ');
                            }
                            unput('\n');
                            // Now, insert a fake character indented just so
                            // that we get a correct outdent the next time.
                            unput('?');
                            // Though we need to remember that it's a fake one
                            // so we can ignore the symbol.
                            is_fake_symbol = true;
                            for(size_t i = 0 ; i < indent_levels.top() ; ++i) {
                                unput(' ');
                            }
                            unput('\n');
                        } else {
                            BEGIN(indent_caller);
                        }
                        printf("lexer: DEDENT found\n");
                        return DEDENT;
                    } else {
                        // No change in indentation, not much to do here...
                        if (!is_fake_symbol) {
                          is_fake_symbol = false;
                          BEGIN(indent_caller);
                        }
                    }
                }

<normal>{eol}    { current_line_indent = 0;
                   indent_caller = YY_START;
                   BEGIN(indent);
                   printf("Lexer: NEWLINE found\n");
                   return NEWLINE;}

<normal,enclosed>"["        {printf("Lexer: LSQUAREBRACE found.\n");
                            ++squarebraces_lvl;
                            BEGIN(enclosed);
                            return LSQUAREBRACE;}

<enclosed>"]"                        {printf("Lexer: RSQUAREBRACE found.\n");
                            --squarebraces_lvl;
                            endenclosed();
                            return RSQUAREBRACE;}

<normal,enclosed>"("        {printf("Lexer: LPARENTHESIS found.\n");
                            ++parentheses_lvl;
                            BEGIN(enclosed);
                            return LPARENTHESIS;}

<enclosed>")"                        {printf("Lexer: RPARENTHESIS found.\n");
                            --parentheses_lvl;
                            endenclosed();
                            return RPARENTHESIS;}

<normal,enclosed>"{"        {printf("Lexer: LCURLYBRACE found.\n");
                            ++curlybraces_lvl;
                            BEGIN(enclosed);
                            return LCURLYBRACE;}

<enclosed>"}"               {printf("Lexer: RCURLYBRACE found.\n");
                            --curlybraces_lvl;
                            endenclosed();
                            return RCURLYBRACE;}

<normal,enclosed>"False" {printf("Lexer: FALSE found \n"); return FALSE;}
<normal,enclosed>"None" {printf("Lexer: NONE found \n"); return NONE;}
<normal,enclosed>"True" {printf("Lexer: TRUE found \n"); return TRUE;}
<normal,enclosed>"and" {printf("Lexer: AND found \n"); return AND;}
<normal,enclosed>"as" {printf("Lexer: AS found \n"); return AS;}
<normal,enclosed>"assert" {printf("Lexer: ASSERT found \n"); return ASSERT;}
<normal,enclosed>"break" {printf("Lexer: BREAK found \n"); return BREAK;}
<normal,enclosed>"class" {printf("Lexer: CLASS found \n"); return CLASS;}
<normal,enclosed>"continue" {printf("Lexer: CONTINUE found \n"); return CONTINUE;}
<normal,enclosed>"def" {printf("Lexer: DEF found \n"); return DEF;}
<normal,enclosed>"del" {printf("Lexer: DEL found \n"); return DEL;}
<normal,enclosed>"elif" {printf("Lexer: ELIF found \n"); return ELIF;}
<normal,enclosed>"else" {printf("Lexer: ELSE found \n"); return ELSE;}
<normal,enclosed>"except" {printf("Lexer: EXCEPT found \n"); return EXCEPT;}
<normal,enclosed>"finally" {printf("Lexer: FINALLY found \n"); return FINALLY;}
<normal,enclosed>"for" {printf("Lexer: FOR found \n"); return FOR;}
<normal,enclosed>"from" {printf("Lexer: FROM found \n"); return FROM;}
<normal,enclosed>"global" {printf("Lexer: GLOBAL found \n"); return GLOBAL;}
<normal,enclosed>"if" {printf("Lexer: IF found \n"); return IF;}
<normal,enclosed>"import" {printf("Lexer: IMPORT found \n"); return IMPORT;}
<normal,enclosed>"in" {printf("Lexer: IN found \n"); return IN;}
<normal,enclosed>"is" {printf("Lexer: IS found \n"); return IS;}
<normal,enclosed>"lambda" {printf("Lexer: LAMBDA found \n"); return LAMBDA;}
<normal,enclosed>"nonlocal" {printf("Lexer: NONLOCAL found \n"); return NONLOCAL;}
<normal,enclosed>"not" {printf("Lexer: NOT found \n"); return NOT;}
<normal,enclosed>"or" {printf("Lexer: OR found \n"); return OR;}
<normal,enclosed>"pass" {printf("Lexer: PASS found \n"); return PASS;}
<normal,enclosed>"raise" {printf("Lexer: RAISE found \n"); return RAISE;}
<normal,enclosed>"return" {printf("Lexer: RETURN found \n"); return RETURN;}
<normal,enclosed>"try" {printf("Lexer: TRY found \n"); return TRY;}
<normal,enclosed>"while" {printf("Lexer: WHILE found \n"); return WHILE;}
<normal,enclosed>"with" {printf("Lexer: WITH found \n"); return WITH;}
<normal,enclosed>"yield" {printf("Lexer: YIELD found \n"); return YIELD;}
<normal,enclosed>"->" {printf("Lexer: ANNOTATIONRETURN found \n"); return ANNOTATIONRETURN;}
<normal,enclosed>"+=" {printf("Lexer: RADD found \n"); return RADD;}
<normal,enclosed>"-=" {printf("Lexer: RSUB found \n"); return RSUB;}
<normal,enclosed>"*=" {printf("Lexer: RMUL found \n"); return RMUL;}
<normal,enclosed>"/=" {printf("Lexer: RDIV found \n"); return RDIV;}
<normal,enclosed>"//=" {printf("Lexer: RFDIV found \n"); return RFDIV;}
<normal,enclosed>"%=" {printf("Lexer: RMOD found \n"); return RMOD;}
<normal,enclosed>"&=" {printf("Lexer: RAND found \n"); return RAND;}
<normal,enclosed>"|=" {printf("Lexer: ROR found \n"); return ROR;}
<normal,enclosed>"^=" {printf("Lexer: RXOR found \n"); return RXOR;}
<normal,enclosed>">>=" {printf("Lexer: RRSHIFT found \n"); return RRSHIFT;}
<normal,enclosed>"<<=" {printf("Lexer: RLSHIFT found \n"); return RLSHIFT;}
<normal,enclosed>"**=" {printf("Lexer: RPOW found \n"); return RPOW;}
<normal,enclosed>"+" {printf("Lexer: ADD found \n"); return ADD;}
<normal,enclosed>"-" {printf("Lexer: SUB found \n"); return SUB;}
<normal,enclosed>"**" {printf("Lexer: POW found \n"); return POW;}
<normal,enclosed>"*" {printf("Lexer: MUL found \n"); return MUL;}
<normal,enclosed>"//" {printf("Lexer: FDIV found \n"); return FDIV;}
<normal,enclosed>"/" {printf("Lexer: DIV found \n"); return DIV;}
<normal,enclosed>"%" {printf("Lexer: MOD found \n"); return MOD;}
<normal,enclosed>"<<" {printf("Lexer: LSHIFT found \n"); return LSHIFT;}
<normal,enclosed>">>" {printf("Lexer: RSHIFT found \n"); return RSHIFT;}
<normal,enclosed>"&" {printf("Lexer: BITWISEAND found \n"); return BITWISEAND;}
<normal,enclosed>"|" {printf("Lexer: BITWISEOR found \n"); return BITWISEOR;}
<normal,enclosed>"^" {printf("Lexer: BITWISEXOR found \n"); return BITWISEXOR;}
<normal,enclosed>"~" {printf("Lexer: BITWISENOT found \n"); return BITWISENOT;}
<normal,enclosed>"<=" {printf("Lexer: LE found \n"); return LE;}
<normal,enclosed>">=" {printf("Lexer: GE found \n"); return GE;}
<normal,enclosed>"==" {printf("Lexer: EQ found \n"); return EQ;}
<normal,enclosed>"<" {printf("Lexer: LT found \n"); return LT;}
<normal,enclosed>">" {printf("Lexer: GT found \n"); return GT;}
<normal,enclosed>"!=" {printf("Lexer: NEQ found \n"); return NEQ;}
<normal,enclosed>"," {printf("Lexer: COMMA found \n"); return COMMA;}
<normal,enclosed>":" {printf("Lexer: COLON found \n"); return COLON;}
<normal,enclosed>"." {printf("Lexer: DOT found \n"); return DOT;}
<normal,enclosed>";" {printf("Lexer: SEMICOLON found \n"); return SEMICOLON;}
<normal,enclosed>"@" {printf("Lexer: AT found \n"); return AT;}
<normal,enclosed>"=" {printf("Lexer: ASSIGNMENT found \n"); return ASSIGNMENT;}
<normal,enclosed>"..." {printf("Lexer: ELLIPSIS found \n"); return ELLIPSIS;}


<normal,enclosed>{longstringliteral}                 {printf("Lexer: Longstrings not supported!\n"); exit(EXIT_FAILURE);}
<normal,enclosed>{shortstringliteral}                {printf("Lexer: STRING found %s.\n",yytext); return STRING;}
<normal,enclosed>{number}                            {printf("Lexer: NUMBER found %s.\n",yytext); return NUMBER;}
<normal,enclosed>{identifier}                        {printf("Lexer: NAME found %s.\n", yytext); return NAME;}



<*>(.|{eol})  { printf("Lexer: Unexpected character: %s\n", yytext);}

%%

