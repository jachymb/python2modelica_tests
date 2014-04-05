
/* "From here down, only Absyn helper functions should be present.
 Thus, no actual absyn uniontype definitions." */

protected import List;
protected import Util;
protected import Error;

public constant TimeStamp dummyTimeStamp = TIMESTAMP(0.0,0.0);

public constant ClassDef dummyParts = PARTS({},{},{},{},NONE());
public constant Info dummyInfo = INFO("",false,0,0,0,0,dummyTimeStamp);
public constant TimeStamp newTimeStamp = TIMESTAMP(0.0,1.0);
public constant Program dummyProgram = PROGRAM({},TOP(),dummyTimeStamp);

public function getNewTimeStamp
"generate a new timestamp with edittime>buildtime."
output TimeStamp ts;
algorithm
  ts := newTimeStamp;
annotation(__OpenModelica_EarlyInline = true);
end getNewTimeStamp;

public function setTimeStampBool ""
  input TimeStamp its;
  input Boolean which "true for edit time, false for build time";
  output TimeStamp ots;
algorithm ots := match(its,which)
  local Real timer; TimeStamp ts;
  case(_,true)
    equation
      timer = System.getCurrentTime();
      ts = setTimeStampEdit(its,timer);
    then
      ts;
  case(_,false)
    equation
      timer = System.getCurrentTime();
      ts = setTimeStampBuild(its,timer);
    then
      ts;
end match;
end setTimeStampBool;

// stefan
public function traverseEquation
"Traverses all subequations of an equation
  takes a function and an extra argument passed through the traversal"
  input Equation inEquation;
  input FuncTplToTpl inFunc;
  input TypeA inTypeA;
  output tuple<Equation, TypeA> outTpl;
  partial function FuncTplToTpl
    input tuple<Equation, TypeA> inTpl;
    output tuple<Equation, TypeA> outTpl;
    replaceable type TypeA subtypeof Any;
  end FuncTplToTpl;
  replaceable type TypeA subtypeof Any;
algorithm
  outTpl := matchcontinue (inEquation,inFunc,inTypeA)
    local
      TypeA arg,arg_1,arg_2,arg_3,arg_4;
      Equation eq,eq_1;
      FuncTplToTpl rel;
      Exp e,e_1;
      list<EquationItem> eqilst,eqilst1,eqilst2,eqilst_1,eqilst1_1,eqilst2_1;
      list<tuple<Exp, list<EquationItem>>> eeqitlst,eeqitlst_1;
      ForIterators fis,fis_1;
      EquationItem ei,ei_1;
    case(eq as EQ_IF(e,eqilst1,eeqitlst,eqilst2),rel,arg)
      equation
        ((eqilst1_1,arg_1)) = traverseEquationItemList(eqilst1,rel,arg);
        ((eeqitlst_1,arg_2)) = traverseExpEqItemTupleList(eeqitlst,rel,arg_1);
        ((eqilst2_1,arg_3)) = traverseEquationItemList(eqilst2,rel,arg_2);
        ((EQ_IF(e_1,_,_,_),arg_4)) = rel((eq,arg_3));
      then
        ((EQ_IF(e,eqilst1_1,eeqitlst_1,eqilst2_1),arg_4));
    case(eq as EQ_FOR(fis,eqilst),rel,arg)
      equation
        ((eqilst_1,arg_1)) = traverseEquationItemList(eqilst,rel,arg);
        ((EQ_FOR(fis_1,_),arg_2)) = rel((eq,arg_1));
      then
        ((EQ_FOR(fis_1,eqilst_1),arg_2));
    case(eq as EQ_WHEN_E(e,eqilst,eeqitlst),rel,arg)
      equation
        ((eqilst_1,arg_1)) = traverseEquationItemList(eqilst,rel,arg);
        ((eeqitlst_1,arg_2)) = traverseExpEqItemTupleList(eeqitlst,rel,arg_1);
        ((EQ_WHEN_E(e_1,_,_),arg_3)) = rel((eq,arg_2));
      then
        ((EQ_WHEN_E(e_1,eqilst_1,eeqitlst_1),arg_3));
    case(eq as EQ_FAILURE(ei),rel,arg)
      equation
        ((ei_1,arg_1)) = traverseEquationItem(ei,rel,arg);
        ((EQ_FAILURE(_),arg_2)) = rel((eq,arg_1));
      then
        ((EQ_FAILURE(ei_1),arg_2));
    case(eq,rel,arg)
      equation
        ((eq_1,arg_1)) = rel((eq,arg));
      then
        ((eq_1,arg_1));
  end matchcontinue;
end traverseEquation;

// stefan
protected function traverseEquationItem
"Traverses the equation inside an equationitem"
  input EquationItem inEquationItem;
  input FuncTplToTpl inFunc;
  input TypeA inTypeA;
  output tuple<EquationItem, TypeA> outTpl;
  partial function FuncTplToTpl
    input tuple<Equation, TypeA> inTpl;
    output tuple<Equation, TypeA> outTpl;
    replaceable type TypeA subtypeof Any;
  end FuncTplToTpl;
  replaceable type TypeA subtypeof Any;
algorithm
  outTpl := matchcontinue (inEquationItem,inFunc,inTypeA)
    local
      EquationItem ei;
      FuncTplToTpl rel;
      TypeA arg,arg_1;
      Equation eq,eq_1;
      Option<Comment> oc;
      Info info;
    case(EQUATIONITEM(eq,oc,info),rel,arg)
      equation
        ((eq_1,arg_1)) = traverseEquation(eq,rel,arg);
      then
        ((EQUATIONITEM(eq_1,oc,info),arg_1));
    case(ei,rel,arg) then ((ei,arg));
  end matchcontinue;
end traverseEquationItem;

// stefan
public function traverseEquationItemList
"calls traverseEquationItem on every element of the given list"
  input list<EquationItem> inEquationItemList;
  input FuncTplToTpl inFunc;
  input TypeA inTypeA;
  output tuple<list<EquationItem>, TypeA> outTpl;
  partial function FuncTplToTpl
    input tuple<Equation, TypeA> inTpl;
    output tuple<Equation, TypeA> outTpl;
    replaceable type TypeA subtypeof Any;
  end FuncTplToTpl;
  replaceable type TypeA subtypeof Any;
algorithm
  outTpl := matchcontinue (inEquationItemList,inFunc,inTypeA)
    local
      list<EquationItem> cdr,cdr_1;
      FuncTplToTpl rel;
      TypeA arg,arg_1,arg_2;
      EquationItem ei,ei_1;
    case({},_,arg) then (({},arg));
    case(ei :: cdr,rel,arg)
      equation
        ((ei_1,arg_1)) = traverseEquationItem(ei,rel,arg);
        ((cdr_1,arg_2)) = traverseEquationItemList(cdr,rel,arg_1);
      then
        ((ei_1 :: cdr_1,arg_2));
  end matchcontinue;
end traverseEquationItemList;

// stefan
public function traverseExpEqItemTupleList
"traverses a list of Exp * EquationItem list tuples
  mostly used for else-if blocks"
  input list<tuple<Exp, list<EquationItem>>> inList;
  input FuncTplToTpl inFunc;
  input TypeA inTypeA;
  output tuple<list<tuple<Exp, list<EquationItem>>>, TypeA> outTpl;
  partial function FuncTplToTpl
    input tuple<Equation, TypeA> inTpl;
    output tuple<Equation, TypeA> outTpl;
    replaceable type TypeA subtypeof Any;
  end FuncTplToTpl;
  replaceable type TypeA subtypeof Any;
algorithm
  outTpl := matchcontinue (inList,inFunc,inTypeA)
    local
      FuncTplToTpl rel;
      TypeA arg,arg_1,arg_2;
      list<tuple<Exp, list<EquationItem>>> cdr,cdr_1;
      Exp e;
      list<EquationItem> eilst,eilst_1;
    case({},rel,arg) then (({},arg));
    case((e,eilst) :: cdr,rel,arg)
      equation
        ((eilst_1,arg_1)) = traverseEquationItemList(eilst,rel,arg);
        ((cdr_1,arg_2)) = traverseExpEqItemTupleList(cdr,rel,arg_1);
      then
        (((e,eilst_1) :: cdr_1,arg_2));
  end matchcontinue;
end traverseExpEqItemTupleList;

// stefan
public function traverseAlgorithm
"Traverses all subalgorithms of an algorithm
  Takes a function and an extra argument passed through the traversal"
  input Algorithm inAlgorithm;
  input FuncTplToTpl inFunc;
  input TypeA inTypeA;
  output tuple<Algorithm, TypeA> outTpl;
  partial function FuncTplToTpl
    input tuple<Algorithm, TypeA> inTpl;
    output tuple<Algorithm, TypeA> outTpl;
    replaceable type TypeA subtypeof Any;
  end FuncTplToTpl;
  replaceable type TypeA subtypeof Any;
algorithm
  outTpl := matchcontinue (inAlgorithm,inFunc,inTypeA)
    local
      TypeA arg,arg_1,arg1_1,arg2_1,arg3_1;
      Algorithm alg,alg_1,alg1_1,alg2_1,alg3_1;
      list<AlgorithmItem> ailst,ailst1,ailst2,ailst_1,ailst1_1,ailst2_1;
      list<tuple<Exp, list<AlgorithmItem>>> eaitlst,eaitlst_1;
      FuncTplToTpl rel;
      AlgorithmItem ai,ai_1;
      Exp e,e_1;
      ForIterators fis,fis_1;
    case(alg as ALG_IF(e,ailst1,eaitlst,ailst2),rel,arg)
      equation
        ((ailst1_1,arg1_1)) = traverseAlgorithmItemList(ailst1,rel,arg);
        ((eaitlst_1,arg2_1)) = traverseExpAlgItemTupleList(eaitlst,rel,arg1_1);
        ((ailst2_1,arg3_1)) = traverseAlgorithmItemList(ailst2,rel,arg2_1);
        ((ALG_IF(e_1,_,_,_),arg_1)) = rel((alg,arg3_1));
      then
        ((ALG_IF(e_1,ailst1_1,eaitlst_1,ailst2_1),arg_1));
    case(alg as ALG_FOR(fis,ailst),rel,arg)
      equation
        ((ailst_1,arg1_1)) = traverseAlgorithmItemList(ailst,rel,arg);
        ((ALG_FOR(fis_1,_),arg_1)) = rel((alg,arg1_1));
      then
        ((ALG_FOR(fis_1,ailst_1),arg_1));
    case(alg as ALG_PARFOR(fis,ailst),rel,arg)
      equation
        ((ailst_1,arg1_1)) = traverseAlgorithmItemList(ailst,rel,arg);
        ((ALG_PARFOR(fis_1,_),arg_1)) = rel((alg,arg1_1));
      then
        ((ALG_PARFOR(fis_1,ailst_1),arg_1));
    case(alg as ALG_WHILE(e,ailst),rel,arg)
      equation
        ((ailst_1,arg1_1)) = traverseAlgorithmItemList(ailst,rel,arg);
        ((ALG_WHILE(e_1,_),arg_1)) = rel((alg,arg1_1));
      then
        ((ALG_WHILE(e_1,ailst_1),arg_1));
    case(alg as ALG_WHEN_A(e,ailst,eaitlst),rel,arg)
      equation
        ((ailst_1,arg1_1)) = traverseAlgorithmItemList(ailst,rel,arg);
        ((eaitlst_1,arg2_1)) = traverseExpAlgItemTupleList(eaitlst,rel,arg1_1);
        ((ALG_WHEN_A(e_1,_,_),arg_1)) = rel((alg,arg2_1));
      then
        ((ALG_WHEN_A(e_1,ailst_1,eaitlst_1),arg_1));
    case(alg as ALG_TRY(ailst),rel,arg)
      equation
        ((ailst_1,arg1_1)) = traverseAlgorithmItemList(ailst,rel,arg);
        ((ALG_TRY(_),arg_1)) = rel((alg,arg1_1));
      then
        ((ALG_TRY(ailst_1),arg_1));
    case(alg as ALG_CATCH(ailst),rel,arg)
      equation
        ((ailst_1,arg1_1)) = traverseAlgorithmItemList(ailst,rel,arg);
        ((ALG_CATCH(_),arg_1)) = rel((alg,arg1_1));
      then
        ((ALG_CATCH(ailst_1),arg_1));
    case(alg,rel,arg)
      equation
        ((alg_1,arg_1)) = rel((alg,arg));
      then
        ((alg_1,arg_1));
  end matchcontinue;
end traverseAlgorithm;

// stefan
public function traverseAlgorithmItem
"traverses the Algorithm contained in an AlgorithmItem, if any
  see traverseAlgorithm"
  input AlgorithmItem inAlgorithmItem;
  input FuncTplToTpl inFunc;
  input TypeA inTypeA;
  output tuple<AlgorithmItem, TypeA> outTpl;
  partial function FuncTplToTpl
    input tuple<Algorithm, TypeA> inTpl;
    output tuple<Algorithm, TypeA> outTpl;
    replaceable type TypeA subtypeof Any;
  end FuncTplToTpl;
  replaceable type TypeA subtypeof Any;
algorithm
  outTpl := matchcontinue (inAlgorithmItem,inFunc,inTypeA)
    local
      FuncTplToTpl rel;
      TypeA arg,arg_1;
      Algorithm alg,alg_1;
      Option<Comment> oc;
      AlgorithmItem ai;
      Info info;
    case(ALGORITHMITEM(alg,oc,info),rel,arg)
      equation
        ((alg_1,arg_1)) = traverseAlgorithm(alg,rel,arg);
      then
        ((ALGORITHMITEM(alg_1,oc,info),arg_1));
    case(ai,_,arg) then ((ai,arg));
  end matchcontinue;
end traverseAlgorithmItem;

// stefan
public function traverseAlgorithmItemList
"calls traverseAlgorithmItem on each item in a list of AlgorithmItems"
  input list<AlgorithmItem> inAlgorithmItemList;
  input FuncTplToTpl inFunc;
  input TypeA inTypeA;
  output tuple<list<AlgorithmItem>, TypeA> outTpl;
  partial function FuncTplToTpl
    input tuple<Algorithm, TypeA> inTpl;
    output tuple<Algorithm, TypeA> outTpl;
    replaceable type TypeA subtypeof Any;
  end FuncTplToTpl;
  replaceable type TypeA subtypeof Any;
algorithm
  outTpl := matchcontinue (inAlgorithmItemList,inFunc,inTypeA)
    local
      FuncTplToTpl rel;
      TypeA arg,arg_1,arg_2;
      AlgorithmItem ai,ai_1;
      list<AlgorithmItem> cdr,cdr_1;
    case({},_,arg) then (({},arg));
    case(ai :: cdr,rel,arg)
      equation
        ((ai_1,arg_1)) = traverseAlgorithmItem(ai,rel,arg);
        ((cdr_1,arg_2)) = traverseAlgorithmItemList(cdr,rel,arg_1);
      then
        ((ai_1 :: cdr_1,arg_2));
  end matchcontinue;
end traverseAlgorithmItemList;

// stefan
public function traverseExpAlgItemTupleList
"traverses a list of Exp * AlgorithmItem list tuples
  mostly used for else-if blocks"
  input list<tuple<Exp, list<AlgorithmItem>>> inList;
  input FuncTplToTpl inFunc;
  input TypeA inTypeA;
  output tuple<list<tuple<Exp, list<AlgorithmItem>>>, TypeA> outTpl;
  partial function FuncTplToTpl
    input tuple<Algorithm, TypeA> inTpl;
    output tuple<Algorithm, TypeA> outTpl;
    replaceable type TypeA subtypeof Any;
  end FuncTplToTpl;
  replaceable type TypeA subtypeof Any;
algorithm
  outTpl := matchcontinue (inList,inFunc,inTypeA)
    local
      FuncTplToTpl rel;
      TypeA arg,arg_1,arg_2;
      list<tuple<Exp, list<AlgorithmItem>>> cdr,cdr_1;
      Exp e;
      list<AlgorithmItem> ailst,ailst_1;
    case({},rel,arg) then (({},arg));
    case((e,ailst) :: cdr,rel,arg)
      equation
        ((ailst_1,arg_1)) = traverseAlgorithmItemList(ailst,rel,arg);
        ((cdr_1,arg_2)) = traverseExpAlgItemTupleList(cdr,rel,arg_1);
      then
        (((e,ailst_1) :: cdr_1,arg_2));
  end matchcontinue;
end traverseExpAlgItemTupleList;

public function traverseExp
" Traverses all subexpressions of an Exp expression.
  Takes a function and an extra argument passed through the traversal.
  NOTE:This function was copied from Expression.traverseExpression."
  input Exp inExp;
  input FuncTypeTplExpType_aToTplExpType_a inFuncTypeTplExpTypeAToTplExpTypeA;
  input Type_a inTypeA;
  output tuple<Exp, Type_a> outTplExpTypeA;
  partial function FuncTypeTplExpType_aToTplExpType_a
    input tuple<Exp, Type_a> inTplExpTypeA;
    output tuple<Exp, Type_a> outTplExpTypeA;
    replaceable type Type_a subtypeof Any;
  end FuncTypeTplExpType_aToTplExpType_a;
  replaceable type Type_a subtypeof Any;
algorithm
  outTplExpTypeA:=
  matchcontinue (inExp,inFuncTypeTplExpTypeAToTplExpTypeA,inTypeA)
    local
      Exp e1_1,e,e1,e2_1,e2,e3_1,e_1,e3;
      Type_a ext_arg_1,ext_arg_2,ext_arg,ext_arg_3,ext_arg_4;
      Operator op_1,op;
      FuncTypeTplExpType_aToTplExpType_a rel;
      list<Exp> expl_1,expl;
      list<tuple<Exp,Exp>> elseIfBranch,elseIfBranch1;
      FunctionArgs fargs,fargs1,fargs2;
      ComponentRef cfn,cfn_1; Exp e_temp;
      list<list<Exp>> mexpl,mexpl1;
    case ((e as UNARY(op,e1)),rel,ext_arg) /* unary */
      equation
        ((e1_1,ext_arg_1)) = traverseExp(e1, rel, ext_arg);
        ((UNARY(op_1,_),ext_arg_2)) = rel((e,ext_arg_1));
      then
        ((UNARY(op_1,e1_1),ext_arg_2));
    case ((e as BINARY(e1,op,e2)),rel,ext_arg) /* binary */
      equation
        ((e1_1,ext_arg_1)) = traverseExp(e1, rel, ext_arg);
        ((e2_1,ext_arg_2)) = traverseExp(e2, rel, ext_arg_1);
        ((BINARY(_,op_1,_),ext_arg_3)) = rel((e,ext_arg_2));
      then
        ((BINARY(e1_1,op_1,e2_1),ext_arg_3));
    case ((e as LUNARY(op,e1)),rel,ext_arg) /* logic unary */
      equation
        ((e1_1,ext_arg_1)) = traverseExp(e1, rel, ext_arg);
        ((LUNARY(op_1,_),ext_arg_2)) = rel((e,ext_arg_1));
      then
        ((LUNARY(op_1,e1_1),ext_arg_2));
    case ((e as LBINARY(e1,op,e2)),rel,ext_arg) /* logic binary */
      equation
        ((e1_1,ext_arg_1)) = traverseExp(e1, rel, ext_arg);
        ((e2_1,ext_arg_2)) = traverseExp(e2, rel, ext_arg_1);
        ((LBINARY(_,op_1,_),ext_arg_3)) = rel((e,ext_arg_2));
      then
        ((LBINARY(e1_1,op_1,e2_1),ext_arg_3));
    case ((e as RELATION(e1,op,e2)),rel,ext_arg) /* RELATION */
      equation
        ((e1_1,ext_arg_1)) = traverseExp(e1, rel, ext_arg);
        ((e2_1,ext_arg_2)) = traverseExp(e2, rel, ext_arg_1);
        ((RELATION(_,op_1,_),ext_arg_3)) = rel((e,ext_arg_2));
      then
        ((RELATION(e1_1,op_1,e2_1),ext_arg_3));

    case ((e as IFEXP(e1,e2,e3,elseIfBranch)),rel,ext_arg) /* if expression */
      equation
        ((e1_1,ext_arg_1)) = traverseExp(e1, rel, ext_arg);
        ((e2_1,ext_arg_2)) = traverseExp(e2, rel, ext_arg_1);
        ((e3_1,ext_arg_3)) = traverseExp(e3, rel, ext_arg_2);
        ((elseIfBranch1,ext_arg_3)) = traverseExpElseIfBranch(elseIfBranch,rel,ext_arg_3);
        ((e_1,ext_arg_4)) = rel((e,ext_arg_3));
      then
        ((IFEXP(e1_1,e2_1,e3_1,elseIfBranch1),ext_arg_4));

    case ((e as CALL(cfn,fargs)),rel,ext_arg)
      equation
        ((fargs1,ext_arg_1)) = traverseExpFunctionArgs(fargs, rel, ext_arg);
        e_temp = CALL(cfn,fargs1);
        ((CALL(cfn_1,fargs2),ext_arg_2)) = rel((e_temp,ext_arg_1));
      then
        ((CALL(cfn_1,fargs2),ext_arg_2));

    //stefan
    case ((e as PARTEVALFUNCTION(cfn,fargs)),rel,ext_arg)
      equation
        ((fargs1,ext_arg_1)) = traverseExpFunctionArgs(fargs,rel,ext_arg);
        ((PARTEVALFUNCTION(cfn_1,_),ext_arg_2)) = rel((e,ext_arg_1));
      then
        ((PARTEVALFUNCTION(cfn_1,fargs1),ext_arg_2));

    case ((e as ARRAY(expl)),rel,ext_arg)
      equation
        // Also traverse expressions within the array. Daniel Hedberg 2010-10.
        ((expl_1,ext_arg_1)) = traverseExpList(expl, rel, ext_arg);
        ((ARRAY(_),ext_arg_2)) = rel((e,ext_arg_1));
      then
        ((ARRAY(expl_1),ext_arg_2));

    case ((e as MATRIX(mexpl)),rel,ext_arg)
      equation
        // Also traverse expressions within the matrix. Daniel Hedberg 2010-10.
        ((mexpl1,ext_arg_1)) = traverseExpListList(mexpl, rel, ext_arg);
        ((MATRIX(_),ext_arg_2)) = rel((e,ext_arg_1));
      then
        ((MATRIX(mexpl1),ext_arg_2));

    case ((e as RANGE(e1,NONE(),e2)),rel,ext_arg)
      equation
        ((e1_1,ext_arg_1)) = traverseExp(e1, rel, ext_arg);
        ((e2_1,ext_arg_2)) = traverseExp(e2, rel, ext_arg_1);
        ((RANGE(_,_,_),ext_arg_3)) = rel((e,ext_arg_2));
      then
        ((RANGE(e1_1,NONE(),e2_1),ext_arg_3));
    case ((e as RANGE(e1,SOME(e2),e3)),rel,ext_arg)
      equation
        ((e1_1,ext_arg_1)) = traverseExp(e1, rel, ext_arg);
        ((e2_1,ext_arg_2)) = traverseExp(e2, rel, ext_arg_1);
        ((e3_1,ext_arg_3)) = traverseExp(e3, rel, ext_arg_2);
        ((RANGE(_,_,_),ext_arg_4)) = rel((e,ext_arg_3));
      then
        ((RANGE(e1_1,SOME(e3),e2_1),ext_arg_4));

    case ((e as TUPLE(expl)),rel,ext_arg)
      equation
        (expl_1,ext_arg_1) = List.mapFoldTuple(expl, rel, ext_arg);
        ((e_1,ext_arg_2)) = rel((e,ext_arg_1));
      then
        ((TUPLE(expl_1),ext_arg_2));

    case (e,rel,ext_arg)
      equation
        ((e_1,ext_arg_1)) = rel((e,ext_arg));
      then
        ((e_1,ext_arg_1));
  end matchcontinue;
