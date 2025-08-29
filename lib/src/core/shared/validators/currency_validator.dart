class CurrencyValidator {
  static const Set<String> _validCurrencyCodes = {
    'USD',
    'EUR',
    'GBP',
    'JPY',
    'CAD',
    'AUD',
    'CHF',

    'BRL',
    'CNY',
    'INR',
    'MXN',
    'RUB',
    'ZAR',
    'TRY',

    'SGD',
    'HKD',
    'KRW',
    'THB',
    'MYR',
    'IDR',
    'PHP',
    'VND',

    'NOK',
    'SEK',
    'DKK',
    'PLN',
    'CZK',
    'HUF',
    'RON',
    'BGN',
    'HRK',

    'SAR',
    'AED',
    'QAR',
    'KWD',
    'BHD',
    'OMR',

    'NZD',
    'CLP',
    'COP',
    'PEN',
    'UYU',
    'ARS',
    'ILS',
    'EGP',
    'NGN',
    'KES',
    'GHS',
    'MAD',
    'TND',
  };

  static bool isValid(String code) {
    if (code.isEmpty) return false;

    final normalizedCode = code.trim().toUpperCase();

    if (!RegExp(r'^[A-Z]{3}$').hasMatch(normalizedCode)) {
      return false;
    }

    return _validCurrencyCodes.contains(normalizedCode);
  }

  static String? getErrorMessage(String code) {
    if (code.isEmpty) return null;

    final normalizedCode = code.trim().toUpperCase();

    if (normalizedCode.length != 3) {
      return 'Should be 3 characters';
    }

    if (!RegExp(r'^[A-Z]{3}$').hasMatch(normalizedCode)) {
      return 'Only letters are allowed';
    }

    if (!_validCurrencyCodes.contains(normalizedCode)) {
      return 'Currency code not recognized';
    }

    return null;
  }

  static List<String> getSuggestions(String partialCode) {
    if (partialCode.isEmpty) return [];

    final normalizedCode = partialCode.trim().toUpperCase();
    final suggestions = <String>[];

    for (final code in _validCurrencyCodes) {
      if (code.startsWith(normalizedCode) && code != normalizedCode) {
        suggestions.add(code);
      }
    }

    return suggestions.take(5).toList();
  }
}
