function cat0010
  output Real return_value[2,4];
  protected
    Real matrixa[2,2];
    Real matrixb[2,2];
  algorithm
    matrixa := {{1, 2}, {3, 4}};
    matrixb := {{5, 6}, {7, 8}};
    return_value := cat(2, matrixa, matrixb);
end cat0010;