end traverseExp;

public function traverseExpListList
"
  Calls traverseExpList on each element in the given list.
"
  input list<list<Exp>> inExpListList;
  input FuncTplToTpl inFunc;
  input Type_a inTypeA;
  output tuple<list<list<Exp>>, Type_a> outTpl;
  partial function FuncTplToTpl
    input tuple<Exp, Type_a> inTpl;
    output tuple<Exp, Type_a> outTpl;
    replaceable type Type_a subtypeof Any;
  end FuncTplToTpl;
  replaceable type Type_a subtypeof Any;
algorithm
  outTpl := match (inExpListList,inFunc,inTypeA)
    local
      FuncTplToTpl rel;
      Type_a arg,arg_1,arg_2;
      list<Exp> e,e_1;
      list<list<Exp>> cdr,cdr_1;
    case({},_,arg) then (({},arg));
    case(e :: cdr,rel,arg)
      equation
        ((e_1,arg_1)) = traverseExpList(e,rel,arg);
        ((cdr_1,arg_2)) = traverseExpListList(cdr,rel,arg_1);
      then
        ((e_1 :: cdr_1,arg_2));
  end match;
end traverseExpListList;

// stefan
public function traverseExpList
"calls traverseExp on each element in the given list"
  input list<Exp> inExpList;
  input FuncTplToTpl inFunc;
  input Type_a inTypeA;
  output tuple<list<Exp>, Type_a> outTpl;
  partial function FuncTplToTpl
    input tuple<Exp, Type_a> inTpl;
    output tuple<Exp, Type_a> outTpl;
    replaceable type Type_a subtypeof Any;
  end FuncTplToTpl;
  replaceable type Type_a subtypeof Any;
algorithm
  outTpl := match (inExpList,inFunc,inTypeA)
    local
      FuncTplToTpl rel;
      Type_a arg,arg_1,arg_2;
      Exp e,e_1;
      list<Exp> cdr,cdr_1;
    case({},_,arg) then (({},arg));
    case(e :: cdr,rel,arg)
      equation
        ((e_1,arg_1)) = traverseExp(e,rel,arg);
        ((cdr_1,arg_2)) = traverseExpList(cdr,rel,arg_1);
      then
        ((e_1 :: cdr_1,arg_2));
  end match;
end traverseExpList;

public function traverseExpElseIfBranch
"Help function for traverseExp"
  input list<tuple<Exp,Exp>> inLst;
  input FuncTypeTplExpType_aToTplExpType_a rel;
  input Type_a iext_arg;
  output tuple<list<tuple<Exp,Exp>>, Type_a> outTplExpTypeA;
  partial function FuncTypeTplExpType_aToTplExpType_a
    input tuple<Exp, Type_a> inTplExpTypeA;
    output tuple<Exp, Type_a> outTplExpTypeA;
    replaceable type Type_a subtypeof Any;
  end FuncTypeTplExpType_aToTplExpType_a;
  replaceable type Type_a subtypeof Any;
algorithm
  outTplExpTypeA:= match(inLst,rel,iext_arg)
   local Exp e1,e2,e11,e21; Type_a ext_arg;
     list<tuple<Exp,Exp>> lst;
    case({},_,ext_arg) then (({},ext_arg));
    case((e1,e2)::lst,_,ext_arg) equation
      ((lst,ext_arg)) = traverseExpElseIfBranch(lst,rel,iext_arg);
      ((e11,ext_arg)) = traverseExp(e1, rel, ext_arg);
      ((e21,ext_arg)) = traverseExp(e2, rel, ext_arg);
    then (((e11,e21)::lst,ext_arg));
  end match;
end traverseExpElseIfBranch;

public function traverseExpFunctionArgs
"Help function for traverseExp"
  input FunctionArgs inArgs;
  input FuncTypeTplExpType_aToTplExpType_a rel;
  input Type_a iext_arg;
  output tuple<FunctionArgs, Type_a> outTplExpTypeA;
  partial function FuncTypeTplExpType_aToTplExpType_a
    input tuple<Exp, Type_a> inTplExpTypeA;
    output tuple<Exp, Type_a> outTplExpTypeA;
    replaceable type Type_a subtypeof Any;
  end FuncTypeTplExpType_aToTplExpType_a;
  replaceable type Type_a subtypeof Any;
algorithm
  outTplExpTypeA:= match(inArgs,rel,iext_arg)
    local Exp e1,forExp;
      list<NamedArg> nargs;
      list<Exp> expl,expl_1;
      ForIterators iterators;
      Type_a ext_arg;
    case(FUNCTIONARGS(expl,nargs),_,ext_arg)
      equation
        ((expl_1,ext_arg)) = traverseExpPosArgs(expl,rel,ext_arg);
        ((nargs,ext_arg)) = traverseExpNamedArgs(nargs,rel,ext_arg);
      then ((FUNCTIONARGS(expl_1,nargs),ext_arg));

    case(FOR_ITER_FARG(exp = forExp,iterators=iterators),_,ext_arg)
      equation
        ((e1,ext_arg)) = traverseExp(forExp, rel, ext_arg);
        /* adrpo: TODO! travese iterators! */
      then((FOR_ITER_FARG(e1,iterators),ext_arg));
  end match;
end traverseExpFunctionArgs;

protected function traverseExpNamedArgs "Help function to traverseExpFunctionArgs"
  input list<NamedArg> inargs;
  input FuncTypeTplExpType_aToTplExpType_a rel;
  input Type_a iext_arg;
  output tuple<list<NamedArg>, Type_a> outTplExpTypeA;
  partial function FuncTypeTplExpType_aToTplExpType_a
    input tuple<Exp, Type_a> inTplExpTypeA;
    output tuple<Exp, Type_a> outTplExpTypeA;
    replaceable type Type_a subtypeof Any;
  end FuncTypeTplExpType_aToTplExpType_a;
  replaceable type Type_a subtypeof Any;
algorithm
  outTplExpTypeA:= match(inargs,rel,iext_arg)
    local
      Exp e1,e11;
      Ident id;
      Type_a ext_arg;
      list<NamedArg> nargs;
    case({},_,ext_arg) then (({},ext_arg));
    case(NAMEDARG(id,e1)::nargs,_,ext_arg)
      equation
        ((e11,ext_arg)) = traverseExp(e1, rel, ext_arg);
        ((nargs,ext_arg)) = traverseExpNamedArgs(nargs,rel,ext_arg);
      then((NAMEDARG(id,e11)::nargs,ext_arg));
  end match;
end traverseExpNamedArgs;

protected function traverseExpPosArgs "Help function to traverseExpFunctionArgs"
  input list<Exp> ipargs;
  input FuncTypeTplExpType_aToTplExpType_a rel;
  input Type_a iext_arg;
  output tuple<list<Exp>, Type_a> outTplExpTypeA;
  partial function FuncTypeTplExpType_aToTplExpType_a
    input tuple<Exp, Type_a> inTplExpTypeA;
    output tuple<Exp, Type_a> outTplExpTypeA;
    replaceable type Type_a subtypeof Any;
  end FuncTypeTplExpType_aToTplExpType_a;
  replaceable type Type_a subtypeof Any;
algorithm
  outTplExpTypeA:= match(ipargs,rel,iext_arg)
    local
      Exp e1,e11;
      list<Exp> pargs;
      Type_a ext_arg;
    case({},_,ext_arg) then (({},ext_arg));
    case(e1::pargs,_,ext_arg)
      equation
        ((e11,ext_arg)) = traverseExp(e1, rel, ext_arg);
        ((pargs,ext_arg)) = traverseExpPosArgs(pargs,rel,ext_arg);
      then((e11::pargs,ext_arg));
  end match;
end traverseExpPosArgs;

public function traverseExpListBidir
  "Traverses a list of expressions, calling traverseExpBidir on each
  expression."
  input list<Exp> inExpl;
  input tuple<FuncType, FuncType, Argument> inTuple;
  output list<Exp> outExpl;
  output tuple<FuncType, FuncType, Argument> outTuple;

  partial function FuncType
    input tuple<Exp, Argument> inTuple;
    output tuple<Exp, Argument> outTuple;
  end FuncType;

  replaceable type Argument subtypeof Any;
algorithm
  (outExpl, outTuple) :=
    List.mapFold(inExpl, traverseExpBidir, inTuple);
end traverseExpListBidir;

public function traverseExpBidir
  "This function takes an expression and a tuple with an enter function, an exit
  function, and an extra argument. For each expression it encounters it calls
  the enter function with the expression and the extra argument. It then
  traverses all subexpressions in the expression and calls traverseExpBidir on
  them with the updated argument. Finally it calls the exit function, again with
  the updated argument. This means that this function is bidirectional, and can
  be used to emulate both top-down and bottom-up traversal."
  input Exp inExp;
  input tuple<FuncType, FuncType, Argument> inTuple;
  output Exp outExp;
  output tuple<FuncType, FuncType, Argument> outTuple;

  partial function FuncType
    input tuple<Exp, Argument> inTuple;
    output tuple<Exp, Argument> outTuple;
  end FuncType;

  replaceable type Argument subtypeof Any;

protected
  FuncType enterFunc, exitFunc;
  Argument arg;
  Exp e;
  tuple<FuncType, FuncType, Argument> tup;
algorithm
  (enterFunc, exitFunc, arg) := inTuple;
  ((e, arg)) := enterFunc((inExp, arg));
  (e, (_, _, arg)) := traverseExpBidirSubExps(e,
    (enterFunc, exitFunc, arg));
  ((outExp, arg)) := exitFunc((e, arg));
  outTuple := (enterFunc, exitFunc, arg);
end traverseExpBidir;

public function traverseExpOptBidir
  "Same as traverseExpBidir, but with an optional expression. Calls
  traverseExpBidir if the option is SOME(), or just returns the input if it's
  NONE()"
  input Option<Exp> inExp;
  input tuple<FuncType, FuncType, Argument> inTuple;
  output Option<Exp> outExp;
  output tuple<FuncType, FuncType, Argument> outTuple;

  partial function FuncType
    input tuple<Exp, Argument> inTuple;
    output tuple<Exp, Argument> outTuple;
  end FuncType;

  replaceable type Argument subtypeof Any;
algorithm
  (outExp, outTuple) := match(inExp, inTuple)
    local
      Exp e;
      tuple<FuncType, FuncType, Argument> tup;

    case (SOME(e), tup)
      equation
        (e, tup) = traverseExpBidir(e, tup);
      then
        (SOME(e), tup);

    case (NONE(), _) then (inExp, inTuple);
  end match;
end traverseExpOptBidir;

protected function traverseExpBidirSubExps
  "Helper function to traverseExpBidir. Traverses the subexpressions of an
  expression and calls traverseExpBidir on them."
  input Exp inExp;
  input tuple<FuncType, FuncType, Argument> inTuple;
  output Exp outExp;
  output tuple<FuncType, FuncType, Argument> outTuple;

  partial function FuncType
    input tuple<Exp, Argument> inTuple;
    output tuple<Exp, Argument> outTuple;
  end FuncType;

  replaceable type Argument subtypeof Any;
algorithm
  (outExp, outTuple) := match(inExp, inTuple)
    local
      Exp e1, e2, e3;
      Option<Exp> oe1;
      tuple<FuncType, FuncType, Argument> tup;
      Operator op;
      ComponentRef cref;
      list<tuple<Exp, Exp>> else_ifs;
      list<Exp> expl;
      list<list<Exp>> mat_expl;
      FunctionArgs fargs;
      String error_msg;
      Ident id;
      MatchType match_ty;
      list<ElementItem> match_decls;
      list<Case> match_cases;
      Option<String> cmt;

    case (INTEGER(value = _), _) then (inExp, inTuple);
    case (REAL(value = _), _) then (inExp, inTuple);
    case (STRING(value = _), _) then (inExp, inTuple);
    case (BOOL(value = _), _) then (inExp, inTuple);

    case (CREF(componentRef = cref), tup)
      equation
        (cref, tup) = traverseExpBidirCref(cref, tup);
      then
        (CREF(cref), tup);

    case (BINARY(exp1 = e1, op = op, exp2 = e2), tup)
      equation
        (e1, tup) = traverseExpBidir(e1, tup);
        (e2, tup) = traverseExpBidir(e2, tup);
      then
        (BINARY(e1, op, e2), tup);

    case (UNARY(op = op, exp = e1), tup)
      equation
        (e1, tup) = traverseExpBidir(e1, tup);
      then
        (UNARY(op, e1), tup);

    case (LBINARY(exp1 = e1, op = op, exp2 = e2), tup)
      equation
        (e1, tup) = traverseExpBidir(e1, tup);
        (e2, tup) = traverseExpBidir(e2, tup);
      then
        (LBINARY(e1, op, e2), tup);

    case (LUNARY(op = op, exp = e1), tup)
      equation
        (e1, tup) = traverseExpBidir(e1, tup);
      then
        (LUNARY(op, e1), tup);

    case (RELATION(exp1 = e1, op = op, exp2 = e2), tup)
      equation
        (e1, tup) = traverseExpBidir(e1, tup);
        (e2, tup) = traverseExpBidir(e2, tup);
      then
        (RELATION(e1, op, e2), tup);

    case (IFEXP(ifExp = e1, trueBranch = e2, elseBranch = e3,
        elseIfBranch = else_ifs), tup)
      equation
        (e1, tup) = traverseExpBidir(e1, tup);
        (e2, tup) = traverseExpBidir(e2, tup);
        (e3, tup) = traverseExpBidir(e3, tup);
        (else_ifs, tup) = List.mapFold(else_ifs,
          traverseExpBidirElseIf, tup);
      then
        (IFEXP(e1, e2, e3, else_ifs), tup);

    case (CALL(function_ = cref, functionArgs = fargs), tup)
      equation
        (fargs, tup) = traverseExpBidirFunctionArgs(fargs, tup);
      then
        (CALL(cref, fargs), tup);

    case (PARTEVALFUNCTION(function_ = cref, functionArgs = fargs), tup)
      equation
        (fargs, tup) = traverseExpBidirFunctionArgs(fargs, tup);
      then
        (PARTEVALFUNCTION(cref, fargs), tup);

    case (ARRAY(arrayExp = expl), tup)
      equation
        (expl, tup) = traverseExpListBidir(expl, tup);
      then
        (ARRAY(expl), tup);

    case (MATRIX(matrix = mat_expl), tup)
      equation
        (mat_expl, tup) = List.mapFold(mat_expl,
          traverseExpListBidir, tup);
      then
        (MATRIX(mat_expl), tup);

    case (RANGE(start = e1, step = oe1, stop = e2), tup)
      equation
        (e1, tup) = traverseExpBidir(e1, tup);
        (oe1, tup) = traverseExpOptBidir(oe1, tup);
        (e2, tup) = traverseExpBidir(e2, tup);
      then
        (RANGE(e1, oe1, e2), tup);

    case (END(), _) then (inExp, inTuple);

    case (TUPLE(expressions = expl), tup)
      equation
        (expl, tup) = traverseExpListBidir(expl, tup);
      then
        (TUPLE(expl), tup);

    case (AS(id = id, exp = e1), tup)
      equation
        (e1, tup) = traverseExpBidir(e1, tup);
      then
        (AS(id, e1), tup);

    case (CONS(head = e1, rest = e2), tup)
      equation
        (e1, tup) = traverseExpBidir(e1, tup);
        (e2, tup) = traverseExpBidir(e2, tup);
      then
        (CONS(e1, e2), tup);

    case (MATCHEXP(matchTy = match_ty, inputExp = e1, localDecls = match_decls,
        cases = match_cases, comment = cmt), tup)
      equation
        (e1, tup) = traverseExpBidir(e1, tup);
        (match_cases, tup) = List.mapFold(match_cases,
          traverseMatchCase, tup);
      then
        (MATCHEXP(match_ty, e1, match_decls, match_cases, cmt), tup);

    case (LIST(exps = expl), tup)
      equation
        (expl, tup) = traverseExpListBidir(expl, tup);
      then
        (LIST(expl), tup);

    case (CODE(code = _), tup)
      then (inExp, tup);

    else
      equation
        error_msg = "in traverseExpBidirSubExps - Unknown expression: ";
        error_msg = error_msg +& Dump.printExpStr(inExp);
        Error.addMessage(Error.INTERNAL_ERROR, {error_msg});
      then
        fail();

  end match;
end traverseExpBidirSubExps;

