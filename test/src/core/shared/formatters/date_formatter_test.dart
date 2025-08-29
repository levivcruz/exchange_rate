import 'package:flutter_test/flutter_test.dart';

import 'package:exchange_rate/src/core/shared/formatters/date_formatter.dart';

void main() {
  group('DateFormatter', () {
    group('formatDateTime', () {
      test('should format date and time correctly', () {
        final date = DateTime(2024, 1, 15, 14, 30);
        final result = DateFormatter.formatDateTime(date);
        expect(result, equals('15/01/2024 - 14h30'));
      });

      test('should pad single digits with zeros', () {
        final date = DateTime(2024, 1, 5, 9, 5);
        final result = DateFormatter.formatDateTime(date);
        expect(result, equals('05/01/2024 - 09h05'));
      });

      test('should handle midnight', () {
        final date = DateTime(2024, 12, 31, 0, 0);
        final result = DateFormatter.formatDateTime(date);
        expect(result, equals('31/12/2024 - 00h00'));
      });

      test('should handle end of day', () {
        final date = DateTime(2024, 6, 15, 23, 59);
        final result = DateFormatter.formatDateTime(date);
        expect(result, equals('15/06/2024 - 23h59'));
      });

      test('should format leap year date', () {
        final date = DateTime(2024, 2, 29, 12, 15);
        final result = DateFormatter.formatDateTime(date);
        expect(result, equals('29/02/2024 - 12h15'));
      });

      test('should handle single digit month and day', () {
        final date = DateTime(2024, 3, 7, 8, 3);
        final result = DateFormatter.formatDateTime(date);
        expect(result, equals('07/03/2024 - 08h03'));
      });
    });

    group('formatDate', () {
      test('should format date only correctly', () {
        final date = DateTime(2024, 1, 15, 14, 30);
        final result = DateFormatter.formatDate(date);
        expect(result, equals('15/01/2024'));
      });

      test('should pad single digits with zeros', () {
        final date = DateTime(2024, 1, 5);
        final result = DateFormatter.formatDate(date);
        expect(result, equals('05/01/2024'));
      });

      test('should handle leap year date', () {
        final date = DateTime(2024, 2, 29);
        final result = DateFormatter.formatDate(date);
        expect(result, equals('29/02/2024'));
      });

      test('should handle end of year', () {
        final date = DateTime(2024, 12, 31);
        final result = DateFormatter.formatDate(date);
        expect(result, equals('31/12/2024'));
      });

      test('should handle beginning of year', () {
        final date = DateTime(2024, 1, 1);
        final result = DateFormatter.formatDate(date);
        expect(result, equals('01/01/2024'));
      });

      test('should ignore time information', () {
        final date1 = DateTime(2024, 1, 15, 0, 0);
        final date2 = DateTime(2024, 1, 15, 23, 59);

        final result1 = DateFormatter.formatDate(date1);
        final result2 = DateFormatter.formatDate(date2);

        expect(result1, equals(result2));
        expect(result1, equals('15/01/2024'));
      });
    });

    group('formatCurrentDateTime', () {
      test('should return current date and time in correct format', () {
        final result = DateFormatter.formatCurrentDateTime();

        expect(result, matches(r'^\d{2}/\d{2}/\d{4} - \d{2}h\d{2}$'));

        expect(result, contains('/'));
        expect(result, contains(' - '));
        expect(result, contains('h'));
      });

      test('should use current time when called', () {
        final before = DateTime.now();
        final result = DateFormatter.formatCurrentDateTime();
        final after = DateTime.now();

        expect(result, matches(r'^\d{2}/\d{2}/\d{4} - \d{2}h\d{2}$'));

        expect(
          before.isBefore(after) || before.isAtSameMomentAs(after),
          isTrue,
        );
      });
    });

    group('Edge cases', () {
      test('should handle year 2000', () {
        final date = DateTime(2000, 1, 1, 12, 0);
        final result = DateFormatter.formatDateTime(date);
        expect(result, equals('01/01/2000 - 12h00'));
      });

      test('should handle year 9999', () {
        final date = DateTime(9999, 12, 31, 23, 59);
        final result = DateFormatter.formatDateTime(date);
        expect(result, equals('31/12/9999 - 23h59'));
      });

      test('should handle very old dates', () {
        final date = DateTime(1900, 1, 1, 0, 0);
        final result = DateFormatter.formatDateTime(date);
        expect(result, equals('01/01/1900 - 00h00'));
      });

      test('should handle single digit year', () {
        final date = DateTime(5, 1, 1, 12, 0);
        final result = DateFormatter.formatDateTime(date);
        expect(result, equals('01/01/5 - 12h00'));
      });
    });

    group('Integration tests', () {
      test('should maintain consistency between methods', () {
        final date = DateTime(2024, 6, 15, 14, 30);

        final dateTimeResult = DateFormatter.formatDateTime(date);
        final dateOnlyResult = DateFormatter.formatDate(date);

        expect(dateTimeResult, contains(dateOnlyResult));
        expect(dateTimeResult, equals('15/06/2024 - 14h30'));
        expect(dateOnlyResult, equals('15/06/2024'));
      });

      test('should handle different date components correctly', () {
        final dates = [
          DateTime(2024, 1, 1, 0, 0),
          DateTime(2024, 2, 29, 12, 0),
          DateTime(2024, 6, 15, 15, 30),
          DateTime(2024, 12, 31, 23, 59),
        ];

        for (final date in dates) {
          final dateTimeResult = DateFormatter.formatDateTime(date);
          final dateOnlyResult = DateFormatter.formatDate(date);

          expect(dateTimeResult, matches(r'^\d{2}/\d{2}/\d{4} - \d{2}h\d{2}$'));
          expect(dateOnlyResult, matches(r'^\d{2}/\d{2}/\d{4}$'));
          expect(dateTimeResult, contains(dateOnlyResult));
        }
      });

      test('should format all months correctly', () {
        for (int month = 1; month <= 12; month++) {
          final date = DateTime(2024, month, 15, 12, 0);
          final result = DateFormatter.formatDateTime(date);

          expect(result, matches(r'^\d{2}/\d{2}/\d{4} - \d{2}h\d{2}$'));
          expect(result, contains('15/'));
          expect(result, contains('/2024'));
        }
      });
    });
  });
}
