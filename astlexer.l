%{
#include <iostream>
#include "astparser.tab.h"
using std::cout;
using std::cerr;
using std::endl;
extern YYSTYPE yylval;
#define YY_DECL extern "C" int yylex()


%}

intpart        [0-9]+
fraction       \.[0-9]+
exponent       [eE][+-]?[0-9]+
exponentfloat  ({intpart}|{pointfloat}){exponent}
pointfloat     {intpart}?{fraction}|{intpart}\.
floatnumber    ({pointfloat}|{exponentfloat})
imagnumber     ({floatnumber}|{intpart})[jJ]

object         ({intpart}|{floatnumber}|{imagnumber})
%%
Add		{ cout << "Found token: Add" << endl; return Add; }
And		{ cout << "Found token: And" << endl; return And; }
Assert		{ cout << "Found token: Assert" << endl; return Assert; }
Assign		{ cout << "Found token: Assign" << endl; return Assign; }
Attribute	{ cout << "Found token: Attribute" << endl; return Attribute; }
AugAssign	{ cout << "Found token: AugAssign" << endl; return AugAssign; }
AugLoad		{ cout << "Found token: AugLoad" << endl; return AugLoad; }
AugStore	{ cout << "Found token: AugStore" << endl; return AugStore; }
BinOp		{ cout << "Found token: BinOp" << endl; return BinOp; }
BitAnd		{ cout << "Found token: BitAnd" << endl; return BitAnd; }
BitOr		{ cout << "Found token: BitOr" << endl; return BitOr; }
BitXor		{ cout << "Found token: BitXor" << endl; return BitXor; }
BoolOp		{ cout << "Found token: BoolOp" << endl; return BoolOp; }
Break		{ cout << "Found token: Break" << endl; return Break; }
Bytes		{ cout << "Found token: Bytes" << endl; return Bytes; }
Call		{ cout << "Found token: Call" << endl; return Call; }
ClassDef	{ cout << "Found token: ClassDef" << endl; return ClassDef; }
Compare		{ cout << "Found token: Compare" << endl; return Compare; }
Continue	{ cout << "Found token: Continue" << endl; return Continue; }
Del		{ cout << "Found token: Del" << endl; return Del; }
Delete		{ cout << "Found token: Delete" << endl; return Delete; }
Dict		{ cout << "Found token: Dict" << endl; return Dict; }
DictComp	{ cout << "Found token: DictComp" << endl; return DictComp; }
Div		{ cout << "Found token: Div" << endl; return Div; }
Ellipsis	{ cout << "Found token: Ellipsis" << endl; return Ellipsis; }
Eq		{ cout << "Found token: Eq" << endl; return Eq; }
ExceptHandler	{ cout << "Found token: ExceptHandler" << endl; return ExceptHandler; }
Expr		{ cout << "Found token: Expr" << endl; return Expr; }
ExtSlice	{ cout << "Found token: ExtSlice" << endl; return ExtSlice; }
FloorDiv	{ cout << "Found token: FloorDiv" << endl; return FloorDiv; }
For		{ cout << "Found token: For" << endl; return For; }
FunctionDef	{ cout << "Found token: FunctionDef" << endl; return FunctionDef; }
GeneratorExp	{ cout << "Found token: GeneratorExp" << endl; return GeneratorExp; }
Global		{ cout << "Found token: Global" << endl; return Global; }
Gt		{ cout << "Found token: Gt" << endl; return Gt; }
GtE		{ cout << "Found token: GtE" << endl; return GtE; }
If		{ cout << "Found token: If" << endl; return If; }
IfExp		{ cout << "Found token: IfExp" << endl; return IfExp; }
Import		{ cout << "Found token: Import" << endl; return Import; }
ImportFrom	{ cout << "Found token: ImportFrom" << endl; return ImportFrom; }
In		{ cout << "Found token: In" << endl; return In; }
Index		{ cout << "Found token: Index" << endl; return Index; }
Invert		{ cout << "Found token: Invert" << endl; return Invert; }
Is		{ cout << "Found token: Is" << endl; return Is; }
IsNot		{ cout << "Found token: IsNot" << endl; return IsNot; }
LShift		{ cout << "Found token: LShift" << endl; return LShift; }
Lambda		{ cout << "Found token: Lambda" << endl; return Lambda; }
List		{ cout << "Found token: List" << endl; return List; }
ListComp	{ cout << "Found token: ListComp" << endl; return ListComp; }
Load		{ cout << "Found token: Load" << endl; return Load; }
Lt		{ cout << "Found token: Lt" << endl; return Lt; }
LtE		{ cout << "Found token: LtE" << endl; return LtE; }
Mod		{ cout << "Found token: Mod" << endl; return Mod; }
Module		{ cout << "Found token: Module" << endl; return Module; }
Mult		{ cout << "Found token: Mult" << endl; return Mult; }
Name		{ cout << "Found token: Name" << endl; return Name; }
NameConstant	{ cout << "Found token: NameConstant" << endl; return NameConstant; }
None		{ cout << "Found token: None" << endl; return None; }
Nonlocal	{ cout << "Found token: Nonlocal" << endl; return Nonlocal; }
Not		{ cout << "Found token: Not" << endl; return Not; }
NotEq		{ cout << "Found token: NotEq" << endl; return NotEq; }
NotIn		{ cout << "Found token: NotIn" << endl; return NotIn; }
Num		{ cout << "Found token: Num" << endl; return Num; }
Or		{ cout << "Found token: Or" << endl; return Or; }
Param		{ cout << "Found token: Param" << endl; return Param; }
Pass		{ cout << "Found token: Pass" << endl; return Pass; }
Pow		{ cout << "Found token: Pow" << endl; return Pow; }
RShift		{ cout << "Found token: RShift" << endl; return RShift; }
Raise		{ cout << "Found token: Raise" << endl; return Raise; }
Return		{ cout << "Found token: Return" << endl; return Return; }
Set		{ cout << "Found token: Set" << endl; return Set; }
SetComp		{ cout << "Found token: SetComp" << endl; return SetComp; }
Slice		{ cout << "Found token: Slice" << endl; return Slice; }
Starred		{ cout << "Found token: Starred" << endl; return Starred; }
Store		{ cout << "Found token: Store" << endl; return Store; }
Str		{ cout << "Found token: Str" << endl; return Str; }
Sub		{ cout << "Found token: Sub" << endl; return Sub; }
Subscript	{ cout << "Found token: Subscript" << endl; return Subscript; }
Try		{ cout << "Found token: Try" << endl; return Try; }
Tuple		{ cout << "Found token: Tuple" << endl; return Tuple; }
UAdd		{ cout << "Found token: UAdd" << endl; return UAdd; }
USub		{ cout << "Found token: USub" << endl; return USub; }
UnaryOp		{ cout << "Found token: UnaryOp" << endl; return UnaryOp; }
While		{ cout << "Found token: While" << endl; return While; }
With		{ cout << "Found token: With" << endl; return With; }
Yield		{ cout << "Found token: Yield" << endl; return Yield; }
YieldFrom	{ cout << "Found token: YieldFrom" << endl; return YieldFrom; }
alias		{ cout << "Found token: alias_" << endl; return alias_; /* Underscore! */ }
arg		{ cout << "Found token: arg_" << endl; return arg_; /* Underscore! */ }
arguments	{ cout << "Found token: arguments_" << endl; return arguments_; /* Underscore! */ }
comprehension	{ cout << "Found token: comprehension_" << endl; return comprehension_; /* Underscore! */ }
keyword		{ cout << "Found token: keyword_" << endl; return keyword_; /* Underscore! */ }
withitem	{ cout << "Found token: withitem_" << endl; return withitem_; /* Underscore! */ }

\'(\\.|[^'])*\'         { cout << "Found token: string " << yytext << endl;
                         // yylval.sval = yytext; // Is it enough? Shoudln't we copy it instead?
                          return string; }



"("                     { cout << "Found token: (" << endl; return '('; }
")"                     { cout << "Found token: )" << endl; return ')'; }
"["                     { cout << "Found token: [" << endl; return '['; }
"]"                     { cout << "Found token: ]" << endl; return ']'; }
","                     { cout << "Found token: ," << endl; return ','; }
"="                     { cout << "Found token: =" << endl; return '='; }
"b"                     { cout << "Found token: b" << endl; return 'b'; }

{object}                { cout << "Found token: object " << yytext << endl;
                         // yylval.sval = yytext; // Is it enough? Shoudln't we copy it instead?
                         return object;
                        }

[ \n\t\r\f]+            { }

.                       { cerr << "Unknown character: " << yytext << endl; yyterminate(); }
<<EOF>>                 yyterminate();


%%

/*
int main() {
while (yylex());
}
*/
