function test0030
  input list<Option<Real>> v;
  output list<Option<Real>> modified_v;
  algorithm
    modified_v := v;
    modified_v := listAppend(modified_v, {SOME(1.0)});
    modified_v := listAppend(modified_v, {NONE()});
end test0030;
