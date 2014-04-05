
[ \n\t\r\f]+  ;

{object}        return object;

%"\'(\\.|[^'])*\'" return string;

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

