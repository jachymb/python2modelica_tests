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
"Add"           return ADD;
"And"           return AND;
"Assert"        return ASSERT;
"Assign"        return ASSIGN;
"Attribute"     return ATTRIBUTE;
"AugAssign"     return AUGASSIGN;
"AugLoad"       return AUGLOAD;
"AugStore"      return AUGSTORE;
"BinOp"         return BINOP;
"BitAnd"        return BITAND;
"BitOr"         return BITOR;
"BitXor"        return BITXOR;
"BoolOp"        return BOOLOP;
"Break"         return BREAK;
"Bytes"         return BYTES;
"Call"          return CALL;
"ClassDef"      return CLASSDEF;
"Compare"       return COMPARE;
"Continue"      return CONTINUE;
"Del"           return DEL;
"Delete"        return DELETE;
"Dict"          return DICT;
"DictComp"      return DICTCOMP;
"Div"           return DIV;
"Ellipsis"      return ELLIPSIS;
"Eq"            return EQ;
"ExceptHandler" return EXCEPTHANDLER;
"Expr"          return EXPR;
"ExtSlice"      return EXTSLICE;
"False"         return FALSE;
"FloorDiv"      return FLOORDIV;
"For"           return FOR;
"FunctionDef"   return FUNCTIONDEF;
"GeneratorExp"  return GENERATOREXP;
"Global"        return GLOBAL;
"Gt"            return GT;
"GtE"           return GTE;
"If"            return IF;
"IfExp"         return IFEXP;
"Import"        return IMPORT;
"ImportFrom"    return IMPORTFROM;
"In"            return IN;
"Index"         return INDEX;
"Invert"        return INVERT;
"Is"            return IS;
"IsNot"         return ISNOT;
"LShift"        return LSHIFT;
"Lambda"        return LAMBDA;
"List"          return LIST;
"ListComp"      return LISTCOMP;
"Load"          return LOAD;
"Lt"            return LT;
"LtE"           return LTE;
"Mod"           return MOD;
"Module"        return MODULE;
"Mult"          return MULT;
"Name"          return NAME;
"NameConstant"  return NAMECONSTANT;
"None"          return NONE;
"Nonlocal"      return NONLOCAL;
"Not"           return NOT;
"NotEq"         return NOTEQ;
"NotIn"         return NOTIN;
"Num"           return NUM;
"Or"            return OR;
"Param"         return PARAM;
"Pass"          return PASS;
"Pow"           return POW;
"RShift"        return RSHIFT;
"Raise"         return RAISE;
"Return"        return RETURN;
"Set"           return SET;
"SetComp"       return SETCOMP;
"Slice"         return SLICE;
"Starred"       return STARRED;
"Store"         return STORE;
"Str"           return STR;
"Sub"           return SUB;
"Subscript"     return SUBSCRIPT;
"True"          return TRUE;
"Try"           return TRY;
"Tuple"         return TUPLE;
"UAdd"          return UADD;
"USub"          return USUB;
"UnaryOp"       return UNARYOP;
"While"         return WHILE;
"With"          return WITH;
"Yield"         return YIELD;
"YieldFrom"     return YIELDFROM;
"alias"         return ALIAS;
"arg"           return ARG;
"arguments"     return ARGUMENTS;
"b"             return B;
"comprehension" return COMPREHENSION;
"keyword"       return KEYWORD;
"withitem"      return WITHITEM;

")"             return RPAREN;
"("             return LPAREN;
"["             return LBRACE;
"]"             return RBRACE;
","             return COMMA;


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

