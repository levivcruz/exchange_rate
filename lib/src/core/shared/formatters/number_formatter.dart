class NumberFormatter {
  NumberFormatter._(); //coverage:ignore-line

  static String formatDecimal(double value, int decimalPlaces) {
    return value.toStringAsFixed(decimalPlaces).replaceAll('.', ',');
  }

  static String formatPercentage(double value, {int decimalPlaces = 2}) {
    final percentage = value * 100;
    return '${formatDecimal(percentage, decimalPlaces)}%';
  }

  static String formatPercentageWithSign(
    double value, {
    int decimalPlaces = 2,
  }) {
    final sign = value >= 0 ? '+' : '';
    final percentage = value * 100;
    return '$sign${formatDecimal(percentage, decimalPlaces)}%';
  }
}
