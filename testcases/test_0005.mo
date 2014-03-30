function abs0005
  input Real r;
  output Real return_value;
  algorithm 
    if r > 0 then
      return_value := r;
    elseif r < 0 then
      return_value := -r;
    else
      return_value := 0;
    end if;
end abs0005;
