class CurrencyFormatter {
  CurrencyFormatter._(); //coverage:ignore-line

  static String formatBRL(double value) {
    return 'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  static String formatBRLWithDecimals(double value, int decimalPlaces) {
    return 'R\$ ${value.toStringAsFixed(decimalPlaces).replaceAll('.', ',')}';
  }
}
