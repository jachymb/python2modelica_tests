function addc0006
  input Real r;
  output Real return_value;
  protected
    Real myconstant;
  algorithm
    myconstant := 12.3;
    return_value := r + myconstant;
end addc0006;
