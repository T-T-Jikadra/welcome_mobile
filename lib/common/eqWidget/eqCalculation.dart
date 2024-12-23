// Methods to do transaction calculation ..

// Method to calculate Discounts ..
Map<String, double> calcDiscounts(
    {required double amount,
    required double discPer,
    required double discAmt,
    required double discPer2}) {
  double nDiscAmt = 0;
  double nDiscAmt2 = 0;

  if (discPer > 0) {
    nDiscAmt = (amount * discPer) / 100;
  }

  if (discPer2 > 0) {
    nDiscAmt2 = ((amount - nDiscAmt) * discPer2) / 100;
  }

  return {
    'discamt': nDiscAmt,
    'discamt2': nDiscAmt2,
  };
}

// Method to calculate taxable value ..
double calcTaxableValue({
  required double nAmount,
  double nFoldAmt = 0.0,
  required double nDiscAmt,
  required double nDiscAmt2,
}) {
  return nAmount - nFoldAmt - nDiscAmt - nDiscAmt2;
}

// Method to calculate final amount ..
double calcFinalAmount({
  required double nTaxableValue,
  required double nCGSTAmt,
  required double nSGSTAmt,
  required double NIGSTAmt,
}) {
  return nTaxableValue + nCGSTAmt + nSGSTAmt + NIGSTAmt;
}

// Method to calculate CGST amount ..
double calcCGSTAmount(
    {required double nTaxableValue, required double nCGSTRate}) {
  if (nCGSTRate > 0) {
    return ((nTaxableValue * nCGSTRate) / 100);
  }
  return 0.0;
}

// Method to calculate SGST amount ..
double calcSGSTAmount(
    {required double nTaxableValue, required double nSGSTRate}) {
  if (nSGSTRate > 0) {
    return ((nTaxableValue * nSGSTRate) / 100);
  }
  return 0.0;
}

// Method to calculate IGST amount ..
double calcIGSTAmount(
    {required double nTaxableValue, required double nIGSTRate}) {
  if (nIGSTRate > 0) {
    return ((nTaxableValue * nIGSTRate) / 100);
  }
  return 0.0;
}
