import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._(); //coverage:ignore-line

  static const String fontFamily = 'Roboto';

  static const TextStyle titleExtraLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.branded01,
    height: 1.25,
    letterSpacing: 0.0,
  );

  static const TextStyle titleAdminH1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.neutralDark01,
    height: 1.25,
    letterSpacing: 0.0,
  );

  static const TextStyle headingSemibold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.neutralDark01,
    height: 1.56,
    letterSpacing: 0.0,
  );

  static const TextStyle bodySemibold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.neutralDark01,
    height: 1.5,
    letterSpacing: 0.0,
  );

  static const TextStyle buttonLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.neutralDark01,
    height: 1.5,
    letterSpacing: 0.0,
  );

  static const TextStyle bodyRegular = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.neutralDark01,
    height: 1.5,
    letterSpacing: 0.0,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.neutralDark02,
    height: 1.57,
    letterSpacing: 0.0,
  );

  static const TextStyle captionSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.neutralDark02,
    height: 1.33,
    letterSpacing: 0.0,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.neutralDark02,
    height: 1.27,
    letterSpacing: 0.0,
  );
}
