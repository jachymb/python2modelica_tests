function fractional0004
  input Real r;
  output Real return_value;
  algorithm
    return_value := r;
    while return_value >= 1. loop
      return_value := return_value0 - 1.;
    end while;
end fractional0004;
