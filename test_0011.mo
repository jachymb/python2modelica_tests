function test0011
  input Real r;
  output Real matrix[2,2];
  algorithm
    matrix := zeros(2,2);
    matrix := matrix + (r .* ones(2,2));
end test0011;
