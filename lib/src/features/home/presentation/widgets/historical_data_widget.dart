import 'package:flutter/material.dart';

import '../../domain/entities/exchange_rate_history_entity.dart';
import '../../../../core/core.dart';

class HistoricalDataWidget extends StatelessWidget {
  final ExchangeRatesEntity exchangeRates;

  const HistoricalDataWidget({super.key, required this.exchangeRates});

  @override
  Widget build(BuildContext context) {
    if (exchangeRates.data == null || exchangeRates.data!.isEmpty) {
      return Center(
        child: Text(
          'No historical data available',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.neutralGrey02,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: exchangeRates.data!.length,
      itemBuilder: (context, index) {
        final data = exchangeRates.data![index];

        double? closeDiffPercent;
        if (data.open != null && data.close != null && data.open != 0) {
          closeDiffPercent = ((data.close! - data.open!) / data.open!) * 100;
        }

        bool isPositive = closeDiffPercent != null && closeDiffPercent >= 0;

        return Card(
          color: AppColors.neutralWhite,
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.date != null
                            ? DateFormatter.formatDate(
                                DateTime.parse(data.date!),
                              )
                            : 'N/A',
                        style: AppTextStyles.bodySemibold.copyWith(
                          fontSize: 14,
                          color: AppColors.branded01,
                        ),
                      ),
                      const SizedBox(height: 8),

                      _DataRow(
                        label: 'OPEN:',
                        value: CurrencyFormatter.formatBRLWithDecimals(
                          data.open ?? 0,
                          4,
                        ),
                      ),
                      _DataRow(
                        label: 'CLOSE:',
                        value: CurrencyFormatter.formatBRLWithDecimals(
                          data.close ?? 0,
                          4,
                        ),
                      ),

                      if (closeDiffPercent != null)
                        _PercentageRow(
                          label: 'CLOSE DIFF (%):',
                          percentage: closeDiffPercent,
                          isPositive: isPositive,
                        ),
                    ],
                  ),
                ),

                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _DataRow(
                        label: 'HIGH:',
                        value: CurrencyFormatter.formatBRLWithDecimals(
                          data.high ?? 0,
                          4,
                        ),
                      ),
                      _DataRow(
                        label: 'LOW:',
                        value: CurrencyFormatter.formatBRLWithDecimals(
                          data.low ?? 0,
                          4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DataRow extends StatelessWidget {
  final String label;
  final String value;

  const _DataRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppDimensions.paddingOnly(bottom: AppDimensions.spacingXs),
      child: Row(
        children: [
          Flexible(
            flex: 2,
            child: Text(
              label,
              style: AppTextStyles.labelSmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: AppDimensions.spacingSm),
          Flexible(
            flex: 3,
            child: Text(
              value,
              style: AppTextStyles.bodySemibold,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _PercentageRow extends StatelessWidget {
  final String label;
  final double percentage;
  final bool isPositive;

  const _PercentageRow({
    required this.label,
    required this.percentage,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppDimensions.paddingOnly(bottom: AppDimensions.spacingXs),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.labelSmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: AppDimensions.spacingSm),
          Text(
            NumberFormatter.formatPercentageWithSign(
              percentage / 100,
              decimalPlaces: 2,
            ),
            style: AppTextStyles.bodySemibold.copyWith(
              color: isPositive ? AppColors.alertGreen : AppColors.alertRed,
            ),
          ),
          const SizedBox(width: AppDimensions.spacingXs),
          Icon(
            isPositive ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: isPositive ? AppColors.alertGreen : AppColors.alertRed,
            size: 24,
          ),
        ],
      ),
    );
  }
}