public function traverseExpBidirCref
  "Helper function to traverseExpBidirSubExps. Traverses any expressions in a
  component reference (i.e. in it's subscripts)."
  input ComponentRef inCref;
  input tuple<FuncType, FuncType, Argument> inTuple;
  output ComponentRef outCref;
  output tuple<FuncType, FuncType, Argument> outTuple;

  partial function FuncType
    input tuple<Exp, Argument> inTuple;
    output tuple<Exp, Argument> outTuple;
  end FuncType;

  replaceable type Argument subtypeof Any;
algorithm
  (outCref, outTuple) := match(inCref, inTuple)
    local
      Ident name;
      ComponentRef cr;
      list<Subscript> subs;
      tuple<FuncType, FuncType, Argument> tup;

    case (CREF_FULLYQUALIFIED(componentRef = cr), _)
      equation
        (cr, tup) = traverseExpBidirCref(cr, inTuple);
      then
        (crefMakeFullyQualified(cr), tup);

    case (CREF_QUAL(name = name, subscripts = subs, componentRef = cr), _)
      equation
        (subs, tup) = List.mapFold(subs, traverseExpBidirSubs, inTuple);
        (cr, tup) = traverseExpBidirCref(cr, tup);
      then
        (CREF_QUAL(name, subs, cr), tup);

    case (CREF_IDENT(name = name, subscripts = subs), _)
      equation
        (subs, tup) = List.mapFold(subs, traverseExpBidirSubs, inTuple);
      then
        (CREF_IDENT(name, subs), tup);

    case (ALLWILD(), _) then (inCref, inTuple);
    case (WILD(), _) then (inCref, inTuple);
  end match;
end traverseExpBidirCref;

public function traverseExpBidirSubs
  "Helper function to traverseExpBidirCref. Traverses expressions in a
  subscript."
  input Subscript inSubscript;
  input tuple<FuncType, FuncType, Argument> inTuple;
  output Subscript outSubscript;
  output tuple<FuncType, FuncType, Argument> outTuple;

  partial function FuncType
    input tuple<Exp, Argument> inTuple;
    output tuple<Exp, Argument> outTuple;
  end FuncType;

  replaceable type Argument subtypeof Any;
algorithm
  (outSubscript, outTuple) := match(inSubscript, inTuple)
    local
      Exp sub_exp;
      tuple<FuncType, FuncType, Argument> tup;

    case (SUBSCRIPT(subscript = sub_exp), tup)
      equation
        (sub_exp, tup) = traverseExpBidir(sub_exp, tup);
      then
        (SUBSCRIPT(sub_exp), tup);

    case (NOSUB(), _) then (inSubscript, inTuple);
  end match;
end traverseExpBidirSubs;

public function traverseExpBidirElseIf
  "Helper function to traverseExpBidirSubExps. Traverses the expressions in an
  elseif branch."
  input tuple<Exp, Exp> inElseIf;
  input tuple<FuncType, FuncType, Argument> inTuple;
  output tuple<Exp, Exp> outElseIf;
  output tuple<FuncType, FuncType, Argument> outTuple;

  partial function FuncType
    input tuple<Exp, Argument> inTuple;
    output tuple<Exp, Argument> outTuple;
  end FuncType;

  replaceable type Argument subtypeof Any;

protected
  Exp e1, e2;
  tuple<FuncType, FuncType, Argument> tup;
algorithm
  (e1, e2) := inElseIf;
  (e1, tup) := traverseExpBidir(e1, inTuple);
  (e2, outTuple) := traverseExpBidir(e2, tup);
  outElseIf := (e1, e2);
end traverseExpBidirElseIf;

public function traverseExpBidirFunctionArgs
  "Helper function to traverseExpBidirSubExps. Traverses the expressions in a
  list of function argument."
  input FunctionArgs inArgs;
  input tuple<FuncType, FuncType, Argument> inTuple;
  output FunctionArgs outArgs;
  output tuple<FuncType, FuncType, Argument> outTuple;

  partial function FuncType
    input tuple<Exp, Argument> inTuple;
    output tuple<Exp, Argument> outTuple;
  end FuncType;

  replaceable type Argument subtypeof Any;
algorithm
  (outArgs, outTuple) := match(inArgs, inTuple)
    local
      Exp e;
      list<Exp> expl;
      list<NamedArg> named_args;
      ForIterators iters;
      tuple<FuncType, FuncType, Argument> tup;

    case (FUNCTIONARGS(args = expl, argNames = named_args), tup)
      equation
        (expl, tup) = traverseExpListBidir(expl, tup);
        (named_args, tup) = List.mapFold(named_args,
          traverseExpBidirNamedArg, tup);
      then
        (FUNCTIONARGS(expl, named_args), tup);

    case (FOR_ITER_FARG(exp = e, iterators = iters), tup)
      equation
        (e, tup) = traverseExpBidir(e, tup);
        (iters, tup) = List.mapFold(iters,
          traverseExpBidirIterator, tup);
      then
        (FOR_ITER_FARG(e, iters), tup);
  end match;
end traverseExpBidirFunctionArgs;

public function traverseExpBidirNamedArg
  "Helper function to traverseExpBidirFunctionArgs. Traverses the expressions in
  a named function argument."
  input NamedArg inArg;
  input tuple<FuncType, FuncType, Argument> inTuple;
  output NamedArg outArg;
  output tuple<FuncType, FuncType, Argument> outTuple;

  partial function FuncType
    input tuple<Exp, Argument> inTuple;
    output tuple<Exp, Argument> outTuple;
  end FuncType;

  replaceable type Argument subtypeof Any;

protected
  Ident name;
  Exp value;
algorithm
  NAMEDARG(name, value) := inArg;
  (value, outTuple) := traverseExpBidir(value, inTuple);
  outArg := NAMEDARG(name, value);
end traverseExpBidirNamedArg;

public function traverseExpBidirIterator
  "Helper function to traverseExpBidirFunctionArgs. Traverses the expressions in
  an iterator."
  input ForIterator inIterator;
  input tuple<FuncType, FuncType, Argument> inTuple;
  output ForIterator outIterator;
  output tuple<FuncType, FuncType, Argument> outTuple;

  partial function FuncType
    input tuple<Exp, Argument> inTuple;
    output tuple<Exp, Argument> outTuple;
  end FuncType;

  replaceable type Argument subtypeof Any;

protected
  Ident name;
  Option<Exp> guardExp,range;
algorithm
  ITERATOR(name=name, guardExp=guardExp, range=range) := inIterator;
  (guardExp, outTuple) := traverseExpOptBidir(guardExp, inTuple);
  (range, outTuple) := traverseExpOptBidir(range, outTuple);
  outIterator := ITERATOR(name, guardExp, range);
end traverseExpBidirIterator;

protected function traverseMatchCase
  input Case inMatchCase;
  input tuple<FuncType, FuncType, Argument> inTuple;
  output Case outMatchCase;
  output tuple<FuncType, FuncType, Argument> outTuple;

  partial function FuncType
    input tuple<Exp, Argument> inTuple;
    output tuple<Exp, Argument> outTuple;
  end FuncType;

  replaceable type Argument subtypeof Any;
algorithm
  (outMatchCase, outTuple) := match(inMatchCase, inTuple)
    local
      tuple<FuncType, FuncType, Argument> tup;
      Exp pattern, result;
      Info info, resultInfo, pinfo;
      list<ElementItem> ldecls;
      list<EquationItem> eql;
      Option<String> cmt;
      Option<Exp> patternGuard;

    case (CASE(pattern, patternGuard, pinfo, ldecls, eql, result, resultInfo, cmt, info), tup)
      equation
        (pattern, tup) = traverseExpBidir(pattern, tup);
        (patternGuard, tup) = traverseExpOptBidir(patternGuard, tup);
        (eql, tup) = List.mapFold(eql, traverseEquationItemBidir, tup);
        (result, tup) = traverseExpBidir(result, tup);
      then
        (CASE(pattern, patternGuard, pinfo, ldecls, eql, result, resultInfo, cmt, info), tup);

    case (ELSE(localDecls = ldecls, equations = eql, result = result, resultInfo = resultInfo,
        comment = cmt, info = info), tup)
      equation
        (eql, tup) = List.mapFold(eql, traverseEquationItemBidir, tup);
        (result, tup) = traverseExpBidir(result, tup);
      then
        (ELSE(ldecls, eql, result, resultInfo, cmt, info), tup);

  end match;
end traverseMatchCase;

protected function traverseEquationItemListBidir
  input list<EquationItem> inEquationItems;
  input tuple<FuncType, FuncType, Argument> inTuple;
  output list<EquationItem> outEquationItems;
  output tuple<FuncType, FuncType, Argument> outTuple;

  partial function FuncType
    input tuple<Exp, Argument> inTuple;
    output tuple<Exp, Argument> outTuple;
  end FuncType;

  replaceable type Argument subtypeof Any;
algorithm
  (outEquationItems, outTuple) := List.mapFold(inEquationItems,
    traverseEquationItemBidir, inTuple);
end traverseEquationItemListBidir;

protected function traverseEquationItemBidir
  input EquationItem inEquationItem;
  input tuple<FuncType, FuncType, Argument> inTuple;
  output EquationItem outEquationItem;
  output tuple<FuncType, FuncType, Argument> outTuple;

  partial function FuncType
    input tuple<Exp, Argument> inTuple;
    output tuple<Exp, Argument> outTuple;
  end FuncType;

  replaceable type Argument subtypeof Any;
algorithm
  (outEquationItem, outTuple) := match(inEquationItem, inTuple)
    local
      tuple<FuncType, FuncType, Argument> tup;
      Equation eq;
      Option<Comment> cmt;
      Info info;

    case (EQUATIONITEM(equation_ = eq, comment = cmt, info = info), tup)
      equation
        (eq, tup) = traverseEquationBidir(eq, tup);
      then
        (EQUATIONITEM(eq, cmt, info), tup);

  end match;
end traverseEquationItemBidir;

public function traverseEquationBidir
  input Equation inEquation;
  input tuple<FuncType, FuncType, Argument> inTuple;
  output Equation outEquation;
  output tuple<FuncType, FuncType, Argument> outTuple;

  partial function FuncType
    input tuple<Exp, Argument> inTuple;
    output tuple<Exp, Argument> outTuple;
  end FuncType;

  replaceable type Argument subtypeof Any;
algorithm
  (outEquation, outTuple) := match(inEquation, inTuple)
    local
      tuple<FuncType, FuncType, Argument> tup;
      Exp e1, e2;
      list<EquationItem> eqil1, eqil2;
      list<tuple<Exp, list<EquationItem>>> else_branch;
      ComponentRef cref1, cref2;
      ForIterators iters;
      FunctionArgs func_args;
      EquationItem eq;

    case (EQ_IF(ifExp = e1, equationTrueItems = eqil1,
        elseIfBranches = else_branch, equationElseItems = eqil2), tup)
      equation
        (e1, tup) = traverseExpBidir(e1, tup);
        (eqil1, tup) = traverseEquationItemListBidir(eqil1, tup);
        (else_branch, tup) = List.mapFold(else_branch,
          traverseEquationBidirElse, tup);
        (eqil2, tup) = traverseEquationItemListBidir(eqil2, tup);
      then
        (EQ_IF(e1, eqil1, else_branch, eqil2), tup);

    case (EQ_EQUALS(leftSide = e1, rightSide = e2), tup)
      equation
        (e1, tup) = traverseExpBidir(e1, tup);
        (e2, tup) = traverseExpBidir(e2, tup);
      then
        (EQ_EQUALS(e1, e2), tup);

    case (EQ_CONNECT(connector1 = cref1, connector2 = cref2), tup)
      equation
        (cref1, tup) = traverseExpBidirCref(cref1, tup);
        (cref2, tup) = traverseExpBidirCref(cref2, tup);
      then
        (EQ_CONNECT(cref1, cref2), tup);

    case (EQ_FOR(iterators = iters, forEquations = eqil1), tup)
      equation
        (iters, tup) = List.mapFold(iters,
          traverseExpBidirIterator, tup);
        (eqil1, tup) = traverseEquationItemListBidir(eqil1, tup);
      then
        (EQ_FOR(iters, eqil1), tup);

    case (EQ_WHEN_E(whenExp = e1, whenEquations = eqil1,
        elseWhenEquations = else_branch), tup)
      equation
        (e1, tup) = traverseExpBidir(e1, tup);
        (eqil1, tup) = traverseEquationItemListBidir(eqil1, tup);
        (else_branch, tup) = List.mapFold(else_branch,
          traverseEquationBidirElse, tup);
      then
        (EQ_WHEN_E(e1, eqil1, else_branch), tup);

    case (EQ_NORETCALL(functionName = cref1, functionArgs = func_args), tup)
      equation
        (cref1, tup) = traverseExpBidirCref(cref1, tup);
        (func_args, tup) = traverseExpBidirFunctionArgs(func_args, tup);
      then
        (EQ_NORETCALL(cref1, func_args), tup);

    case (EQ_FAILURE(equ = eq), tup)
      equation
        (eq, tup) = traverseEquationItemBidir(eq, tup);
      then
        (EQ_FAILURE(eq), tup);

  end match;
end traverseEquationBidir;

protected function traverseEquationBidirElse
  input tuple<Exp, list<EquationItem>> inElse;
  input tuple<FuncType, FuncType, Argument> inTuple;
  output tuple<Exp, list<EquationItem>> outElse;
  output tuple<FuncType, FuncType, Argument> outTuple;

  partial function FuncType
    input tuple<Exp, Argument> inTuple;
    output tuple<Exp, Argument> outTuple;
  end FuncType;

  replaceable type Argument subtypeof Any;
protected
  Exp e;
  list<EquationItem> eqil;
  tuple<FuncType, FuncType, Argument> tup;
algorithm
  (e, eqil) := inElse;
  (e, tup) := traverseExpBidir(e, inTuple);
  (eqil, outTuple) := traverseEquationItemListBidir(eqil, tup);
  outElse := (e, eqil);
end traverseEquationBidirElse;

public function makeIdentPathFromString ""
  input String s;
  output Path p;
algorithm
  p := IDENT(s);
annotation(__OpenModelica_EarlyInline = true);
end makeIdentPathFromString;

public function makeQualifiedPathFromStrings ""
  input String s1;
  input String s2;
  output Path p;
algorithm
  p := QUALIFIED(s1,IDENT(s2));
annotation(__OpenModelica_EarlyInline = true);
end makeQualifiedPathFromStrings;

public function setTimeStampEdit "Function: getNewTimeStamp
Update current TimeStamp with a new Edit-time.
"
input TimeStamp its;
input Real editTime;
output TimeStamp ots;
algorithm ots := match(its,editTime)
  local
    Real buildTime;
    TimeStamp ts;
  case(TIMESTAMP(buildTime,_),_)
    equation
      ts = TIMESTAMP(buildTime,editTime);
    then
      ts;
end match;
end setTimeStampEdit;

public function setTimeStampBuild "Function: getNewTimeStamp
Update current TimeStamp with a new Build-time.
"
input TimeStamp its;
input Real buildTime;
output TimeStamp ots;
algorithm ots := match(its,buildTime)
  local
    Real editTime;
    TimeStamp ts;
  case(TIMESTAMP(_,editTime),_)
    equation
      ts = TIMESTAMP(buildTime,editTime);
    then
      ts;
end match;
end setTimeStampBuild;

public function className "returns the class name of a Class as a Path"
  input Class cl;
  output Path name;
algorithm
  name := match(cl)
  local String id;
    case(CLASS(name=id)) then IDENT(id);
  end match;
end className;

public function elementSpecName "The ElementSpec type contans the name of the element, and this
  function extracts this name."
  input ElementSpec inElementSpec;
  output Ident outIdent;
algorithm
  outIdent:=
  match (inElementSpec)
    local Ident n;
    case CLASSDEF(class_ = CLASS(name = n)) then n;
    case COMPONENTS(components = {COMPONENTITEM(component = COMPONENT(name = n))}) then n;
    case EXTENDS(path = _)
      equation
        print("#- elementSpecName EXTENDS\n");
      then
        fail();
  end match;
end elementSpecName;

public function printImportString "Function: printImportString
This function takes a Import and prints it as a flat-string.
"
  input Import imp;
  output String ostring;
algorithm ostring := match(imp)
  local Path path; String name;
  case(NAMED_IMPORT(name,_)) then name;
  case(QUAL_IMPORT(path))
    equation
      name = pathString(path);
    then name;
  case(UNQUAL_IMPORT(path))
    equation
      name = pathString(path);
    then name;
end match;
end printImportString;

public function expString "returns the string of an expression if it is a string constant."
  input Exp exp;
  output String str;
algorithm
  str := matchcontinue(exp)
    case(STRING(str)) then str;
  end matchcontinue;
end expString;

public function expCref "returns the componentRef of an expression if matches."
  input Exp exp;
  output ComponentRef cr;
algorithm
  cr := match(exp)
    case(CREF(cr)) then cr;
  end match;
end expCref;

public function crefExp "returns the componentRef of an expression if matches."
 input ComponentRef cr;
 output Exp exp;
algorithm
  exp := CREF(cr);
annotation(__OpenModelica_EarlyInline = true);
end crefExp;

public function expComponentRefStr ""
  input Exp aexp;
  output String outString;
algorithm outString := matchcontinue(aexp)
  local ComponentRef cr;
  case(CREF(cr)) then printComponentRefStr(cr);
  case(_) equation print("Error input for exp_Component_Ref_Str was not a string\n"); then fail();
end matchcontinue;
end expComponentRefStr;

public function printComponentRefStr ""
  input ComponentRef cr;
  output String ostring;
algorithm
  ostring := match(cr)
    local
      String s1,s2;
      ComponentRef child;
    case(CREF_IDENT(s1,_)) then s1;
    case(CREF_QUAL(s1,_,child))
      equation
        s2 = printComponentRefStr(child);
        s1 = s1 +& "." +& s2;
      then s1;
    case(CREF_FULLYQUALIFIED(child))
      equation
        s2 = printComponentRefStr(child);
        s1 = "." +& s2;
      then s1;
    case (ALLWILD()) then "__";
    case (WILD()) then "_";
  end match;
end printComponentRefStr;

public function pathEqual "Returns true if two paths are equal."
  input Path inPath1;
  input Path inPath2;
  output Boolean outBoolean;
algorithm
  outBoolean := match (inPath1, inPath2)
    local
      String id1,id2;
      Boolean res;
      Path path1,path2;
    // fully qual vs. path
    case (FULLYQUALIFIED(path1),path2) then pathEqual(path1,path2);
    // path vs. fully qual
    case (path1,FULLYQUALIFIED(path2)) then pathEqual(path1,path2);
    // ident vs. ident
    case (IDENT(id1),IDENT(id2))
      then stringEq(id1, id2);
    // qual ident vs. qual ident
    case (QUALIFIED(id1, path1),QUALIFIED(id2, path2))
      equation
        res = Debug.bcallret2(stringEq(id1, id2), pathEqual, path1, path2, false);
      then res;
    // other return false
    else false;
  end match;
end pathEqual;

public function typeSpecEqual "
Author BZ 2009-01
Check whether two type specs are equal or not."
  input TypeSpec a,b;
  output Boolean ob;
algorithm
  ob := matchcontinue(a,b)
    local
      Path p1,p2;
      Option<ArrayDim> oad1,oad2;
      list<TypeSpec> lst1,lst2;
      Ident i1, i2;
      Integer pos1, pos2;

    // first try full equality
    case(TPATH(p1,oad1), TPATH(p2,oad2))
      equation
        true = pathEqual(p1,p2);
        true = optArrayDimEqual(oad1,oad2);
      then true;

    case(TCOMPLEX(p1,lst1,oad1),TCOMPLEX(p2,lst2,oad2))
      equation
        true = pathEqual(p1,p2);
        true = List.isEqualOnTrue(lst1,lst2,typeSpecEqual);
        true = optArrayDimEqual(oad1,oad2);
      then
        true;
    case(_,_) then false;
  end matchcontinue;
end typeSpecEqual;

public function optArrayDimEqual "
Author BZ
helperfunction for typeSpecEqual
"
  input Option<ArrayDim> oad1,oad2;
  output Boolean b;
algorithm b:= matchcontinue(oad1,oad2)
  local
    list<Subscript> ad1,ad2;
  case(SOME(ad1),SOME(ad2))
    equation
    true = List.isEqualOnTrue(ad1,ad2,subscriptEqual);
    then true;
  case(NONE(),NONE()) then true;
  case(_,_) then false;
end matchcontinue;
end optArrayDimEqual;

public function typeSpecPathString "This function simply converts a Path to a string."
  input TypeSpec tp;
  output String s;
algorithm s := match(tp)
  local Path p;
  case(TCOMPLEX(path = p)) then pathString(p);
  case(TPATH(path = p)) then pathString(p);
end match;
end typeSpecPathString;

public function typeSpecPath
"convert TypeSpec to Path"
  input TypeSpec tp;
  output Path op;
algorithm
  op := match(tp)
    local Path p;
    case(TCOMPLEX(path = p)) then p;
    case(TPATH(path = p)) then p;
  end match;
end typeSpecPath;

public function typeSpecDimensions
  "Returns the dimensions of a TypeSpec."
  input TypeSpec inTypeSpec;
  output ArrayDim outDimensions;
algorithm
  outDimensions := match(inTypeSpec)
    local
      ArrayDim dim;

    case TPATH(arrayDim = SOME(dim)) then dim;
    case TCOMPLEX(arrayDim = SOME(dim)) then dim;
    else {};

  end match;
end typeSpecDimensions;

public function pathString "This function simply converts a Path to a string."
  input Path path;
  output String s;
algorithm
  s := pathString2(path, ".");
end pathString;

public function pathStringNoQual
  "Converts a Path to a String, but does not add a dot in front of fully
  qualified paths."
  input Path inPath;
  output String outString;
algorithm
  outString := pathString2(makeNotFullyQualified(inPath), ".");
end pathStringNoQual;

public function pathHashMod "Hashes a path."
  input Path path;
  input Integer mod;
  output Integer hash;
algorithm
// hash := valueHashMod(path,mod);
// print(pathString(path) +& " => " +& intString(hash) +& "\n");
// hash := System.stringHashDjb2Mod(pathString(path),mod);
// TODO: stringHashDjb2 is missing a default value for the seed; add this once we bootstrapped omc so we can use that function instead of our own hack
  hash := intAbs(intMod(pathHashModWork(path,5381),mod));
end pathHashMod;

protected function pathHashModWork "Hashes a path."
  input Path path;
  input Integer acc;
  output Integer hash;
algorithm
  hash := match (path,acc)
    local
      Path p;
      String s;
      Integer i,i2;
    case (FULLYQUALIFIED(p),_) then pathHashModWork(p, acc*31 + 46 /* '.' */);
    case (QUALIFIED(s,p),_) equation i = stringHashDjb2(s); i2 = acc*31+46; then pathHashModWork(p, i2*31 + i);
    case (IDENT(s),_) equation i = stringHashDjb2(s); i2 = acc*31+46; then i2*31 + i;
  end match;
end pathHashModWork;

public function optPathString "Returns a path converted to string or an empty string if nothing exist"
  input Option<Path> inPathOption;
  output String outString;
algorithm
  outString:=
  match (inPathOption)
    local
      Ident str;
      Path p;
    case (NONE()) then "";
    case (SOME(p))
      equation
        str = pathString(p);
      then
        str;
  end match;
end optPathString;

public function pathString2 "Tail-recursive version, with string builder (stringDelimitList is optimised)"
  input Path path;
  input String delimiter;
  output String outString;
algorithm
  outString := match (path,delimiter)
    case (FULLYQUALIFIED(path=_),_)
      then "." +& stringDelimitList(pathToStringList(path),delimiter);
    else
      then stringDelimitList(pathToStringList(path),delimiter);
  end match;
end pathString2;

public function pathStringReplaceDot "Helper function to pathString."
  input Path inPath;
  input String inString;
  output String outString;
algorithm
  outString:=
  match (inPath,inString)
    local
      String s,ns,s1,ss,str,dstr,safe_s;
      Path n;
    case (IDENT(name = s),str)
      equation
        dstr = stringAppend(str, str);
        safe_s = System.stringReplace(s, str, dstr);
      then
        safe_s;
    case(FULLYQUALIFIED(n),str) then pathStringReplaceDot(n,str);
    case (QUALIFIED(name = s,path = n),str)
      equation
        ns = pathStringReplaceDot(n, str);
        dstr = stringAppend(str, str);
        safe_s = System.stringReplace(s, str, dstr);
        s1 = stringAppend(safe_s, str);
        ss = stringAppend(s1, ns);
      then
        ss;
  end match;
end pathStringReplaceDot;

public function stringPath
  "Converts a string into a qualified path."
  input String str;
  output Path qualifiedPath;

protected
  list<String> paths;
algorithm
  paths := Util.stringSplitAtChar(str, ".");
  qualifiedPath := stringListPath(paths);
end stringPath;

public function stringListPath
  "Converts a list of strings into a qualified path."
  input list<String> paths;
  output Path qualifiedPath;
algorithm
  qualifiedPath := matchcontinue(paths)
    local
      String str;
      list<String> rest_str;
      Path p;
    case ({}) then fail();
    case (str :: {}) then IDENT(str);
    case (str :: rest_str)
      equation
        p = stringListPath(rest_str);
      then
        QUALIFIED(str, p);
  end matchcontinue;
end stringListPath;

public function stringListPathReversed
  "Converts a list of strings into a qualified path, in reverse order.
   Ex: {'a', 'b', 'c'} => c.b.a"
  input list<String> inStrings;
  output Path outPath;
protected
  String id;
  list<String> rest_str;
  Path path;
algorithm
  id :: rest_str := inStrings;
  path := IDENT(id);
  outPath := stringListPathReversed2(rest_str, path);
end stringListPathReversed;

protected function stringListPathReversed2
  input list<String> inStrings;
  input Path inAccumPath;
  output Path outPath;
algorithm
  outPath := match(inStrings, inAccumPath)
    local
      String id;
      list<String> rest_str;
      Path path;

    case ({}, _) then inAccumPath;

    case (id :: rest_str, _)
      equation
        path = QUALIFIED(id, inAccumPath);
      then
        stringListPathReversed2(rest_str, path);

  end match;
end stringListPathReversed2;

public function pathTwoLastIdents "Returns the two last idents of a path"
  input Path inPath;
  output Path outTwoLast;
algorithm
  outTwoLast := match(inPath)
    local
      Path p;

    case QUALIFIED(path = IDENT(name = _)) then inPath;
    case QUALIFIED(path = p) then pathTwoLastIdents(p);
    case FULLYQUALIFIED(path = p) then pathTwoLastIdents(p);
  end match;
end pathTwoLastIdents;

public function pathLastIdent
  "Returns the last ident (after last dot) in a path"
  input Path inPath;
  output Ident outIdent;
algorithm
  outIdent := match(inPath)
    local
      Ident id;
      Path p;

    case QUALIFIED(path = p) then pathLastIdent(p);
    case IDENT(name = id) then id;
    case FULLYQUALIFIED(path = p) then pathLastIdent(p);
  end match;
end pathLastIdent;

public function pathFirstIdent "Returns the first ident (before first dot) in a path"
  input Path inPath;
  output Ident outIdent;
algorithm
  outIdent := match (inPath)
    local
      Ident n;
      Path p;

    case (FULLYQUALIFIED(path = p)) then pathFirstIdent(p);
    case (QUALIFIED(name = n,path = p)) then n;
    case (IDENT(name = n)) then n;
  end match;
end pathFirstIdent;

public function pathSecondIdent
  input Path inPath;
  output Ident outIdent;
algorithm
  outIdent := match(inPath)
    local
      Ident n;
      Path p;

    case QUALIFIED(path = QUALIFIED(name = n)) then n;
    case QUALIFIED(path = IDENT(name = n)) then n;
    case FULLYQUALIFIED(path = p) then pathSecondIdent(p);

  end match;
end pathSecondIdent;

public function pathPrefix
  "Returns the prefix of a path, i.e. this.is.a.path => this.is.a"
  input Path path;
  output Path prefix;
algorithm
  prefix := matchcontinue(path)
    local
      Path p;
      Ident n;

    case (FULLYQUALIFIED(path = p)) then pathPrefix(p);
    case (QUALIFIED(name = n, path = IDENT(name = _))) then IDENT(n);
    case (QUALIFIED(name = n, path = p))
      equation
        p = pathPrefix(p);
      then
        QUALIFIED(n, p);
  end matchcontinue;
end pathPrefix;

public function prefixPath
  "Prefixes a path with an identifier."
  input Ident prefix;
  input Path path;
  output Path outPath;
algorithm
  outPath := QUALIFIED(prefix, path);
end prefixPath;

public function prefixOptPath
  "Prefixes an optional path with an identifier."
  input Ident prefix;
  input Option<Path> optPath;
  output Option<Path> outPath;
algorithm
  outPath := match(prefix, optPath)
    local
      Path path;

    case (_, NONE()) then SOME(IDENT(prefix));
    case (_, SOME(path)) then SOME(QUALIFIED(prefix, path));
  end match;
end prefixOptPath;

public function suffixPath
  "Adds a suffix to a path. Ex:
     suffixPath(a.b.c, 'd') => a.b.c.d"
  input Path inPath;
  input Ident inSuffix;
  output Path outPath;
algorithm
  outPath := match(inPath, inSuffix)
    local
      Ident name;
      Path path;

    case (IDENT(name), _)
      then QUALIFIED(name, IDENT(inSuffix));

    case (QUALIFIED(name, path), _)
      equation
        path = suffixPath(path, inSuffix);
      then
        QUALIFIED(name, path);

    case (FULLYQUALIFIED(path), _)
      equation
        path = suffixPath(path, inSuffix);
      then
        FULLYQUALIFIED(path);

  end match;
end suffixPath;

public function pathSuffixOf "returns true if suffix_path is a suffix of path"
  input Path suffix_path;
  input Path path;
  output Boolean res;
algorithm
  res := matchcontinue(suffix_path,path)
  local Path p;
    case(_,_)
      equation
      true = pathEqual(suffix_path,path);
      then true;
    case(_,FULLYQUALIFIED(path = p))
      then pathSuffixOf(suffix_path,p);
    case(_,QUALIFIED(name=_,path = p))
      then pathSuffixOf(suffix_path,p);
    case(_,_) then false;
  end matchcontinue;
end pathSuffixOf;

public function pathSuffixOfr "returns true if suffix_path is a suffix of path"
  input Path path;
  input Path suffix_path;
  output Boolean res;
algorithm
  res := pathSuffixOf(suffix_path, path);
end pathSuffixOfr;

public function pathToStringList
  input Path path;
  output list<String> outPaths;
algorithm
  outPaths := listReverse(pathToStringListWork(path,{}));
end pathToStringList;

protected function pathToStringListWork
  input Path path;
  input list<String> acc;
  output list<String> outPaths;
algorithm
  outPaths := match(path,acc)
    local
      String n;
      Path p;
      list<String> strings;

    case (IDENT(name = n),_) then n::acc;
    case (FULLYQUALIFIED(path = p),_) then pathToStringListWork(p,acc);
    case (QUALIFIED(name = n,path = p),_)
      then pathToStringListWork(p,n::acc);
  end match;
end pathToStringListWork;

public function pathReplaceFirstIdent "
  Replaces the first part of a path with a replacement path:
  (a.b.c, d.e) => d.e.b.c
  (a, b.c.d) => b.c.d
"
  input Path path;
  input Path replPath;
  output Path outPath;
algorithm
  outPath := match(path,replPath)
    local
      Path p;
    // Should not be possible to replace FQ paths
    case (QUALIFIED(path = p), _) then joinPaths(replPath,p);
    case (IDENT(name = _), _) then replPath;
  end match;
end pathReplaceFirstIdent;

public function addSubscriptsLast "
Function for appending subscripts at end on last ident"
  input ComponentRef icr;
  input list<Subscript> i;
  output ComponentRef ocr;
algorithm
  ocr := match(icr,i)
    local
      list<Subscript> subs;
      String id;
      ComponentRef cr;
    case (CREF_IDENT(id,subs),_)
      equation
        subs = listAppend(subs,i);
      then
        CREF_IDENT(id,subs);
    case (CREF_QUAL(id,subs,cr),_)
      equation
        cr = addSubscriptsLast(cr,i);
      then
        CREF_QUAL(id,subs,cr);
    case (CREF_FULLYQUALIFIED(cr),_)
      equation
        cr = addSubscriptsLast(cr,i);
      then
        crefMakeFullyQualified(cr);
  end match;
end addSubscriptsLast;

public function crefReplaceFirstIdent "
  Replaces the first part of a cref with a replacement path:
  (a[4].b.c[3], d.e) => d.e[4].b.c[3]
  (a[3], b.c.d) => b.c.d[3]
"
  input ComponentRef icref;
  input Path replPath;
  output ComponentRef outCref;
algorithm
  outCref := match(icref,replPath)
    local
      list<Subscript> subs;
      ComponentRef cr,cref;
    case (CREF_FULLYQUALIFIED(componentRef = cr),_)
      equation
        cr = crefReplaceFirstIdent(cr,replPath);
      then crefMakeFullyQualified(cr);
    case (CREF_QUAL(componentRef = cr, subscripts = subs),_)
      equation
        cref = pathToCref(replPath);
        cref = addSubscriptsLast(cref,subs);
      then joinCrefs(cref,cr);
    case (CREF_IDENT(subscripts = subs),_)
      equation
        cref = pathToCref(replPath);
        cref = addSubscriptsLast(cref,subs);
      then cref;
  end match;
end crefReplaceFirstIdent;

public function pathPrefixOf
  "Returns true if prefixPath is a prefix of path, false otherwise."
  input Path prefixPath;
  input Path path;
  output Boolean isPrefix;
algorithm
  isPrefix := matchcontinue(prefixPath, path)
    local
      Path p, p2;
      String id, id2;
    case (FULLYQUALIFIED(p), p2) then pathPrefixOf(p, p2);
    case (p, FULLYQUALIFIED(p2)) then pathPrefixOf(p, p2);
    case (IDENT(id), IDENT(id2)) then stringEq(id, id2);
    case (IDENT(id), QUALIFIED(name = id2)) then stringEq(id, id2);
    case (QUALIFIED(id, p), QUALIFIED(id2, p2))
      equation
        true = stringEq(id, id2);
        true = pathPrefixOf(p, p2);
      then
        true;
    case (_, _) then false;
  end matchcontinue;
end pathPrefixOf;

public function crefPrefixOf
"Alternative names: crefIsPrefixOf, isPrefixOf, prefixOf
  Author: DH 2010-03

  Returns true if prefixCr is a prefix of cr, i.e., false otherwise.
  Subscripts are NOT checked."
  input ComponentRef prefixCr;
  input ComponentRef cr;
  output Boolean out;
algorithm
  out := matchcontinue(prefixCr, cr)
    case(_, _)
      equation
        true = crefEqualNoSubs(prefixCr, cr);
      then true;
    case(_, _)
      then crefPrefixOf(prefixCr, crefStripLast(cr));
    case(_, _) then false;
  end matchcontinue;
end crefPrefixOf;

public function removePrefix "removes the prefix_path from path, and returns the rest of path"
  input Path prefix_path;
  input Path path;
  output Path newPath;
algorithm
  newPath := match(prefix_path,path)
    local Path p,p2; Ident id1,id2;
    // fullyqual path
    case (p,FULLYQUALIFIED(p2)) then removePrefix(p,p2);
    // qual
    case (QUALIFIED(name=id1,path=p),QUALIFIED(name=id2,path=p2))
      equation
        true = stringEq(id1, id2);
      then
        removePrefix(p,p2);
    // ids
    case(IDENT(id1),QUALIFIED(name=id2,path=p2))
      equation
        true = stringEq(id1, id2);
      then p2;
  end match;
end removePrefix;

public function removePartialPrefix
  "Tries to remove a given prefix from a path with removePrefix. If it fails it
  removes the first identifier in the prefix and tries again, until it either
  succeeds or reaches the end of the prefix. Ex:
    removePartialPrefix(A.B.C, B.C.D.E) => D.E
  "
  input Path inPrefix;
  input Path inPath;
  output Path outPath;
algorithm
  outPath := matchcontinue(inPrefix, inPath)
    local
      Path p;

    case (_, _)
      equation
        p = removePrefix(inPrefix, inPath);
      then
        p;

    case (QUALIFIED(path = p), _)
      equation
        p = removePrefix(p, inPath);
      then
        p;

    case (FULLYQUALIFIED(path = p), _)
      equation
        p = removePartialPrefix(p, inPath);
      then
        p;

    else inPath;
  end matchcontinue;
end removePartialPrefix;

public function crefRemovePrefix
"
  function: crefRemovePrefix
  Alternative names: removePrefix
  Author: DH 2010-03

  If prefixCr is a prefix of cr, removes prefixCr from cr and returns the remaining reference,
  otherwise fails. Subscripts are NOT checked.
"
  input ComponentRef prefixCr;
  input ComponentRef cr;
  output ComponentRef out;
algorithm
  out := matchcontinue(prefixCr, cr)
    local
      Ident prefixIdent, ident;
      ComponentRef prefixRestCr, restCr;
    // fqual
    case(CREF_FULLYQUALIFIED(componentRef = prefixRestCr), CREF_FULLYQUALIFIED(componentRef = restCr))
      then
        crefRemovePrefix(prefixRestCr, restCr);
    // qual
    case(CREF_QUAL(name = prefixIdent, componentRef = prefixRestCr), CREF_QUAL(name = ident, componentRef = restCr))
      equation
        true = stringEq(prefixIdent, ident);
      then
        crefRemovePrefix(prefixRestCr, restCr);
    // id vs. qual
    case(CREF_IDENT(name = prefixIdent), CREF_QUAL(name = ident, componentRef = restCr))
      equation
        true = stringEq(prefixIdent, ident);
      then restCr;
    // id vs. id
    case(CREF_IDENT(name = prefixIdent), CREF_IDENT(name = ident))
      equation
        true = stringEq(prefixIdent, ident);
      then CREF_IDENT("", {});
  end matchcontinue;
end crefRemovePrefix;

public function pathContains "
Author BZ,
checks if one IDENT(..) is contained in path."
  input Path fullPath;
  input Path pathId;
  output Boolean b;
algorithm
  b := match (fullPath,pathId)
    local
      String str1,str2;
      Path qp;
      Boolean b1,b2;

    case(IDENT(str1),IDENT(str2)) then stringEq(str1,str2);

    case(QUALIFIED(str1,qp),IDENT(str2))
      equation
        b1 = stringEq(str1,str2);
        b2 = pathContains(qp,pathId);
        b1 = boolOr(b1,b2);
      then
        b1;

    case(FULLYQUALIFIED(qp),_) then pathContains(qp,pathId);
  end match;
end pathContains;

public function pathContainsString "
Author OT,
checks if Path contains the given string."
  input Path p1;
  input String str;
  output Boolean b;
algorithm
  b := matchcontinue(p1,str)
    local
      String str1,searchStr;
      Path qp;
      Boolean b1,b2,b3;

    case(IDENT(str1),searchStr)
      equation
        b1 = System.stringFind(str1,searchStr) <> -1;
      then b1;

    case(QUALIFIED(str1,qp),searchStr)
      equation
        b1 = System.stringFind(str1, searchStr) <> -1;
        b2 = pathContainsString(qp, searchStr);
        b3 = boolOr(b1, b2);
      then
        b3;

    case(FULLYQUALIFIED(qp), searchStr)
    then pathContainsString(qp, searchStr);
  end matchcontinue;
end pathContainsString;

public function pathContainedIn "This function checks if subPath is contained in path.
If it is the complete path is returned. Otherwise the function fails.
For example,
pathContainedIn( C.D, A.B.C) => A.B.C.D
pathContainedIn(C.D, A.B.C.D) => A.B.C.D
pathContainedIn(A.B.C.D, A.B.C.D) => A.B.C.D
pathContainedIn(B.C,A.B) => A.B.C"
  input Path subPath;
  input Path path;
  output Path completePath;
algorithm
  completePath := matchcontinue(subPath,path)
    local
      Ident ident;
      Path newPath,newSubPath;
    // A suffix, e.g. C.D in A.B.C.D
    case (_,_)
      equation
        true=pathSuffixOf(subPath,path);
      then path;
     // strip last ident of path and recursively check if suffix.
    case (_,_)
      equation
        ident = pathLastIdent(path);
        newPath = stripLast(path);
        newPath=pathContainedIn(subPath,newPath);
      then joinPaths(newPath,IDENT(ident));

        // strip last ident of subpath and recursively check if suffix.
    case (_,_)
      equation
        ident = pathLastIdent(subPath);
        newSubPath = stripLast(subPath);
        newSubPath=pathContainedIn(newSubPath,path);
      then joinPaths(newSubPath,IDENT(ident));
  end matchcontinue;
end pathContainedIn;

public function getCrefsFromSubs "
Author BZ 2009-08
Function for getting ComponentRefs out from Subscripts"
  input list<Subscript> isubs;
  input Boolean includeSubs "include crefs from array subscripts";
  input Boolean includeFunctions "note that if you say includeSubs = false then you won't get the functions from array subscripts";
  output list<ComponentRef> crefs;
algorithm 
  crefs := match(isubs,includeSubs,includeFunctions)
    local
      list<ComponentRef> crefs1;
      Exp exp;
      list<Subscript> subs;
    
    case({},_,_) then {};
    
    case(NOSUB()::subs,_,_) then getCrefsFromSubs(subs,includeSubs,includeFunctions);
    
    case(SUBSCRIPT(exp)::subs,_,_)
      equation
        crefs1 = getCrefsFromSubs(subs,includeSubs,includeFunctions);
        crefs = getCrefFromExp(exp,includeSubs,includeFunctions);
        crefs = listAppend(crefs,crefs1);
        //crefs = List.unionOnTrue(crefs,crefs1,crefEqual);
      then
        crefs;
  end match;
end getCrefsFromSubs;

public function getCrefFromExp "
  Returns a flattened list of the
  component references in an expression"
  input Exp inExp;
  input Boolean includeSubs "include crefs from array subscripts";
  input Boolean includeFunctions "note that if you say includeSubs = false then you won't get the functions from array subscripts";
  output list<ComponentRef> outComponentRefLst;
algorithm
  outComponentRefLst := matchcontinue (inExp,includeSubs,includeFunctions)
    local
      ComponentRef cr;
      list<ComponentRef> l1,l2,res;
      ComponentCondition e1,e2,e3;
      Operator op;
      list<tuple<ComponentCondition, ComponentCondition>> e4;
      FunctionArgs farg;
      list<ComponentCondition> expl;
      list<list<ComponentCondition>> expll;
      list<Subscript> subs;
      list<list<ComponentRef>> lstres1;
      list<list<ComponentRef>> crefll;

    case (INTEGER(value = _),_,_) then {};
    case (REAL(value = _),_,_) then {};
    case (STRING(value = _),_,_) then {};
    case (BOOL(value = _),_,_) then {};
    case (CREF(componentRef = ALLWILD()),_,_) then {};
    case (CREF(componentRef = WILD()),_,_) then {};
    case (CREF(componentRef = cr),false,_) then {cr};

    case (CREF(componentRef = (cr)),true,_)
      equation
        subs = getSubsFromCref(cr,includeSubs,includeFunctions);
        l1 = getCrefsFromSubs(subs,includeSubs,includeFunctions);
      then cr::l1;

    case (BINARY(exp1 = e1,op = op,exp2 = e2),_,_)
      equation
        l1 = getCrefFromExp(e1,includeSubs,includeFunctions);
        l2 = getCrefFromExp(e2,includeSubs,includeFunctions);
        res = listAppend(l1, l2);
      then
        res;
    
    case (UNARY(op = op,exp = e1),_,_)
      equation
        res = getCrefFromExp(e1,includeSubs,includeFunctions);
      then
        res;
    
    case (LBINARY(exp1 = e1,op = op,exp2 = e2),_,_)
      equation
        l1 = getCrefFromExp(e1,includeSubs,includeFunctions);
        l2 = getCrefFromExp(e2,includeSubs,includeFunctions);
        res = listAppend(l1, l2);
      then
        res;
    
    case (LUNARY(op = op,exp = e1),_,_)
      equation
        res = getCrefFromExp(e1,includeSubs,includeFunctions);
      then
        res;
    
    case (RELATION(exp1 = e1,op = op,exp2 = e2),_,_)
      equation
        l1 = getCrefFromExp(e1,includeSubs,includeFunctions);
        l2 = getCrefFromExp(e2,includeSubs,includeFunctions);
        res = listAppend(l1, l2);
      then
        res;
    
    case (IFEXP(ifExp = e1,trueBranch = e2,elseBranch = e3,elseIfBranch = e4),_,_)
      equation
        l1 = getCrefFromExp(e1,includeSubs,includeFunctions);
        l2 = getCrefFromExp(e2,includeSubs,includeFunctions);
        l1 = listAppend(l1, l2);
        l2 = getCrefFromExp(e3,includeSubs,includeFunctions);
        res = listAppend(l1, l2) "TODO elseif\'s e4";
      then
        res;
    
    case (CALL(function_ = cr, functionArgs = farg),_,_)
      equation
        res = getCrefFromFarg(farg,includeSubs,includeFunctions);
        res = Util.if_(includeFunctions, cr::res, res);
      then
        res;
    case (PARTEVALFUNCTION(function_ = cr, functionArgs = farg),_,_)
      equation
        res = getCrefFromFarg(farg,includeSubs,includeFunctions);
        res = Util.if_(includeFunctions, cr::res, res);
      then
        res;
    case (ARRAY(arrayExp = expl),_,_)
      equation
        lstres1 = List.map2(expl, getCrefFromExp, includeSubs, includeFunctions);
        res = List.flatten(lstres1);
      then
        res;
    case (MATRIX(matrix = expll),_,_)
      equation
        res = List.flatten(List.flatten(List.map2List(expll, getCrefFromExp, includeSubs, includeFunctions)));
      then
        res;
    case (RANGE(start = e1,step = SOME(e3),stop = e2),_,_)
      equation
        l1 = getCrefFromExp(e1,includeSubs,includeFunctions);
        l2 = getCrefFromExp(e2,includeSubs,includeFunctions);
        l2 = listAppend(l1, l2);
        l2 = getCrefFromExp(e3,includeSubs,includeFunctions);
        res = listAppend(l1, l2);
      then
        res;
    case (RANGE(start = e1,step = NONE(),stop = e2),_,_)
      equation
        l1 = getCrefFromExp(e1,includeSubs,includeFunctions);
        l2 = getCrefFromExp(e2,includeSubs,includeFunctions);
        res = listAppend(l1, l2);
      then
        res;
    
    case (END(),_,_) then {};

    case (TUPLE(expressions = expl),_,_)
      equation
        crefll = List.map2(expl,getCrefFromExp,includeSubs,includeFunctions);
        res = List.flatten(crefll);
      then
        res;

    case (CODE(_),_,_) then {};

    case (AS(exp = e1),_,_) then getCrefFromExp(e1,includeSubs,includeFunctions);
    
    case (CONS(e1,e2),_,_)
      equation
        l1 = getCrefFromExp(e1,includeSubs,includeFunctions);
        l2 = getCrefFromExp(e2,includeSubs,includeFunctions);
        res = listAppend(l1, l2);
      then
        res;

    case (LIST(expl),_,_)
      equation
        crefll = List.map2(expl,getCrefFromExp,includeSubs,includeFunctions);
        res = List.flatten(crefll);
      then
        res;

    case (MATCHEXP(matchTy = _),_,_) then fail();

    case (e1,_,_)
      equation
        print("Internal error: getCrefFromExp failed " +& Dump.printExpStr(e1) +& "\n");
      then fail();
  end matchcontinue;
end getCrefFromExp;

public function getCrefFromFarg "Returns the flattened list of all component references
  present in a list of function arguments."
  input FunctionArgs inFunctionArgs;
  input Boolean includeSubs "include crefs from array subscripts";
  input Boolean includeFunctions "note that if you say includeSubs = false then you won't get the functions from array subscripts";
  output list<ComponentRef> outComponentRefLst;
algorithm 
  outComponentRefLst := match (inFunctionArgs,includeSubs,includeFunctions)
    local
      list<list<ComponentRef>> l1,l2;
      list<ComponentRef> fl1,fl2,fl3,res;
      list<ComponentCondition> expl;
      list<NamedArg> nargl;
      ForIterators iterators;
      Exp exp;
    
    case (FUNCTIONARGS(args = expl,argNames = nargl),_,_)
      equation
        l1 = List.map2(expl, getCrefFromExp, includeSubs, includeFunctions);
        fl1 = List.flatten(l1);
        l2 = List.map2(nargl, getCrefFromNarg, includeSubs, includeFunctions);
        fl2 = List.flatten(l2);
        res = listAppend(fl1, fl2);
      then
        res;
    
    case (FOR_ITER_FARG(exp,iterators),_,_)
      equation
        l1 = List.map2Option(List.map(iterators,iteratorRange),getCrefFromExp,includeSubs,includeFunctions);
        l2 = List.map2Option(List.map(iterators,iteratorGuard),getCrefFromExp,includeSubs,includeFunctions);
        fl1 = List.flatten(l1);
        fl2 = List.flatten(l2);
        fl3 = getCrefFromExp(exp,includeSubs,includeFunctions);
        res = listAppend(fl1,listAppend(fl2, fl3));
      then
        res;
        
  end match;
end getCrefFromFarg;

public function iteratorName
  input ForIterator iterator;
  output String name;
algorithm
  ITERATOR(name=name) := iterator;
end iteratorName;

public function iteratorRange
  input ForIterator iterator;
  output Option<Exp> range;
algorithm
  ITERATOR(range=range) := iterator;
end iteratorRange;

public function iteratorGuard
  input ForIterator iterator;
  output Option<Exp> guardExp;
algorithm
  ITERATOR(guardExp=guardExp) := iterator;
end iteratorGuard;

// stefan
public function getNamedFuncArgNamesAndValues
"returns the names from a list of NamedArgs as a string list"
  input list<NamedArg> inNamedArgList;
  output list<String> outStringList;
  output list<Exp> outExpList;
algorithm
  (outStringList,outExpList) := match ( inNamedArgList )
    local
      list<NamedArg> cdr;
      String s;
      Exp e;
      list<String> slst;
      list<Exp> elst;

    case ({})  then ({},{});
    case (NAMEDARG(argName=s,argValue=e) :: cdr)
      equation
        (slst,elst) = getNamedFuncArgNamesAndValues(cdr);
      then
        (s :: slst, e :: elst);
  end match;
end getNamedFuncArgNamesAndValues;

protected function getCrefFromNarg "Returns the flattened list of all component references
  present in a list of named function arguments."
  input NamedArg inNamedArg;
  input Boolean includeSubs "include crefs from array subscripts";
  input Boolean includeFunctions "note that if you say includeSubs = false then you won't get the functions from array subscripts";
  output list<ComponentRef> outComponentRefLst;
algorithm 
  outComponentRefLst := match (inNamedArg,includeSubs,includeFunctions)
    local
      list<ComponentRef> res;
      ComponentCondition exp;
    case (NAMEDARG(argValue = exp),_,_)
      equation
        res = getCrefFromExp(exp,includeSubs,includeFunctions);
      then
        res;
  end match;
end getCrefFromNarg;

public function joinPaths "This function joins two paths"
  input Path inPath1;
  input Path inPath2;
  output Path outPath;
algorithm
  outPath := match (inPath1,inPath2)
    local
      Ident str;
      Path p2,p_1,p;
    case (IDENT(name = str),p2) then QUALIFIED(str,p2);
    case (QUALIFIED(name = str,path = p),p2)
      equation
        p_1 = joinPaths(p, p2);
      then
        QUALIFIED(str,p_1);
    case(FULLYQUALIFIED(p),p2) then joinPaths(p,p2);
    case(p,FULLYQUALIFIED(p2)) then joinPaths(p,p2);
  end match;
end joinPaths;

public function joinPathsOpt "This function joins two paths when the first one might be NONE"
  input Option<Path> inPath1;
  input Path inPath2;
  output Path outPath;
algorithm
  outPath := match (inPath1,inPath2)
    local Path p;
    case (NONE(), _) then inPath2;
    case (SOME(p), _) then joinPaths(p, inPath2);
  end match;
end joinPathsOpt;

public function joinPathsOptSuffix
  input Path inPath1;
  input Option<Path> inPath2;
  output Path outPath;
algorithm
  outPath := match(inPath1, inPath2)
    local
      Path p;

    case (_, SOME(p)) then joinPaths(inPath1, p);
    else inPath1;

  end match;
end joinPathsOptSuffix;

public function selectPathsOpt "This function selects the second path when the first one
  is NONE() otherwise it will select the first one."
  input Option<Path> inPath1;
  input Path inPath2;
  output Path outPath;
algorithm
  outPath := match (inPath1,inPath2)
    local
      Path p;
    case (NONE(), p) then p;
    case (SOME(p),_) then p;
  end match;
end selectPathsOpt;

public function pathAppendList "author Lucian
  This function joins a path list"
  input list<Path> inPathLst;
  output Path outPath;
algorithm
  outPath := match (inPathLst)
    local
      Path path,res_path,first;
      list<Path> rest;
    case ({}) then IDENT("");
    case ((path :: {})) then path;
    case ((first :: rest))
      equation
        path = pathAppendList(rest);
        res_path = joinPaths(first, path);
      then
        res_path;
  end match;
end pathAppendList;

public function stripLast "Returns the path given as argument to
  the function minus the last ident."
  input Path inPath;
  output Path outPath;
algorithm
  outPath := match (inPath)
    local
      Ident str;
      Path p;

    case QUALIFIED(name = str, path = IDENT(name = _)) 
      then IDENT(str);

    case QUALIFIED(name = str, path = p)
      equation
        p = stripLast(p);
      then
        QUALIFIED(str, p);

    case FULLYQUALIFIED(p)
      equation
        p = stripLast(p);
      then
        FULLYQUALIFIED(p);

  end match;
end stripLast;

public function stripLastOpt
  input Path inPath;
  output Option<Path> outPath;
algorithm
  outPath := match(inPath)
    local
      Path p;

    case IDENT(name = _) then NONE();

    else
      equation
        p = stripLast(inPath);
      then
        SOME(p);

  end match;
end stripLastOpt;

public function crefStripLast "Returns the path given as argument to
  the function minus the last ident."
  input ComponentRef inCref;
  output ComponentRef outCref;
algorithm
  outCref := match (inCref)
    local
      Ident str;
      ComponentRef c_1, c;
      list<Subscript> subs;

    case (CREF_IDENT(name = _)) then fail();
    case (CREF_QUAL(name = str,subscripts = subs, componentRef = CREF_IDENT(name = _))) then CREF_IDENT(str,subs);
    case (CREF_QUAL(name = str,subscripts = subs,componentRef = c))
      equation
        c_1 = crefStripLast(c);
      then
        CREF_QUAL(str,subs,c_1);
    case (CREF_FULLYQUALIFIED(componentRef = c))
      equation
        c_1 = crefStripLast(c);
      then
        crefMakeFullyQualified(c_1);
  end match;
end crefStripLast;

public function splitQualAndIdentPath "
Author BZ 2008-04
Function for splitting Absynpath into two parts,
qualified part, and ident part (all_but_last, last);
"
  input Path inPath;
  output Path outPath1;
  output Path outPath2;
algorithm (outPath1,outPath2) := match(inPath)
  local
    Path qPath,curPath,identPath;
    String s1,s2;

  case (QUALIFIED(name = s1, path = IDENT(name = s2)))
    then (IDENT(s1), IDENT(s2));

  case (QUALIFIED(name = s1, path = qPath))
    equation
      (curPath, identPath) = splitQualAndIdentPath(qPath);
    then
      (QUALIFIED(s1, curPath), identPath);

  case (FULLYQUALIFIED(qPath))
    equation
      (curPath, identPath) = splitQualAndIdentPath(qPath);
    then
      (curPath, identPath);
  end match;
end splitQualAndIdentPath;

public function stripFirst "Returns the path given as argument
  to the function minus the first ident."
  input Path inPath;
  output Path outPath;
algorithm
  outPath:=
  matchcontinue (inPath)
    local
      Path p;
    case (QUALIFIED(name = _,path = p)) then p;
    case(FULLYQUALIFIED(p)) then stripFirst(p);
  end matchcontinue;
end stripFirst;

public function crefToPath "This function converts a ComponentRef to a Path, if possible.
  If the component reference contains subscripts, it will silently fail."
  input ComponentRef inComponentRef;
  output Path outPath;
algorithm
  outPath:=
  match (inComponentRef)
    local
      Ident i;
      Path p;
      ComponentRef c;
    case CREF_IDENT(name = i,subscripts = {}) then IDENT(i);
    case CREF_QUAL(name = i,subscripts = {},componentRef = c)
      equation
        p = crefToPath(c);
      then
        QUALIFIED(i,p);
    case CREF_FULLYQUALIFIED(componentRef = c)
      equation
        p = crefToPath(c);
      then
        FULLYQUALIFIED(p);
  end match;
end crefToPath;

public function crefToPathIgnoreSubs
  "Converts a ComponentRef to a Path, ignoring any subscripts."
  input ComponentRef inComponentRef;
  output Path outPath;
algorithm
  outPath := match(inComponentRef)
    local
      Ident i;
      Path p;
      ComponentRef c;

    case CREF_IDENT(name = i) then IDENT(i);

    case CREF_QUAL(name = i, componentRef = c)
      equation
        p = crefToPathIgnoreSubs(c);
      then
        QUALIFIED(i, p);

    case CREF_FULLYQUALIFIED(componentRef = c)
      equation
        p = crefToPathIgnoreSubs(c);
      then
        FULLYQUALIFIED(p);
  end match;
end crefToPathIgnoreSubs;

public function pathToCref "This function converts a Path to a ComponentRef."
  input Path inPath;
  output ComponentRef outComponentRef;
algorithm
  outComponentRef:=
  match (inPath)
    local
      Ident i;
      ComponentRef c;
      Path p;
    case IDENT(name = i) then CREF_IDENT(i,{});
    case QUALIFIED(name = i,path = p)
      equation
        c = pathToCref(p);
      then
        CREF_QUAL(i,{},c);
    case(FULLYQUALIFIED(p))
      equation
        c = pathToCref(p);
      then crefMakeFullyQualified(c);
  end match;
end pathToCref;

public function pathToCrefWithSubs
  "This function converts a Path to a ComponentRef, and applies the given
  subscripts to the last identifier."
  input Path inPath;
  input list<Subscript> inSubs;
  output ComponentRef outComponentRef;
algorithm
  outComponentRef := match(inPath, inSubs)
    local
      Ident i;
      ComponentRef c;
      Path p;

    case (IDENT(name = i), _) then CREF_IDENT(i, inSubs);

    case (QUALIFIED(name = i, path = p), _)
      equation
        c = pathToCrefWithSubs(p, inSubs);
      then
        CREF_QUAL(i, {}, c);

    case (FULLYQUALIFIED(p), _)
      equation
        c = pathToCrefWithSubs(p, inSubs);
      then
        crefMakeFullyQualified(c);
  end match;
end pathToCrefWithSubs;

public function crefFirstIdent "
Returns the base-name of the componentReference"
  input ComponentRef inComponentRef;
  output String str;
algorithm str := match(inComponentRef)
  local
    String ret;
    ComponentRef cr;
  case(CREF_IDENT(ret,_)) then ret;
  case(CREF_QUAL(ret,_,_)) then ret;
  case(CREF_FULLYQUALIFIED(cr)) then crefFirstIdent(cr);
end match;
end crefFirstIdent;

public function crefFirstIdentNoSubs
  "Returns the basename of the component reference, but fails if it encounters
  any subscripts."
  input ComponentRef inCref;
  output Ident outIdent;
algorithm
  outIdent := match(inCref)
    local
      Ident id;
      ComponentRef cr;
    case CREF_IDENT(name = id, subscripts = {}) then id;
    case CREF_QUAL(name = id, subscripts = {}) then id;
    case CREF_FULLYQUALIFIED(componentRef = cr) then crefFirstIdentNoSubs(cr);
  end match;
end crefFirstIdentNoSubs;

public function crefIsIdent
  "Returns true if the component reference is a simple identifier, otherwise false."
  input ComponentRef inComponentRef;
  output Boolean outIsIdent;
algorithm
  outIsIdent := match(inComponentRef)
    case CREF_IDENT(name = _) then true;
    else false;
  end match;
end crefIsIdent;

public function crefIsQual
  "Returns true if the component reference is a qualified identifier, otherwise false."
  input ComponentRef inComponentRef;
  output Boolean outIsQual;
algorithm
  outIsQual := match(inComponentRef)
    case CREF_QUAL(name = _) then true;
    case CREF_FULLYQUALIFIED(componentRef = _) then true;
    else false;
  end match;
end crefIsQual;

public function crefLastSubs "Return the last subscripts of an ComponentRef"
  input ComponentRef inComponentRef;
  output list<Subscript> outSubscriptLst;
algorithm
  outSubscriptLst:=
  match (inComponentRef)
    local
      Ident id;
      list<Subscript> subs,res;
      ComponentRef cr;
    case (CREF_IDENT(name = id,subscripts= subs)) then subs;
    case (CREF_QUAL(componentRef = cr))
      equation
        res = crefLastSubs(cr);
      then
        res;
    case (CREF_FULLYQUALIFIED(componentRef = cr))
      equation
        res = crefLastSubs(cr);
      then
        res;
  end match;
end crefLastSubs;

public function crefHasSubscripts "This function finds if a cref has subscripts"
  input ComponentRef inComponentRef;
  output Boolean outHasSubscripts;
algorithm
  outHasSubscripts := match (inComponentRef)
    local
      Ident i;
      Boolean b;
      ComponentRef c;

    case CREF_IDENT(name = i,subscripts = {}) then false;

    case CREF_QUAL(name = i,subscripts = {},componentRef = c)
      equation
        b = crefHasSubscripts(c);
      then
        b;

    case CREF_FULLYQUALIFIED(componentRef = c)
      equation
        b = crefHasSubscripts(c);
      then
        b;
  end match;
end crefHasSubscripts;

public function getSubsFromCref "
Author: BZ, 2009-09
 Extract subscripts of crefs."
  input ComponentRef cr;
  input Boolean includeSubs "include crefs from array subscripts";
  input Boolean includeFunctions "note that if you say includeSubs = false then you won't get the functions from array subscripts";
  output list<Subscript> subscripts;
algorithm 
  subscripts := match(cr,includeSubs,includeFunctions)
    local
      list<Subscript> subs2;
      ComponentRef child;
    
    case(CREF_IDENT(_,subs2), _, _) then subs2;
    
    case(CREF_QUAL(_,subs2,child), _, _)
      equation
        subscripts = getSubsFromCref(child, includeSubs, includeFunctions);
        subscripts = List.unionOnTrue(subscripts,subs2, subscriptEqual);
      then
        subscripts;
    
    case(CREF_FULLYQUALIFIED(child), _, _)
      equation
        subscripts = getSubsFromCref(child, includeSubs, includeFunctions);
      then
        subscripts;  
  end match;
end getSubsFromCref;

// stefan
public function crefGetLastIdent
"Gets the last ident in a ComponentRef"
  input ComponentRef inComponentRef;
  output ComponentRef outComponentRef;
algorithm
  outComponentRef := match (inComponentRef)
    local
      ComponentRef cref,cref_1;
      Ident id;
      list<Subscript> subs;
    case(CREF_IDENT(id,subs)) then CREF_IDENT(id,subs);
    case(CREF_QUAL(id,subs,cref))
      equation
        cref_1 = crefGetLastIdent(cref);
      then
        cref_1;
    case(CREF_FULLYQUALIFIED(cref))
      equation
        cref_1 = crefGetLastIdent(cref);
      then
        cref_1;
  end match;
end crefGetLastIdent;

public function crefStripLastSubs "Strips the last subscripts of a ComponentRef"
  input ComponentRef inComponentRef;
  output ComponentRef outComponentRef;
algorithm
  outComponentRef:=
  match (inComponentRef)
    local
      Ident id;
      list<Subscript> subs,s;
      ComponentRef cr_1,cr;
    case (CREF_IDENT(name = id,subscripts= subs)) then CREF_IDENT(id,{});
    case (CREF_QUAL(name= id,subscripts= s,componentRef = cr))
      equation
        cr_1 = crefStripLastSubs(cr);
      then
        CREF_QUAL(id,s,cr_1);
    case (CREF_FULLYQUALIFIED(componentRef = cr))
      equation
        cr_1 = crefStripLastSubs(cr);
      then
        crefMakeFullyQualified(cr_1);
  end match;
end crefStripLastSubs;

public function joinCrefs "This function joins two ComponentRefs."
  input ComponentRef inComponentRef1;
  input ComponentRef inComponentRef2;
  output ComponentRef outComponentRef;
algorithm
  outComponentRef:=
  match (inComponentRef1,inComponentRef2)
    local
      Ident id;
      list<Subscript> sub;
      ComponentRef cr2,cr_1,cr;
    case (CREF_IDENT(name = id,subscripts = sub),cr2)
      equation
        failure(CREF_FULLYQUALIFIED(_) = cr2);
      then CREF_QUAL(id,sub,cr2);
    case (CREF_QUAL(name = id,subscripts = sub,componentRef = cr),cr2)
      equation
        cr_1 = joinCrefs(cr, cr2);
      then
        CREF_QUAL(id,sub,cr_1);
    case (CREF_FULLYQUALIFIED(componentRef = cr),cr2)
      equation
        cr_1 = joinCrefs(cr, cr2);
      then
        crefMakeFullyQualified(cr_1);
  end match;
end joinCrefs;

public function crefGetFirst "Returns first ident from a ComponentRef"
  input ComponentRef inComponentRef;
  output ComponentRef outComponentRef;
algorithm
  outComponentRef:=
  matchcontinue (inComponentRef)
    local
      Ident i;
      ComponentRef cr;
    case (CREF_IDENT(name = i)) then CREF_IDENT(i,{});
    case (CREF_QUAL(name = i)) then CREF_IDENT(i,{});
    case (CREF_FULLYQUALIFIED(cr)) then crefGetFirst(cr);
  end matchcontinue;
end crefGetFirst;

public function crefStripFirst "Strip the first ident from a ComponentRef"
  input ComponentRef inComponentRef;
  output ComponentRef outComponentRef;
algorithm
  outComponentRef:=
  match (inComponentRef)
    local ComponentRef cr;
    case CREF_QUAL(componentRef = cr) then cr;
    case CREF_FULLYQUALIFIED(componentRef = cr) then crefStripFirst(cr);
  end match;
end crefStripFirst;

public function crefMakeFullyQualified
  "Makes a component reference fully qualified unless it already is."
  input ComponentRef inComponentRef;
  output ComponentRef outComponentRef;
algorithm
  outComponentRef := match(inComponentRef)
    case CREF_FULLYQUALIFIED(componentRef = _) then inComponentRef;
    else CREF_FULLYQUALIFIED(inComponentRef);
  end match;
end crefMakeFullyQualified;

public function restrString "Maps a class restriction to the corresponding string for printing"
  input Restriction inRestriction;
  output String outString;
algorithm
  outString:=
  match (inRestriction)
    case R_CLASS() then "CLASS";
    case R_OPTIMIZATION() then "OPTIMIZATION";
    case R_MODEL() then "MODEL";
    case R_RECORD() then "RECORD";
    case R_BLOCK() then "BLOCK";
    case R_CONNECTOR() then "CONNECTOR";
    case R_EXP_CONNECTOR() then "EXPANDABLE CONNECTOR";
    case R_TYPE() then "TYPE";
    case R_PACKAGE() then "PACKAGE";
    case R_FUNCTION(FR_NORMAL_FUNCTION(PURE())) then "PURE FUNCTION";
    case R_FUNCTION(FR_NORMAL_FUNCTION(IMPURE())) then "IMPURE FUNCTION";
    case R_FUNCTION(FR_NORMAL_FUNCTION(NO_PURITY())) then "FUNCTION";
    case R_FUNCTION(FR_OPERATOR_FUNCTION()) then "OPERATOR FUNCTION";
    case R_PREDEFINED_INTEGER() then "PREDEFINED_INT";
    case R_PREDEFINED_REAL() then "PREDEFINED_REAL";
    case R_PREDEFINED_STRING() then "PREDEFINED_STRING";
    case R_PREDEFINED_BOOLEAN() then "PREDEFINED_BOOL";

    /* MetaModelica restriction */
    case R_UNIONTYPE() then "UNIONTYPE";
    else "* Unknown restriction *";
  end match;
end restrString;

public function lastClassname "Returns the path (=name) of the last class in a program"
  input Program inProgram;
  output Path outPath;
algorithm
  outPath:=
  match (inProgram)
    local
      Ident id;
      list<Class> lst;
    case (PROGRAM(classes = lst))
      equation
        CLASS(id,_,_,_,_,_,_) = List.last(lst);
      then
        IDENT(id);
  end match;
end lastClassname;

public function classFilename "author: PA
  Retrieves the filename where the class is stored."
  input Class inClass;
  output String outString;
algorithm
  outString:=
  match (inClass)
    local Ident filename;
    case (CLASS(info = INFO(fileName = filename))) then filename;
  end match;
end classFilename;

public function setClassFilename "author: PA
  Sets the filename where the class is stored."
  input Class inClass;
  input String inString;
  input TimeStamp build1;
  output Class outClass;
algorithm
  outClass:=
  match (inClass,inString,build1)
    local
      Ident n,filename;
      Boolean p,f,e;
      Restriction r;
      ClassDef body;
      TimeStamp build;
    case (CLASS(name = n,partialPrefix = p,finalPrefix = f,encapsulatedPrefix = e,restriction = r,body = body),filename,build)
      then CLASS(n,p,f,e,r,body,INFO(filename,false,0,0,0,0, build)  );
  end match;
end setClassFilename;

public function emptyClassInfo "
Return a class info with no content
"
output Info info;
algorithm
  info := dummyInfo; //INFO("",false,0,0,0,0,TIMESTAMP(0.0,0.0));
end emptyClassInfo;

public function setClassName "author: BZ
  Sets the name of the class"
  input Class inClass;
  input String newName;
  output Class outClass;
algorithm
  outClass:=
  matchcontinue (inClass,newName)
    local
      Ident n;
      Boolean p,f,e;
      Restriction r;
      ClassDef body;
      Info nfo;
    case (CLASS(name = n,partialPrefix = p,finalPrefix = f,encapsulatedPrefix = e,restriction = r,body = body),_)
      then CLASS(newName,p,f,e,r,body,INFO("",false,0,0,0,0, TIMESTAMP(0.0,0.0))  );
  end matchcontinue;
end setClassName;

public function crefEqual " Checks if the name of a ComponentRef is
 equal to the name of another ComponentRef, including subscripts.
 See also crefEqualNoSubs."
  input ComponentRef iCr1;
  input ComponentRef iCr2;
  output Boolean outBoolean;
algorithm
  outBoolean := matchcontinue (iCr1,iCr2)
    local
      Ident id,id2;
      list<Subscript> ss1,ss2;
      ComponentRef cr1,cr2;

    case (CREF_IDENT(name = id,subscripts=ss1),CREF_IDENT(name = id2,subscripts = ss2))
      equation
        true = stringEq(id, id2);
        true = subscriptsEqual(ss1,ss2);
      then
        true;
    case (CREF_QUAL(name = id,subscripts = ss1, componentRef = cr1),CREF_QUAL(name = id2,subscripts = ss2, componentRef = cr2))
      equation
        true = stringEq(id, id2);
        true = subscriptsEqual(ss1,ss2);
        true = crefEqual(cr1, cr2);
      then
        true;
    case (CREF_FULLYQUALIFIED(componentRef = cr1),CREF_FULLYQUALIFIED(componentRef = cr2))
      then
        crefEqual(cr1, cr2);
    case (_,_) then false;
  end matchcontinue;
end crefEqual;

public function crefFirstEqual
"@author: adrpo
 a.b, a -> true
 b.c, a -> false"
  input ComponentRef iCr1;
  input ComponentRef iCr2;
  output Boolean outBoolean;
algorithm
  outBoolean := stringEq(crefFirstIdent(iCr1),crefFirstIdent(iCr2));
end crefFirstEqual;

public function subscriptsEqual "
Checks if two subscript lists are equal.
See also crefEqual."
  input list<Subscript> inSs1;
  input list<Subscript> inSs2;
  output Boolean equal;
algorithm
  equal := matchcontinue(inSs1,inSs2)
    local
      Exp e1,e2;
      list<Subscript> ss1,ss2;

    case({},{}) then true;
    case(NOSUB()::ss1, NOSUB()::ss2) then subscriptsEqual(ss1,ss2);
    case(SUBSCRIPT(e1)::ss1,SUBSCRIPT(e2)::ss2) equation
      true = expEqual(e1,e2);
    then subscriptsEqual(ss1,ss2);
    case(_,_) then false;
  end matchcontinue;
end subscriptsEqual;

public function crefEqualNoSubs "
 Checks if the name of a ComponentRef is equal to the name
 of another ComponentRef without checking subscripts.
 See also crefEqual."
  input ComponentRef cr1;
  input ComponentRef cr2;
  output Boolean outBoolean;
algorithm
  outBoolean := matchcontinue (cr1,cr2)
    local
      ComponentRef rest1,rest2;
      Ident id,id2;
    case (CREF_IDENT(name = id),CREF_IDENT(name = id2))
      equation
        true = stringEq(id, id2);
      then
        true;
    case (CREF_QUAL(name = id,componentRef = rest1),CREF_QUAL(name = id2,componentRef = rest2))
      equation
        true = stringEq(id, id2);
        true = crefEqualNoSubs(rest1, rest2);
      then
        true;
    case (CREF_FULLYQUALIFIED(componentRef = rest1),CREF_FULLYQUALIFIED(componentRef = rest2))
      then crefEqualNoSubs(rest1, rest2);
    else false;
  end matchcontinue;
end crefEqualNoSubs;

public function isPackageRestriction "checks if the provided parameter is a package or not"
  input Restriction inRestriction;
  output Boolean outBoolean;
algorithm
  outBoolean := matchcontinue (inRestriction)
    case (R_PACKAGE()) then true;
    case (_) then false;
  end matchcontinue;
end isPackageRestriction;

public function isFunctionRestriction "checks if restriction is a function or not"
  input Restriction inRestriction;
  output Boolean outBoolean;
algorithm
  outBoolean := matchcontinue (inRestriction)
    case (R_FUNCTION(_)) then true;
    case (_) then false;
  end matchcontinue;
end isFunctionRestriction;

public function subscriptEqual "
Author BZ, 2009-01
Check if two subscripts are equal.
"
input Subscript ss1,ss2;
output Boolean b;
algorithm b:= matchcontinue(ss1,ss2)
  local Exp e1,e2;
  case(NOSUB(),NOSUB()) then true;
  case(SUBSCRIPT(e1),SUBSCRIPT(e2)) then expEqual(e1,e2);
  case(_,_) then false;
  end matchcontinue;
end subscriptEqual;

public function expEqual "Returns true if two expressions are equal"
  input Exp exp1;
  input Exp exp2;
  output Boolean equal;
algorithm
  equal := matchcontinue(exp1,exp2)
    local
      Exp x, y;
      Integer   i; Real   r;

    // real vs. integer
    case (INTEGER(i), REAL(r))
      equation
        true = realEq(intReal(i), r);
      then
        true;

    case (REAL(r), INTEGER(i))
      equation
        true = realEq(intReal(i), r);
      then
        true;

    // anything else, exact match!
    case (x, y) equation equality(x = y);          then true;
    case (x, y) equation failure(equality(x = y)); then false;
  end matchcontinue;
end expEqual;

public function eachEqual "Returns true if two each attributes are equal"
  input Each each1;
  input Each each2;
  output Boolean equal;
algorithm
  equal := matchcontinue(each1,each2)
    case(NON_EACH(),NON_EACH()) then true;
    case(EACH(),EACH()) then true;
    case(_,_) then false;
  end matchcontinue;
end eachEqual;

protected function functionArgsEqual "Returns true if two FunctionArgs are equal"
  input FunctionArgs args1;
  input FunctionArgs args2;
  output Boolean equal;
algorithm
  equal := matchcontinue(args1,args2)
    local
      ComponentRef cref1,cref2;
      list<Exp> expl1,expl2;
      Boolean b1;
      list<Boolean> blst;
    case (FUNCTIONARGS(expl1,_),FUNCTIONARGS(expl2,_))
      equation
        // fails if not all are true
        List.threadMapAllValue(expl1,expl2,expEqual,true);
      then
        true;
    case(_,_) then false;
  end matchcontinue;
end functionArgsEqual;

public function getClassName "author: adrpo
  gets the name of the class."
  input Class inClass;
  output String outName;
algorithm
  CLASS(name=outName) := inClass;
end getClassName;

protected function findIteratorInElseIfExpBranch //This function is not tail-recursive, and I don't know how to fix it -- alleb
  input String inString;
  input list<tuple<Exp, Exp>> inElseIfBranch;
  output list<tuple<ComponentRef, Integer>> outLst;
algorithm
    outLst := match(inString,inElseIfBranch)
    local
      list<tuple<ComponentRef, Integer>> lst,lst_1,lst_2,lst_3;
      String id;
      list<tuple<Exp, Exp>> rest;
      Exp e_1,e_2;
      case (id,{}) then {};
      case (id,(e_1,e_2)::rest)
        equation
          lst_1=findIteratorInExp(id,e_1);
          lst_2=findIteratorInExp(id,e_2);
          lst_3=findIteratorInElseIfExpBranch(id,rest);
          lst=List.flatten({lst_1,lst_2,lst_3});
        then lst;
  end match;
end findIteratorInElseIfExpBranch;

public function findIteratorInFunctionArgs
  input String inString;
  input FunctionArgs inFunctionArgs;
  output list<tuple<ComponentRef, Integer>> outLst;
algorithm
    outLst := match(inString,inFunctionArgs)
    local
      list<tuple<ComponentRef, Integer>> lst,lst_1,lst_2;
      String id;
      list<Exp> expLst;
      list<NamedArg> namedArgs;
      Exp exp;
      list<ForIterator> forIterators;
      Boolean bool;
      case (id,FUNCTIONARGS(expLst,namedArgs))
        equation
          lst_1=findIteratorInExpLst(id,expLst);
          lst_2=findIteratorInNamedArgs(id,namedArgs);
          lst=listAppend(lst_1,lst_2);
        then lst;
/*      case (id, FOR_ITER_FARG(exp,forIterators))
        equation
          true=iteratorPresentAmongIterators(id,forIterators);
          lst=findIteratorInForIteratorsBounds(id,forIterators);
        then lst;
      case (id, FOR_ITER_FARG(exp,forIterators))
        equation
          false=iteratorPresentAmongIterators(id,forIterators);
          lst_1=findIteratorInExp(id,exp);
          lst_2=findIteratorInForIteratorsBounds(id,forIterators);
          lst=listAppend(lst_1,lst_2);
        then lst;    */
      case (id, FOR_ITER_FARG(exp,forIterators))
        equation
          lst_1=findIteratorInExp(id,exp);
          (bool,lst_2)=findIteratorInForIteratorsBounds2(id,forIterators);
          lst_1=Util.if_(bool, {}, lst_1);
          lst=listAppend(lst_1,lst_2);
        then lst;
  end match;
end findIteratorInFunctionArgs;

/*protected function iteratorPresentAmongIterators
  input String inString;
  input list<ForIterator> inForIterators;
  output Boolean outBool;
algorithm
    outBool:=matchcontinue(inString,inForIterators)
    local
      String id,id1;
      Boolean bool;
      list<ForIterator> rest;
      case (id,{}) then false;
      case (id,(id1,_)::rest)
        equation
          true = stringEq(id, id1);
        then true;
      case (id,(id1,_)::rest)
        equation
          failure(equality(id=id1));
          bool=iteratorPresentAmongIterators(id,rest);
        then bool;
  end matchcontinue;
end iteratorPresentAmongIterators;      */

public function findIteratorInExpLst//This function is not tail-recursive, and I don't know how to fix it -- alleb
  input String inString;
  input list<Exp> inExpLst;
  output list<tuple<ComponentRef, Integer>> outLst;
algorithm
  outLst := match(inString,inExpLst)
    local
      list<tuple<ComponentRef, Integer>> lst,lst_1,lst_2;
      String id;
      list<Exp> rest;
      Exp exp;
    case (id,{}) then {};
    case (id,exp::rest)
      equation
        lst_1=findIteratorInExp(id,exp);
        lst_2=findIteratorInExpLst(id,rest);
        lst=listAppend(lst_1,lst_2);
      then lst;
  end match;
end findIteratorInExpLst;

protected function findIteratorInExpLstLst//This function is not tail-recursive, and I don't know how to fix it -- alleb
  input String inString;
  input list<list<Exp>> inExpLstLst;
  output list<tuple<ComponentRef, Integer>> outLst;
algorithm
  outLst := match(inString,inExpLstLst)
    local
      list<tuple<ComponentRef, Integer>> lst,lst_1,lst_2;
      String id;
      list<list<Exp>> rest;
      list<Exp> expLst;
    case (id,{}) then {};
    case (id,expLst::rest)
      equation
        lst_1=findIteratorInExpLst(id,expLst);
        lst_2=findIteratorInExpLstLst(id,rest);
        lst=listAppend(lst_1,lst_2);
      then lst;
  end match;
end findIteratorInExpLstLst;

protected function findIteratorInNamedArgs
  input String inString;
  input list<NamedArg> inNamedArgs;
  output list<tuple<ComponentRef, Integer>> outLst;
algorithm
  outLst := match(inString,inNamedArgs)
    local
      list<tuple<ComponentRef, Integer>> lst,lst_1,lst_2;
      String id;
      list<NamedArg> rest;
      Exp exp;
    case (id,{}) then {};
    case (id,NAMEDARG(_,exp)::rest)
      equation
        lst_1=findIteratorInExp(id,exp);
        lst_2=findIteratorInNamedArgs(id,rest);
        lst=listAppend(lst_1,lst_2);
      then lst;
  end match;
end findIteratorInNamedArgs;

/*
protected function findIteratorInForIteratorsBounds
  input String inString;
  input list<ForIterator> inForIterators;
  output list<tuple<ComponentRef, Integer>> outLst;
algorithm
    outLst:=matchcontinue(inString,inForIterators)
    local
      list<tuple<ComponentRef, Integer>> lst,lst_1,lst_2;
      String id;
      list<ForIterator> rest;
      Exp exp;
      case (id,{}) then {};
      case (id,(_,NONE())::rest)
        equation
          lst=findIteratorInForIteratorsBounds(id,rest);
        then lst;
      case (id,(_,SOME(exp))::rest)
        equation
          lst_1=findIteratorInExp(id,exp);
          lst_2=findIteratorInForIteratorsBounds(id,rest);
          lst=listAppend(lst_1,lst_2);
        then lst;
  end matchcontinue;
end findIteratorInForIteratorsBounds; */

public function findIteratorInForIteratorsBounds2 "
This is a fixed version of the function; it stops looking for the iterator when it finds another iterator
with the same name. It also returns information about whether it has found such an iterator"
  input String inString;
  input list<ForIterator> inForIterators;
  output Boolean outBool;
  output list<tuple<ComponentRef, Integer>> outLst;
algorithm
  (outBool,outLst) := matchcontinue(inString,inForIterators)
    local
      list<tuple<ComponentRef, Integer>> lst,lst_1,lst_2;
      Boolean bool;
      String id, id_1;
      list<ForIterator> rest;
      Exp exp;
    case (_,{}) then (false,{});
    case (id,ITERATOR(name=id_1)::_)
      equation
        true = stringEq(id, id_1);
      then
        (true,{});
    case (id,ITERATOR(range=NONE())::rest)
      equation
        (bool,lst)=findIteratorInForIteratorsBounds2(id,rest);
      then (bool,lst);
    case (id,ITERATOR(range=SOME(exp))::rest)
      equation
        lst_1=findIteratorInExp(id,exp);
        (bool,lst_2)=findIteratorInForIteratorsBounds2(id,rest);
        lst=listAppend(lst_1,lst_2);
      then (bool,lst);
  end matchcontinue;
end findIteratorInForIteratorsBounds2;

public function findIteratorInExp
  input String inString;
  input Exp inExp;
  output list<tuple<ComponentRef, Integer>> outLst;
algorithm
    outLst := matchcontinue(inString,inExp)
      local
        list<tuple<ComponentRef, Integer>> lst,lst_1,lst_2,lst_3,lst_4;
        String id;
        Exp e_1,e_2,e_3;
        list<Exp> expLst;
        list<list<Exp>> expLstLst;
        ComponentRef cref;
        list<tuple<Exp, Exp>> elseIfBranch;
        FunctionArgs funcArgs;
        Option<Exp> expOpt;

      case(id, CREF(cref))
        equation
          lst=findIteratorInCRef(id,cref);
        then lst;
      case(id, BINARY(e_1,_,e_2))
        equation
          lst_1=findIteratorInExp(id,e_1);
          lst_2=findIteratorInExp(id,e_2);
          lst=listAppend(lst_1,lst_2);
        then lst;
      case(id, UNARY(_,e_1))
        equation
          lst=findIteratorInExp(id,e_1);
        then lst;
      case(id, LBINARY(e_1,_,e_2))
        equation
          lst_1=findIteratorInExp(id,e_1);
          lst_2=findIteratorInExp(id,e_2);
          lst=listAppend(lst_1,lst_2);
        then lst;
      case(id, LUNARY(_,e_1))
        equation
          lst=findIteratorInExp(id,e_1);
        then lst;
      case(id, RELATION(e_1,_,e_2))
        equation
          lst_1=findIteratorInExp(id,e_1);
          lst_2=findIteratorInExp(id,e_2);
          lst=listAppend(lst_1,lst_2);
        then lst;
      case(id, IFEXP(e_1,e_2,e_3,elseIfBranch))
        equation
          lst_1=findIteratorInExp(id,e_1);
          lst_2=findIteratorInExp(id,e_2);
          lst_3=findIteratorInExp(id,e_3);
          lst_4=findIteratorInElseIfExpBranch(id,elseIfBranch);
          lst=List.flatten({lst_1,lst_2,lst_3,lst_4});
        then lst;
      case (id,CALL(_,funcArgs))
        equation
          lst=findIteratorInFunctionArgs(id,funcArgs);
        then lst;
      // stefan
      case (id, PARTEVALFUNCTION(_,funcArgs))
        equation
          lst=findIteratorInFunctionArgs(id,funcArgs);
        then lst;
      case (id, ARRAY(expLst))
        equation
          lst=findIteratorInExpLst(id,expLst);
        then lst;
      case (id, MATRIX(expLstLst))
        equation
          lst=findIteratorInExpLstLst(id,expLstLst);
        then lst;
      case(id, RANGE(e_1,expOpt,e_2))
        equation
          lst_1=findIteratorInExp(id,e_1);
          lst_2=findIteratorInExpOpt(id,expOpt);
          lst_3=findIteratorInExp(id,e_2);
          lst=List.flatten({lst_1,lst_2,lst_3});
        then lst;
      case (id, TUPLE(expLst))
        equation
          lst=findIteratorInExpLst(id,expLst);
        then lst;
      case (id, LIST(expLst))
        equation
          lst=findIteratorInExpLst(id,expLst);
        then lst;
      case(_,_) then {};
  end matchcontinue;
end findIteratorInExp;

protected function findIteratorInExpOpt
  input String inString;
  input Option<Exp> inExpOpt;
  output list<tuple<ComponentRef, Integer>> outLst;
algorithm
    outLst := match(inString,inExpOpt)
    local
      list<tuple<ComponentRef, Integer>> lst;
      String id;
      Exp exp;
      case (id,NONE()) then {};
      case (id,SOME(exp))
        equation
          lst=findIteratorInExp(id,exp);
        then lst;
  end match;
end findIteratorInExpOpt;

public function findIteratorInCRef "
The most important among \"findIteratorIn...\" functions -- they all use this one in the end
"
  input String inString;
  input ComponentRef inCref;
  output list<tuple<ComponentRef, Integer>> outLst;
algorithm
    outLst := match(inString,inCref)
    local
      list<tuple<ComponentRef, Integer>> lst,lst_1,lst_2,lst_3;
      String id,name;
      list<Subscript> subLst;
      ComponentRef cref;
      list<Integer> intLst;
      case(id, CREF_IDENT(name,subLst))
        equation
        intLst=findIteratorInSubscripts(id,subLst,1);
        lst=combineCRefAndIntLst(CREF_IDENT(name,{}),intLst);
        then lst;
      case(id, CREF_QUAL(name,subLst,cref))
        equation
        intLst=findIteratorInSubscripts(id,subLst,1);
        lst_1=combineCRefAndIntLst(CREF_IDENT(name,{}),intLst);
        lst_2=findIteratorInCRef(id,cref);
        lst_3=qualifyCRefIntLst(name,subLst,lst_2);
        lst=listAppend(lst_1,lst_3);
        then lst;
      case(id, CREF_FULLYQUALIFIED(cref)) then findIteratorInCRef(id,cref);
      case (_,ALLWILD()) then {};
      case (_,WILD()) then {};
  end match;
end findIteratorInCRef;

protected function findIteratorInSubscripts
  input String inString;
  input list<Subscript> inSubLst;
  input Integer inInt;
  output list<Integer> outIntLst;
algorithm
  outIntLst := matchcontinue(inString,inSubLst,inInt)
    local
      list<Integer> lst;
      Integer n, n_1;
      String id,name;
      list<Subscript> rest;
    case (_,{},_) then {};
    case (id,SUBSCRIPT(CREF(CREF_IDENT(name,{})))::rest,n)
      equation
        true = stringEq(id, name);
        n_1=n+1;
        lst=findIteratorInSubscripts(id,rest,n_1);
      then n::lst;
    case (id,_::rest,n)
      equation
        n_1=n+1;
        lst=findIteratorInSubscripts(id,rest,n_1);
      then lst;
  end matchcontinue;
end findIteratorInSubscripts;

protected function combineCRefAndIntLst
  input ComponentRef inCRef;
  input list<Integer> inIntLst;
  output list<tuple<ComponentRef, Integer>> outLst;
algorithm
  outLst := match(inCRef,inIntLst)
    local
      ComponentRef cref;
      list<Integer> rest;
      Integer i;
      list<tuple<ComponentRef, Integer>> lst;
    case (_,{}) then {};
    case (cref,i::rest)
      equation
        lst=combineCRefAndIntLst(cref,rest);
      then (cref,i)::lst;
  end match;
end combineCRefAndIntLst;

protected function qualifyCRefIntLst
  input String inString;
  input list<Subscript> inSubLst;
  input list<tuple<ComponentRef, Integer>> inLst;
  output list<tuple<ComponentRef, Integer>> outLst;
algorithm
  outLst:=match(inString,inSubLst,inLst)
    local
      ComponentRef cref;
      String name;
      list<Subscript> subLst;
      list<tuple<ComponentRef, Integer>> rest,lst;
      Integer i;
    case (_,_,{}) then {};
    case (name,subLst,(cref,i)::rest)
      equation
        lst=qualifyCRefIntLst(name,subLst,rest);
      then (CREF_QUAL(name,subLst,cref),i)::lst;
  end match;
end qualifyCRefIntLst;

public function pathReplaceIdent
  input Path path;
  input String last;
  output Path out;
algorithm
  out := match (path,last)
    local Path p; String n,s;
    case (FULLYQUALIFIED(p),s) equation p = pathReplaceIdent(p,s); then FULLYQUALIFIED(p);
    case (QUALIFIED(n,p),s) equation p = pathReplaceIdent(p,s); then QUALIFIED(n,p);
    case (IDENT(_),s) then IDENT(s);
  end match;
end pathReplaceIdent;

public function setBuildTimeInInfo
  input Real buildTime;
  input Info inInfo;
  output Info outInfo;
algorithm
  outInfo := match(buildTime, inInfo)
    local
      String fileName "fileName where the class is defined in";
      Boolean isReadOnly "isReadOnly : (true|false). Should be true for libraries";
      Integer lineNumberStart "lineNumberStart";
      Integer columnNumberStart "columnNumberStart";
      Integer lineNumberEnd "lineNumberEnd";
      Integer columnNumberEnd "columnNumberEnd";
      Real lastBuildTime "Last Build Time";
      Real lastEditTime "Last Edit Time";
    case (_, INFO(fileName, isReadOnly, lineNumberStart, columnNumberStart,
                          lineNumberEnd, columnNumberEnd, TIMESTAMP(lastBuildTime,lastEditTime)))
    then
      (INFO(fileName, isReadOnly, lineNumberStart, columnNumberStart, lineNumberEnd, columnNumberEnd, TIMESTAMP(buildTime,lastEditTime)));
  end match;
end setBuildTimeInInfo;

public function getFileNameFromInfo
  input Info inInfo;
  output String inFileName;
algorithm
  inFileName := match(inInfo)
    local String fileName;
    case (INFO(fileName = fileName)) then fileName;
  end match;
end getFileNameFromInfo;

public function isOuter
"@author: adrpo
  this function returns true if the given InnerOuter
  is one of INNER_OUTER() or OUTER()"
  input InnerOuter io;
  output Boolean isItAnOuter;
algorithm
  isItAnOuter := match(io)
    case (INNER_OUTER()) then true;
    case (OUTER()) then true;
    else false;
  end match;
end isOuter;

public function isInner
"@author: adrpo
  this function returns true if the given InnerOuter
  is one of INNER_OUTER() or INNER()"
  input InnerOuter io;
  output Boolean isItAnInner;
algorithm
  isItAnInner := match(io)
    case (INNER_OUTER()) then true;
    case (INNER()) then true;
    else false;
  end match;
end isInner;

public function isOnlyInner
  "Returns true if the InnerOuter is INNER, false otherwise."
  input InnerOuter inIO;
  output Boolean outOnlyInner;
algorithm
  outOnlyInner := match(inIO)
    case (INNER()) then true;
    else false;
  end match;
end isOnlyInner;

public function isOnlyOuter
  "Returns true if the InnerOuter is OUTER, false otherwise."
  input InnerOuter inIO;
  output Boolean outOnlyOuter;
algorithm
  outOnlyOuter := match(inIO)
    case (OUTER()) then true;
    else false;
  end match;
end isOnlyOuter;

public function isInnerOuter
  input InnerOuter inIO;
  output Boolean outIsInnerOuter;
algorithm
  outIsInnerOuter := match(inIO)
    case (INNER_OUTER()) then true;
    else false;
  end match;
end isInnerOuter;

public function isNotInnerOuter
  input InnerOuter inIO;
  output Boolean outIsNotInnerOuter;
algorithm
  outIsNotInnerOuter := match(inIO)
    case (NOT_INNER_OUTER()) then true;
    else false;
  end match;
end isNotInnerOuter;

public function innerOuterEqual "Returns true if two InnerOuter's are equal"
  input InnerOuter io1;
  input InnerOuter io2;
  output Boolean res;
algorithm
  res := match(io1,io2)
    case(INNER(),INNER()) then true;
    case(OUTER(),OUTER()) then true;
    case(INNER_OUTER(),INNER_OUTER()) then true;
    case(NOT_INNER_OUTER(),NOT_INNER_OUTER()) then true;
    else false;
  end match;
end innerOuterEqual;

public function makeFullyQualified
"Makes a path fully qualified unless it already is."
  input Path inPath;
  output Path outPath;
algorithm
  outPath := match(inPath)
    case FULLYQUALIFIED(path = _) then inPath;
    else FULLYQUALIFIED(inPath);
  end match;
end makeFullyQualified;

public function makeNotFullyQualified
"Makes a path not fully qualified unless it already is."
  input Path inPath;
  output Path outPath;
algorithm
  outPath := match inPath
    local Path path;
    case FULLYQUALIFIED(path) then path;
    else inPath;
  end match;
end makeNotFullyQualified;

public function importEqual "Compares two import elements. "
  input Import im1;
  input Import im2;
  output Boolean outBoolean;
algorithm
  outBoolean := matchcontinue (im1,im2)
    local
      Ident id,id2;
      Path p1,p2;
    case (NAMED_IMPORT(name = id,path=p1),NAMED_IMPORT(name = id2,path=p2))
      equation
        true = stringEq(id, id2);
        true = pathEqual(p1,p2);
      then
        true;
    case (QUAL_IMPORT(path=p1),QUAL_IMPORT(path=p2))
      equation
        true = pathEqual(p1,p2);
      then
        true;
    case (UNQUAL_IMPORT(path=p1),UNQUAL_IMPORT(path=p2))
      equation
        true = pathEqual(p1,p2);
      then
        true;
    case (_,_) then false;
  end matchcontinue;
end importEqual;

public function canonIfExp "Transforms an if-expression to canonical form (without else-if branches)"
  input Exp inExp;
  output Exp outExp;
algorithm
  outExp := match inExp
    local
      Exp cond,tb,eb,ei_cond,ei_tb,e;
      list<tuple<Exp,Exp>> eib;

    case IFEXP(elseIfBranch={}) then inExp;
    case IFEXP(ifExp=cond,trueBranch=tb,elseBranch=eb,elseIfBranch=(ei_cond,ei_tb)::eib)
      equation
        e = canonIfExp(IFEXP(ei_cond,ei_tb,eb,eib));
      then IFEXP(cond,tb,e,{});
  end match;
end canonIfExp;

public function onlyLiteralsInAnnotationMod
"@author: adrpo
  This function checks if a modification only contains literal expressions"
  input list<ElementArg> inMod;
  output Boolean onlyLiterals;
algorithm
  onlyLiterals := matchcontinue(inMod)
    local
      list<ElementArg> dive, rest;
      EqMod eqMod;
      Boolean b1, b2, b3, b;

    case ({}) then true;

    // skip "interaction" annotation!
    case (MODIFICATION(path = IDENT(name = "interaction")) :: rest)
      equation
        b = onlyLiteralsInAnnotationMod(rest);
      then
        b;


    // search inside, some(exp)
    case (MODIFICATION(modification = SOME(CLASSMOD(dive, eqMod))) :: rest)
      equation
        b1 = onlyLiteralsInEqMod(eqMod);
        b2 = onlyLiteralsInAnnotationMod(dive);
        b3 = onlyLiteralsInAnnotationMod(rest);
        b = boolAnd(b1, boolAnd(b2, b3));
      then
        b;

    case (_ :: rest)
      equation
        b = onlyLiteralsInAnnotationMod(rest);
      then
        b;

    // failed above, return false
    case (_) then false;

  end matchcontinue;
end onlyLiteralsInAnnotationMod;

protected function onlyLiteralsInEqMod
"@author: adrpo
  This function checks if an optional expression only contains literal expressions"
  input EqMod eqMod;
  output Boolean onlyLiterals;
algorithm
  onlyLiterals := match (eqMod)
    local
      Exp exp;
      list<Exp> lst;
      Boolean b;

    case (NOMOD()) then true;

    // DynamicSelect returns true!
    case (EQMOD(exp=CALL(function_ = CREF_IDENT(name = "DynamicSelect")))) then true;

    // search inside, some(exp)
    case (EQMOD(exp=exp))
      equation
         ((_, lst)) = traverseExp(exp, onlyLiteralsInExp, {});
         // if list is empty (no crefs were added)
         b = List.isEmpty(lst);
         // debugging:
         // print("Crefs in annotations: (" +& stringDelimitList(List.map(inAnnotationMod, Dump.printExpStr), ", ") +& ")\n");
      then
        b;
  end match;
end onlyLiteralsInEqMod;

protected function onlyLiteralsInExp
"@author: adrpo
 Visitor function for checking if Exp contains only literals, NO CREFS!
 It returns an empty list if it doesn't contain any crefs!"
  input tuple<Exp, list<Exp>> tpl;
  output tuple<Exp, list<Exp>> outTpl;
algorithm
  outTpl := matchcontinue(tpl)
    local
      Exp e;
      ComponentRef cr;
      list<Exp> lst, lstArgs;
      String name;
      FunctionArgs fargs;

    // first handle DynamicSelect
    case ((e as CALL(function_ = CREF_IDENT(name = "DynamicSelect"), functionArgs = fargs), lst))
      equation
        ((_, lstArgs)) = traverseExpFunctionArgs(fargs, onlyLiteralsInExp, {});
        // if the lst is the same as the one got from args, return nothing
        equality(lst = lstArgs);
      then
        ((e, {}));

    // first handle all graphic enumerations!
    // FillPattern.*, Smooth.*, TextAlignment.*, etc!
    case ((e as CREF(cr as CREF_QUAL(name=name)), lst))
      equation
        true = listMember(name,{
                          "LinePattern",
                          "Arrow",
                          "FillPattern",
                          "BorderPattern",
                          "TextStyle",
                          "Smooth",
                          "TextAlignment"});
      then
        ((e, lst));

    // crefs, add to list
    case ((e as CREF(cr), lst)) then ((e,e::lst));
    // anything else, return the same!
    case _ then tpl;

  end matchcontinue;
end onlyLiteralsInExp;

public function makeCons
  input Exp e1;
  input Exp e2;
  output Exp e;
algorithm
  e := CONS(e1,e2);
annotation(__OpenModelica_EarlyInline = true);
end makeCons;

public function crefIdent
  input ComponentRef cr;
  output String str;
algorithm
  CREF_IDENT(str,{}) := cr;
end crefIdent;

public function unqotePathIdents
  input Path inPath;
  output Path path;
algorithm
  path := stringListPath(List.map(pathToStringList(inPath), System.unquoteIdentifier));
end unqotePathIdents;

public function unqualifyCref
  "If the given component reference is fully qualified this function removes the
  fully qualified qualifier, otherwise does nothing."
  input ComponentRef inCref;
  output ComponentRef outCref;
algorithm
  outCref := match(inCref)
    local
      ComponentRef cref;

    case CREF_FULLYQUALIFIED(componentRef = cref) then cref;
    else inCref;
  end match;
end unqualifyCref;

public function pathIsFullyQualified
  input Path inPath;
  output Boolean outIsQualified;
algorithm
  outIsQualified := match(inPath)
    case FULLYQUALIFIED(path = _) then true;
    else false;
  end match;
end pathIsFullyQualified;

public function withinEqual
  input Within within1;
  input Within within2;
  output Boolean b;
algorithm
  b := match (within1,within2)
    local
      Path p1,p2;
    case (TOP(),TOP()) then true;
    case (WITHIN(p1),WITHIN(p2)) then pathEqual(p1,p2);
    else false;
  end match;
end withinEqual;

public function withinString
  input Within w1;
  output String str;
algorithm
  str := match (w1)
    local
      Path p1;
    case (TOP()) then "within ;";
    case (WITHIN(p1)) then "within " +& pathString(p1) +& ";";
  end match;
end withinString;

public function joinWithinPath
  input Within within_;
  input Path path;
  output Path outPath;
algorithm
  outPath := match (within_,path)
    local
      Path path1;
    case (TOP(),_) then path;
    case (WITHIN(path1),_) then joinPaths(path1,path);
  end match;
end joinWithinPath;

public function innerOuterStr
  input InnerOuter io;
  output String str;
algorithm
  str := match(io)
    case (INNER_OUTER()) then "inner outer ";
    case (INNER()) then "inner ";
    case (OUTER()) then "outer ";
    case (NOT_INNER_OUTER()) then "";
  end match;
end innerOuterStr;

public function subscriptExpOpt
  input Subscript inSub;
  output Option<Exp> outExpOpt;
algorithm
  outExpOpt := match(inSub)
    local
      Exp e;
      case SUBSCRIPT(subscript = e)
        then SOME(e);
      case NOSUB()
        then NONE();
  end match;
end subscriptExpOpt;

public function crefInsertSubscriptLstLst
  input tuple<Exp,list<list<Subscript>>> inTpl;
  output tuple<Exp,list<list<Subscript>>> outTpl;
algorithm
  outTpl := matchcontinue(inTpl)
  local
    ComponentRef cref,cref2;
    list<list<Subscript>> subs;
    Exp e;
    case ((CREF(componentRef=cref),subs))
      equation
        cref2 = crefInsertSubscriptLstLst2(cref,subs);
      then
         ((CREF(cref2),subs));
    case ((e,subs)) then ((e,subs));
  end matchcontinue;
end crefInsertSubscriptLstLst;

public function crefInsertSubscriptLstLst2
"Helper function to crefInsertSubscriptLstLst"
  input ComponentRef inCref;
  input list<list<Subscript>> inSubs;
  output ComponentRef outCref;
algorithm
  outCref := matchcontinue(inCref,inSubs)
    local
      ComponentRef cref, cref2;
      Ident n;
      list<list<Subscript>> subs;
      list<Subscript> s;
      case (cref,{})
        then cref;
      case (CREF_IDENT(name = n), {s})
        then CREF_IDENT(n,s);
      case (CREF_QUAL(name = n, componentRef = cref), s::subs)
        equation
          cref2 = crefInsertSubscriptLstLst2(cref, subs);
        then
          CREF_QUAL(n,s,cref2);
      case (CREF_FULLYQUALIFIED(componentRef = cref), subs)
        equation
          cref2 = crefInsertSubscriptLstLst2(cref, subs);
        then
          crefMakeFullyQualified(cref2);
  end matchcontinue;
end crefInsertSubscriptLstLst2;

public function isCref
  input Exp exp;
  output Boolean b;
algorithm
  b := match exp
    case CREF(_) then true;
    else false;
  end match;
end isCref;

public function isDerCref
  input Exp exp;
  output Boolean b;
algorithm
  b := match exp
    case CALL(CREF_IDENT("der",{}),FUNCTIONARGS({CREF(_)},{})) then true;
    else false;
  end match;
end isDerCref;

public function isDerCrefFail
  input Exp exp;
algorithm
  CALL(CREF_IDENT("der",{}),FUNCTIONARGS({CREF(_)},{})) := exp;
end isDerCrefFail;

public function getExpsFromArrayDim
 "author: adrpo
  returns all the expressions from array dimension as a list
  also returns if we have unknown dimensions in the array dimension"
  input ArrayDim inAd;
  output Boolean hasUnknownDimensions;
  output list<Exp> outExps;
algorithm
  (hasUnknownDimensions, outExps) := getExpsFromArrayDim_tail(inAd, {});
end getExpsFromArrayDim;

public function getExpsFromArrayDimOpt
 "author: adrpo
  returns all the expressions from array dimension as a list
  also returns if we have unknown dimensions in the array dimension"
  input Option<ArrayDim> inAdO;
  output Boolean hasUnknownDimensions;
  output list<Exp> outExps;
algorithm
  (hasUnknownDimensions, outExps) := match(inAdO)
    local ArrayDim ad;
    
    case (NONE()) then (false, {});
    
    case (SOME(ad))
      equation
        (hasUnknownDimensions, outExps) = getExpsFromArrayDim_tail(ad, {}); 
      then 
        (hasUnknownDimensions, outExps);
  
  end match;
end getExpsFromArrayDimOpt;

public function getExpsFromArrayDim_tail
 "author: adrpo
  returns all the expressions from array dimension as a list
  also returns if we have unknown dimensions in the array dimension"
  input ArrayDim inAd;
  input list<Exp> inAccumulator;
  output Boolean hasUnknownDimensions;
  output list<Exp> outExps;
algorithm
  (hasUnknownDimensions, outExps) := match(inAd, inAccumulator)
    local
      list<Subscript> rest;
      Exp e;
      list<Exp> exps, acc;
      Boolean b;

    // handle empty list
    case ({}, acc) then (false, listReverse(acc));

    // handle SUBSCRIPT
    case (SUBSCRIPT(e)::rest, acc)
      equation
        (b, exps) = getExpsFromArrayDim_tail(rest, e::acc);
       then
         (b, exps);

    // handle NOSUB
    case (NOSUB()::rest, acc)
      equation
        (b, exps) = getExpsFromArrayDim_tail(rest, acc);
       then
         (true, exps);
  end match;
end getExpsFromArrayDim_tail;

public function isInputOrOutput
"@author: adrpo
 returns true if the given direction is input or output"
 input Direction direction;
 output Boolean isIorO "input or output only";
algorithm
  isIorO := match(direction)
    case (INPUT()) then true;
    case (OUTPUT()) then true;
    case (BIDIR()) then false;
  end match;
end isInputOrOutput;

public function isInput
  input Direction inDirection;
  output Boolean outIsInput;
algorithm
  outIsInput := match(inDirection)
    case INPUT() then true;
    else false;
  end match;
end isInput;

public function directionEqual
  input Direction inDirection1;
  input Direction inDirection2;
  output Boolean outEqual;
algorithm
  outEqual := match(inDirection1, inDirection2)
    case (BIDIR(), BIDIR()) then true;
    case (INPUT(), INPUT()) then true;
    case (OUTPUT(), OUTPUT()) then true;
    else false;
  end match;
end directionEqual;

public function pathLt
  input Path path1;
  input Path path2;
  output Boolean lt;
algorithm
  lt := stringCompare(pathString(path1),pathString(path2)) < 0;
end pathLt;

public function pathGe
  input Path path1;
  input Path path2;
  output Boolean ge;
algorithm
  ge := not pathLt(path1,path2);
end pathGe;

public function getShortClass "Strips out long class definitions"
  input Class cl;
  output Class o;
algorithm
  o := match cl
    local
      Ident name;
      Boolean pa, fi, en;
      Restriction re;
      ClassDef body;
      Info info;
    case CLASS(body=PARTS(comment=_)) then fail();
    case CLASS(body=CLASS_EXTENDS(comment=_)) then fail();
    case CLASS(name,pa,fi,en,re,body,info)
      equation
        body = stripClassDefComment(body);
      then CLASS(name,pa,fi,en,re,body,info);
  end match;
end getShortClass;

protected function stripClassDefComment "Strips out long class definitions"
  input ClassDef cl;
  output ClassDef o;
algorithm
  o := match cl
    local
      EnumDef enumLiterals;
      TypeSpec typeSpec;
      ElementAttributes attributes;
      list<ElementArg> arguments;
      list<Path> functionNames;
      Path functionName;
      list<Ident> vars;
      list<String> typeVars;
      Ident baseClassName;
      list<ElementArg> modifications;
      list<ClassPart> parts;
      list<NamedArg> classAttrs;
      list<Annotation> ann;
    case PARTS(typeVars,classAttrs,parts,ann,_) then PARTS(typeVars,classAttrs,parts,ann,NONE());
    case CLASS_EXTENDS(baseClassName,modifications,_,parts,ann) then CLASS_EXTENDS(baseClassName,modifications,NONE(),parts,ann);
    case DERIVED(typeSpec,attributes,arguments,_) then DERIVED(typeSpec,attributes,arguments,NONE());
    case ENUMERATION(enumLiterals,_) then ENUMERATION(enumLiterals,NONE());
    case OVERLOAD(functionNames,_) then OVERLOAD(functionNames,NONE());
    case PDER(functionName,vars,_) then PDER(functionName,vars,NONE());
    else cl;
  end match;
end stripClassDefComment;

public function getFunctionInterface "Strips out the parts of a function definition that are not needed for the interface"
  input Class cl;
  output Class o;
algorithm
  o := match cl
    local
      Ident name;
      Boolean partialPrefix, finalPrefix, encapsulatedPrefix;
      Info info;
      list<String> typeVars;
      list<ClassPart> classParts;
      list<ElementItem> elts;
      FunctionRestriction funcRest;
      list<NamedArg> classAttr;
    case CLASS(name,partialPrefix,finalPrefix,encapsulatedPrefix,R_FUNCTION(funcRest),PARTS(typeVars,classAttr,classParts,_,_),info)
      equation
        (elts as _::_) = List.fold(listReverse(classParts),getFunctionInterfaceParts,{});
      then CLASS(name,partialPrefix,finalPrefix,encapsulatedPrefix,R_FUNCTION(funcRest),PARTS(typeVars,classAttr,PUBLIC(elts)::{},{},NONE()),info);
  end match;
end getFunctionInterface;

protected function getFunctionInterfaceParts
  input ClassPart part;
  input list<ElementItem> elts;
  output list<ElementItem> oelts;
algorithm
  oelts := match (part,elts)
    local
      list<ElementItem> elts1,elts2;
    case (PUBLIC(elts1),elts2)
      equation
        elts1 = List.filter(elts1,filterAnnotationItem);
      then listAppend(elts1,elts2);
    case (_,_) then elts;
  end match;
end getFunctionInterfaceParts;

protected function filterAnnotationItem
  input ElementItem elt;
algorithm
  _ := match elt
    case ELEMENTITEM(element=_) then ();
  end match;
end filterAnnotationItem;

public function getExternalDecl
"@author: adrpo
 returns the EXTERNAL form parts if there is any.
 if there is none, it fails!"
 input Class inCls;
 output ClassPart outExternal;
algorithm
 outExternal := match(inCls)
   local
     ClassPart cp;
     list<ClassPart> classParts;

   case (CLASS(body = PARTS(classParts = classParts)))
     equation
       cp = getExternalFromClassParts(classParts);
     then
       cp;
 end match;
end getExternalDecl;

public function getExternalFromClassParts
 input list<ClassPart> inClassParts;
 output ClassPart outExternal;
algorithm
 outExternal := matchcontinue(inClassParts)
   local
     ClassPart cp;
     list<ClassPart> rest;

   case ((cp as EXTERNAL(externalDecl = _))::rest) then cp;

   case (_::rest)
     equation
       cp = getExternalFromClassParts(rest);
     then
       cp;
 end matchcontinue;
end getExternalFromClassParts;

public function isParts
  input ClassDef cl;
  output Boolean b;
algorithm
  b := match cl
    case PARTS(comment=_) then true;
    else false;
  end match;
end isParts;

public function makeClassElement "Makes a class into an ElementItem"
  input Class cl;
  output ElementItem el;
algorithm
  el := match cl
    local
      Info info;
      Boolean fp;
    case CLASS(finalPrefix=fp,info=info) then ELEMENTITEM(ELEMENT(fp,NONE(),NOT_INNER_OUTER(),CLASSDEF(false,cl),info,NONE()));
  end match;
end makeClassElement;

public function componentName
  input ComponentItem c;
  output String name;
algorithm
  COMPONENTITEM(component=COMPONENT(name=name)) := c;
end componentName;

public function pathSetLastIdent
  input Path inPath;
  input Path inLastIdent;
  output Path outPath;
algorithm
  outPath := match(inPath, inLastIdent)
    local
      Path p;
      String n;

    case (IDENT(_), _) then inLastIdent;

    case (QUALIFIED(n, p), _)
      equation
        p = pathSetLastIdent(p, inLastIdent);
      then
        QUALIFIED(n, p);

    case (FULLYQUALIFIED(p), _)
      equation
        p = pathSetLastIdent(p, inLastIdent);
      then
        FULLYQUALIFIED(p);

  end match;
end pathSetLastIdent;

public function expContainsInitial
"@author:
  returns true if expression contains initial()"
  input Exp inExp;
  output Boolean hasInitial;
algorithm
  hasInitial := matchcontinue(inExp)
    local Boolean b;
    case (_)
      equation
        ((_, b)) = traverseExp(inExp, isInitialTraverseHelper, false);
      then
        b;
    else then false;
  end matchcontinue;
end expContainsInitial;

protected function isInitialTraverseHelper
"@author:
  returns true if expression is initial()"
  input tuple<Exp, Boolean> inExpBooleanTpl;
  output tuple<Exp, Boolean> outExpBooleanTpl;
algorithm
  outExpBooleanTpl := match(inExpBooleanTpl)
    local Exp e; Boolean b;

    // make sure we don't have not initial()
    case ((UNARY(NOT(), e) , b)) then inExpBooleanTpl;
    // we have initial
    case ((e , b))
      equation
        b = isInitial(e);
      then ((e, b));
    else inExpBooleanTpl;
  end match;
end isInitialTraverseHelper;

public function isInitial
"@author:
  returns true if expression is initial()"
  input Exp inExp;
  output Boolean hasReinit;
algorithm
  hasReinit := match(inExp)
    case (CALL(function_ = CREF_IDENT("initial", _))) then true;
    case (CALL(function_ = CREF_FULLYQUALIFIED(CREF_IDENT("initial", _)))) then true;
    else then false;
  end match;
end isInitial;

public function importPath
  "Return the path of the given import."
  input Import inImport;
  output Path outPath;
algorithm
  outPath := match(inImport)
    local
      Path path;

    case NAMED_IMPORT(path = path) then path;
    case QUAL_IMPORT(path = path) then path;
    case UNQUAL_IMPORT(path = path) then path;
    case GROUP_IMPORT(prefix = path) then path;

  end match;
end importPath;

public function importName
  "Returns the import name of a named or qualified import."
  input Import inImport;
  output Ident outName;
algorithm
  outName := match(inImport)
    local
      Ident name;
      Path path;

    // Named import has a given name, 'import D = A.B.C' => D.
    case NAMED_IMPORT(name = name) then name;
    // Qualified import uses the last identifier, 'import A.B.C' => C.
    case QUAL_IMPORT(path = path) then pathLastIdent(path);

  end match;
end importName;

public function mergeAnnotations
" This function takes an old annotation as first argument and a new
   annotation as  second argument and merges the two.
   Annotation \"parts\" that exist in both the old and the new annotation
   will be changed according to the new definition. For instance,
   merge_annotations(annotation(x=1,y=2),annotation(x=3))
   => annotation(x=3,y=2)"
  input Annotation inAnnotation1;
  input Annotation inAnnotation2;
  output Annotation outAnnotation;
algorithm
  outAnnotation:=
  matchcontinue (inAnnotation1,inAnnotation2)
    local
      list<ElementArg> neweltargs,oldrest,eltargs,eltargs_1;
      ElementArg mod;
      Annotation a;
      Path p;
    case (ANNOTATION(elementArgs = ((mod as MODIFICATION(path = p)) :: oldrest)),ANNOTATION(elementArgs = eltargs))
      equation
        failure(_ = removeModificationInElementargs(eltargs, p));
        ANNOTATION(neweltargs) = mergeAnnotations(ANNOTATION(oldrest), ANNOTATION(eltargs));
      then
        ANNOTATION((mod :: neweltargs));
    case (ANNOTATION(elementArgs = ((mod as MODIFICATION(path = p)) :: oldrest)),ANNOTATION(elementArgs = eltargs))
      equation
        eltargs_1 = removeModificationInElementargs(eltargs, p);
        ANNOTATION(neweltargs) = mergeAnnotations(ANNOTATION(oldrest), ANNOTATION(eltargs));
      then ANNOTATION(neweltargs);
    case (ANNOTATION(elementArgs = {}),a) then a;
  end matchcontinue;
end mergeAnnotations;

protected function removeModificationInElementargs
" This function removes the class modification named by the second argument.
   If no such class modification is found thefunction fails.
   Currently, only identifiers are allowed as class modifiers,
   i.e. a(...) and not a.b(...)"
  input list<ElementArg> inAbsynElementArgLst;
  input Path inPath;
  output list<ElementArg> outAbsynElementArgLst;
algorithm
  outAbsynElementArgLst := matchcontinue (inAbsynElementArgLst,inPath)
    local
      String id1,id2;
      ElementArg m;
      list<ElementArg> res,xs;

    case ({MODIFICATION(path = IDENT(name = id1))},IDENT(name = id2))
      equation
        true = stringEq(id1, id2);
      then {};

    case ({(m as MODIFICATION(path = IDENT(name = id1)))},IDENT(name = id2))
      equation
        false = stringEq(id1, id2);
      then
        fail();

    case ((MODIFICATION(path = IDENT(name = id1)) :: xs),IDENT(name = id2))
      equation
        true = stringEq(id1, id2);
        res = removeModificationInElementargs(xs, inPath);
      then
        res;

    case (((m as MODIFICATION(path = IDENT(name = id1))) :: xs),IDENT(name = id2))
      equation
        false = stringEq(id1, id2);
        res = removeModificationInElementargs(xs, inPath);
      then
        (m :: res);

    case (((m as MODIFICATION(path = IDENT(name = id1))) :: xs),IDENT(name = id2))
      equation
        res = removeModificationInElementargs(xs, inPath);
      then
        (m :: res);
  end matchcontinue;
end removeModificationInElementargs;

public function annotationToElementArgs
  input Annotation ann;
  output list<ElementArg> args;
algorithm
  ANNOTATION(args) := ann;
end annotationToElementArgs;

public function pathToTypeSpec
  input Path inPath;
  output TypeSpec outTypeSpec;
algorithm
  outTypeSpec := TPATH(inPath, NONE());
end pathToTypeSpec;

public function typeSpecString
  input TypeSpec inTs;
  output String outStr;
algorithm
  outStr := Dump.unparseTypeSpec(inTs);
end typeSpecString;

public function crefString
  input ComponentRef inCr;
  output String outStr;
algorithm
  outStr := Dump.printComponentRefStr(inCr);
end crefString;

public function typeSpecStringNoQualNoDims
  input TypeSpec inTs;
  output String outStr;
algorithm
  outStr := match (inTs)
    local
      Ident str,s,str1,str2,str3;
      Path path;
      Option<list<Subscript>> adim;
      list<TypeSpec> typeSpecLst;
    
    case (TPATH(path = path))
      equation
        str = pathString(makeNotFullyQualified(path));
      then
        str;
    
    case (TCOMPLEX(path = path,typeSpecs = typeSpecLst))
      equation
        str1 = pathString(makeNotFullyQualified(path));
        str2 = typeSpecStringNoQualNoDimsLst(typeSpecLst);
        str = stringAppendList({str1,"<",str2,">"});
      then
        str;
  
  end match;
end typeSpecStringNoQualNoDims;

public function typeSpecStringNoQualNoDimsLst
  input list<TypeSpec> inTypeSpecLst;
  output String outString;
algorithm
  outString := matchcontinue (inTypeSpecLst)
    local
      String str, str1, str2, str3;
      TypeSpec x;
      list<TypeSpec> rest;
    
    case ({x})
      equation
        str = typeSpecStringNoQualNoDims(x);
      then
        str;
    
    case (x::rest)
      equation
        str1 = typeSpecStringNoQualNoDims(x);
        str2 = typeSpecStringNoQualNoDimsLst(rest);
        str3 = stringAppendList({str1, ", ", str2});
      then
        str3;
  
  end matchcontinue;
end typeSpecStringNoQualNoDimsLst;

public function crefStringIgnoreSubs
  input ComponentRef inCr;
  output String outStr;
protected
  Path p;  
algorithm
  p := crefToPathIgnoreSubs(inCr);
  outStr := pathString(makeNotFullyQualified(p));
end crefStringIgnoreSubs;

public function importString
  input Import inImp;
  output String outStr;
algorithm
  outStr := Dump.unparseImportStr(inImp);
end importString;

public function refString
"@author: adrpo
 full Ref -> string 
 cref/path full qualified, type dims, subscripts in crefs"
  input Ref inRef;
  output String outStr;
algorithm
  outStr := match(inRef)
    local ComponentRef cr; TypeSpec ts; Import im;
    case (RCR(cr)) then crefString(cr);
    case (RTS(ts)) then typeSpecString(ts);
    case (RIM(im)) then importString(im);
  end match;
end refString;

public function refStringBrief 
"@author: adrpo
 brief Ref -> string 
 no cref/path full qualified, no type dims, no subscripts in crefs"
  input Ref inRef;
  output String outStr;
algorithm
  outStr := match(inRef)
    local ComponentRef cr; TypeSpec ts; Import im;
    case (RCR(cr)) then crefStringIgnoreSubs(cr);
    case (RTS(ts)) then typeSpecStringNoQualNoDims(ts);
    case (RIM(im)) then importString(im);
  end match;
end refStringBrief;

public function getArrayDimOptAsList
  input Option<ArrayDim> inArrayDim;
  output ArrayDim outArrayDim;
algorithm
  outArrayDim := match(inArrayDim)
    local ArrayDim ad;
    case (SOME(ad)) then ad;
    else {}; 
  end match;
end getArrayDimOptAsList;

public function removeCrefFromCrefs
"Removes a variable from a variable list"
  input list<ComponentRef> inAbsynComponentRefLst;
  input ComponentRef inComponentRef;
  output list<ComponentRef> outAbsynComponentRefLst;
algorithm
  outAbsynComponentRefLst := matchcontinue (inAbsynComponentRefLst,inComponentRef)
    local
      String n1,n2;
      list<ComponentRef> rest_1,rest;
      ComponentRef cr1,cr2;
    case ({},_) then {};
    case ((cr1 :: rest),cr2)
      equation
        CREF_IDENT(name = n1,subscripts = {}) = cr1;
        CREF_IDENT(name = n2,subscripts = {}) = cr2;
        true = stringEq(n1, n2);
        rest_1 = removeCrefFromCrefs(rest, cr2);
      then
        rest_1;
    case ((cr1 :: rest),cr2) // If modifier like on comp like: T t(x=t.y) => t.y must be removed
      equation
        CREF_QUAL(name = n1) = cr1;
        CREF_IDENT(name = n2) = cr2;
        true = stringEq(n1, n2);
        rest_1 = removeCrefFromCrefs(rest, cr2);
      then
        rest_1;
    case ((cr1 :: rest),cr2)
      equation
        rest_1 = removeCrefFromCrefs(rest, cr2);
      then
        (cr1 :: rest_1);
  end matchcontinue;
end removeCrefFromCrefs;

public function getNamedAnnotationInClass
  "Retrieve e.g. the documentation annotation as a string from the class passed as argument."
  input Class inClass;
  input Path id;
  input ModFunc f;
  output Option<TypeA> outString;
  replaceable type TypeA subtypeof Any;
  partial function ModFunc
    input Option<Modification> mod;
    output TypeA docStr;
  end ModFunc;
algorithm
  outString := matchcontinue (inClass,id,f)
    local
      TypeA str,res;
      list<ClassPart> parts;
      list<ElementArg> annlst;
      list<Annotation> ann;

    case (CLASS(body = PARTS(ann = ann)),_,_)
      equation
        annlst = List.flatten(List.map(ann,annotationToElementArgs));
        SOME(str) = getNamedAnnotationStr(annlst,id,f);
      then
        SOME(str);

    case (CLASS(body = CLASS_EXTENDS(ann = ann)),_,_)
      equation
        annlst = List.flatten(List.map(ann,annotationToElementArgs));
        SOME(str) = getNamedAnnotationStr(annlst,id,f);
      then
        SOME(str);

    case (CLASS(body = DERIVED(comment = SOME(COMMENT(SOME(ANNOTATION(annlst)),_)))),_,_)
      equation
        SOME(res) = getNamedAnnotationStr(annlst,id,f);
      then
        SOME(res);

    case (CLASS(body = ENUMERATION(comment = SOME(COMMENT(SOME(ANNOTATION(annlst)),_)))),_,_)
      equation
        SOME(res) = getNamedAnnotationStr(annlst,id,f);
      then
        SOME(res);

    case (CLASS(body = OVERLOAD(comment = SOME(COMMENT(SOME(ANNOTATION(annlst)),_)))),_,_)
      equation
        SOME(res) = getNamedAnnotationStr(annlst,id,f);
      then
        SOME(res);

    else NONE();

  end matchcontinue;
end getNamedAnnotationInClass;

protected function getNamedAnnotationStr
"Helper function to getNamedAnnotationInElementitemlist."
  input list<ElementArg> inAbsynElementArgLst;
  input Path id;
  input ModFunc f;
  output Option<TypeA> outString;
  replaceable type TypeA subtypeof Any;
  partial function ModFunc
    input Option<Modification> mod;
    output TypeA docStr;
  end ModFunc;
algorithm
  outString := matchcontinue (inAbsynElementArgLst,id,f)
    local
      TypeA str;
      ElementArg ann;
      Option<Modification> mod;
      list<ElementArg> xs;
      Ident id1,id2;
      Path rest;

    case (((ann as MODIFICATION(path = IDENT(name = id1),modification = mod)) :: _),IDENT(id2),_)
      equation
        true = stringEq(id1, id2);
        str = f(mod);
      then
        SOME(str);

    case (((ann as MODIFICATION(path = IDENT(name = id1),modification = SOME(CLASSMOD(elementArgLst=xs)))) :: _),QUALIFIED(name=id2,path=rest),_)
      equation
        true = stringEq(id1, id2);
      then getNamedAnnotationStr(xs,rest,f);

    case ((_ :: xs),_,_) then getNamedAnnotationStr(xs,id,f);
  end matchcontinue;
end getNamedAnnotationStr;

public function mapCrefParts
  "This function splits each part of a cref into CREF_IDENTs and applies the
   given function to each part. If the given cref is a qualified cref then the
   map function is expected to also return CREF_IDENT, so that the split cref
   can be reconstructed. Otherwise the map function is free to return whatever
   it wants."
  input ComponentRef inCref;
  input MapFunc inMapFunc;
  output ComponentRef outCref;

  partial function MapFunc
    input ComponentRef inCref;
    output ComponentRef outCref;
  end MapFunc;
algorithm
  outCref := match(inCref, inMapFunc)
    local
      Ident name;
      list<Subscript> subs;
      ComponentRef rest_cref;
      ComponentRef cref;

    case (CREF_QUAL(name, subs, rest_cref), _)
      equation
        cref = CREF_IDENT(name, subs);
        CREF_IDENT(name, subs) = inMapFunc(cref);
        rest_cref = mapCrefParts(rest_cref, inMapFunc);
      then
        CREF_QUAL(name, subs, rest_cref);

    case (CREF_FULLYQUALIFIED(cref), _)
      equation
        cref = mapCrefParts(cref, inMapFunc);
      then
        CREF_FULLYQUALIFIED(cref);

    else
      equation
        cref = inMapFunc(inCref);
      then
        cref;

  end match;
end mapCrefParts;

public function opEqual
 input Operator op1;
 input Operator op2;
 output Boolean isEqual;
algorithm
  isEqual := valueEq(op1, op2);
end opEqual;

end Absyn;
