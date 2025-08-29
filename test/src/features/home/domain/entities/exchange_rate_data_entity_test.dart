import 'package:flutter_test/flutter_test.dart';
import 'package:exchange_rate/src/features/home/domain/entities/exchange_rate_data_entity.dart';

void main() {
  group('ExchangeRateDataEntity', () {
    test('should create an ExchangeRateDataEntity with all properties', () {
      const close = 5.25;
      const date = '2024-01-15';
      const high = 5.50;
      const low = 5.00;
      const open = 5.10;

      const entity = ExchangeRateDataEntity(
        close: close,
        date: date,
        high: high,
        low: low,
        open: open,
      );

      expect(entity.close, equals(close));
      expect(entity.date, equals(date));
      expect(entity.high, equals(high));
      expect(entity.low, equals(low));
      expect(entity.open, equals(open));
    });

    test('should create an ExchangeRateDataEntity with null properties', () {
      const entity = ExchangeRateDataEntity();

      expect(entity.close, isNull);
      expect(entity.date, isNull);
      expect(entity.high, isNull);
      expect(entity.low, isNull);
      expect(entity.open, isNull);
    });

    test('should create an ExchangeRateDataEntity with partial properties', () {
      const close = 3.75;
      const date = '2024-01-14';

      const entity = ExchangeRateDataEntity(close: close, date: date);

      expect(entity.close, equals(close));
      expect(entity.date, equals(date));
      expect(entity.high, isNull);
      expect(entity.low, isNull);
      expect(entity.open, isNull);
    });

    test('should return correct props list', () {
      const close = 2.50;
      const date = '2024-01-13';
      const high = 2.75;
      const low = 2.25;
      const open = 2.30;

      const entity = ExchangeRateDataEntity(
        close: close,
        date: date,
        high: high,
        low: low,
        open: open,
      );

      final props = entity.props;

      expect(props, containsAll([close, date, high, low, open]));
      expect(props.length, equals(5));
    });

    test('should be equal when all properties are the same', () {
      const entity1 = ExchangeRateDataEntity(
        close: 1.50,
        date: '2024-01-15',
        high: 1.75,
        low: 1.25,
        open: 1.30,
      );

      const entity2 = ExchangeRateDataEntity(
        close: 1.50,
        date: '2024-01-15',
        high: 1.75,
        low: 1.25,
        open: 1.30,
      );

      expect(entity1, equals(entity2));
      expect(entity1.hashCode, equals(entity2.hashCode));
    });

    test('should not be equal when properties are different', () {
      const entity1 = ExchangeRateDataEntity(close: 1.50, date: '2024-01-15');

      const entity2 = ExchangeRateDataEntity(close: 2.00, date: '2024-01-15');

      expect(entity1, isNot(equals(entity2)));
    });

    test('should handle decimal precision correctly', () {
      const close = 1.23456789;
      const high = 1.99999999;
      const low = 0.00000001;

      const entity = ExchangeRateDataEntity(close: close, high: high, low: low);

      expect(entity.close, equals(close));
      expect(entity.high, equals(high));
      expect(entity.low, equals(low));
    });

    test('should handle different date formats', () {
      const date1 = '2024-01-15';
      const date2 = '2024/01/15';
      const date3 = '15-01-2024';

      const entity1 = ExchangeRateDataEntity(date: date1);
      const entity2 = ExchangeRateDataEntity(date: date2);
      const entity3 = ExchangeRateDataEntity(date: date3);

      expect(entity1.date, equals(date1));
      expect(entity2.date, equals(date2));
      expect(entity3.date, equals(date3));
    });
  });
}
