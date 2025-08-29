import 'package:flutter_test/flutter_test.dart';
import 'package:equatable/equatable.dart';

import 'package:exchange_rate/src/features/home/presentation/blocs/daily_exchange_rate_bloc.dart';

void main() {
  group('DailyExchangeRateEvent', () {
    group('DailyExchangeRateEvent base class', () {
      test('should be abstract and extend Equatable', () {
        expect(DailyExchangeRateEvent, isA<Type>());

        const event = GetDailyExchangeRate(fromSymbol: 'USD', toSymbol: 'BRL');
        expect(event, isA<Equatable>());
      });

      test('should have const constructor', () {
        const event = GetDailyExchangeRate(fromSymbol: 'USD', toSymbol: 'BRL');
        expect(event, isA<DailyExchangeRateEvent>());
      });
    });

    group('GetDailyExchangeRate', () {
      test('should create event with required parameters', () {
        const fromSymbol = 'USD';
        const toSymbol = 'BRL';

        const event = GetDailyExchangeRate(
          fromSymbol: fromSymbol,
          toSymbol: toSymbol,
        );

        expect(event.fromSymbol, equals(fromSymbol));
        expect(event.toSymbol, equals(toSymbol));
      });

      test('should have const constructor', () {
        const event = GetDailyExchangeRate(fromSymbol: 'USD', toSymbol: 'BRL');
        expect(event, isA<GetDailyExchangeRate>());
      });

      test('should extend DailyExchangeRateEvent', () {
        const event = GetDailyExchangeRate(fromSymbol: 'USD', toSymbol: 'BRL');
        expect(event, isA<DailyExchangeRateEvent>());
      });

      test('should extend Equatable', () {
        const event = GetDailyExchangeRate(fromSymbol: 'USD', toSymbol: 'BRL');
        expect(event, isA<Equatable>());
      });

      test('props should contain fromSymbol and toSymbol', () {
        const fromSymbol = 'EUR';
        const toSymbol = 'JPY';

        const event = GetDailyExchangeRate(
          fromSymbol: fromSymbol,
          toSymbol: toSymbol,
        );

        expect(event.props, contains(fromSymbol));
        expect(event.props, contains(toSymbol));
        expect(event.props.length, equals(2));
      });

      test('should be equal when fromSymbol and toSymbol are equal', () {
        const event1 = GetDailyExchangeRate(fromSymbol: 'USD', toSymbol: 'BRL');
        const event2 = GetDailyExchangeRate(fromSymbol: 'USD', toSymbol: 'BRL');

        expect(event1, equals(event2));
        expect(event1.hashCode, equals(event2.hashCode));
      });

      test('should not be equal when fromSymbol differs', () {
        const event1 = GetDailyExchangeRate(fromSymbol: 'USD', toSymbol: 'BRL');
        const event2 = GetDailyExchangeRate(fromSymbol: 'EUR', toSymbol: 'BRL');

        expect(event1, isNot(equals(event2)));
        expect(event1.hashCode, isNot(equals(event2.hashCode)));
      });

      test('should not be equal when toSymbol differs', () {
        const event1 = GetDailyExchangeRate(fromSymbol: 'USD', toSymbol: 'BRL');
        const event2 = GetDailyExchangeRate(fromSymbol: 'USD', toSymbol: 'EUR');

        expect(event1, isNot(equals(event2)));
        expect(event1.hashCode, isNot(equals(event2.hashCode)));
      });

      test('should handle different currency combinations', () {
        const testCases = [
          {'from': 'USD', 'to': 'BRL'},
          {'from': 'EUR', 'to': 'USD'},
          {'from': 'GBP', 'to': 'JPY'},
          {'from': 'CAD', 'to': 'AUD'},
          {'from': 'CHF', 'to': 'CNY'},
        ];

        for (final testCase in testCases) {
          final event = GetDailyExchangeRate(
            fromSymbol: testCase['from']!,
            toSymbol: testCase['to']!,
          );

          expect(event.fromSymbol, equals(testCase['from']));
          expect(event.toSymbol, equals(testCase['to']));
        }
      });

      test('should handle empty strings', () {
        const event = GetDailyExchangeRate(fromSymbol: '', toSymbol: '');

        expect(event.fromSymbol, equals(''));
        expect(event.toSymbol, equals(''));
        expect(event.props, contains(''));
        expect(event.props.length, equals(2));
      });

      test('should handle special characters in symbols', () {
        const event = GetDailyExchangeRate(fromSymbol: 'US\$', toSymbol: 'R\$');

        expect(event.fromSymbol, equals('US\$'));
        expect(event.toSymbol, equals('R\$'));
        expect(event.props, contains('US\$'));
        expect(event.props, contains('R\$'));
      });
    });

    group('ResetDailyExchangeRate', () {
      test('should create event without parameters', () {
        const event = ResetDailyExchangeRate();
        expect(event, isA<ResetDailyExchangeRate>());
      });

      test('should have const constructor', () {
        const event = ResetDailyExchangeRate();
        expect(event, isA<ResetDailyExchangeRate>());
      });

      test('should extend DailyExchangeRateEvent', () {
        const event = ResetDailyExchangeRate();
        expect(event, isA<DailyExchangeRateEvent>());
      });

      test('should extend Equatable', () {
        const event = ResetDailyExchangeRate();
        expect(event, isA<Equatable>());
      });

      test('props should be empty list', () {
        const event = ResetDailyExchangeRate();
        expect(event.props, isEmpty);
        expect(event.props.length, equals(0));
      });

      test('should be equal to other ResetDailyExchangeRate instances', () {
        const event1 = ResetDailyExchangeRate();
        const event2 = ResetDailyExchangeRate();

        expect(event1, equals(event2));
        expect(event1.hashCode, equals(event2.hashCode));
      });

      test('should not be equal to GetDailyExchangeRate', () {
        const resetEvent = ResetDailyExchangeRate();
        const getEvent = GetDailyExchangeRate(
          fromSymbol: 'USD',
          toSymbol: 'BRL',
        );

        expect(resetEvent, isNot(equals(getEvent)));
        expect(resetEvent.hashCode, isNot(equals(getEvent.hashCode)));
      });
    });

    group('Event comparison', () {
      test('GetDailyExchangeRate events should be comparable', () {
        const event1 = GetDailyExchangeRate(fromSymbol: 'USD', toSymbol: 'BRL');
        const event2 = GetDailyExchangeRate(fromSymbol: 'USD', toSymbol: 'BRL');
        const event3 = GetDailyExchangeRate(fromSymbol: 'EUR', toSymbol: 'BRL');

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
        expect(event1.hashCode, equals(event2.hashCode));
        expect(event1.hashCode, isNot(equals(event3.hashCode)));
      });

      test('ResetDailyExchangeRate events should be comparable', () {
        const event1 = ResetDailyExchangeRate();
        const event2 = ResetDailyExchangeRate();

        expect(event1, equals(event2));
        expect(event1.hashCode, equals(event2.hashCode));
      });

      test('different event types should not be equal', () {
        const getEvent = GetDailyExchangeRate(
          fromSymbol: 'USD',
          toSymbol: 'BRL',
        );
        const resetEvent = ResetDailyExchangeRate();

        expect(getEvent, isNot(equals(resetEvent)));
        expect(getEvent.hashCode, isNot(equals(resetEvent.hashCode)));
      });
    });

    group('Event immutability', () {
      test('GetDailyExchangeRate should be immutable', () {
        const event = GetDailyExchangeRate(fromSymbol: 'USD', toSymbol: 'BRL');

        expect(event.fromSymbol, equals('USD'));
        expect(event.toSymbol, equals('BRL'));

        const event2 = GetDailyExchangeRate(fromSymbol: 'USD', toSymbol: 'BRL');
        expect(event, equals(event2));
      });

      test('ResetDailyExchangeRate should be immutable', () {
        const event = ResetDailyExchangeRate();

        const event2 = ResetDailyExchangeRate();
        expect(event, equals(event2));
      });
    });

    group('Edge cases', () {
      test('should handle very long currency symbols', () {
        final longSymbol = 'A' * 100;

        final event = GetDailyExchangeRate(
          fromSymbol: longSymbol,
          toSymbol: longSymbol,
        );

        expect(event.fromSymbol, equals(longSymbol));
        expect(event.toSymbol, equals(longSymbol));
        expect(event.props.length, equals(2));
      });

      test('should handle unicode characters in symbols', () {
        final unicodeSymbol = '€¥£\$¢₿';

        final event = GetDailyExchangeRate(
          fromSymbol: unicodeSymbol,
          toSymbol: unicodeSymbol,
        );

        expect(event.fromSymbol, equals(unicodeSymbol));
        expect(event.toSymbol, equals(unicodeSymbol));
        expect(event.props, contains(unicodeSymbol));
      });

      test('should handle numbers in symbols', () {
        final event = GetDailyExchangeRate(fromSymbol: '123', toSymbol: '456');

        expect(event.fromSymbol, equals('123'));
        expect(event.toSymbol, equals('456'));
        expect(event.props, contains('123'));
        expect(event.props, contains('456'));
      });
    });
  });
}
