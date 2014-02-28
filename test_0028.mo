function asin0028
  input Real x;
  output Option<Real> return_value;
  algorithm
    if x > 1.0 or x < -1.0 then
      return_value := NONE();
    else
      return_value := SOME(asin(x));
    end if;
end asin0028;
