import 'package:http/http.dart' as http;

import '../../../core/core.dart';
import '../../domain/entities/current_exchange_rate_entity.dart';
import '../../domain/entities/exchange_rate_history_entity.dart';
import '../dto/current_exchange_rate_dto.dart';
import '../dto/exchange_rates_dto.dart';
import 'exchange_rate_repository.dart';

class ExchangeRateRepositoryImpl
    with HttpRepositoryMixin
    implements IExchangeRateRepository {
  final http.Client _httpClient;
  final String _baseUrl;
  final String _apiKey;

  const ExchangeRateRepositoryImpl({
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

  @override
  Future<Either<Failure, CurrentExchangeRateEntity>> getCurrentExchangeRate({
    required String fromSymbol,
    required String toSymbol,
  }) async {
    try {
      final response = await makeRequest(
        endpoint: '/open/currentExchangeRate',
        fromSymbol: fromSymbol,
        toSymbol: toSymbol,
      );

      return handleResponse<CurrentExchangeRateEntity>(
        response,
        (json) => CurrentExchangeRateDTO.fromJson(json),
      );
    } on Exception catch (e) {
      return handleException(e, 'getting exchange rate');
    }
  }

  @override
  Future<Either<Failure, ExchangeRatesEntity>> getDailyExchangeRate({
    required String fromSymbol,
    required String toSymbol,
  }) async {
    try {
      final response = await makeRequest(
        endpoint: '/open/dailyExchangeRate',
        fromSymbol: fromSymbol,
        toSymbol: toSymbol,
      );

      return handleResponse<ExchangeRatesEntity>(
        response,
        (json) => ExchangeRatesDTO.fromJson(json),
      );
    } on Exception catch (e) {
      return handleException(e, 'getting exchange rate history');
    }
  }
}
