import '../../domain/entities/exchange_rate_data_entity.dart';

class ExchangeRateDataDTO extends ExchangeRateDataEntity {
  const ExchangeRateDataDTO({
    super.close,
    super.date,
    super.high,
    super.low,
    super.open,
  });

  factory ExchangeRateDataDTO.fromJson(Map<String, dynamic> json) {
    return ExchangeRateDataDTO(
      close: json['close']?.toDouble(),
      date: json['date'],
      high: json['high']?.toDouble(),
      low: json['low']?.toDouble(),
      open: json['open']?.toDouble(),
    );
  }

  factory ExchangeRateDataDTO.fromEntity(ExchangeRateDataEntity entity) {
    return ExchangeRateDataDTO(
      close: entity.close,
      date: entity.date,
      high: entity.high,
      low: entity.low,
      open: entity.open,
    );
  }
}
