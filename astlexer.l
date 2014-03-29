%{

%}

%x pyast_string

intpart        [0-9]+
fraction       \.[0-9]+
exponent       [eE][+-]?[0-9]+
exponentfloat  ({intpart}|{pointfloat}){exponent}
pointfloat     {intpart}?{fraction}|{intpart}\.
floatnumber    ({pointfloat}|{exponentfloat})
imagnumber     ({floatnumber}|{intpart})[jJ]

object         ({intpart}|{floatnumber}|{imagnumber})


%%
"Add"		return Add;
"And"		return And;
"Assert"	return Assert;
"Assign"	return Assign;
"Attribute"	return Attribute;
"AugAssign"	return AugAssign;
"AugLoad"	return AugLoad;
"AugStore"	return AugStore;
"BinOp"		return BinOp;
"BitAnd"	return BitAnd;
"BitOr"		return BitOr;
"BitXor"	return BitXor;
"BoolOp"	return BoolOp;
"Break"		return Break;
"Bytes"		return Bytes;
"Call"		return Call;
"ClassDef"	return ClassDef;
"Compare"	return Compare;
"Continue"	return Continue;
"Del"		return Del;
"Delete"	return Delete;
"Dict"		return Dict;
"DictComp"	return DictComp;
"Div"		return Div;
"Ellipsis"	return Ellipsis;
"Eq"		return Eq;
"ExceptHandler"	return ExceptHandler;
"Expr"		return Expr;
"ExtSlice"	return ExtSlice;
"FloorDiv"	return FloorDiv;
"For"		return For;
"FunctionDef"	return FunctionDef;
"GeneratorExp"	return GeneratorExp;
"Global"	return Global;
"Gt"		return Gt;
"GtE"		return GtE;
"If"		return If;
"IfExp"		return IfExp;
"Import"	return Import;
"ImportFrom"	return ImportFrom;
"In"		return In;
"Index"		return Index;
"Invert"	return Invert;
"Is"		return Is;
"IsNot"		return IsNot;
"LShift"	return LShift;
"Lambda"	return Lambda;
"List"		return List;
"ListComp"	return ListComp;
"Load"		return Load;
"Lt"		return Lt;
"LtE"		return LtE;
"Mod"		return Mod;
"Module"	return Module;
"Mult"		return Mult;
"Name"		return Name;
"NameConstant"	return NameConstant;
"None"		return None;
"Nonlocal"	return Nonlocal;
"Not"		return Not;
"NotEq"		return NotEq;
"NotIn"		return NotIn;
"Num"		return Num;
"Or"		return Or;
"Param"		return Param;
"Pass"		return Pass;
"Pow"		return Pow;
"RShift"	return RShift;
"Raise"		return Raise;
"Return"	return Return;
"Set"		return Set;
"SetComp"	return SetComp;
"Slice"		return Slice;
"Starred"	return Starred;
"Store"		return Store;
"Str"		return Str;
"Sub"		return Sub;
"Subscript"	return Subscript;
"Try"		return Try;
"Tuple"		return Tuple;
"UAdd"		return UAdd;
"USub"		return USub;
"UnaryOp"	return UnaryOp;
"While"		return While;
"With"		return With;
"Yield"		return Yield;
"YieldFrom"	return YieldFrom;
"alias"		return alias_;
"arg"		return arg_;
"arguments"	return arguments_;
"comprehension"	return comprehension_;
"keyword"	return keyword_;
"withitem"	return withitem_;

"True"          return True;
"False"         return False;

"("             return LPAREN;
")"             return RPAREN;
"["             return LBRACE;
"]"             return RBRACE;
","             return COMMA;
"b"             return B;

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

