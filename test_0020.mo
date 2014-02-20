function anonymous_function0
  input Real x;
  input Real y;
  output Real return_value;
  algorithm
    return_value := x + y;
end anonymous_function0;

function sum0020
  input Real a;
  input Real b;
  output Real return_value;
  algorithm
    return_value := anonymous_function0(a,b);
end sum0020;
