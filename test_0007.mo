function transform0007
  input Real r[2,2]; 
  output Real return_value0[2,3];

  protected
    Real local_variable0[2,2];

  algorithm 
     local_variable0 := r;
     local_variable0 := local_variable0 .+ ones(2,2);
     local_variable0 := local_variable0 .+ 1;
     return_value0 := local_variable0 * [1,0,1;0,2,1];

end transform0007;
