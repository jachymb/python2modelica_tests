function transform0018
  input Real m[3];
  output Real modified_m[3];
  output Real return_value[3];
  algorithm
    return_value := m;

    return_value := return_value + {1,2,3};
    
    return_value := return_value .+ 1;

    return_value := return_value .* return_value;
    modified_m := return_value;
    
    return_value := return_value .+ 1;

    return_value := return_value .+ 1;
    
    return_value := return_value .* return_value;

    return_value := return_value + {1,2,3};
end transform0018;
