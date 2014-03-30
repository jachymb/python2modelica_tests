function cat0009
  output Real return_value[4,2];
  protected
    Real matrixa[2,2];
    Real matrixb[2,2];
  algorithm
    matrixa := {{1, 2}, {3, 4}};
    matrixb := {{5, 6}, {7, 8}};
    return_value := cat(1, matrixa, matrixb);
end cat0009;
