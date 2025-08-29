import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../errors/either.dart';
import '../errors/failures.dart';

mixin HttpRepositoryMixin {
  static const Duration requestTimeout = Duration(seconds: 30);

  static const String timeoutMessage =
      'Request timeout: API did not respond within 30 seconds';

  http.Client get httpClient;

  String get baseUrl;

  String get apiKey;

  Future<http.Response> makeRequest({
    required String endpoint,
    required String fromSymbol,
    required String toSymbol,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint').replace(
      queryParameters: {
        'apiKey': apiKey,
        'from_symbol': fromSymbol.toUpperCase(),
        'to_symbol': toSymbol.toUpperCase(),
      },
    );

    return await httpClient.get(uri).timeout(requestTimeout);
  }

  Either<Failure, T> handleResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as Map<String, dynamic>;
      final result = fromJson(jsonData);
      return Right(result);
    } else if (response.statusCode == 401) {
      return const Left(ServerFailure(message: 'Invalid or expired API key'));
    } else if (response.statusCode == 403) {
      return const Left(ServerFailure(message: 'Access denied to API'));
    } else if (response.statusCode == 404) {
      return const Left(ServerFailure(message: 'Endpoint not found'));
    } else {
      return Left(
        ServerFailure(
          message:
              'API error: ${response.statusCode} - ${response.reasonPhrase}',
        ),
      );
    }
  }

  Either<Failure, T> handleException<T>(Exception exception, String operation) {
    if (exception is TimeoutException) {
      return Left(
        NetworkFailure(
          message: 'Request timeout: API took too long to respond',
          code: 'TIMEOUT_ERROR',
        ),
      );
    } else if (exception is SocketException) {
      return Left(
        NetworkFailure(
          message: 'Connection error: Please check your internet connection',
          code: 'NETWORK_ERROR',
        ),
      );
    } else if (exception is HttpException) {
      return Left(
        NetworkFailure(
          message: 'HTTP communication error: ${exception.message}',
          code: 'HTTP_ERROR',
        ),
      );
    } else if (exception is FormatException) {
      return Left(
        ServerFailure(
          message: 'Error parsing API response',
          code: 'PARSING_ERROR',
        ),
      );
    } else {
      return Left(
        ServerFailure(
          message: 'Unexpected error while $operation: ${exception.toString()}',
          code: 'UNKNOWN_ERROR',
        ),
      );
    }
  }
}
