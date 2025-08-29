import 'package:flutter_test/flutter_test.dart';

import 'package:exchange_rate/src/core/shared/errors/either.dart';
import 'package:exchange_rate/src/core/shared/errors/failures.dart';
import 'package:exchange_rate/src/features/home/domain/entities/current_exchange_rate_entity.dart';
import 'package:exchange_rate/src/features/home/domain/entities/exchange_rate_history_entity.dart';
import 'package:exchange_rate/src/features/home/domain/entities/exchange_rate_data_entity.dart';
import 'package:exchange_rate/src/features/home/domain/usecases/get_daily_exchange_rate_usecase.dart';
import 'package:exchange_rate/src/features/home/data/repositories/exchange_rate_repository.dart';

class MockExchangeRateRepository implements IExchangeRateRepository {
  Either<Failure, ExchangeRatesEntity>? _returnValue;
  Exception? _exceptionToThrow;
  int _callCount = 0;
  String? _lastFromSymbol;
  String? _lastToSymbol;

  void setReturnValue(Either<Failure, ExchangeRatesEntity> value) {
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
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, ExchangeRatesEntity>> getDailyExchangeRate({
    required String fromSymbol,
    required String toSymbol,
  }) async {
    _callCount++;
    _lastFromSymbol = fromSymbol;
    _lastToSymbol = toSymbol;

    if (_exceptionToThrow != null) {
      throw _exceptionToThrow!;
    }

    return _returnValue ?? const Right(ExchangeRatesEntity());
  }
}

void main() {
  late GetDailyExchangeRateUsecase usecase;
  late MockExchangeRateRepository mockRepository;

  setUp(() {
    mockRepository = MockExchangeRateRepository();
    usecase = GetDailyExchangeRateUsecase(mockRepository);
  });

  group('GetDailyExchangeRateUsecase', () {
    const validFromSymbol = 'USD';
    const validToSymbol = 'BRL';
    const invalidFromSymbol = 'INVALID';
    const invalidToSymbol = 'WRONG';

    final mockExchangeRatesEntity = ExchangeRatesEntity(
      data: [
        const ExchangeRateDataEntity(
          close: 5.25,
          date: '2024-01-15',
          high: 5.50,
          low: 5.00,
          open: 5.10,
        ),
        const ExchangeRateDataEntity(
          close: 5.30,
          date: '2024-01-14',
          high: 5.55,
          low: 5.05,
          open: 5.15,
        ),
      ],
      from: 'USD',
      to: 'BRL',
      success: true,
      lastUpdatedAt: '2024-01-15T10:30:00Z',
      rateLimitExceeded: false,
    );

    test('should be a callable class', () {
      mockRepository.setReturnValue(Right(mockExchangeRatesEntity));

      final result = usecase(
        fromSymbol: validFromSymbol,
        toSymbol: validToSymbol,
      );

      expect(result, isA<Future<Either<Failure, ExchangeRatesEntity>>>());
    });

    test(
      'should return InvalidInputFailure when fromSymbol is invalid',
      () async {
        final result = await usecase(
          fromSymbol: invalidFromSymbol,
          toSymbol: validToSymbol,
        );

        expect(result, isA<Left<Failure, ExchangeRatesEntity>>());
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

        expect(result, isA<Left<Failure, ExchangeRatesEntity>>());
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

        expect(result, isA<Left<Failure, ExchangeRatesEntity>>());
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

        expect(result, isA<Left<Failure, ExchangeRatesEntity>>());
        expect(
          result.fold((failure) => failure, (entity) => null),
          isA<InvalidInputFailure>(),
        );
      },
    );

    test('should return InvalidInputFailure when toSymbol is empty', () async {
      final result = await usecase(fromSymbol: validFromSymbol, toSymbol: '');

      expect(result, isA<Left<Failure, ExchangeRatesEntity>>());
      expect(
        result.fold((failure) => failure, (entity) => null),
        isA<InvalidInputFailure>(),
      );
    });

    test(
      'should return InvalidInputFailure when fromSymbol has less than 3 characters',
      () async {
        final result = await usecase(fromSymbol: 'US', toSymbol: validToSymbol);

        expect(result, isA<Left<Failure, ExchangeRatesEntity>>());
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

        expect(result, isA<Left<Failure, ExchangeRatesEntity>>());
        expect(
          result.fold((failure) => failure, (entity) => null),
          isA<InvalidInputFailure>(),
        );
      },
    );

    test(
      'should call repository with uppercase symbols when both are valid',
      () async {
        mockRepository.setReturnValue(Right(mockExchangeRatesEntity));

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
      mockRepository.setReturnValue(Right(mockExchangeRatesEntity));

      final result = await usecase(
        fromSymbol: validFromSymbol,
        toSymbol: validToSymbol,
      );

      expect(result, isA<Right<Failure, ExchangeRatesEntity>>());
      expect(
        result.fold((failure) => null, (entity) => entity),
        equals(mockExchangeRatesEntity),
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

        expect(result, isA<Left<Failure, ExchangeRatesEntity>>());
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

      expect(result, isA<Left<Failure, ExchangeRatesEntity>>());
      expect(
        result.fold((failure) => failure, (entity) => null),
        isA<ServerFailure>(),
      );
      expect(
        result.fold((failure) => failure.message, (entity) => null),
        contains('Unexpected error while getting exchange rate history'),
      );
    });

    test('should handle various valid currency codes', () async {
      final validCurrencies = ['USD', 'EUR', 'GBP', 'JPY', 'BRL', 'CAD', 'AUD'];

      for (final currency in validCurrencies) {
        mockRepository.setReturnValue(Right(mockExchangeRatesEntity));

        final result = await usecase(
          fromSymbol: currency,
          toSymbol: validToSymbol,
        );

        expect(result, isA<Right<Failure, ExchangeRatesEntity>>());
      }
    });

    test(
      'should handle edge case with special characters in currency codes',
      () async {
        final result = await usecase(fromSymbol: 'USD\$', toSymbol: 'BRL#');

        expect(result, isA<Left<Failure, ExchangeRatesEntity>>());
        expect(
          result.fold((failure) => failure, (entity) => null),
          isA<InvalidInputFailure>(),
        );
      },
    );

    test('should handle empty data list from repository', () async {
      final emptyDataEntity = ExchangeRatesEntity(
        data: [],
        from: 'USD',
        to: 'BRL',
        success: true,
      );
      mockRepository.setReturnValue(Right(emptyDataEntity));

      final result = await usecase(
        fromSymbol: validFromSymbol,
        toSymbol: validToSymbol,
      );

      expect(result, isA<Right<Failure, ExchangeRatesEntity>>());
      expect(
        result.fold((failure) => null, (entity) => entity.data?.isEmpty),
        isTrue,
      );
    });

    test('should handle null data from repository', () async {
      final nullDataEntity = ExchangeRatesEntity(
        data: null,
        from: 'USD',
        to: 'BRL',
        success: true,
      );
      mockRepository.setReturnValue(Right(nullDataEntity));

      final result = await usecase(
        fromSymbol: validFromSymbol,
        toSymbol: validToSymbol,
      );

      expect(result, isA<Right<Failure, ExchangeRatesEntity>>());
      expect(result.fold((failure) => null, (entity) => entity.data), isNull);
    });
  });
}
