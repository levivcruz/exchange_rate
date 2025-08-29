import 'package:flutter_test/flutter_test.dart';
import 'package:exchange_rate/src/features/home/domain/entities/current_exchange_rate_entity.dart';

void main() {
  group('CurrentExchangeRateEntity', () {
    test('should create a CurrentExchangeRateEntity with all properties', () {
      const exchangeRate = 5.25;
      const fromSymbol = 'USD';
      const lastUpdatedAt = '2024-01-15T10:30:00Z';
      const rateLimitExceeded = false;
      const success = true;
      const toSymbol = 'BRL';

      const entity = CurrentExchangeRateEntity(
        exchangeRate: exchangeRate,
        fromSymbol: fromSymbol,
        lastUpdatedAt: lastUpdatedAt,
        rateLimitExceeded: rateLimitExceeded,
        success: success,
        toSymbol: toSymbol,
      );

      expect(entity.exchangeRate, equals(exchangeRate));
      expect(entity.fromSymbol, equals(fromSymbol));
      expect(entity.lastUpdatedAt, equals(lastUpdatedAt));
      expect(entity.rateLimitExceeded, equals(rateLimitExceeded));
      expect(entity.success, equals(success));
      expect(entity.toSymbol, equals(toSymbol));
    });

    test('should create a CurrentExchangeRateEntity with null properties', () {
      const entity = CurrentExchangeRateEntity();

      expect(entity.exchangeRate, isNull);
      expect(entity.fromSymbol, isNull);
      expect(entity.lastUpdatedAt, isNull);
      expect(entity.rateLimitExceeded, isNull);
      expect(entity.success, isNull);
      expect(entity.toSymbol, isNull);
    });

    test(
      'should create a CurrentExchangeRateEntity with partial properties',
      () {
        const exchangeRate = 3.75;
        const fromSymbol = 'EUR';

        const entity = CurrentExchangeRateEntity(
          exchangeRate: exchangeRate,
          fromSymbol: fromSymbol,
        );

        expect(entity.exchangeRate, equals(exchangeRate));
        expect(entity.fromSymbol, equals(fromSymbol));
        expect(entity.lastUpdatedAt, isNull);
        expect(entity.rateLimitExceeded, isNull);
        expect(entity.success, isNull);
        expect(entity.toSymbol, isNull);
      },
    );

    test('should return correct props list', () {
      const exchangeRate = 2.50;
      const fromSymbol = 'JPY';
      const lastUpdatedAt = '2024-01-15T12:00:00Z';
      const rateLimitExceeded = false;
      const success = true;
      const toSymbol = 'BRL';

      const entity = CurrentExchangeRateEntity(
        exchangeRate: exchangeRate,
        fromSymbol: fromSymbol,
        lastUpdatedAt: lastUpdatedAt,
        rateLimitExceeded: rateLimitExceeded,
        success: success,
        toSymbol: toSymbol,
      );

      final props = entity.props;

      expect(
        props,
        containsAll([
          exchangeRate,
          fromSymbol,
          lastUpdatedAt,
          rateLimitExceeded,
          success,
          toSymbol,
        ]),
      );
      expect(props.length, equals(6));
    });

    test('should be equal when all properties are the same', () {
      const entity1 = CurrentExchangeRateEntity(
        exchangeRate: 1.50,
        fromSymbol: 'USD',
        toSymbol: 'BRL',
        success: true,
      );

      const entity2 = CurrentExchangeRateEntity(
        exchangeRate: 1.50,
        fromSymbol: 'USD',
        toSymbol: 'BRL',
        success: true,
      );

      expect(entity1, equals(entity2));
      expect(entity1.hashCode, equals(entity2.hashCode));
    });

    test('should not be equal when properties are different', () {
      const entity1 = CurrentExchangeRateEntity(
        exchangeRate: 1.50,
        fromSymbol: 'USD',
      );

      const entity2 = CurrentExchangeRateEntity(
        exchangeRate: 2.00,
        fromSymbol: 'USD',
      );

      expect(entity1, isNot(equals(entity2)));
    });
  });
}
