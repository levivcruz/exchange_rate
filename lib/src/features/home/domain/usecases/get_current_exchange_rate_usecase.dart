import '../../../../core/core.dart';
import '../entities/current_exchange_rate_entity.dart';
import '../../data/repositories/repositories.dart';

abstract interface class IGetCurrentExchangeRateUsecase {
  Future<Either<Failure, CurrentExchangeRateEntity>> call({
    required String fromSymbol,
    required String toSymbol,
  });
}

class GetCurrentExchangeRateUsecase implements IGetCurrentExchangeRateUsecase {
  final IExchangeRateRepository _repository;

  const GetCurrentExchangeRateUsecase(this._repository);

  @override
  Future<Either<Failure, CurrentExchangeRateEntity>> call({
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

      final result = await _repository.getCurrentExchangeRate(
        fromSymbol: fromSymbol.toUpperCase(),
        toSymbol: toSymbol.toUpperCase(),
      );

      return result;
    } catch (e) {
      return Left(
        ServerFailure(
          message:
              'Unexpected error while getting exchange rate: ${e.toString()}',
        ),
      );
    }
  }
}
