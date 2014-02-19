function sum0013
  input Real m[:, :];
  output Real return_value;
  protected
    Real first_row[:];
    Real first_col[:];

    Real right_down_square[:, :];
  algorithm
    first_row := m[1, :];
    first_col := m[:, 1];
    right_down_square := m[2:end,2:end];
    return_value := sum(first_row) + sum(first_col) + sum(right_down_square) - m[1,1];
end sum0013;
