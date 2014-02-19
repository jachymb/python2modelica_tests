function asgn0015
  input Real m[:, :];
  output Real modified_m[:, :];
  algorithm
    modified_m := m;
    modified_m[1,1:2] := {0, 0};
    modified_m[1:2,1] := {1, 1};
    modified_m[2,2] := modified_m[1,1];
    modified_m[1:1, 2:2] := ones(1,1);
end asgn0015;
