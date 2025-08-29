import '../../domain/entities/exchange_rate_history_entity.dart';
import 'exchange_rate_data_dto.dart';

class ExchangeRatesDTO extends ExchangeRatesEntity {
  const ExchangeRatesDTO({
    super.data,
    super.from,
    super.lastUpdatedAt,
    super.rateLimitExceeded,
    super.success,
    super.to,
  });

  factory ExchangeRatesDTO.fromJson(Map<String, dynamic> json) {
    return ExchangeRatesDTO(
      data: json['data'] != null
          ? (json['data'] as List)
                .map((item) => ExchangeRateDataDTO.fromJson(item))
                .toList()
          : null,
      from: json['from'],
      lastUpdatedAt: json['lastUpdatedAt'],
      rateLimitExceeded: json['rateLimitExceeded'],
      success: json['success'],
      to: json['to'],
    );
  }
}
