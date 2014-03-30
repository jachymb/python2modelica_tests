function transform0017
  input Real m[3,2];
  output Real return_value[3,2];
  algorithm
    return_value := m;
    return_value := return_value - {{1,2},{3,4},{5,6}};
    for local_variable0 in 1:3 loop
      return_value[local_variable0] := return_value[local_variable0] - {7,7};
    end for;
    return_value := return_value / 2;

end transform0017;
