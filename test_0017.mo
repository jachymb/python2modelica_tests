function transform0017
  input Real m[3,2];
  output Real return_value[3,2];
  algorithm
    return_value := m;
    return_value := return_value - {{1,2},{3,4},{5,6}};
    return_value := return_value - {{7,7},{7,7},{7,7}};
    return_value := return_value / 2;

end transform0017;
