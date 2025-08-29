import 'dart:async';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:exchange_rate/src/core/shared/errors/failures.dart';
import 'package:exchange_rate/src/core/shared/mixins/http_repository_mixin.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

class TestRepository with HttpRepositoryMixin {
  final http.Client _httpClient;
  final String _baseUrl;
  final String _apiKey;

  TestRepository({
    required http.Client httpClient,
    required String baseUrl,
    required String apiKey,
  }) : _httpClient = httpClient,
       _baseUrl = baseUrl,
       _apiKey = apiKey;

  @override
  http.Client get httpClient => _httpClient;

  @override
  String get baseUrl => _baseUrl;

  @override
  String get apiKey => _apiKey;
}

class TestDto {
  final String data;

  TestDto(this.data);

  factory TestDto.fromJson(Map<String, dynamic> json) {
    return TestDto(json['data'] as String);
  }
}

void main() {
  group('HttpRepositoryMixin', () {
    late MockHttpClient mockHttpClient;
    late TestRepository testRepository;
    late MockResponse mockResponse;

    const testBaseUrl = 'https://api.example.com';
    const testApiKey = 'test-key';
    const testFromSymbol = 'USD';
    const testToSymbol = 'BRL';
    const testEndpoint = '/test';

    setUp(() {
      mockHttpClient = MockHttpClient();
      mockResponse = MockResponse();
      testRepository = TestRepository(
        httpClient: mockHttpClient,
        baseUrl: testBaseUrl,
        apiKey: testApiKey,
      );

      registerFallbackValue(Uri());
    });

    group('makeRequest', () {
      test('should make GET request with correct URI and parameters', () async {
        when(() => mockResponse.statusCode).thenReturn(200);
        when(() => mockResponse.body).thenReturn('{"data": "test"}');
        when(
          () => mockHttpClient.get(any()),
        ).thenAnswer((_) async => mockResponse);

        final response = await testRepository.makeRequest(
          endpoint: testEndpoint,
          fromSymbol: testFromSymbol,
          toSymbol: testToSymbol,
        );

        expect(response, equals(mockResponse));

        final capturedUri =
            verify(() => mockHttpClient.get(captureAny())).captured.first
                as Uri;
        expect(capturedUri.path, equals(testEndpoint));
        expect(capturedUri.queryParameters['apiKey'], equals(testApiKey));
        expect(
          capturedUri.queryParameters['from_symbol'],
          equals(testFromSymbol.toUpperCase()),
        );
        expect(
          capturedUri.queryParameters['to_symbol'],
          equals(testToSymbol.toUpperCase()),
        );
      });

      test('should convert currency symbols to uppercase', () async {
        when(() => mockResponse.statusCode).thenReturn(200);
        when(() => mockResponse.body).thenReturn('{"data": "test"}');
        when(
          () => mockHttpClient.get(any()),
        ).thenAnswer((_) async => mockResponse);

        await testRepository.makeRequest(
          endpoint: testEndpoint,
          fromSymbol: 'usd',
          toSymbol: 'brl',
        );

        final capturedUri =
            verify(() => mockHttpClient.get(captureAny())).captured.first
                as Uri;
        expect(capturedUri.queryParameters['from_symbol'], equals('USD'));
        expect(capturedUri.queryParameters['to_symbol'], equals('BRL'));
      });

      test('should throw TimeoutException when request times out', () async {
        when(() => mockHttpClient.get(any())).thenAnswer(
          (_) async => throw TimeoutException(
            'Request timeout: API did not respond within 30 seconds',
            const Duration(seconds: 30),
          ),
        );

        expect(
          () => testRepository.makeRequest(
            endpoint: testEndpoint,
            fromSymbol: testFromSymbol,
            toSymbol: testToSymbol,
          ),
          throwsA(isA<TimeoutException>()),
        );
      });
    });

    group('handleResponse', () {
      test('should return Right with parsed data when status code is 200', () {
        const testData = '{"data": "success"}';
        when(() => mockResponse.statusCode).thenReturn(200);
        when(() => mockResponse.body).thenReturn(testData);

        final result = testRepository.handleResponse<TestDto>(
          mockResponse,
          (json) => TestDto.fromJson(json),
        );

        expect(result.isRight, isTrue);
        expect(result.right.data, equals('success'));
      });

      test('should return Left with ServerFailure when status code is 401', () {
        when(() => mockResponse.statusCode).thenReturn(401);

        final result = testRepository.handleResponse<TestDto>(
          mockResponse,
          (json) => TestDto.fromJson(json),
        );

        expect(result.isLeft, isTrue);
        expect(result.left, isA<ServerFailure>());
        expect(result.left.message, equals('Invalid or expired API key'));
      });

      test('should return Left with ServerFailure when status code is 403', () {
        when(() => mockResponse.statusCode).thenReturn(403);

        final result = testRepository.handleResponse<TestDto>(
          mockResponse,
          (json) => TestDto.fromJson(json),
        );

        expect(result.isLeft, isTrue);
        expect(result.left, isA<ServerFailure>());
        expect(result.left.message, equals('Access denied to API'));
      });

      test('should return Left with ServerFailure when status code is 404', () {
        when(() => mockResponse.statusCode).thenReturn(404);

        final result = testRepository.handleResponse<TestDto>(
          mockResponse,
          (json) => TestDto.fromJson(json),
        );

        expect(result.isLeft, isTrue);
        expect(result.left, isA<ServerFailure>());
        expect(result.left.message, equals('Endpoint not found'));
      });

      test(
        'should return Left with ServerFailure for other error status codes',
        () {
          when(() => mockResponse.statusCode).thenReturn(500);
          when(
            () => mockResponse.reasonPhrase,
          ).thenReturn('Internal Server Error');

          final result = testRepository.handleResponse<TestDto>(
            mockResponse,
            (json) => TestDto.fromJson(json),
          );

          expect(result.isLeft, isTrue);
          expect(result.left, isA<ServerFailure>());
          expect(
            result.left.message,
            contains('API error: 500 - Internal Server Error'),
          );
        },
      );
    });

    group('handleException', () {
      test(
        'should return NetworkFailure with TIMEOUT_ERROR for TimeoutException',
        () {
          const operation = 'test operation';
          final exception = TimeoutException(
            'Timeout',
            const Duration(seconds: 30),
          );

          final result = testRepository.handleException<TestDto>(
            exception,
            operation,
          );

          expect(result.isLeft, isTrue);
          expect(result.left, isA<NetworkFailure>());
          expect(result.left.code, equals('TIMEOUT_ERROR'));
          expect(
            result.left.message,
            equals('Request timeout: API took too long to respond'),
          );
        },
      );

      test(
        'should return NetworkFailure with NETWORK_ERROR for SocketException',
        () {
          const operation = 'test operation';
          final exception = const SocketException('Network error');

          final result = testRepository.handleException<TestDto>(
            exception,
            operation,
          );

          expect(result.isLeft, isTrue);
          expect(result.left, isA<NetworkFailure>());
          expect(result.left.code, equals('NETWORK_ERROR'));
          expect(
            result.left.message,
            equals('Connection error: Please check your internet connection'),
          );
        },
      );

      test(
        'should return NetworkFailure with HTTP_ERROR for HttpException',
        () {
          const operation = 'test operation';
          final exception = const HttpException('HTTP error');

          final result = testRepository.handleException<TestDto>(
            exception,
            operation,
          );

          expect(result.isLeft, isTrue);
          expect(result.left, isA<NetworkFailure>());
          expect(result.left.code, equals('HTTP_ERROR'));
          expect(
            result.left.message,
            equals('HTTP communication error: HTTP error'),
          );
        },
      );

      test(
        'should return ServerFailure with PARSING_ERROR for FormatException',
        () {
          const operation = 'test operation';
          final exception = const FormatException('Invalid JSON');

          final result = testRepository.handleException<TestDto>(
            exception,
            operation,
          );

          expect(result.isLeft, isTrue);
          expect(result.left, isA<ServerFailure>());
          expect(result.left.code, equals('PARSING_ERROR'));
          expect(result.left.message, equals('Error parsing API response'));
        },
      );

      test(
        'should return ServerFailure with UNKNOWN_ERROR for generic exceptions',
        () {
          const operation = 'test operation';
          final exception = Exception('Unknown error');

          final result = testRepository.handleException<TestDto>(
            exception,
            operation,
          );

          expect(result.isLeft, isTrue);
          expect(result.left, isA<ServerFailure>());
          expect(result.left.code, equals('UNKNOWN_ERROR'));
          expect(
            result.left.message,
            contains(
              'Unexpected error while test operation: Exception: Unknown error',
            ),
          );
        },
      );
    });

    group('constants', () {
      test('should have correct default timeout duration', () {
        expect(
          HttpRepositoryMixin.requestTimeout,
          equals(const Duration(seconds: 30)),
        );
      });

      test('should have correct default timeout message', () {
        expect(
          HttpRepositoryMixin.timeoutMessage,
          equals('Request timeout: API did not respond within 30 seconds'),
        );
      });
    });
  });
}
