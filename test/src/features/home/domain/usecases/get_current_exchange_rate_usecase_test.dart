import 'package:flutter_test/flutter_test.dart';

import 'package:exchange_rate/src/core/shared/errors/either.dart';
import 'package:exchange_rate/src/core/shared/errors/failures.dart';
import 'package:exchange_rate/src/features/home/domain/entities/current_exchange_rate_entity.dart';
import 'package:exchange_rate/src/features/home/domain/usecases/get_current_exchange_rate_usecase.dart';
import 'package:exchange_rate/src/features/home/data/repositories/exchange_rate_repository.dart';
import 'package:exchange_rate/src/features/home/domain/entities/exchange_rate_history_entity.dart';

class MockExchangeRateRepository implements IExchangeRateRepository {
  Either<Failure, CurrentExchangeRateEntity>? _returnValue;
  Exception? _exceptionToThrow;
  int _callCount = 0;
  String? _lastFromSymbol;
  String? _lastToSymbol;

  void setReturnValue(Either<Failure, CurrentExchangeRateEntity> value) {
    _returnValue = value;
  }

  void setException(Exception exception) {
    _exceptionToThrow = exception;
  }

  int get callCount => _callCount;
  String? get lastFromSymbol => _lastFromSymbol;
  String? get lastToSymbol => _lastToSymbol;

  @override
  Future<Either<Failure, CurrentExchangeRateEntity>> getCurrentExchangeRate({
    required String fromSymbol,
    required String toSymbol,
  }) async {
    _callCount++;
    _lastFromSymbol = fromSymbol;
    _lastToSymbol = toSymbol;

    if (_exceptionToThrow != null) {
      throw _exceptionToThrow!;
    }

    return _returnValue ?? const Right(CurrentExchangeRateEntity());
  }

  @override
  Future<Either<Failure, ExchangeRatesEntity>> getDailyExchangeRate({
    required String fromSymbol,
    required String toSymbol,
  }) async {
    throw UnimplementedError();
  }
}

