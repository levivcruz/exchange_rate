import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'package:exchange_rate/src/features/home/presentation/screens/home_screen.dart';
import 'package:exchange_rate/src/features/home/presentation/cubits/current_exchange_rate_cubit.dart';
import 'package:exchange_rate/src/features/home/presentation/cubits/currency_input_cubit.dart';
import 'package:exchange_rate/src/features/home/presentation/blocs/daily_exchange_rate_bloc.dart';
import 'package:exchange_rate/src/features/home/presentation/widgets/widgets.dart';
import 'package:exchange_rate/src/core/theme/app_colors.dart';
import 'package:exchange_rate/src/features/home/domain/entities/current_exchange_rate_entity.dart';
import 'package:exchange_rate/src/features/home/domain/entities/exchange_rate_history_entity.dart';
import 'package:exchange_rate/src/features/home/domain/entities/exchange_rate_data_entity.dart';
import 'package:exchange_rate/src/features/home/domain/usecases/get_current_exchange_rate_usecase.dart';
import 'package:exchange_rate/src/features/home/domain/usecases/get_daily_exchange_rate_usecase.dart';
import 'package:exchange_rate/src/features/home/data/repositories/exchange_rate_repository.dart';
import 'package:exchange_rate/src/core/shared/errors/either.dart';
import 'package:exchange_rate/src/core/shared/errors/failures.dart';
import 'package:exchange_rate/src/features/di/di.dart';

class MockHttpClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    return http.StreamedResponse(
      Stream.fromIterable([]),
      200,
      headers: {'content-type': 'application/json'},
    );
  }
}

class MockExchangeRateRepository implements IExchangeRateRepository {
  @override
  Future<Either<Failure, CurrentExchangeRateEntity>> getCurrentExchangeRate({
    required String fromSymbol,
    required String toSymbol,
  }) async {
    return Right(_MockCurrentExchangeRateEntity());
  }

  @override
  Future<Either<Failure, ExchangeRatesEntity>> getDailyExchangeRate({
    required String fromSymbol,
    required String toSymbol,
  }) async {
    return Right(_MockExchangeRatesEntity());
  }
}

class MockGetCurrentExchangeRateUsecase
    implements IGetCurrentExchangeRateUsecase {
  @override
  Future<Either<Failure, CurrentExchangeRateEntity>> call({
    required String fromSymbol,
    required String toSymbol,
  }) async {
    return Right(_MockCurrentExchangeRateEntity());
  }
}

class MockGetDailyExchangeRateUsecase implements IGetDailyExchangeRateUsecase {
  @override
  Future<Either<Failure, ExchangeRatesEntity>> call({
    required String fromSymbol,
    required String toSymbol,
  }) async {
    return Right(_MockExchangeRatesEntity());
  }
}

class _MockCurrentExchangeRateEntity implements CurrentExchangeRateEntity {
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

class _MockExchangeRatesEntity implements ExchangeRatesEntity {
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

void main() {
  group('HomeScreen Widget Tests', () {
    setUp(() async {
      await sl.reset();

      sl.registerLazySingleton<http.Client>(() => MockHttpClient());
      sl.registerLazySingleton<IExchangeRateRepository>(
        () => MockExchangeRateRepository(),
      );
      sl.registerLazySingleton<IGetCurrentExchangeRateUsecase>(
        () => MockGetCurrentExchangeRateUsecase(),
      );
      sl.registerLazySingleton<IGetDailyExchangeRateUsecase>(
        () => MockGetDailyExchangeRateUsecase(),
      );

      sl.registerFactory<CurrentExchangeRateCubit>(
        () => CurrentExchangeRateCubit(sl<IGetCurrentExchangeRateUsecase>()),
      );
      sl.registerFactory<CurrencyInputCubit>(() => CurrencyInputCubit());
      sl.registerFactory<DailyExchangeRateBloc>(
        () => DailyExchangeRateBloc(sl<IGetDailyExchangeRateUsecase>()),
      );
    });

    tearDown(() async {
      await sl.reset();
    });

    Widget createTestableWidget() {
      return MaterialApp(home: const HomeScreen());
    }

    testWidgets('should render HomeScreen with all main components', (
      tester,
    ) async {
      await tester.pumpWidget(createTestableWidget());

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SafeArea), findsOneWidget);
      expect(find.byType(MultiBlocProvider), findsOneWidget);
    });

    testWidgets('should have correct background color', (tester) async {
      await tester.pumpWidget(createTestableWidget());

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, AppColors.neutralWhite);
    });

