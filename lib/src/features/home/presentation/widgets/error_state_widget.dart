import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../cubits/cubits.dart';

class ErrorStateWidget extends StatelessWidget {
  final String message;

  const ErrorStateWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppDimensions.paddingHorizontal(AppDimensions.spacingMd),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: AppColors.alertRed,
              size: ResponsiveConstants.iconLarge(context),
            ),
            const SizedBox(height: 16),
            Text(
              'Error: $message',
              style: TextStyle(
                color: AppColors.alertRed,
                fontSize: ResponsiveConstants.normalText(context),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<CurrentExchangeRateCubit>().reset();
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
