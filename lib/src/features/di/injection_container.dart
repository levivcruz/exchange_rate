import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../home/data/repositories/exchange_rate_repository_impl.dart';
import '../home/data/repositories/exchange_rate_repository.dart';
import '../home/domain/usecases/get_current_exchange_rate_usecase.dart';
import '../home/domain/usecases/get_daily_exchange_rate_usecase.dart';
import '../home/presentation/cubits/current_exchange_rate_cubit.dart';
import '../home/presentation/cubits/currency_input_cubit.dart';
import '../home/presentation/blocs/daily_exchange_rate_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  _initCore();

  _initHomeFeature();
}

void _initCore() {
  sl.registerLazySingleton<http.Client>(() => http.Client());
}

void _initHomeFeature() {
  final baseUrl = dotenv.env['API_BASE_URL'];
  final apiKey = dotenv.env['API_KEY'];

  if (baseUrl == null || baseUrl.isEmpty) {
    throw Exception('API_BASE_URL not found in .env file');
  }

  if (apiKey == null || apiKey.isEmpty) {
    throw Exception('API_KEY not found in .env file');
  }

  sl.registerLazySingleton<IExchangeRateRepository>(
    () => ExchangeRateRepositoryImpl(
      httpClient: sl<http.Client>(),
      baseUrl: baseUrl,
      apiKey: apiKey,
    ),
  );

  sl.registerLazySingleton<IGetCurrentExchangeRateUsecase>(
    () => GetCurrentExchangeRateUsecase(sl<IExchangeRateRepository>()),
  );

  sl.registerLazySingleton<IGetDailyExchangeRateUsecase>(
    () => GetDailyExchangeRateUsecase(sl<IExchangeRateRepository>()),
  );

  sl.registerFactory<CurrentExchangeRateCubit>(
    () => CurrentExchangeRateCubit(sl<IGetCurrentExchangeRateUsecase>()),
  );

  sl.registerFactory<CurrencyInputCubit>(() => CurrencyInputCubit());

  sl.registerFactory<DailyExchangeRateBloc>(
    () => DailyExchangeRateBloc(sl<IGetDailyExchangeRateUsecase>()),
  );
}

Future<void> reset() async {
  await sl.reset();
}
