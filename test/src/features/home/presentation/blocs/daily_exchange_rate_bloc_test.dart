import 'package:flutter_test/flutter_test.dart';

import 'package:exchange_rate/src/features/home/domain/entities/exchange_rate_history_entity.dart';
import 'package:exchange_rate/src/features/home/domain/entities/exchange_rate_data_entity.dart';
import 'package:exchange_rate/src/features/home/domain/usecases/get_daily_exchange_rate_usecase.dart';
import 'package:exchange_rate/src/features/home/presentation/blocs/daily_exchange_rate_bloc.dart';
import 'package:exchange_rate/src/core/shared/errors/either.dart';
import 'package:exchange_rate/src/core/shared/errors/failures.dart';

class MockGetDailyExchangeRateUsecase implements IGetDailyExchangeRateUsecase {
  Future<Either<Failure, ExchangeRatesEntity>>? _mockResult;

  void setMockResult(Future<Either<Failure, ExchangeRatesEntity>> result) {
    _mockResult = result;
  }

  @override
  Future<Either<Failure, ExchangeRatesEntity>> call({
    required String fromSymbol,
    required String toSymbol,
  }) async {
    if (_mockResult != null) {
      return await _mockResult!;
    }
    throw UnimplementedError('Mock not configured');
  }
}

class MockExchangeRatesEntity implements ExchangeRatesEntity {
  @override
  List<ExchangeRateDataEntity>? get data => [];

  @override
  String? get from => 'USD';

  @override
  String? get lastUpdatedAt => '2025-01-01T00:00:00Z';

  @override
  bool? get rateLimitExceeded => false;

  @override
  bool? get success => true;

  @override
  String? get to => 'BRL';

  @override
  List<Object?> get props => [
    data,
    from,
    lastUpdatedAt,
    rateLimitExceeded,
    success,
    to,
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
  group('DailyExchangeRateBloc', () {
    late DailyExchangeRateBloc bloc;
    late MockGetDailyExchangeRateUsecase mockUsecase;
    late MockExchangeRatesEntity mockExchangeRates;
    late MockFailure mockFailure;

    setUp(() {
      mockUsecase = MockGetDailyExchangeRateUsecase();
      mockExchangeRates = MockExchangeRatesEntity();
      mockFailure = MockFailure();
      bloc = DailyExchangeRateBloc(mockUsecase);
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state should be DailyExchangeRateInitial', () {
      expect(bloc.state, const DailyExchangeRateInitial());
    });

    group('GetDailyExchangeRate', () {
      const fromSymbol = 'USD';
      const toSymbol = 'BRL';

      test(
        'should emit [DailyExchangeRateLoading, DailyExchangeRateLoaded] when usecase returns success',
        () async {
          mockUsecase.setMockResult(Future.value(Right(mockExchangeRates)));

          final expectedStates = [
            const DailyExchangeRateLoading(),
            DailyExchangeRateLoaded(mockExchangeRates),
          ];

          expectLater(bloc.stream, emitsInOrder(expectedStates));

          bloc.add(
            const GetDailyExchangeRate(
              fromSymbol: fromSymbol,
              toSymbol: toSymbol,
            ),
          );
        },
      );

      test(
        'should emit [DailyExchangeRateLoading, DailyExchangeRateError] when usecase returns failure',
        () async {
          mockUsecase.setMockResult(Future.value(Left(mockFailure)));

          final expectedStates = [
            const DailyExchangeRateLoading(),
            DailyExchangeRateError(mockFailure.message),
          ];

          expectLater(bloc.stream, emitsInOrder(expectedStates));

          bloc.add(
            const GetDailyExchangeRate(
              fromSymbol: fromSymbol,
              toSymbol: toSymbol,
            ),
          );
        },
      );

      test('should call usecase with correct parameters', () async {
        mockUsecase.setMockResult(Future.value(Right(mockExchangeRates)));

        bloc.add(
          const GetDailyExchangeRate(
            fromSymbol: fromSymbol,
            toSymbol: toSymbol,
          ),
        );

        await Future.delayed(const Duration(milliseconds: 100));
      });
    });

    group('ResetDailyExchangeRate', () {
      test('should emit DailyExchangeRateInitial when reset is called', () {
        expectLater(bloc.stream, emits(const DailyExchangeRateInitial()));

        bloc.add(const ResetDailyExchangeRate());
      });

      test('should reset state to initial from any state', () {
        expectLater(bloc.stream, emits(const DailyExchangeRateInitial()));

        bloc.add(const ResetDailyExchangeRate());
      });
    });

    group('State equality', () {
      test('DailyExchangeRateInitial should be equal to itself', () {
        const state1 = DailyExchangeRateInitial();
        const state2 = DailyExchangeRateInitial();
        expect(state1, equals(state2));
      });

      test('DailyExchangeRateLoading should be equal to itself', () {
        const state1 = DailyExchangeRateLoading();
        const state2 = DailyExchangeRateLoading();
        expect(state1, equals(state2));
      });

      test(
        'DailyExchangeRateLoaded should be equal when exchangeRates are equal',
        () {
          final state1 = DailyExchangeRateLoaded(mockExchangeRates);
          final state2 = DailyExchangeRateLoaded(mockExchangeRates);
          expect(state1, equals(state2));
        },
      );

      test(
        'DailyExchangeRateError should be equal when messages are equal',
        () {
          const state1 = DailyExchangeRateError('Error message');
          const state2 = DailyExchangeRateError('Error message');
          expect(state1, equals(state2));
        },
      );
    });
  });
}
