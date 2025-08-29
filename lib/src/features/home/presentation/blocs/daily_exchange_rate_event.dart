part of 'daily_exchange_rate_bloc.dart';

abstract class DailyExchangeRateEvent extends Equatable {
  const DailyExchangeRateEvent();

  @override
  List<Object?> get props => [];
}

class GetDailyExchangeRate extends DailyExchangeRateEvent {
  final String fromSymbol;
  final String toSymbol;

  const GetDailyExchangeRate({
    required this.fromSymbol,
    required this.toSymbol,
  });

  @override
  List<Object?> get props => [fromSymbol, toSymbol];
}

class ResetDailyExchangeRate extends DailyExchangeRateEvent {
  const ResetDailyExchangeRate();
}
