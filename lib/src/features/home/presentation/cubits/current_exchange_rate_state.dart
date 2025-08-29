part of 'current_exchange_rate_cubit.dart';

abstract class CurrentExchangeRateState extends Equatable {
  const CurrentExchangeRateState();

  @override
  List<Object?> get props => [];
}

class CurrentExchangeRateInitial extends CurrentExchangeRateState {
  const CurrentExchangeRateInitial();
}

class CurrentExchangeRateLoading extends CurrentExchangeRateState {
  const CurrentExchangeRateLoading();
}

class CurrentExchangeRateLoaded extends CurrentExchangeRateState {
  final CurrentExchangeRateEntity exchangeRate;

  const CurrentExchangeRateLoaded(this.exchangeRate);

  @override
  List<Object?> get props => [exchangeRate];
}

class CurrentExchangeRateError extends CurrentExchangeRateState {
  final String message;

  const CurrentExchangeRateError(this.message);

  @override
  List<Object?> get props => [message];
}
