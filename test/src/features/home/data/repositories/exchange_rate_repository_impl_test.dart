import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:exchange_rate/src/core/shared/errors/failures.dart';
import 'package:exchange_rate/src/features/home/data/repositories/exchange_rate_repository_impl.dart';
import 'package:exchange_rate/src/features/home/domain/entities/current_exchange_rate_entity.dart';
import 'package:exchange_rate/src/features/home/domain/entities/exchange_rate_history_entity.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

void main() {
  group('ExchangeRateRepositoryImpl', () {
    late MockHttpClient mockHttpClient;
    late ExchangeRateRepositoryImpl repository;
    late MockResponse mockResponse;

    const testBaseUrl = 'https://api.example.com';
    const testApiKey = 'test-api-key';
    const testFromSymbol = 'USD';
    const testToSymbol = 'BRL';

    setUp(() {
      mockHttpClient = MockHttpClient();
      mockResponse = MockResponse();
      repository = ExchangeRateRepositoryImpl(
        httpClient: mockHttpClient,
        baseUrl: testBaseUrl,
        apiKey: testApiKey,
      );

      registerFallbackValue(Uri());
    });

    group('getCurrentExchangeRate', () {
      const testCurrentExchangeRateJson = {
        'exchangeRate': 5.25,
        'fromSymbol': 'USD',
        'toSymbol': 'BRL',
        'lastUpdatedAt': '2024-01-15T10:00:00Z',
        'rateLimitExceeded': false,
        'success': true,
      };

      test(
        'should return CurrentExchangeRateEntity when request is successful',
        () async {
          when(() => mockResponse.statusCode).thenReturn(200);
          when(
            () => mockResponse.body,
          ).thenReturn(json.encode(testCurrentExchangeRateJson));
          when(
            () => mockHttpClient.get(any()),
          ).thenAnswer((_) async => mockResponse);

          final result = await repository.getCurrentExchangeRate(
            fromSymbol: testFromSymbol,
            toSymbol: testToSymbol,
          );

          expect(result.isRight, isTrue);
          final entity = result.right;
          expect(entity, isA<CurrentExchangeRateEntity>());
          expect(entity.exchangeRate, equals(5.25));
          expect(entity.fromSymbol, equals('USD'));
          expect(entity.toSymbol, equals('BRL'));
          expect(entity.success, isTrue);
        },
      );

      test(
        'should make request to correct endpoint with proper parameters',
        () async {
          when(() => mockResponse.statusCode).thenReturn(200);
          when(
            () => mockResponse.body,
          ).thenReturn(json.encode(testCurrentExchangeRateJson));
          when(
            () => mockHttpClient.get(any()),
          ).thenAnswer((_) async => mockResponse);

          await repository.getCurrentExchangeRate(
            fromSymbol: testFromSymbol,
            toSymbol: testToSymbol,
          );

          final capturedUri =
              verify(() => mockHttpClient.get(captureAny())).captured.first
                  as Uri;
          expect(capturedUri.path, equals('/open/currentExchangeRate'));
          expect(capturedUri.queryParameters['apiKey'], equals(testApiKey));
          expect(capturedUri.queryParameters['from_symbol'], equals('USD'));
          expect(capturedUri.queryParameters['to_symbol'], equals('BRL'));
        },
      );

      test('should return ServerFailure when API returns 401', () async {
        when(() => mockResponse.statusCode).thenReturn(401);
        when(
          () => mockHttpClient.get(any()),
        ).thenAnswer((_) async => mockResponse);

        final result = await repository.getCurrentExchangeRate(
          fromSymbol: testFromSymbol,
          toSymbol: testToSymbol,
        );

        expect(result.isLeft, isTrue);
        expect(result.left, isA<ServerFailure>());
        expect(result.left.message, equals('Invalid or expired API key'));
      });

      test('should return NetworkFailure when timeout occurs', () async {
        when(
          () => mockHttpClient.get(any()),
        ).thenThrow(TimeoutException('Timeout', const Duration(seconds: 30)));

        final result = await repository.getCurrentExchangeRate(
          fromSymbol: testFromSymbol,
          toSymbol: testToSymbol,
        );

        expect(result.isLeft, isTrue);
        expect(result.left, isA<NetworkFailure>());
        expect(result.left.code, equals('TIMEOUT_ERROR'));
      });

      test(
        'should return NetworkFailure when SocketException occurs',
        () async {
          when(
            () => mockHttpClient.get(any()),
          ).thenThrow(const SocketException('Network error'));

          final result = await repository.getCurrentExchangeRate(
            fromSymbol: testFromSymbol,
            toSymbol: testToSymbol,
          );

          expect(result.isLeft, isTrue);
          expect(result.left, isA<NetworkFailure>());
          expect(result.left.code, equals('NETWORK_ERROR'));
        },
      );

      test('should return ServerFailure when FormatException occurs', () async {
        when(() => mockResponse.statusCode).thenReturn(200);
        when(() => mockResponse.body).thenReturn('invalid json');
        when(
          () => mockHttpClient.get(any()),
        ).thenAnswer((_) async => mockResponse);

        final result = await repository.getCurrentExchangeRate(
          fromSymbol: testFromSymbol,
          toSymbol: testToSymbol,
        );

        expect(result.isLeft, isTrue);
        expect(result.left, isA<ServerFailure>());
        expect(result.left.code, equals('PARSING_ERROR'));
      });
    });

    group('getDailyExchangeRate', () {
      const testDailyExchangeRateJson = {
        'data': [
          {
            'close': 5.20,
            'date': '2024-01-15',
            'high': 5.30,
            'low': 5.10,
            'open': 5.15,
          },
          {
            'close': 5.25,
            'date': '2024-01-16',
            'high': 5.35,
            'low': 5.15,
            'open': 5.20,
          },
        ],
        'from': 'USD',
        'to': 'BRL',
        'lastUpdatedAt': '2024-01-16T10:00:00Z',
        'rateLimitExceeded': false,
        'success': true,
      };

      test(
        'should return ExchangeRatesEntity when request is successful',
        () async {
          when(() => mockResponse.statusCode).thenReturn(200);
          when(
            () => mockResponse.body,
          ).thenReturn(json.encode(testDailyExchangeRateJson));
          when(
            () => mockHttpClient.get(any()),
          ).thenAnswer((_) async => mockResponse);

          final result = await repository.getDailyExchangeRate(
            fromSymbol: testFromSymbol,
            toSymbol: testToSymbol,
          );

          expect(result.isRight, isTrue);
          final entity = result.right;
          expect(entity, isA<ExchangeRatesEntity>());
          expect(entity.from, equals('USD'));
          expect(entity.to, equals('BRL'));
          expect(entity.success, isTrue);
          expect(entity.data, hasLength(2));
          expect(entity.data!.first.close, equals(5.20));
          expect(entity.data!.first.date, equals('2024-01-15'));
        },
      );

      test(
        'should make request to correct endpoint with proper parameters',
        () async {
          when(() => mockResponse.statusCode).thenReturn(200);
          when(
            () => mockResponse.body,
          ).thenReturn(json.encode(testDailyExchangeRateJson));
          when(
            () => mockHttpClient.get(any()),
          ).thenAnswer((_) async => mockResponse);

          await repository.getDailyExchangeRate(
            fromSymbol: testFromSymbol,
            toSymbol: testToSymbol,
          );

          final capturedUri =
              verify(() => mockHttpClient.get(captureAny())).captured.first
                  as Uri;
          expect(capturedUri.path, equals('/open/dailyExchangeRate'));
          expect(capturedUri.queryParameters['apiKey'], equals(testApiKey));
          expect(capturedUri.queryParameters['from_symbol'], equals('USD'));
          expect(capturedUri.queryParameters['to_symbol'], equals('BRL'));
        },
      );

      test('should return ServerFailure when API returns 403', () async {
        when(() => mockResponse.statusCode).thenReturn(403);
        when(
          () => mockHttpClient.get(any()),
        ).thenAnswer((_) async => mockResponse);

        final result = await repository.getDailyExchangeRate(
          fromSymbol: testFromSymbol,
          toSymbol: testToSymbol,
        );

        expect(result.isLeft, isTrue);
        expect(result.left, isA<ServerFailure>());
        expect(result.left.message, equals('Access denied to API'));
      });

      test('should return ServerFailure when API returns 404', () async {
        when(() => mockResponse.statusCode).thenReturn(404);
        when(
          () => mockHttpClient.get(any()),
        ).thenAnswer((_) async => mockResponse);

        final result = await repository.getDailyExchangeRate(
          fromSymbol: testFromSymbol,
          toSymbol: testToSymbol,
        );

        expect(result.isLeft, isTrue);
        expect(result.left, isA<ServerFailure>());
        expect(result.left.message, equals('Endpoint not found'));
      });

      test('should return ServerFailure for other HTTP error codes', () async {
        when(() => mockResponse.statusCode).thenReturn(500);
        when(
          () => mockResponse.reasonPhrase,
        ).thenReturn('Internal Server Error');
        when(
          () => mockHttpClient.get(any()),
        ).thenAnswer((_) async => mockResponse);

        final result = await repository.getDailyExchangeRate(
          fromSymbol: testFromSymbol,
          toSymbol: testToSymbol,
        );

        expect(result.isLeft, isTrue);
        expect(result.left, isA<ServerFailure>());
        expect(
          result.left.message,
          contains('API error: 500 - Internal Server Error'),
        );
      });

      test('should return NetworkFailure when HttpException occurs', () async {
        when(
          () => mockHttpClient.get(any()),
        ).thenThrow(const HttpException('HTTP error'));

        final result = await repository.getDailyExchangeRate(
          fromSymbol: testFromSymbol,
          toSymbol: testToSymbol,
        );

        expect(result.isLeft, isTrue);
        expect(result.left, isA<NetworkFailure>());
        expect(result.left.code, equals('HTTP_ERROR'));
      });

      test('should return ServerFailure for unexpected exceptions', () async {
        when(
          () => mockHttpClient.get(any()),
        ).thenThrow(Exception('Unexpected error'));

        final result = await repository.getDailyExchangeRate(
          fromSymbol: testFromSymbol,
          toSymbol: testToSymbol,
        );

        expect(result.isLeft, isTrue);
        expect(result.left, isA<ServerFailure>());
        expect(result.left.code, equals('UNKNOWN_ERROR'));
        expect(result.left.message, contains('getting exchange rate history'));
      });
    });

    group('mixin integration', () {
      test('should expose httpClient getter', () {
        expect(repository.httpClient, equals(mockHttpClient));
      });

      test('should expose baseUrl getter', () {
        expect(repository.baseUrl, equals(testBaseUrl));
      });

      test('should expose apiKey getter', () {
        expect(repository.apiKey, equals(testApiKey));
      });
    });
  });
}
