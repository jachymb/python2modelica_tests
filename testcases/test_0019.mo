function test0019
  input Integer n;
  output Real return_value;
  protected
    Real m[n,n];
  algorithm
    m := identity(n);
    for local_variable0 in 1:n loop
      m[local_variable0] := m[local_variable0] + linspace(0,1,n);
    end for;
    return_value := sum(m);
end test0019;
