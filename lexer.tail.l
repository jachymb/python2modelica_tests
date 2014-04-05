
[ \n\t\r\f]+  ;

{object}        return OBJECT;

%"\'(\\.|[^'])*\'" return STRING;

"'"	     {
		BEGIN(pyast_string) keepBuffer;
             }

<pyast_string>
{
    "\\"+"'"  { keepBuffer; }
    "\\"+"\\" { keepBuffer; }
    "'"       { BEGIN(INITIAL) return STRING; }
    [^\n]     { keepBuffer; }
    \n        { keepBuffer; }
}

%%