    testWidgets('should render all main widgets', (tester) async {
      await tester.pumpWidget(createTestableWidget());

      expect(find.byType(LogoSectionWidget), findsOneWidget);
      expect(find.byType(HeaderWidget), findsOneWidget);
      expect(find.byType(MainContentWidget), findsOneWidget);
      expect(find.byType(FooterWidget), findsOneWidget);
    });

    testWidgets('should have MainContentWidget inside Expanded', (
      tester,
    ) async {
      await tester.pumpWidget(createTestableWidget());

      expect(find.byType(Expanded), findsAtLeastNWidgets(1));
      expect(find.byType(MainContentWidget), findsOneWidget);
    });

    testWidgets('should render widgets in correct order in Column', (
      tester,
    ) async {
      await tester.pumpWidget(createTestableWidget());

      expect(find.byType(LogoSectionWidget), findsOneWidget);
      expect(find.byType(HeaderWidget), findsOneWidget);
      expect(find.byType(MainContentWidget), findsOneWidget);
      expect(find.byType(FooterWidget), findsOneWidget);
      expect(find.byType(Column), findsAtLeastNWidgets(1));
    });

    testWidgets('should configure MultiBlocProvider with 3 providers', (
      tester,
    ) async {
      await tester.pumpWidget(createTestableWidget());

      expect(find.byType(MultiBlocProvider), findsOneWidget);

      expect(sl.isRegistered<CurrentExchangeRateCubit>(), isTrue);
      expect(sl.isRegistered<CurrencyInputCubit>(), isTrue);
      expect(sl.isRegistered<DailyExchangeRateBloc>(), isTrue);
    });

    testWidgets(
      'should create all bloc providers during widget initialization',
      (tester) async {
        await tester.pumpWidget(createTestableWidget());

        await tester.pump();
        await tester.pump();
        await tester.pumpAndSettle();

        expect(find.byType(CurrentExchangeRateCubit), findsNothing);
        expect(find.byType(HomeScreen), findsOneWidget);
        expect(find.byType(MultiBlocProvider), findsOneWidget);

        expect(find.byType(MainContentWidget), findsOneWidget);
      },
    );

    testWidgets('should render without exceptions', (tester) async {
      await tester.pumpWidget(createTestableWidget());
      await tester.pump();

      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'should trigger DailyExchangeRateBloc creation through widget tree',
      (tester) async {
        await tester.pumpWidget(createTestableWidget());
        await tester.pumpAndSettle();

        await tester.pump(Duration.zero);
        await tester.pump(Duration.zero);
        await tester.pump(Duration.zero);

        expect(sl.isRegistered<CurrentExchangeRateCubit>(), isTrue);
        expect(sl.isRegistered<CurrencyInputCubit>(), isTrue);
        expect(sl.isRegistered<DailyExchangeRateBloc>(), isTrue);

        expect(find.byType(HomeScreen), findsOneWidget);
        expect(find.byType(MainContentWidget), findsOneWidget);
      },
    );

    testWidgets('should access DailyExchangeRateBloc from context', (
      tester,
    ) async {
      await tester.pumpWidget(createTestableWidget());
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(MainContentWidget));

      final bloc = context.read<DailyExchangeRateBloc>();

      expect(bloc, isNotNull);
      expect(bloc, isA<DailyExchangeRateBloc>());
    });
  });
}
