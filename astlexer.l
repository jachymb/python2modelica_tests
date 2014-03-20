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
Add			{ cout << "Found token: Add" << endl; return Add; }
And			{ cout << "Found token: And" << endl; return And; }
Assert			{ cout << "Found token: Assert" << endl; return Assert; }
Assign			{ cout << "Found token: Assign" << endl; return Assign; }
Attribute		{ cout << "Found token: Attribute" << endl; return Attribute; }
AugAssign		{ cout << "Found token: AugAssign" << endl; return AugAssign; }
AugLoad			{ cout << "Found token: AugLoad" << endl; return AugLoad; }
AugStore		{ cout << "Found token: AugStore" << endl; return AugStore; }
BinOp			{ cout << "Found token: BinOp" << endl; return BinOp; }
BitAnd			{ cout << "Found token: BitAnd" << endl; return BitAnd; }
BitOr			{ cout << "Found token: BitOr" << endl; return BitOr; }
BitXor			{ cout << "Found token: BitXor" << endl; return BitXor; }
BoolOp			{ cout << "Found token: BoolOp" << endl; return BoolOp; }
Break			{ cout << "Found token: Break" << endl; return Break; }
Bytes			{ cout << "Found token: Bytes" << endl; return Bytes; }
Call			{ cout << "Found token: Call" << endl; return Call; }
ClassDef		{ cout << "Found token: ClassDef" << endl; return ClassDef; }
Compare			{ cout << "Found token: Compare" << endl; return Compare; }
Continue		{ cout << "Found token: Continue" << endl; return Continue; }
Del			{ cout << "Found token: Del" << endl; return Del; }
Delete			{ cout << "Found token: Delete" << endl; return Delete; }
Dict			{ cout << "Found token: Dict" << endl; return Dict; }
DictComp		{ cout << "Found token: DictComp" << endl; return DictComp; }
Div			{ cout << "Found token: Div" << endl; return Div; }
Ellipsis		{ cout << "Found token: Ellipsis" << endl; return Ellipsis; }
Eq			{ cout << "Found token: Eq" << endl; return Eq; }
ExceptHandler		{ cout << "Found token: ExceptHandler" << endl; return ExceptHandler; }
Expr			{ cout << "Found token: Expr" << endl; return Expr; }
Expression		{ cout << "Found token: Expression" << endl; return Expression; }
ExtSlice		{ cout << "Found token: ExtSlice" << endl; return ExtSlice; }
FloorDiv		{ cout << "Found token: FloorDiv" << endl; return FloorDiv; }
For			{ cout << "Found token: For" << endl; return For; }
FunctionDef		{ cout << "Found token: FunctionDef" << endl; return FunctionDef; }
GeneratorExp		{ cout << "Found token: GeneratorExp" << endl; return GeneratorExp; }
Global			{ cout << "Found token: Global" << endl; return Global; }
Gt			{ cout << "Found token: Gt" << endl; return Gt; }
GtE			{ cout << "Found token: GtE" << endl; return GtE; }
If			{ cout << "Found token: If" << endl; return If; }
IfExp			{ cout << "Found token: IfExp" << endl; return IfExp; }
Import			{ cout << "Found token: Import" << endl; return Import; }
ImportFrom		{ cout << "Found token: ImportFrom" << endl; return ImportFrom; }
In			{ cout << "Found token: In" << endl; return In; }
Index			{ cout << "Found token: Index" << endl; return Index; }
Interactive		{ cout << "Found token: Interactive" << endl; return Interactive; }
Invert			{ cout << "Found token: Invert" << endl; return Invert; }
Is			{ cout << "Found token: Is" << endl; return Is; }
IsNot			{ cout << "Found token: IsNot" << endl; return IsNot; }
LShift			{ cout << "Found token: LShift" << endl; return LShift; }
Lambda			{ cout << "Found token: Lambda" << endl; return Lambda; }
List			{ cout << "Found token: List" << endl; return List; }
ListComp		{ cout << "Found token: ListComp" << endl; return ListComp; }
Load			{ cout << "Found token: Load" << endl; return Load; }
Lt			{ cout << "Found token: Lt" << endl; return Lt; }
LtE			{ cout << "Found token: LtE" << endl; return LtE; }
Mod			{ cout << "Found token: Mod" << endl; return Mod; }
Module			{ cout << "Found token: Module" << endl; return Module; }
Mult			{ cout << "Found token: Mult" << endl; return Mult; }
Name			{ cout << "Found token: Name" << endl; return Name; }
NameConstant		{ cout << "Found token: NameConstant" << endl; return NameConstant; }
None			{ cout << "Found token: None" << endl; return None; }
Nonlocal		{ cout << "Found token: Nonlocal" << endl; return Nonlocal; }
Not			{ cout << "Found token: Not" << endl; return Not; }
NotEq			{ cout << "Found token: NotEq" << endl; return NotEq; }
NotIn			{ cout << "Found token: NotIn" << endl; return NotIn; }
Num			{ cout << "Found token: Num" << endl; return Num; }
Or			{ cout << "Found token: Or" << endl; return Or; }
Param			{ cout << "Found token: Param" << endl; return Param; }
Pass			{ cout << "Found token: Pass" << endl; return Pass; }
Pow			{ cout << "Found token: Pow" << endl; return Pow; }
RShift			{ cout << "Found token: RShift" << endl; return RShift; }
Raise			{ cout << "Found token: Raise" << endl; return Raise; }
Return			{ cout << "Found token: Return" << endl; return Return; }
Set			{ cout << "Found token: Set" << endl; return Set; }
SetComp			{ cout << "Found token: SetComp" << endl; return SetComp; }
Slice			{ cout << "Found token: Slice" << endl; return Slice; }
Starred			{ cout << "Found token: Starred" << endl; return Starred; }
Store			{ cout << "Found token: Store" << endl; return Store; }
Str			{ cout << "Found token: Str" << endl; return Str; }
Sub			{ cout << "Found token: Sub" << endl; return Sub; }
Subscript		{ cout << "Found token: Subscript" << endl; return Subscript; }
Suite			{ cout << "Found token: Suite" << endl; return Suite; }
Try			{ cout << "Found token: Try" << endl; return Try; }
Tuple			{ cout << "Found token: Tuple" << endl; return Tuple; }
UAdd			{ cout << "Found token: UAdd" << endl; return UAdd; }
USub			{ cout << "Found token: USub" << endl; return USub; }
UnaryOp			{ cout << "Found token: UnaryOp" << endl; return UnaryOp; }
While			{ cout << "Found token: While" << endl; return While; }
With			{ cout << "Found token: With" << endl; return With; }
Yield			{ cout << "Found token: Yield" << endl; return Yield; }
YieldFrom		{ cout << "Found token: YieldFrom" << endl; return YieldFrom; }
alias			{ cout << "Found token: alias_" << endl; return alias_; /* Underscore */ }
annotation		{ cout << "Found token: annotation" << endl; return annotation; }
arg			{ cout << "Found token: arg_" << endl; return arg_; /* Underscore */ }
args			{ cout << "Found token: args" << endl; return args; }
arguments		{ cout << "Found token: arguments_" << endl; return arguments_; /* Underscore! */ }
asname			{ cout << "Found token: asname" << endl; return asname; }
attr			{ cout << "Found token: attr" << endl; return attr; }
bases			{ cout << "Found token: bases" << endl; return bases; }
body			{ cout << "Found token: body" << endl; return body; }
cause			{ cout << "Found token: cause" << endl; return cause; }
comparators		{ cout << "Found token: comparators" << endl; return comparators; }
comprehension		{ cout << "Found token: comprehension_" << endl; return comprehension_; /* Underscore! */ }
context_expr		{ cout << "Found token: context_expr" << endl; return context_expr; }
ctx			{ cout << "Found token: ctx" << endl; return ctx; }
decorator		{ cout << "Found token: decorator" << endl; return decorator; }
decorator_list		{ cout << "Found token: decorator_list" << endl; return decorator_list; }
defaults		{ cout << "Found token: defaults" << endl; return defaults; }
dims			{ cout << "Found token: dims" << endl; return dims; }
elt			{ cout << "Found token: elt" << endl; return elt; }
elts			{ cout << "Found token: elts" << endl; return elts; }
exc			{ cout << "Found token: exc" << endl; return exc; }
finalbody		{ cout << "Found token: finalbody" << endl; return finalbody; }
func			{ cout << "Found token: func" << endl; return func; }
generators		{ cout << "Found token: generators" << endl; return generators; }
handlers		{ cout << "Found token: handlers" << endl; return handlers; }
id			{ cout << "Found token: id" << endl; return id; }
ifs			{ cout << "Found token: ifs" << endl; return ifs; }
items			{ cout << "Found token: items" << endl; return items; }
iter			{ cout << "Found token: iter" << endl; return iter; }
key			{ cout << "Found token: key" << endl; return key; }
keys			{ cout << "Found token: keys" << endl; return keys; }
keyword			{ cout << "Found token: keyword_" << endl; return keyword_;  /* Underscore! */ }
keywords		{ cout << "Found token: keywords" << endl; return keywords; }
kw_defaults		{ cout << "Found token: kw_defaults" << endl; return kw_defaults; }
kwarg			{ cout << "Found token: kwarg" << endl; return kwarg; }
kwargs			{ cout << "Found token: kwargs" << endl; return kwargs; }
kwonlyargs		{ cout << "Found token: kwonlyargs" << endl; return kwonlyargs; }
left			{ cout << "Found token: left" << endl; return left; }
level			{ cout << "Found token: level" << endl; return level; }
lower			{ cout << "Found token: lower" << endl; return lower; }
module			{ cout << "Found token: module" << endl; return module; }
msg			{ cout << "Found token: msg" << endl; return msg; }
n			{ cout << "Found token: n" << endl; return n; }
name			{ cout << "Found token: name" << endl; return name; }
names			{ cout << "Found token: names" << endl; return names; }
op			{ cout << "Found token: op" << endl; return op; }
operand			{ cout << "Found token: operand" << endl; return operand; }
ops			{ cout << "Found token: ops" << endl; return ops; }
optional_vars		{ cout << "Found token: optional_vars" << endl; return optional_vars; }
orelse			{ cout << "Found token: orelse" << endl; return orelse; }
returns			{ cout << "Found token: returns" << endl; return returns; }
right			{ cout << "Found token: right" << endl; return right; }
s			{ cout << "Found token: s" << endl; return s; }
slice			{ cout << "Found token: slice_" << endl; return slice_; /* Underscore! */ }
starargs		{ cout << "Found token: starargs" << endl; return starargs; }
step			{ cout << "Found token: step" << endl; return step; }
target			{ cout << "Found token: target" << endl; return target; }
targets			{ cout << "Found token: targets" << endl; return targets; }
test			{ cout << "Found token: test" << endl; return test; }
type			{ cout << "Found token: type" << endl; return type; }
upper			{ cout << "Found token: upper" << endl; return upper; }
value			{ cout << "Found token: value" << endl; return value; }
values			{ cout << "Found token: values" << endl; return values; }
vararg			{ cout << "Found token: vararg" << endl; return vararg; }
withitem		{ cout << "Found token: withitem_" << endl; return withitem_; /* Underscore! */ }

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
