import 'package:equatable/equatable.dart';

class ExchangeRateDataEntity extends Equatable {
  final double? close;

  final String? date;

  final double? high;

  final double? low;

  final double? open;

  const ExchangeRateDataEntity({
    this.close,
    this.date,
    this.high,
    this.low,
    this.open,
  });

  @override
  List<Object?> get props => [close, date, high, low, open];
}
