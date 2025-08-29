import 'package:equatable/equatable.dart';
import 'exchange_rate_data_entity.dart';

class ExchangeRatesEntity extends Equatable {
  final List<ExchangeRateDataEntity>? data;

  final String? from;

  final String? lastUpdatedAt;

  final bool? rateLimitExceeded;

  final bool? success;

  final String? to;

  const ExchangeRatesEntity({
    this.data,
    this.from,
    this.lastUpdatedAt,
    this.rateLimitExceeded,
    this.success,
    this.to,
  });

  @override
  List<Object?> get props => [
    data,
    from,
    lastUpdatedAt,
    rateLimitExceeded,
    success,
    to,
  ];
}