void main() {
  late GetCurrentExchangeRateUsecase usecase;
  late MockExchangeRateRepository mockRepository;

  setUp(() {
    mockRepository = MockExchangeRateRepository();
    usecase = GetCurrentExchangeRateUsecase(mockRepository);
  });

  group('GetCurrentExchangeRateUsecase', () {
    const validFromSymbol = 'USD';
    const validToSymbol = 'BRL';
    const invalidFromSymbol = 'INVALID';
    const invalidToSymbol = 'WRONG';

    final mockExchangeRateEntity = const CurrentExchangeRateEntity(
      exchangeRate: 5.25,
      fromSymbol: 'USD',
      toSymbol: 'BRL',
      success: true,
      lastUpdatedAt: '2024-01-15T10:30:00Z',
      rateLimitExceeded: false,
    );

    test('should be a callable class', () {
      mockRepository.setReturnValue(Right(mockExchangeRateEntity));

      final result = usecase(
        fromSymbol: validFromSymbol,
        toSymbol: validToSymbol,
      );

      expect(result, isA<Future<Either<Failure, CurrentExchangeRateEntity>>>());
    });

    test(
      'should return InvalidInputFailure when fromSymbol is invalid',
      () async {
        final result = await usecase(
          fromSymbol: invalidFromSymbol,
          toSymbol: validToSymbol,
        );

        expect(result, isA<Left<Failure, CurrentExchangeRateEntity>>());
        expect(
          result.fold((failure) => failure, (entity) => null),
          isA<InvalidInputFailure>(),
        );
        expect(
          result.fold((failure) => failure.message, (entity) => null),
          equals('Invalid currency code provided'),
        );
      },
    );

    test(
      'should return InvalidInputFailure when toSymbol is invalid',
      () async {
        final result = await usecase(
          fromSymbol: validFromSymbol,
          toSymbol: invalidToSymbol,
        );

        expect(result, isA<Left<Failure, CurrentExchangeRateEntity>>());
        expect(
          result.fold((failure) => failure, (entity) => null),
          isA<InvalidInputFailure>(),
        );
        expect(
          result.fold((failure) => failure.message, (entity) => null),
          equals('Invalid currency code provided'),
        );
      },
    );

    test(
      'should return InvalidInputFailure when both symbols are invalid',
      () async {
        final result = await usecase(
          fromSymbol: invalidFromSymbol,
          toSymbol: invalidToSymbol,
        );

        expect(result, isA<Left<Failure, CurrentExchangeRateEntity>>());
        expect(
          result.fold((failure) => failure, (entity) => null),
          isA<InvalidInputFailure>(),
        );
        expect(
          result.fold((failure) => failure.message, (entity) => null),
          equals('Invalid currency code provided'),
        );
      },
    );

    test(
      'should return InvalidInputFailure when fromSymbol is empty',
      () async {
        final result = await usecase(fromSymbol: '', toSymbol: validToSymbol);

        expect(result, isA<Left<Failure, CurrentExchangeRateEntity>>());
        expect(
          result.fold((failure) => failure, (entity) => null),
          isA<InvalidInputFailure>(),
        );
      },
    );

    test('should return InvalidInputFailure when toSymbol is empty', () async {
      final result = await usecase(fromSymbol: validFromSymbol, toSymbol: '');

      expect(result, isA<Left<Failure, CurrentExchangeRateEntity>>());
      expect(
        result.fold((failure) => failure, (entity) => null),
        isA<InvalidInputFailure>(),
      );
    });

    test(
      'should return InvalidInputFailure when fromSymbol has less than 3 characters',
      () async {
        final result = await usecase(fromSymbol: 'US', toSymbol: validToSymbol);

        expect(result, isA<Left<Failure, CurrentExchangeRateEntity>>());
        expect(
          result.fold((failure) => failure, (entity) => null),
          isA<InvalidInputFailure>(),
        );
      },
    );

    test(
      'should return InvalidInputFailure when toSymbol has more than 3 characters',
      () async {
        final result = await usecase(
          fromSymbol: validFromSymbol,
          toSymbol: 'BRLR',
        );

        expect(result, isA<Left<Failure, CurrentExchangeRateEntity>>());
        expect(
          result.fold((failure) => failure, (entity) => null),
          isA<InvalidInputFailure>(),
        );
      },
    );

    test(
      'should call repository with uppercase symbols when both are valid',
      () async {
        mockRepository.setReturnValue(Right(mockExchangeRateEntity));

        await usecase(
          fromSymbol: validFromSymbol.toLowerCase(),
          toSymbol: validToSymbol.toLowerCase(),
        );

        expect(mockRepository.callCount, equals(1));
        expect(mockRepository.lastFromSymbol, equals(validFromSymbol));
        expect(mockRepository.lastToSymbol, equals(validToSymbol));
      },
    );

    test('should return success when repository call succeeds', () async {
      mockRepository.setReturnValue(Right(mockExchangeRateEntity));

      final result = await usecase(
        fromSymbol: validFromSymbol,
        toSymbol: validToSymbol,
      );

      expect(result, isA<Right<Failure, CurrentExchangeRateEntity>>());
      expect(
        result.fold((failure) => null, (entity) => entity),
        equals(mockExchangeRateEntity),
      );
    });

    test(
      'should return repository failure when repository call fails',
      () async {
        const repositoryFailure = ServerFailure(message: 'API error');
        mockRepository.setReturnValue(Left(repositoryFailure));

        final result = await usecase(
          fromSymbol: validFromSymbol,
          toSymbol: validToSymbol,
        );

        expect(result, isA<Left<Failure, CurrentExchangeRateEntity>>());
        expect(
          result.fold((failure) => failure, (entity) => null),
          equals(repositoryFailure),
        );
      },
    );

    test('should return ServerFailure when an exception occurs', () async {
      mockRepository.setException(Exception('Network error'));

      final result = await usecase(
        fromSymbol: validFromSymbol,
        toSymbol: validToSymbol,
      );

      expect(result, isA<Left<Failure, CurrentExchangeRateEntity>>());
      expect(
        result.fold((failure) => failure, (entity) => null),
        isA<ServerFailure>(),
      );
      expect(
        result.fold((failure) => failure.message, (entity) => null),
        contains('Unexpected error while getting exchange rate'),
      );
    });

    test('should handle various valid currency codes', () async {
      final validCurrencies = ['USD', 'EUR', 'GBP', 'JPY', 'BRL', 'CAD', 'AUD'];

      for (final currency in validCurrencies) {
        mockRepository.setReturnValue(Right(mockExchangeRateEntity));

        final result = await usecase(
          fromSymbol: currency,
          toSymbol: validToSymbol,
        );

        expect(result, isA<Right<Failure, CurrentExchangeRateEntity>>());
      }
    });

    test(
      'should handle edge case with special characters in currency codes',
      () async {
        final result = await usecase(fromSymbol: 'USD\$', toSymbol: 'BRL#');

        expect(result, isA<Left<Failure, CurrentExchangeRateEntity>>());
        expect(
          result.fold((failure) => failure, (entity) => null),
          isA<InvalidInputFailure>(),
        );
      },
    );
  });
}
