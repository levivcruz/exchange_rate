import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/cubits.dart';
import '../blocs/blocs.dart';
import 'exchange_result_button.dart';
import 'currency_input_field.dart';
import 'exchange_rate_result_widget.dart';
import '../../../../core/core.dart';
import 'error_state_widget.dart';

class MainContentWidget extends StatelessWidget {
  const MainContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: BlocBuilder<CurrencyInputCubit, CurrencyInputState>(
            builder: (context, currencyState) {
              return CurrencyInputField(
                onChanged: (value) {
                  context.read<CurrencyInputCubit>().updateCurrency(value);
                },
              );
            },
          ),
        ),

        BlocBuilder<CurrencyInputCubit, CurrencyInputState>(
          builder: (context, currencyState) {
            if (currencyState is CurrencyInputUpdated &&
                currencyState.currency.length == 3 &&
                !currencyState.isValid) {
              return Padding(
                padding: EdgeInsets.only(
                  top: ResponsiveConstants.spacingXs(context),
                ),
                child: Text(
                  'Invalid currency code',
                  style: TextStyle(
                    color: AppColors.alertRed,
                    fontSize: ResponsiveConstants.smallText(context),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),

        ResponsiveConstants.verticalSpace(context, 0.02),

        Center(
          child:
              BlocBuilder<CurrentExchangeRateCubit, CurrentExchangeRateState>(
                builder: (context, exchangeState) {
                  return BlocBuilder<CurrencyInputCubit, CurrencyInputState>(
                    builder: (context, currencyState) {
                      final isValidCurrency =
                          currencyState is CurrencyInputUpdated &&
                          currencyState.isValid;

                      return ExchangeResultButton(
                        onPressed: () {
                          if (isValidCurrency) {
                            FocusScope.of(context).unfocus();

                            context.read<DailyExchangeRateBloc>().add(
                              ResetDailyExchangeRate(),
                            );

                            context
                                .read<CurrentExchangeRateCubit>()
                                .getCurrentExchangeRate(
                                  fromSymbol: currencyState.currency,
                                  toSymbol: 'BRL',
                                );
                          }
                        },
                        isLoading: exchangeState is CurrentExchangeRateLoading,
                      );
                    },
                  );
                },
              ),
        ),

        ResponsiveConstants.verticalSpace(context, 0.02),

        Expanded(
          child:
              BlocBuilder<CurrentExchangeRateCubit, CurrentExchangeRateState>(
                builder: (context, exchangeState) {
                  if (exchangeState is CurrentExchangeRateLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.branded01,
                      ),
                    );
                  } else if (exchangeState is CurrentExchangeRateLoaded) {
                    return BlocBuilder<CurrencyInputCubit, CurrencyInputState>(
                      builder: (context, currencyState) {
                        final selectedCurrency =
                            currencyState is CurrencyInputUpdated
                            ? currencyState.currency
                            : '';

                        return ExchangeRateResultWidget(
                          exchangeRate: exchangeState.exchangeRate,
                          selectedCurrency: selectedCurrency,
                        );
                      },
                    );
                  } else if (exchangeState is CurrentExchangeRateError) {
                    return ErrorStateWidget(message: exchangeState.message);
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
        ),
      ],
    );
  }
}
