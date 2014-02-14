function abs0005
  input Real r;
  output Real return_value0;
  algorithm 
    if r > 0 then
      return_value0 := r;
    elseif r < 0 then
      return_value0 := -r;
    else
      return_value0 := 0;
    end if;
end abs0005;
