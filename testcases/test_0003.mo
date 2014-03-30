function sum_even0003
  input Integer n;
  output Integer result;
  
  algorithm
    result := 0;
    for x in 0:2:n loop
      result := result + x;
    end for;
end sum_even0003;
