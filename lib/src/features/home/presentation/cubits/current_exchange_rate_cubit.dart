import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/current_exchange_rate_entity.dart';
import '../../domain/usecases/get_current_exchange_rate_usecase.dart';

part 'current_exchange_rate_state.dart';

class CurrentExchangeRateCubit extends Cubit<CurrentExchangeRateState> {
  final IGetCurrentExchangeRateUsecase _getCurrentExchangeRateUsecase;

  CurrentExchangeRateCubit(this._getCurrentExchangeRateUsecase)
    : super(const CurrentExchangeRateInitial());

  Future<void> getCurrentExchangeRate({
    required String fromSymbol,
    required String toSymbol,
  }) async {
    emit(const CurrentExchangeRateLoading());

    final result = await _getCurrentExchangeRateUsecase(
      fromSymbol: fromSymbol,
      toSymbol: toSymbol,
    );

    result.fold(
      (failure) => emit(CurrentExchangeRateError(failure.message)),
      (exchangeRate) => emit(CurrentExchangeRateLoaded(exchangeRate)),
    );
  }

  void reset() {
    emit(const CurrentExchangeRateInitial());
  }
}
