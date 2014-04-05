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
"Add"           return ADD_OP;
"And"           return AND_OP;
"Assert"        return ASSERT;
"Assign"        return ASSIGN;
"Attribute"     return ATTRIBUTE;
"AugAssign"     return AUGASSIGN;
"AugLoad"       return AUGLOAD;
"AugStore"      return AUGSTORE;
"BinOp"         return BINOP;
"BitAnd"        return BITAND_OP;
"BitOr"         return BITOR_OP;
"BitXor"        return BITXOR_OP;
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
"Div"           return DIV_OP;
"Ellipsis"      return ELLIPSIS;
"Eq"            return EQ_OP;
"ExceptHandler" return EXCEPTHANDLER;
"Expr"          return EXPR;
"ExtSlice"      return EXTSLICE;
"False"         return FALSE;
"FloorDiv"      return FLOORDIV_OP;
"For"           return FOR;
"FunctionDef"   return FUNCTIONDEF;
"GeneratorExp"  return GENERATOREXP;
"Global"        return GLOBAL;
"Gt"            return GT_OP;
"GtE"           return GTE_OP;
"If"            return IF;
"IfExp"         return IFEXP;
"Import"        return IMPORT;
"ImportFrom"    return IMPORTFROM;
"In"            return IN_OP;
"Index"         return INDEX;
"Invert"        return INVERT_OP;
"Is"            return IS_OP;
"IsNot"         return ISNOT_OP;
"LShift"        return LSHIFT_OP;
"Lambda"        return LAMBDA;
"List"          return LIST;
"ListComp"      return LISTCOMP;
"Load"          return LOAD;
"Lt"            return LT_OP;
"LtE"           return LTE_OP;
"Mod"           return MOD_OP;
"Module"        return MODULE;
"Mult"          return MULT_OP;
"Name"          return NAME;
"NameConstant"  return NAMECONSTANT;
"None"          return NONE;
"Nonlocal"      return NONLOCAL;
"Not"           return NOT_OP;
"NotEq"         return NOTEQ_OP;
"NotIn"         return NOTIN_OP;
"Num"           return NUM;
"Or"            return OR_OP;
"Param"         return PARAM;
"Pass"          return PASS;
"Pow"           return POW_OP;
"RShift"        return RSHIFT_OP;
"Raise"         return RAISE;
"Return"        return RETURN;
"Set"           return SET;
"SetComp"       return SETCOMP;
"Slice"         return SLICE;
"Starred"       return STARRED;
"Store"         return STORE;
"Str"           return STR;
"Sub"           return SUB_OP;
"Subscript"     return SUBSCRIPT;
"True"          return TRUE;
"Try"           return TRY;
"Tuple"         return TUPLE;
"UAdd"          return UADD_OP;
"USub"          return USUB_OP;
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

"]"             return RBRACE;
"["             return LBRACE;
")"             return RPAREN;
"("             return LPAREN;
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

