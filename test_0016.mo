function test0016
  input Real r[3];
  output Real return_value[0];
  protected
    Real empty1[0];
    Real empty2[3,0];
  algorithm
    return_value := r * empty2 + empty1;
end test0016;
