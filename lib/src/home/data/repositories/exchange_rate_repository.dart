import '../../../core/core.dart';
import '../../domain/entities/entities.dart';

abstract interface class IExchangeRateRepository {
  Future<Either<Failure, CurrentExchangeRateEntity>> getCurrentExchangeRate({
    required String fromSymbol,
    required String toSymbol,
  });

  Future<Either<Failure, ExchangeRatesEntity>> getDailyExchangeRate({
    required String fromSymbol,
    required String toSymbol,
  });
}
