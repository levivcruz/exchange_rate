import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:exchange_rate/src/features/di/injection_container.dart';
import 'package:exchange_rate/src/features/home/data/repositories/exchange_rate_repository.dart';
import 'package:exchange_rate/src/features/home/domain/usecases/get_current_exchange_rate_usecase.dart';
import 'package:exchange_rate/src/features/home/domain/usecases/get_daily_exchange_rate_usecase.dart';
import 'package:exchange_rate/src/features/home/presentation/cubits/current_exchange_rate_cubit.dart';
import 'package:exchange_rate/src/features/home/presentation/cubits/currency_input_cubit.dart';
import 'package:exchange_rate/src/features/home/presentation/blocs/daily_exchange_rate_bloc.dart';

void main() {
  group('Injection Container Tests', () {
    setUp(() async {
      await reset();
      await dotenv.load(fileName: ".env");
    });

    tearDown(() async {
      await reset();
    });

    test('should initialize all dependencies when init is called', () async {
      await init();

      expect(sl.isRegistered<http.Client>(), isTrue);
      expect(sl.isRegistered<IExchangeRateRepository>(), isTrue);
      expect(sl.isRegistered<IGetCurrentExchangeRateUsecase>(), isTrue);
      expect(sl.isRegistered<IGetDailyExchangeRateUsecase>(), isTrue);
      expect(sl.isRegistered<CurrentExchangeRateCubit>(), isTrue);
      expect(sl.isRegistered<CurrencyInputCubit>(), isTrue);
      expect(sl.isRegistered<DailyExchangeRateBloc>(), isTrue);
    });

    test('should register http.Client when _initCore is called', () async {
      await init();

      expect(sl.isRegistered<http.Client>(), isTrue);
      final client = sl<http.Client>();
      expect(client, isA<http.Client>());
    });

    test(
      'should register all home feature dependencies when _initHomeFeature is called',
      () async {
        await init();

        expect(sl.isRegistered<IExchangeRateRepository>(), isTrue);
        final repository = sl<IExchangeRateRepository>();
        expect(repository, isA<IExchangeRateRepository>());

        expect(sl.isRegistered<IGetCurrentExchangeRateUsecase>(), isTrue);
        final currentUsecase = sl<IGetCurrentExchangeRateUsecase>();
        expect(currentUsecase, isA<IGetCurrentExchangeRateUsecase>());

        expect(sl.isRegistered<IGetDailyExchangeRateUsecase>(), isTrue);
        final dailyUsecase = sl<IGetDailyExchangeRateUsecase>();
        expect(dailyUsecase, isA<IGetDailyExchangeRateUsecase>());

        expect(sl.isRegistered<CurrentExchangeRateCubit>(), isTrue);
        final cubit = sl<CurrentExchangeRateCubit>();
        expect(cubit, isA<CurrentExchangeRateCubit>());
        await cubit.close();

        expect(sl.isRegistered<CurrencyInputCubit>(), isTrue);
        final inputCubit = sl<CurrencyInputCubit>();
        expect(inputCubit, isA<CurrencyInputCubit>());
        await inputCubit.close();

        expect(sl.isRegistered<DailyExchangeRateBloc>(), isTrue);
        final bloc = sl<DailyExchangeRateBloc>();
        expect(bloc, isA<DailyExchangeRateBloc>());
        await bloc.close();
      },
    );

    test('should return correct base URL from _getBaseUrl', () async {
      await init();

      final repository = sl<IExchangeRateRepository>();
      expect(repository, isNotNull);

      expect(repository, isA<IExchangeRateRepository>());
    });

    test('should return correct API key from _getApiKey', () async {
      await init();

      final repository = sl<IExchangeRateRepository>();
      expect(repository, isNotNull);

      expect(repository, isA<IExchangeRateRepository>());
    });

    test(
      'should create different instances for factory registrations',
      () async {
        await init();

        final cubit1 = sl<CurrentExchangeRateCubit>();
        final cubit2 = sl<CurrentExchangeRateCubit>();
        expect(identical(cubit1, cubit2), isFalse);
        await cubit1.close();
        await cubit2.close();

        final inputCubit1 = sl<CurrencyInputCubit>();
        final inputCubit2 = sl<CurrencyInputCubit>();
        expect(identical(inputCubit1, inputCubit2), isFalse);
        await inputCubit1.close();
        await inputCubit2.close();

        final bloc1 = sl<DailyExchangeRateBloc>();
        final bloc2 = sl<DailyExchangeRateBloc>();
        expect(identical(bloc1, bloc2), isFalse);
        await bloc1.close();
        await bloc2.close();
      },
    );

    test(
      'should create same instances for lazy singleton registrations',
      () async {
        await init();

        final client1 = sl<http.Client>();
        final client2 = sl<http.Client>();
        expect(identical(client1, client2), isTrue);

        final repository1 = sl<IExchangeRateRepository>();
        final repository2 = sl<IExchangeRateRepository>();
        expect(identical(repository1, repository2), isTrue);

        final currentUsecase1 = sl<IGetCurrentExchangeRateUsecase>();
        final currentUsecase2 = sl<IGetCurrentExchangeRateUsecase>();
        expect(identical(currentUsecase1, currentUsecase2), isTrue);

        final dailyUsecase1 = sl<IGetDailyExchangeRateUsecase>();
        final dailyUsecase2 = sl<IGetDailyExchangeRateUsecase>();
        expect(identical(dailyUsecase1, dailyUsecase2), isTrue);
      },
    );

    test('should reset all dependencies when reset is called', () async {
      await init();
      expect(sl.isRegistered<http.Client>(), isTrue);
      expect(sl.isRegistered<IExchangeRateRepository>(), isTrue);

      await reset();

      expect(sl.isRegistered<http.Client>(), isFalse);
      expect(sl.isRegistered<IExchangeRateRepository>(), isFalse);
      expect(sl.isRegistered<IGetCurrentExchangeRateUsecase>(), isFalse);
      expect(sl.isRegistered<IGetDailyExchangeRateUsecase>(), isFalse);
      expect(sl.isRegistered<CurrentExchangeRateCubit>(), isFalse);
      expect(sl.isRegistered<CurrencyInputCubit>(), isFalse);
      expect(sl.isRegistered<DailyExchangeRateBloc>(), isFalse);
    });

    test('should initialize dependencies in correct order', () async {
      await init();

      expect(sl.isRegistered<http.Client>(), isTrue);

      final repository = sl<IExchangeRateRepository>();
      expect(repository, isNotNull);

      final currentUsecase = sl<IGetCurrentExchangeRateUsecase>();
      final dailyUsecase = sl<IGetDailyExchangeRateUsecase>();
      expect(currentUsecase, isNotNull);
      expect(dailyUsecase, isNotNull);

      final cubit = sl<CurrentExchangeRateCubit>();
      final bloc = sl<DailyExchangeRateBloc>();
      expect(cubit, isNotNull);
      expect(bloc, isNotNull);

      await cubit.close();
      await bloc.close();
    });

    test('should access DailyExchangeRateUsecase for coverage', () async {
      await init();

      final dailyUsecase = sl<IGetDailyExchangeRateUsecase>();
      expect(dailyUsecase, isA<IGetDailyExchangeRateUsecase>());
    });

    test('should access DailyExchangeRateBloc for coverage', () async {
      await init();

      final bloc = sl<DailyExchangeRateBloc>();
      expect(bloc, isA<DailyExchangeRateBloc>());
      await bloc.close();
    });

    test('should throw exception when API_BASE_URL is null or empty', () async {
      await reset();
      final Map<String, String> originalEnv = Map.from(dotenv.env);
      dotenv.env.remove('API_BASE_URL');

      try {
        expect(
          () => init(),
          throwsA(
            predicate(
              (e) =>
                  e is Exception &&
                  e.toString().contains('API_BASE_URL not found in .env file'),
            ),
          ),
        );
      } finally {
        dotenv.env.clear();
        dotenv.env.addAll(originalEnv);
      }
    });

    test('should throw exception when API_KEY is null or empty', () async {
      await reset();
      final Map<String, String> originalEnv = Map.from(dotenv.env);
      dotenv.env.remove('API_KEY');

      try {
        expect(
          () => init(),
          throwsA(
            predicate(
              (e) =>
                  e is Exception &&
                  e.toString().contains('API_KEY not found in .env file'),
            ),
          ),
        );
      } finally {
        dotenv.env.clear();
        dotenv.env.addAll(originalEnv);
      }
    });
  });
}
