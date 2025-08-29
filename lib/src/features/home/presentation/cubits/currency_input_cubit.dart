import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/core.dart';

part 'currency_input_state.dart';

class CurrencyInputCubit extends Cubit<CurrencyInputState> {
  CurrencyInputCubit() : super(const CurrencyInputInitial());

  void updateCurrency(String currency) {
    final normalizedCurrency = currency.trim().toUpperCase();

    if (normalizedCurrency.isEmpty) {
      emit(const CurrencyInputInitial());
      return;
    }

    final isValid = CurrencyValidator.isValid(normalizedCurrency);

    emit(CurrencyInputUpdated(currency: normalizedCurrency, isValid: isValid));
  }

  void clearCurrency() {
    emit(const CurrencyInputInitial());
  }

  String? getErrorMessage() {
    final currentState = state;
    if (currentState is CurrencyInputUpdated && !currentState.isValid) {
      return CurrencyValidator.getErrorMessage(currentState.currency);
    }
    return null;
  }

  List<String> getSuggestions() {
    final currentState = state;
    if (currentState is CurrencyInputUpdated && !currentState.isValid) {
      return CurrencyValidator.getSuggestions(currentState.currency);
    }
    return [];
  }
}
