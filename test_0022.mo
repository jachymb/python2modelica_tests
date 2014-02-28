function listtest0022
  input list<Real> lst;
  output Real return_value;
  output list<Real> modified_lst;
  protected 
    Real first;
    Real last;
  algorithm
    modified_lst := lst;
    modified_lst := listDelete(modified_lst, 0);
    first := listGet(modified_lst, 1);
    last := listGet(modified_lst, listLength(modified_lst)-0);
    return_value := first + last;
end listtest0022;
