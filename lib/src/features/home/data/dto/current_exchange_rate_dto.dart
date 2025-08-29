import '../../domain/entities/current_exchange_rate_entity.dart';

class CurrentExchangeRateDTO extends CurrentExchangeRateEntity {
  const CurrentExchangeRateDTO({
    super.exchangeRate,
    super.fromSymbol,
    super.lastUpdatedAt,
    super.rateLimitExceeded,
    super.success,
    super.toSymbol,
  });

  factory CurrentExchangeRateDTO.fromJson(Map<String, dynamic> json) {
    return CurrentExchangeRateDTO(
      exchangeRate: json['exchangeRate']?.toDouble(),
      fromSymbol: json['fromSymbol'],
      lastUpdatedAt: json['lastUpdatedAt'],
      rateLimitExceeded: json['rateLimitExceeded'],
      success: json['success'],
      toSymbol: json['toSymbol'],
    );
  }
}
