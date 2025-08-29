part of 'currency_input_cubit.dart';

abstract class CurrencyInputState extends Equatable {
  const CurrencyInputState();

  @override
  List<Object?> get props => [];
}

class CurrencyInputInitial extends CurrencyInputState {
  const CurrencyInputInitial();
}

class CurrencyInputUpdated extends CurrencyInputState {
  final String currency;
  final bool isValid;

  const CurrencyInputUpdated({required this.currency, required this.isValid});

  @override
  List<Object?> get props => [currency, isValid];
}
