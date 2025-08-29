import 'package:flutter_test/flutter_test.dart';
import 'package:exchange_rate/src/features/home/domain/entities/exchange_rate_history_entity.dart';
import 'package:exchange_rate/src/features/home/domain/entities/exchange_rate_data_entity.dart';

void main() {
  group('ExchangeRatesEntity', () {
    test('should create an ExchangeRatesEntity with all properties', () {
      final data = [
        const ExchangeRateDataEntity(
          close: 5.25,
          date: '2024-01-15',
          high: 5.50,
          low: 5.00,
          open: 5.10,
        ),
        const ExchangeRateDataEntity(
          close: 5.30,
          date: '2024-01-14',
          high: 5.55,
          low: 5.05,
          open: 5.15,
        ),
      ];
      const from = 'USD';
      const lastUpdatedAt = '2024-01-15T10:30:00Z';
      const rateLimitExceeded = false;
      const success = true;
      const to = 'BRL';

      final entity = ExchangeRatesEntity(
        data: data,
        from: from,
        lastUpdatedAt: lastUpdatedAt,
        rateLimitExceeded: rateLimitExceeded,
        success: success,
        to: to,
      );

      expect(entity.data, equals(data));
      expect(entity.from, equals(from));
      expect(entity.lastUpdatedAt, equals(lastUpdatedAt));
      expect(entity.rateLimitExceeded, equals(rateLimitExceeded));
      expect(entity.success, equals(success));
      expect(entity.to, equals(to));
    });

    test('should create an ExchangeRatesEntity with null properties', () {
      const entity = ExchangeRatesEntity();

      expect(entity.data, isNull);
      expect(entity.from, isNull);
      expect(entity.lastUpdatedAt, isNull);
      expect(entity.rateLimitExceeded, isNull);
      expect(entity.success, isNull);
      expect(entity.to, isNull);
    });

    test('should create an ExchangeRatesEntity with partial properties', () {
      const from = 'EUR';
      const to = 'JPY';

      const entity = ExchangeRatesEntity(from: from, to: to);

      expect(entity.from, equals(from));
      expect(entity.to, equals(to));
      expect(entity.data, isNull);
      expect(entity.lastUpdatedAt, isNull);
      expect(entity.rateLimitExceeded, isNull);
      expect(entity.success, isNull);
    });

    test('should return correct props list', () {
      final data = [
        const ExchangeRateDataEntity(close: 1.50, date: '2024-01-15'),
      ];
      const from = 'USD';
      const lastUpdatedAt = '2024-01-15T12:00:00Z';
      const rateLimitExceeded = false;
      const success = true;
      const to = 'BRL';

      final entity = ExchangeRatesEntity(
        data: data,
        from: from,
        lastUpdatedAt: lastUpdatedAt,
        rateLimitExceeded: rateLimitExceeded,
        success: success,
        to: to,
      );

      final props = entity.props;

      expect(
        props,
        containsAll([
          data,
          from,
          lastUpdatedAt,
          rateLimitExceeded,
          success,
          to,
        ]),
      );
      expect(props.length, equals(6));
    });

    test('should be equal when all properties are the same', () {
      final data = [
        const ExchangeRateDataEntity(close: 1.50, date: '2024-01-15'),
      ];

      final entity1 = ExchangeRatesEntity(
        data: data,
        from: 'USD',
        to: 'BRL',
        success: true,
      );

      final entity2 = ExchangeRatesEntity(
        data: data,
        from: 'USD',
        to: 'BRL',
        success: true,
      );

      expect(entity1, equals(entity2));
      expect(entity1.hashCode, equals(entity2.hashCode));
    });

    test('should not be equal when properties are different', () {
      const entity1 = ExchangeRatesEntity(from: 'USD', to: 'BRL');

      const entity2 = ExchangeRatesEntity(from: 'EUR', to: 'BRL');

      expect(entity1, isNot(equals(entity2)));
    });

    test('should handle empty data list', () {
      final emptyData = <ExchangeRateDataEntity>[];

      final entity = ExchangeRatesEntity(data: emptyData);

      expect(entity.data, equals(emptyData));
      expect(entity.data!.isEmpty, isTrue);
    });

    test('should handle large data list', () {
      final largeData = List.generate(
        100,
        (index) => ExchangeRateDataEntity(
          close: 1.0 + (index * 0.01),
          date: '2024-01-${15 - index}',
        ),
      );

      final entity = ExchangeRatesEntity(data: largeData);

      expect(entity.data, equals(largeData));
      expect(entity.data!.length, equals(100));
    });

    test('should handle special characters in currency symbols', () {
      const from = 'USD\$';
      const to = 'BRL#';

      const entity = ExchangeRatesEntity(from: from, to: to);

      expect(entity.from, equals(from));
      expect(entity.to, equals(to));
    });

    test('should handle different timestamp formats', () {
      const timestamp1 = '2024-01-15T10:30:00Z';
      const timestamp2 = '2024-01-15 10:30:00';
      const timestamp3 = '15/01/2024 10:30';

      const entity1 = ExchangeRatesEntity(lastUpdatedAt: timestamp1);
      const entity2 = ExchangeRatesEntity(lastUpdatedAt: timestamp2);
      const entity3 = ExchangeRatesEntity(lastUpdatedAt: timestamp3);

      expect(entity1.lastUpdatedAt, equals(timestamp1));
      expect(entity2.lastUpdatedAt, equals(timestamp2));
      expect(entity3.lastUpdatedAt, equals(timestamp3));
    });
  });
}
