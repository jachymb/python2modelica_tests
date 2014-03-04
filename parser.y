%{

//#include <cstdio>
#include <stdio.h>
// stuff from flex that bison needs to know about:
extern "C" int yylex();
extern "C" int yyparse();
extern "C" FILE *yyin;

void yyerror(const char *s);


%}


%token NEWLINE
%token ENDMARKER
%token INDENT
%token DEDENT

%start file_input

%% 

file_input: ENDMARKER

%%

main()
{
yyparse();
}
void yyerror(const char *s)
   {
	printf("\n : error:");
}
