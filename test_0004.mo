function fractional0004
  input Real r;
  output Real return_value0;
  algorithm
    return_value0 := r;
    while return_value0 >= 1. loop
      return_value0 := return_value0 - 1.;
    end while;
end fractional0004;
