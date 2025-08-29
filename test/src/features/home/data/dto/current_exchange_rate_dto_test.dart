import 'package:flutter_test/flutter_test.dart';
import 'package:exchange_rate/src/features/home/data/dto/current_exchange_rate_dto.dart';

void main() {
  group('CurrentExchangeRateDTO', () {
    test('should create an instance with valid values', () {
      final dto = CurrentExchangeRateDTO(
        exchangeRate: 5.25,
        fromSymbol: 'USD',
        lastUpdatedAt: '2024-01-01T10:00:00Z',
        rateLimitExceeded: false,
        success: true,
        toSymbol: 'BRL',
      );

      expect(dto.exchangeRate, equals(5.25));
      expect(dto.fromSymbol, equals('USD'));
      expect(dto.lastUpdatedAt, equals('2024-01-01T10:00:00Z'));
      expect(dto.rateLimitExceeded, isFalse);
      expect(dto.success, isTrue);
      expect(dto.toSymbol, equals('BRL'));
    });

    test('should create an instance with null values', () {
      final dto = CurrentExchangeRateDTO();

      expect(dto.exchangeRate, isNull);
      expect(dto.fromSymbol, isNull);
      expect(dto.lastUpdatedAt, isNull);
      expect(dto.rateLimitExceeded, isNull);
      expect(dto.success, isNull);
      expect(dto.toSymbol, isNull);
    });

    test('should create an instance from valid JSON', () {
      final json = {
        'exchangeRate': 5.25,
        'fromSymbol': 'USD',
        'lastUpdatedAt': '2024-01-01T10:00:00Z',
        'rateLimitExceeded': false,
        'success': true,
        'toSymbol': 'BRL',
      };

      final dto = CurrentExchangeRateDTO.fromJson(json);

      expect(dto.exchangeRate, equals(5.25));
      expect(dto.fromSymbol, equals('USD'));
      expect(dto.lastUpdatedAt, equals('2024-01-01T10:00:00Z'));
      expect(dto.rateLimitExceeded, isFalse);
      expect(dto.success, isTrue);
      expect(dto.toSymbol, equals('BRL'));
    });

    test('should create an instance from JSON with null values', () {
      final json = {
        'exchangeRate': null,
        'fromSymbol': null,
        'lastUpdatedAt': null,
        'rateLimitExceeded': null,
        'success': null,
        'toSymbol': null,
      };

      final dto = CurrentExchangeRateDTO.fromJson(json);

      expect(dto.exchangeRate, isNull);
      expect(dto.fromSymbol, isNull);
      expect(dto.lastUpdatedAt, isNull);
      expect(dto.rateLimitExceeded, isNull);
      expect(dto.success, isNull);
      expect(dto.toSymbol, isNull);
    });

    test('should create an instance from JSON with mixed values', () {
      final json = {
        'exchangeRate': 5.25,
        'fromSymbol': 'EUR',
        'lastUpdatedAt': null,
        'rateLimitExceeded': true,
        'success': false,
        'toSymbol': 'JPY',
      };

      final dto = CurrentExchangeRateDTO.fromJson(json);

      expect(dto.exchangeRate, equals(5.25));
      expect(dto.fromSymbol, equals('EUR'));
      expect(dto.lastUpdatedAt, isNull);
      expect(dto.rateLimitExceeded, isTrue);
      expect(dto.success, isFalse);
      expect(dto.toSymbol, equals('JPY'));
    });

    test('should convert numeric values to double correctly', () {
      final json = {
        'exchangeRate': 5,
        'fromSymbol': 'USD',
        'lastUpdatedAt': '2024-01-01T10:00:00Z',
        'rateLimitExceeded': false,
        'success': true,
        'toSymbol': 'BRL',
      };

      final dto = CurrentExchangeRateDTO.fromJson(json);

      expect(dto.exchangeRate, equals(5.0));
      expect(dto.fromSymbol, equals('USD'));
      expect(dto.toSymbol, equals('BRL'));
    });

    test('should handle different currencies', () {
      final currencies = [
        'USD',
        'EUR',
        'GBP',
        'JPY',
        'BRL',
        'CAD',
        'AUD',
        'CHF',
      ];

      for (final fromCurrency in currencies) {
        for (final toCurrency in currencies) {
          if (fromCurrency != toCurrency) {
            final json = {
              'exchangeRate': 1.5,
              'fromSymbol': fromCurrency,
              'lastUpdatedAt': '2024-01-01T10:00:00Z',
              'rateLimitExceeded': false,
              'success': true,
              'toSymbol': toCurrency,
            };

            final dto = CurrentExchangeRateDTO.fromJson(json);

            expect(dto.fromSymbol, equals(fromCurrency));
            expect(dto.toSymbol, equals(toCurrency));
            expect(dto.exchangeRate, equals(1.5));
          }
        }
      }
    });

    test('should be equal to another instance with the same values', () {
      final dto1 = CurrentExchangeRateDTO(
        exchangeRate: 5.25,
        fromSymbol: 'USD',
        lastUpdatedAt: '2024-01-01T10:00:00Z',
        rateLimitExceeded: false,
        success: true,
        toSymbol: 'BRL',
      );

      final dto2 = CurrentExchangeRateDTO(
        exchangeRate: 5.25,
        fromSymbol: 'USD',
        lastUpdatedAt: '2024-01-01T10:00:00Z',
        rateLimitExceeded: false,
        success: true,
        toSymbol: 'BRL',
      );

      expect(dto1, equals(dto2));
    });

    test('should be different from another instance with different values', () {
      final dto1 = CurrentExchangeRateDTO(
        exchangeRate: 5.25,
        fromSymbol: 'USD',
        lastUpdatedAt: '2024-01-01T10:00:00Z',
        rateLimitExceeded: false,
        success: true,
        toSymbol: 'BRL',
      );

      final dto2 = CurrentExchangeRateDTO(
        exchangeRate: 5.26,
        fromSymbol: 'USD',
        lastUpdatedAt: '2024-01-01T10:00:00Z',
        rateLimitExceeded: false,
        success: true,
        toSymbol: 'BRL',
      );

      expect(dto1, isNot(equals(dto2)));
    });

    test('should have correct props for Equatable', () {
      final dto = CurrentExchangeRateDTO(
        exchangeRate: 5.25,
        fromSymbol: 'USD',
        lastUpdatedAt: '2024-01-01T10:00:00Z',
        rateLimitExceeded: false,
        success: true,
        toSymbol: 'BRL',
      );

      final props = dto.props;
      expect(props.length, equals(6));
      expect(props[0], equals(5.25));
      expect(props[1], equals('USD'));
      expect(props[2], equals('2024-01-01T10:00:00Z'));
      expect(props[3], isFalse);
      expect(props[4], isTrue);
      expect(props[5], equals('BRL'));
    });

    test('should handle long decimal values correctly', () {
      final json = {
        'exchangeRate': 5.123456789,
        'fromSymbol': 'USD',
        'lastUpdatedAt': '2024-01-01T10:00:00Z',
        'rateLimitExceeded': false,
        'success': true,
        'toSymbol': 'BRL',
      };

      final dto = CurrentExchangeRateDTO.fromJson(json);

      expect(dto.exchangeRate, equals(5.123456789));
      expect(dto.fromSymbol, equals('USD'));
      expect(dto.toSymbol, equals('BRL'));
    });

    test('should handle zero values correctly', () {
      final json = {
        'exchangeRate': 0.0,
        'fromSymbol': 'USD',
        'lastUpdatedAt': '2024-01-01T10:00:00Z',
        'rateLimitExceeded': false,
        'success': true,
        'toSymbol': 'BRL',
      };

      final dto = CurrentExchangeRateDTO.fromJson(json);

      expect(dto.exchangeRate, equals(0.0));
      expect(dto.fromSymbol, equals('USD'));
      expect(dto.toSymbol, equals('BRL'));
    });

    test('should handle boolean values correctly', () {
      final json = {
        'exchangeRate': 5.25,
        'fromSymbol': 'USD',
        'lastUpdatedAt': '2024-01-01T10:00:00Z',
        'rateLimitExceeded': true,
        'success': false,
        'toSymbol': 'BRL',
      };

      final dto = CurrentExchangeRateDTO.fromJson(json);

      expect(dto.rateLimitExceeded, isTrue);
      expect(dto.success, isFalse);
    });

    test('should handle empty strings correctly', () {
      final json = {
        'exchangeRate': 5.25,
        'fromSymbol': '',
        'lastUpdatedAt': '',
        'rateLimitExceeded': false,
        'success': true,
        'toSymbol': '',
      };

      final dto = CurrentExchangeRateDTO.fromJson(json);

      expect(dto.fromSymbol, equals(''));
      expect(dto.lastUpdatedAt, equals(''));
      expect(dto.toSymbol, equals(''));
    });
  });
}
