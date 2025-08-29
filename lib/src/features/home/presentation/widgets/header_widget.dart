import 'package:flutter/material.dart';
import '../../../../core/core.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppDimensions.paddingHorizontal(AppDimensions.spacingMd),
      child: Padding(
        padding: ResponsiveConstants.verticalPadding(context, 0.02),
        child: Text(
          'BRL EXCHANGE RATE',
          style: AppTextStyles.titleExtraLarge.copyWith(
            color: AppColors.branded01,
            fontSize: ResponsiveConstants.headerText(context),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
