import 'package:equatable/equatable.dart';

class CurrentExchangeRateEntity extends Equatable {
  final double? exchangeRate;

  final String? fromSymbol;

  final String? lastUpdatedAt;

  final bool? rateLimitExceeded;

  final bool? success;

  final String? toSymbol;

  const CurrentExchangeRateEntity({
    this.exchangeRate,
    this.fromSymbol,
    this.lastUpdatedAt,
    this.rateLimitExceeded,
    this.success,
    this.toSymbol,
  });

  @override
  List<Object?> get props => [
    exchangeRate,
    fromSymbol,
    lastUpdatedAt,
    rateLimitExceeded,
    success,
    toSymbol,
  ];
}
