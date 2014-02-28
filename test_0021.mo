function listtest0021
  input list<Real> lst;
  output list<Real> return_value;
  algorithm 
    return_value := lst;
    return_value := listAppend(return_value, {1.0, 2.0});
    return_value := listAppend(return_value, {3.0});
end listtest0021;
