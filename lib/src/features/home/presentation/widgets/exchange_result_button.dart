import 'package:flutter/material.dart';
import '../../../../core/core.dart';

class ExchangeResultButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final String text;

  const ExchangeResultButton({
    super.key,
    this.onPressed,
    this.isLoading = false,
    this.text = 'exchange result',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppDimensions.paddingHorizontal(AppDimensions.spacingMd),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.branded01,
          foregroundColor: AppColors.neutralWhite,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: AppDimensions.iconSize,
                height: AppDimensions.iconSize,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.neutralWhite,
                  ),
                ),
              )
            : Text(
                text.toUpperCase(),
                style: AppTextStyles.buttonLabel.copyWith(
                  color: AppColors.neutralWhite,
                ),
                textAlign: TextAlign.center,
              ),
      ),
    );
  }
}
