import 'package:flutter_test/flutter_test.dart';
import 'package:exchange_rate/src/features/home/data/dto/exchange_rate_data_dto.dart';
import 'package:exchange_rate/src/features/home/domain/entities/exchange_rate_data_entity.dart';

void main() {
  group('ExchangeRateDataDTO', () {
    test('should create an instance with valid values', () {
      final dto = ExchangeRateDataDTO(
        close: 5.25,
        date: '2024-01-01',
        high: 5.30,
        low: 5.20,
        open: 5.22,
      );

      expect(dto.close, equals(5.25));
      expect(dto.date, equals('2024-01-01'));
      expect(dto.high, equals(5.30));
      expect(dto.low, equals(5.20));
      expect(dto.open, equals(5.22));
    });

    test('should create an instance with null values', () {
      final dto = ExchangeRateDataDTO();

      expect(dto.close, isNull);
      expect(dto.date, isNull);
      expect(dto.high, isNull);
      expect(dto.low, isNull);
      expect(dto.open, isNull);
    });

    test('should create an instance from valid JSON', () {
      final json = {
        'close': 5.25,
        'date': '2024-01-01',
        'high': 5.30,
        'low': 5.20,
        'open': 5.22,
      };

      final dto = ExchangeRateDataDTO.fromJson(json);

      expect(dto.close, equals(5.25));
      expect(dto.date, equals('2024-01-01'));
      expect(dto.high, equals(5.30));
      expect(dto.low, equals(5.20));
      expect(dto.open, equals(5.22));
    });

    test('should create an instance from JSON with null values', () {
      final json = {
        'close': null,
        'date': null,
        'high': null,
        'low': null,
        'open': null,
      };

      final dto = ExchangeRateDataDTO.fromJson(json);

      expect(dto.close, isNull);
      expect(dto.date, isNull);
      expect(dto.high, isNull);
      expect(dto.low, isNull);
      expect(dto.open, isNull);
    });

    test('should create an instance from JSON with mixed values', () {
      final json = {
        'close': 5.25,
        'date': '2024-01-01',
        'high': null,
        'low': 5.20,
        'open': null,
      };

      final dto = ExchangeRateDataDTO.fromJson(json);

      expect(dto.close, equals(5.25));
      expect(dto.date, equals('2024-01-01'));
      expect(dto.high, isNull);
      expect(dto.low, equals(5.20));
      expect(dto.open, isNull);
    });

    test('should convert numeric values to double correctly', () {
      final json = {
        'close': 5,
        'date': '2024-01-01',
        'high': 5.0,
        'low': 5,
        'open': 5.5,
      };

      final dto = ExchangeRateDataDTO.fromJson(json);

      expect(dto.close, equals(5.0));
      expect(dto.date, equals('2024-01-01'));
      expect(dto.high, equals(5.0));
      expect(dto.low, equals(5.0));
      expect(dto.open, equals(5.5));
    });

    test('should create an instance from an entity', () {
      final entity = ExchangeRateDataEntity(
        close: 5.25,
        date: '2024-01-01',
        high: 5.30,
        low: 5.20,
        open: 5.22,
      );

      final dto = ExchangeRateDataDTO.fromEntity(entity);

      expect(dto.close, equals(5.25));
      expect(dto.date, equals('2024-01-01'));
      expect(dto.high, equals(5.30));
      expect(dto.low, equals(5.20));
      expect(dto.open, equals(5.22));
    });

    test('should create an instance from an entity with null values', () {
      final entity = ExchangeRateDataEntity();

      final dto = ExchangeRateDataDTO.fromEntity(entity);

      expect(dto.close, isNull);
      expect(dto.date, isNull);
      expect(dto.high, isNull);
      expect(dto.low, isNull);
      expect(dto.open, isNull);
    });

    test('should be equal to another instance with the same values', () {
      final dto1 = ExchangeRateDataDTO(
        close: 5.25,
        date: '2024-01-01',
        high: 5.30,
        low: 5.20,
        open: 5.22,
      );

      final dto2 = ExchangeRateDataDTO(
        close: 5.25,
        date: '2024-01-01',
        high: 5.30,
        low: 5.20,
        open: 5.22,
      );

      expect(dto1, equals(dto2));
    });

    test('should be different from another instance with different values', () {
      final dto1 = ExchangeRateDataDTO(
        close: 5.25,
        date: '2024-01-01',
        high: 5.30,
        low: 5.20,
        open: 5.22,
      );

      final dto2 = ExchangeRateDataDTO(
        close: 5.26,
        date: '2024-01-01',
        high: 5.30,
        low: 5.20,
        open: 5.22,
      );

      expect(dto1, isNot(equals(dto2)));
    });

    test('should have correct props for Equatable', () {
      final dto = ExchangeRateDataDTO(
        close: 5.25,
        date: '2024-01-01',
        high: 5.30,
        low: 5.20,
        open: 5.22,
      );

      final props = dto.props;
      expect(props.length, equals(5));
      expect(props[0], equals(5.25));
      expect(props[1], equals('2024-01-01'));
      expect(props[2], equals(5.30));
      expect(props[3], equals(5.20));
      expect(props[4], equals(5.22));
    });

    test('should handle long decimal values correctly', () {
      final json = {
        'close': 5.123456789,
        'date': '2024-01-01',
        'high': 5.987654321,
        'low': 5.111111111,
        'open': 5.999999999,
      };

      final dto = ExchangeRateDataDTO.fromJson(json);

      expect(dto.close, equals(5.123456789));
      expect(dto.high, equals(5.987654321));
      expect(dto.low, equals(5.111111111));
      expect(dto.open, equals(5.999999999));
    });

    test('should handle zero values correctly', () {
      final json = {
        'close': 0.0,
        'date': '2024-01-01',
        'high': 0,
        'low': 0.0,
        'open': 0,
      };

      final dto = ExchangeRateDataDTO.fromJson(json);

      expect(dto.close, equals(0.0));
      expect(dto.high, equals(0.0));
      expect(dto.low, equals(0.0));
      expect(dto.open, equals(0.0));
    });
  });
}
