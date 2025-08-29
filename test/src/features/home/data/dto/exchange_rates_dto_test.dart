import 'package:flutter_test/flutter_test.dart';
import 'package:exchange_rate/src/features/home/data/dto/exchange_rates_dto.dart';
import 'package:exchange_rate/src/features/home/data/dto/exchange_rate_data_dto.dart';

void main() {
  group('ExchangeRatesDTO', () {
    test('should create an instance with valid values', () {
      final dto = ExchangeRatesDTO(
        data: [
          ExchangeRateDataDTO(
            close: 5.25,
            date: '2024-01-01',
            high: 5.30,
            low: 5.20,
            open: 5.22,
          ),
        ],
        from: 'USD',
        lastUpdatedAt: '2024-01-01T10:00:00Z',
        rateLimitExceeded: false,
        success: true,
        to: 'BRL',
      );

      expect(dto.data, isA<List>());
      expect(dto.data!.length, equals(1));
      expect(dto.from, equals('USD'));
      expect(dto.to, equals('BRL'));
      expect(dto.success, isTrue);
      expect(dto.rateLimitExceeded, isFalse);
      expect(dto.lastUpdatedAt, equals('2024-01-01T10:00:00Z'));
    });

    test('should create an instance with null values', () {
      final dto = ExchangeRatesDTO();

      expect(dto.data, isNull);
      expect(dto.from, isNull);
      expect(dto.to, isNull);
      expect(dto.success, isNull);
      expect(dto.rateLimitExceeded, isNull);
      expect(dto.lastUpdatedAt, isNull);
    });

    test('should create an instance from valid JSON', () {
      final json = {
        'data': [
          {
            'close': 5.25,
            'date': '2024-01-01',
            'high': 5.30,
            'low': 5.20,
            'open': 5.22,
          },
          {
            'close': 5.28,
            'date': '2024-01-02',
            'high': 5.35,
            'low': 5.25,
            'open': 5.26,
          },
        ],
        'from': 'USD',
        'lastUpdatedAt': '2024-01-02T10:00:00Z',
        'rateLimitExceeded': false,
        'success': true,
        'to': 'BRL',
      };

      final dto = ExchangeRatesDTO.fromJson(json);

      expect(dto.data, isA<List>());
      expect(dto.data!.length, equals(2));
      expect(dto.from, equals('USD'));
      expect(dto.to, equals('BRL'));
      expect(dto.success, isTrue);
      expect(dto.rateLimitExceeded, isFalse);
      expect(dto.lastUpdatedAt, equals('2024-01-02T10:00:00Z'));

      expect(dto.data![0].close, equals(5.25));
      expect(dto.data![0].date, equals('2024-01-01'));
      expect(dto.data![0].high, equals(5.30));
      expect(dto.data![0].low, equals(5.20));
      expect(dto.data![0].open, equals(5.22));

      expect(dto.data![1].close, equals(5.28));
      expect(dto.data![1].date, equals('2024-01-02'));
      expect(dto.data![1].high, equals(5.35));
      expect(dto.data![1].low, equals(5.25));
      expect(dto.data![1].open, equals(5.26));
    });

    test('should create an instance from JSON with empty list', () {
      final json = {
        'data': [],
        'from': 'USD',
        'lastUpdatedAt': '2024-01-01T10:00:00Z',
        'rateLimitExceeded': false,
        'success': true,
        'to': 'BRL',
      };

      final dto = ExchangeRatesDTO.fromJson(json);

      expect(dto.data, isA<List>());
      expect(dto.data!.length, equals(0));
      expect(dto.from, equals('USD'));
      expect(dto.to, equals('BRL'));
    });

    test('should create an instance from JSON with null data', () {
      final json = {
        'data': null,
        'from': 'USD',
        'lastUpdatedAt': '2024-01-01T10:00:00Z',
        'rateLimitExceeded': false,
        'success': true,
        'to': 'BRL',
      };

      final dto = ExchangeRatesDTO.fromJson(json);

      expect(dto.data, isNull);
      expect(dto.from, equals('USD'));
      expect(dto.to, equals('BRL'));
    });

    test('should create an instance from JSON with mixed values', () {
      final json = {
        'data': [
          {
            'close': 5.25,
            'date': '2024-01-01',
            'high': 5.30,
            'low': 5.20,
            'open': 5.22,
          },
        ],
        'from': 'EUR',
        'lastUpdatedAt': null,
        'rateLimitExceeded': true,
        'success': false,
        'to': 'JPY',
      };

      final dto = ExchangeRatesDTO.fromJson(json);

      expect(dto.data!.length, equals(1));
      expect(dto.from, equals('EUR'));
      expect(dto.to, equals('JPY'));
      expect(dto.success, isFalse);
      expect(dto.rateLimitExceeded, isTrue);
      expect(dto.lastUpdatedAt, isNull);
    });

    test('should be equal to another instance with the same values', () {
      final dto1 = ExchangeRatesDTO(
        data: [
          ExchangeRateDataDTO(
            close: 5.25,
            date: '2024-01-01',
            high: 5.30,
            low: 5.20,
            open: 5.22,
          ),
        ],
        from: 'USD',
        to: 'BRL',
        success: true,
      );

      final dto2 = ExchangeRatesDTO(
        data: [
          ExchangeRateDataDTO(
            close: 5.25,
            date: '2024-01-01',
            high: 5.30,
            low: 5.20,
            open: 5.22,
          ),
        ],
        from: 'USD',
        to: 'BRL',
        success: true,
      );

      expect(dto1, equals(dto2));
    });

    test('should have correct props for Equatable', () {
      final dto = ExchangeRatesDTO(
        data: [
          ExchangeRateDataDTO(
            close: 5.25,
            date: '2024-01-01',
            high: 5.30,
            low: 5.20,
            open: 5.22,
          ),
        ],
        from: 'USD',
        lastUpdatedAt: '2024-01-01T10:00:00Z',
        rateLimitExceeded: false,
        success: true,
        to: 'BRL',
      );

      final props = dto.props;
      expect(props.length, equals(6));
      expect(props[0], isA<List>());
      expect(props[1], equals('USD'));
      expect(props[2], equals('2024-01-01T10:00:00Z'));
      expect(props[3], isFalse);
      expect(props[4], isTrue);
      expect(props[5], equals('BRL'));
    });
  });
}
