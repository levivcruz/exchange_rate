import 'package:flutter_test/flutter_test.dart';

import 'package:exchange_rate/src/core/shared/formatters/number_formatter.dart';

void main() {
  group('NumberFormatter', () {
    group('formatDecimal', () {
      test('should format decimal with custom places', () {
        final result = NumberFormatter.formatDecimal(123.456, 2);
        expect(result, equals('123,46'));
      });

      test('should format decimal with 0 places', () {
        final result = NumberFormatter.formatDecimal(123.456, 0);
        expect(result, equals('123'));
      });

      test('should format decimal with many places', () {
        final result = NumberFormatter.formatDecimal(123.456, 4);
        expect(result, equals('123,4560'));
      });

      test('should handle zero value', () {
        final result = NumberFormatter.formatDecimal(0.0, 2);
        expect(result, equals('0,00'));
      });

      test('should handle negative values', () {
        final result = NumberFormatter.formatDecimal(-123.456, 2);
        expect(result, equals('-123,46'));
      });

      test('should replace dot with comma', () {
        final result = NumberFormatter.formatDecimal(1.5, 1);
        expect(result, equals('1,5'));
        expect(result, isNot(contains('.')));
        expect(result, contains(','));
      });
    });

    group('formatPercentage', () {
      test('should format percentage with default decimal places', () {
        final result = NumberFormatter.formatPercentage(0.1234);
        expect(result, equals('12,34%'));
      });

      test('should format percentage with custom decimal places', () {
        final result = NumberFormatter.formatPercentage(
          0.1234,
          decimalPlaces: 1,
        );
        expect(result, equals('12,3%'));
      });

      test('should format percentage with 0 decimal places', () {
        final result = NumberFormatter.formatPercentage(
          0.1234,
          decimalPlaces: 0,
        );
        expect(result, equals('12%'));
      });

      test('should handle zero percentage', () {
        final result = NumberFormatter.formatPercentage(0.0);
        expect(result, equals('0,00%'));
      });

      test('should handle negative percentage', () {
        final result = NumberFormatter.formatPercentage(-0.1234);
        expect(result, equals('-12,34%'));
      });

      test('should handle large percentages', () {
        final result = NumberFormatter.formatPercentage(2.5);
        expect(result, equals('250,00%'));
      });
    });

    group('formatPercentageWithSign', () {
      test('should format positive percentage with plus sign', () {
        final result = NumberFormatter.formatPercentageWithSign(0.1234);
        expect(result, equals('+12,34%'));
      });

      test('should format negative percentage without plus sign', () {
        final result = NumberFormatter.formatPercentageWithSign(-0.1234);
        expect(result, equals('-12,34%'));
      });

      test('should format zero percentage with plus sign', () {
        final result = NumberFormatter.formatPercentageWithSign(0.0);
        expect(result, equals('+0,00%'));
      });

      test('should format with custom decimal places', () {
        final result = NumberFormatter.formatPercentageWithSign(
          0.1234,
          decimalPlaces: 1,
        );
        expect(result, equals('+12,3%'));
      });

      test('should handle large positive percentage', () {
        final result = NumberFormatter.formatPercentageWithSign(1.5);
        expect(result, equals('+150,00%'));
      });

      test('should handle large negative percentage', () {
        final result = NumberFormatter.formatPercentageWithSign(-0.5);
        expect(result, equals('-50,00%'));
      });
    });

    group('Edge cases', () {
      test('should handle very small numbers', () {
        final result = NumberFormatter.formatDecimal(0.0001, 4);
        expect(result, equals('0,0001'));
      });

      test('should handle infinity', () {
        final result = NumberFormatter.formatDecimal(double.infinity, 2);
        expect(result, equals('Infinity'));
      });

      test('should handle negative infinity', () {
        final result = NumberFormatter.formatDecimal(
          double.negativeInfinity,
          2,
        );
        expect(result, equals('-Infinity'));
      });

      test('should handle NaN', () {
        final result = NumberFormatter.formatDecimal(double.nan, 2);
        expect(result, equals('NaN'));
      });
    });

    group('Integration tests', () {
      test('should chain methods correctly', () {
        final decimal = NumberFormatter.formatDecimal(0.1234, 2);
        final percentage = NumberFormatter.formatPercentage(0.1234);
        final percentageWithSign = NumberFormatter.formatPercentageWithSign(
          0.1234,
        );

        expect(decimal, equals('0,12'));
        expect(percentage, equals('12,34%'));
        expect(percentageWithSign, equals('+12,34%'));
      });

      test('should maintain consistency across methods', () {
        const value = 0.5678;

        final decimal = NumberFormatter.formatDecimal(value * 100, 2);
        final percentage = NumberFormatter.formatPercentage(value);
        final percentageWithSign = NumberFormatter.formatPercentageWithSign(
          value,
        );

        expect(percentage, equals('$decimal%'));
        expect(percentageWithSign, equals('+$decimal%'));
      });
    });
  });
}
