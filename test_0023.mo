function hasone0023
  input list<Integer> lst;
  output Boolean return_value;
  output list<Integer> modified_lst;

  algorithm
    modified_lst := lst;
    modified_lst := listAppend(modified_lst, {2,2});
    return_value := listMember(1, modified_lst);

end hasone0023;
