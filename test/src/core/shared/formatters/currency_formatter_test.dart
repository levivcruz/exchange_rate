import 'package:flutter_test/flutter_test.dart';

import 'package:exchange_rate/src/core/shared/formatters/currency_formatter.dart';

void main() {
  group('CurrencyFormatter', () {
    group('formatBRL', () {
      test('should format BRL with default 2 decimal places', () {
        final result = CurrencyFormatter.formatBRL(123.456);
        expect(result, equals('R\$ 123,46'));
      });

      test('should format BRL with zero value', () {
        final result = CurrencyFormatter.formatBRL(0.0);
        expect(result, equals('R\$ 0,00'));
      });

      test('should format BRL with negative value', () {
        final result = CurrencyFormatter.formatBRL(-123.456);
        expect(result, equals('R\$ -123,46'));
      });

      test('should format BRL with exact decimal places', () {
        final result = CurrencyFormatter.formatBRL(100.0);
        expect(result, equals('R\$ 100,00'));
      });

      test('should format BRL with many decimal places', () {
        final result = CurrencyFormatter.formatBRL(123.456789);
        expect(result, equals('R\$ 123,46'));
      });

      test('should replace dot with comma', () {
        final result = CurrencyFormatter.formatBRL(1.5);
        expect(result, equals('R\$ 1,50'));
        expect(result, isNot(contains('.')));
        expect(result, contains(','));
      });

      test('should include R\$ prefix', () {
        final result = CurrencyFormatter.formatBRL(42.0);
        expect(result, startsWith('R\$ '));
        expect(result, contains('R\$'));
      });
    });

    group('formatBRLWithDecimals', () {
      test('should format BRL with 0 decimal places', () {
        final result = CurrencyFormatter.formatBRLWithDecimals(123.456, 0);
        expect(result, equals('R\$ 123'));
      });

      test('should format BRL with 1 decimal place', () {
        final result = CurrencyFormatter.formatBRLWithDecimals(123.456, 1);
        expect(result, equals('R\$ 123,5'));
      });

      test('should format BRL with 3 decimal places', () {
        final result = CurrencyFormatter.formatBRLWithDecimals(123.456, 3);
        expect(result, equals('R\$ 123,456'));
      });

      test('should format BRL with 4 decimal places', () {
        final result = CurrencyFormatter.formatBRLWithDecimals(123.456, 4);
        expect(result, equals('R\$ 123,4560'));
      });

      test('should format BRL with zero value and custom decimals', () {
        final result = CurrencyFormatter.formatBRLWithDecimals(0.0, 3);
        expect(result, equals('R\$ 0,000'));
      });

      test('should format BRL with negative value and custom decimals', () {
        final result = CurrencyFormatter.formatBRLWithDecimals(-123.456, 1);
        expect(result, equals('R\$ -123,5'));
      });

      test('should handle rounding correctly', () {
        final result = CurrencyFormatter.formatBRLWithDecimals(123.456, 1);
        expect(result, equals('R\$ 123,5'));
      });
    });

    group('Edge cases', () {
      test('should handle very small values', () {
        final result = CurrencyFormatter.formatBRL(0.001);
        expect(result, equals('R\$ 0,00'));
      });

      test('should handle very large values', () {
        final result = CurrencyFormatter.formatBRL(999999.999);
        expect(result, equals('R\$ 1000000,00'));
      });

      test('should handle infinity', () {
        final result = CurrencyFormatter.formatBRL(double.infinity);
        expect(result, equals('R\$ Infinity'));
      });

      test('should handle negative infinity', () {
        final result = CurrencyFormatter.formatBRL(double.negativeInfinity);
        expect(result, equals('R\$ -Infinity'));
      });

      test('should handle NaN', () {
        final result = CurrencyFormatter.formatBRL(double.nan);
        expect(result, equals('R\$ NaN'));
      });
    });

    group('Integration tests', () {
      test('should maintain consistency between methods', () {
        const value = 123.456;

        final defaultFormat = CurrencyFormatter.formatBRL(value);
        final customFormat = CurrencyFormatter.formatBRLWithDecimals(value, 2);

        expect(defaultFormat, equals(customFormat));
        expect(defaultFormat, equals('R\$ 123,46'));
      });

      test('should chain methods correctly', () {
        const value = 42.123;

        final result1 = CurrencyFormatter.formatBRL(value);
        final result2 = CurrencyFormatter.formatBRLWithDecimals(value, 2);
        final result3 = CurrencyFormatter.formatBRLWithDecimals(value, 3);

        expect(result1, equals('R\$ 42,12'));
        expect(result2, equals('R\$ 42,12'));
        expect(result3, equals('R\$ 42,123'));
      });

      test('should handle different precision levels', () {
        const value = 100.123456;

        final result1 = CurrencyFormatter.formatBRLWithDecimals(value, 0);
        final result2 = CurrencyFormatter.formatBRLWithDecimals(value, 2);
        final result3 = CurrencyFormatter.formatBRLWithDecimals(value, 4);

        expect(result1, equals('R\$ 100'));
        expect(result2, equals('R\$ 100,12'));
        expect(result3, equals('R\$ 100,1235'));
      });
    });
  });
}
