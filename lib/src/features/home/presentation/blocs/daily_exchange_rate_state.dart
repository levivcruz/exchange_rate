part of 'daily_exchange_rate_bloc.dart';

abstract class DailyExchangeRateState extends Equatable {
  const DailyExchangeRateState();

  @override
  List<Object?> get props => [];
}

class DailyExchangeRateInitial extends DailyExchangeRateState {
  const DailyExchangeRateInitial();
}

class DailyExchangeRateLoading extends DailyExchangeRateState {
  const DailyExchangeRateLoading();
}

class DailyExchangeRateLoaded extends DailyExchangeRateState {
  final ExchangeRatesEntity exchangeRates;

  const DailyExchangeRateLoaded(this.exchangeRates);

  @override
  List<Object?> get props => [exchangeRates];
}

class DailyExchangeRateError extends DailyExchangeRateState {
  final String message;

  const DailyExchangeRateError(this.message);

  @override
  List<Object?> get props => [message];
}
