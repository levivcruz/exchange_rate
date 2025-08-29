import '../../../../core/core.dart';
import '../../data/repositories/repositories.dart';
import '../entities/entities.dart';

abstract interface class IGetDailyExchangeRateUsecase {
  Future<Either<Failure, ExchangeRatesEntity>> call({
    required String fromSymbol,
    required String toSymbol,
  });
}

class GetDailyExchangeRateUsecase implements IGetDailyExchangeRateUsecase {
  final IExchangeRateRepository _repository;

  const GetDailyExchangeRateUsecase(this._repository);

  @override
  Future<Either<Failure, ExchangeRatesEntity>> call({
    required String fromSymbol,
    required String toSymbol,
  }) async {
    try {
      if (!CurrencyValidator.isValid(fromSymbol) ||
          !CurrencyValidator.isValid(toSymbol)) {
        return const Left(
          InvalidInputFailure(message: 'Invalid currency code provided'),
        );
      }

      final result = await _repository.getDailyExchangeRate(
        fromSymbol: fromSymbol.toUpperCase(),
        toSymbol: toSymbol.toUpperCase(),
      );

      return result;
    } catch (e) {
      return Left(
        ServerFailure(
          message:
              'Unexpected error while getting exchange rate history: ${e.toString()}',
        ),
      );
    }
  }
}
