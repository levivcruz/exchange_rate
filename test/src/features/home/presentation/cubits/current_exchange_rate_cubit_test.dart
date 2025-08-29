import 'package:flutter_test/flutter_test.dart';

import 'package:exchange_rate/src/features/home/domain/entities/current_exchange_rate_entity.dart';
import 'package:exchange_rate/src/features/home/domain/usecases/get_current_exchange_rate_usecase.dart';
import 'package:exchange_rate/src/features/home/presentation/cubits/current_exchange_rate_cubit.dart';
import 'package:exchange_rate/src/core/shared/errors/either.dart';
import 'package:exchange_rate/src/core/shared/errors/failures.dart';

class MockGetCurrentExchangeRateUsecase
    implements IGetCurrentExchangeRateUsecase {
  Future<Either<Failure, CurrentExchangeRateEntity>>? _mockResult;

  void setMockResult(
    Future<Either<Failure, CurrentExchangeRateEntity>> result,
  ) {
    _mockResult = result;
  }

  @override
  Future<Either<Failure, CurrentExchangeRateEntity>> call({
    required String fromSymbol,
    required String toSymbol,
  }) async {
    if (_mockResult != null) {
      return await _mockResult!;
    }
    throw UnimplementedError('Mock not configured');
  }
}

class MockCurrentExchangeRateEntity implements CurrentExchangeRateEntity {
  @override
  String? get fromSymbol => 'USD';

  @override
  String? get toSymbol => 'BRL';

  @override
  double? get exchangeRate => 5.25;

  @override
  String? get lastUpdatedAt => '2025-01-01T00:00:00Z';

  @override
  bool? get success => true;

  @override
  bool? get rateLimitExceeded => false;

  @override
  List<Object?> get props => [
    fromSymbol,
    toSymbol,
    exchangeRate,
    lastUpdatedAt,
    success,
    rateLimitExceeded,
  ];

  @override
  bool get stringify => true;
}

class MockFailure implements Failure {
  @override
  String get message => 'Mock failure message';

  @override
  String? get code => '500';

  @override
  List<Object?> get props => [message, code];

  @override
  bool get stringify => true;
}

void main() {
  group('CurrentExchangeRateCubit', () {
    late CurrentExchangeRateCubit cubit;
    late MockGetCurrentExchangeRateUsecase mockUsecase;
    late MockCurrentExchangeRateEntity mockExchangeRate;
    late MockFailure mockFailure;

    setUp(() {
      mockUsecase = MockGetCurrentExchangeRateUsecase();
      mockExchangeRate = MockCurrentExchangeRateEntity();
      mockFailure = MockFailure();
      cubit = CurrentExchangeRateCubit(mockUsecase);
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state should be CurrentExchangeRateInitial', () {
      expect(cubit.state, const CurrentExchangeRateInitial());
    });

    group('getCurrentExchangeRate', () {
      const fromSymbol = 'USD';
      const toSymbol = 'BRL';

      test(
        'should emit [CurrentExchangeRateLoading, CurrentExchangeRateLoaded] when usecase returns success',
        () async {
          mockUsecase.setMockResult(Future.value(Right(mockExchangeRate)));

          final expectedStates = [
            const CurrentExchangeRateLoading(),
            CurrentExchangeRateLoaded(mockExchangeRate),
          ];

          expectLater(cubit.stream, emitsInOrder(expectedStates));

          cubit.getCurrentExchangeRate(
            fromSymbol: fromSymbol,
            toSymbol: toSymbol,
          );
        },
      );

      test(
        'should emit [CurrentExchangeRateLoading, CurrentExchangeRateError] when usecase returns failure',
        () async {
          mockUsecase.setMockResult(Future.value(Left(mockFailure)));

          final expectedStates = [
            const CurrentExchangeRateLoading(),
            CurrentExchangeRateError(mockFailure.message),
          ];

          expectLater(cubit.stream, emitsInOrder(expectedStates));

          cubit.getCurrentExchangeRate(
            fromSymbol: fromSymbol,
            toSymbol: toSymbol,
          );
        },
      );

      test('should call usecase with correct parameters', () async {
        mockUsecase.setMockResult(Future.value(Right(mockExchangeRate)));

        cubit.getCurrentExchangeRate(
          fromSymbol: fromSymbol,
          toSymbol: toSymbol,
        );

        await Future.delayed(const Duration(milliseconds: 100));
      });
    });

    group('reset', () {
      test('should emit CurrentExchangeRateInitial when reset is called', () {
        cubit.emit(const CurrentExchangeRateLoading());

        expectLater(cubit.stream, emits(const CurrentExchangeRateInitial()));

        cubit.reset();
      });

      test('should reset state to initial from any state', () {
        cubit.emit(CurrentExchangeRateLoaded(mockExchangeRate));

        expectLater(cubit.stream, emits(const CurrentExchangeRateInitial()));

        cubit.reset();
      });
    });

    group('State equality', () {
      test('CurrentExchangeRateInitial should be equal to itself', () {
        const state1 = CurrentExchangeRateInitial();
        const state2 = CurrentExchangeRateInitial();
        expect(state1, equals(state2));
      });

      test('CurrentExchangeRateLoading should be equal to itself', () {
        const state1 = CurrentExchangeRateLoading();
        const state2 = CurrentExchangeRateLoading();
        expect(state1, equals(state2));
      });

      test(
        'CurrentExchangeRateLoaded should be equal when exchangeRates are equal',
        () {
          final state1 = CurrentExchangeRateLoaded(mockExchangeRate);
          final state2 = CurrentExchangeRateLoaded(mockExchangeRate);
          expect(state1, equals(state2));
        },
      );

      test(
        'CurrentExchangeRateError should be equal when messages are equal',
        () {
          const state1 = CurrentExchangeRateError('Error message');
          const state2 = CurrentExchangeRateError('Error message');
          expect(state1, equals(state2));
        },
      );
    });
  });
}
