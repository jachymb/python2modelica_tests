function fortest0024
  input list<Real> lst;
  output list<Real> modified_lst;
  output Real result;
  protected Real elem;
  algorithm 
    modified_lst := lst;
    modified_lst := listAppend(modified_lst, modified_lst);
    result := 0.0;
    for local_variable0 in (1:listLength(modified_lst)) loop
      elem := listGet(modified_lst, local_variable0);
      result := result + elem;
    end for;
end fortest0024;
