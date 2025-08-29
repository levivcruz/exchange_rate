import 'package:flutter/material.dart';
import '../../../../core/core.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: ResponsiveConstants.footerHeight(context),
      color: AppColors.branded01,
      child: Center(
        child: Padding(
          padding: AppDimensions.paddingHorizontal(AppDimensions.spacingSm),
          child: Text(
            'Copyright 2025 - Action Labs',
            style: AppTextStyles.captionSmall.copyWith(
              color: AppColors.neutralWhite,
              fontSize: ResponsiveConstants.smallText(context),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
