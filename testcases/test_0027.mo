function tupleunpack0027
  input Real a;
  input Real b;
  output Real s;
  protected 
    tuple<Real, Real> t;
    Real c;
    Real d;
  algorithm
    t := (a, b);
    s := match t
         case (c, d) then
         c + d;
    end match;
end tupleunpack0027;
