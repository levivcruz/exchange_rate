import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/exchange_rate_history_entity.dart';
import '../../domain/usecases/get_daily_exchange_rate_usecase.dart';

part 'daily_exchange_rate_event.dart';
part 'daily_exchange_rate_state.dart';

class DailyExchangeRateBloc
    extends Bloc<DailyExchangeRateEvent, DailyExchangeRateState> {
  final IGetDailyExchangeRateUsecase _getDailyExchangeRateUsecase;

  DailyExchangeRateBloc(this._getDailyExchangeRateUsecase)
    : super(const DailyExchangeRateInitial()) {
    on<GetDailyExchangeRate>(_onGetDailyExchangeRate);
    on<ResetDailyExchangeRate>(_onResetDailyExchangeRate);
  }

  Future<void> _onGetDailyExchangeRate(
    GetDailyExchangeRate event,
    Emitter<DailyExchangeRateState> emit,
  ) async {
    emit(const DailyExchangeRateLoading());

    final result = await _getDailyExchangeRateUsecase(
      fromSymbol: event.fromSymbol,
      toSymbol: event.toSymbol,
    );

    result.fold(
      (failure) => emit(DailyExchangeRateError(failure.message)),
      (exchangeRates) => emit(DailyExchangeRateLoaded(exchangeRates)),
    );
  }

  void _onResetDailyExchangeRate(
    ResetDailyExchangeRate event,
    Emitter<DailyExchangeRateState> emit,
  ) {
    emit(const DailyExchangeRateInitial());
  }
}
