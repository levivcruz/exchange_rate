import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/current_exchange_rate_entity.dart';
import '../../../../core/core.dart';
import 'historical_data_widget.dart';

import '../blocs/blocs.dart';

class ExchangeRateResultWidget extends StatelessWidget {
  final CurrentExchangeRateEntity exchangeRate;
  final String selectedCurrency;

  const ExchangeRateResultWidget({
    super.key,
    required this.exchangeRate,
    required this.selectedCurrency,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppDimensions.paddingHorizontal(AppDimensions.spacingMd),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Exchange rate now',
                        style: AppTextStyles.headingSemibold,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        DateFormatter.formatCurrentDateTime(),
                        style: AppTextStyles.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: Text(
                    '${exchangeRate.fromSymbol ?? selectedCurrency}/BRL',
                    style: AppTextStyles.titleAdminH1.copyWith(
                      color: AppColors.branded01,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppDimensions.spacingMd),

            Container(
              color: const Color(0xFFE6F3FF),
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Text(
                  CurrencyFormatter.formatBRL(exchangeRate.exchangeRate ?? 0.0),
                  style: AppTextStyles.titleExtraLarge.copyWith(
                    color: AppColors.branded01,
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppDimensions.spacingXl),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('LAST 30 DAYS', style: AppTextStyles.bodySemibold),
                BlocBuilder<DailyExchangeRateBloc, DailyExchangeRateState>(
                  builder: (context, historyState) {
                    return IconButton(
                      onPressed: () {
                        if (historyState is DailyExchangeRateLoaded) {
                          context.read<DailyExchangeRateBloc>().add(
                            ResetDailyExchangeRate(),
                          );
                        } else {
                          context.read<DailyExchangeRateBloc>().add(
                            GetDailyExchangeRate(
                              fromSymbol: selectedCurrency,
                              toSymbol: 'BRL',
                            ),
                          );
                        }
                      },
                      icon: Icon(
                        historyState is DailyExchangeRateLoaded
                            ? Icons.remove
                            : Icons.add,
                        color: AppColors.branded01,
                        size: 24,
                      ),
                    );
                  },
                ),
              ],
            ),

            BlocBuilder<DailyExchangeRateBloc, DailyExchangeRateState>(
              builder: (context, historyState) {
                if (historyState is! DailyExchangeRateLoaded) {
                  return Column(
                    children: [
                      Container(height: 2, color: AppColors.branded01),
                      const SizedBox(height: AppDimensions.spacingMd),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),

            BlocBuilder<DailyExchangeRateBloc, DailyExchangeRateState>(
              builder: (context, historyState) {
                if (historyState is DailyExchangeRateLoading) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: AppDimensions.spacingMd,
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.branded01,
                      ),
                    ),
                  );
                } else if (historyState is DailyExchangeRateLoaded) {
                  return Container(
                    height: ResponsiveConstants.historicalDataHeight(context),
                    color: AppColors.neutralGrey03,
                    padding: AppDimensions.padding(10),
                    margin: const EdgeInsets.only(
                      bottom: AppDimensions.spacingMd,
                    ),
                    child: HistoricalDataWidget(
                      exchangeRates: historyState.exchangeRates,
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
