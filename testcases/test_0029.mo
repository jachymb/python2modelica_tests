function fromjust0029
  input Option<Real> v;
  output Real return_value;
  protected
    Real local_variable0;
  algorithm
    return_value := match v 
      case(SOME(local_variable0)) then local_variable0;
      else 0;
    end match;
      

end fromjust0029;
