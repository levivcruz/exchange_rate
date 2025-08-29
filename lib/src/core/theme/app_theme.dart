import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'app_dimensions.dart';

class AppTheme {
  AppTheme._(); //coverage:ignore-line

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'Roboto',

      colorScheme: _buildColorScheme(),

      textTheme: _buildTextTheme(),

      elevatedButtonTheme: _buildElevatedButtonTheme(),

      cardTheme: _buildCardTheme(),

      iconTheme: _buildIconTheme(),

      appBarTheme: _buildAppBarTheme(),

      scaffoldBackgroundColor: AppColors.neutralWhite,
    );
  }

  static ColorScheme _buildColorScheme() {
    return const ColorScheme.light(
      primary: AppColors.branded01,
      onPrimary: AppColors.neutralWhite,
      primaryContainer: AppColors.branded01Hover,
      onPrimaryContainer: AppColors.neutralWhite,

      secondary: AppColors.neutralDark02,
      onSecondary: AppColors.neutralWhite,
      secondaryContainer: AppColors.neutralGrey03,
      onSecondaryContainer: AppColors.neutralDark01,

      surface: AppColors.neutralGrey03,
      onSurface: AppColors.neutralDark01,
      surfaceContainerHighest: AppColors.neutralGrey03,
      onSurfaceVariant: AppColors.neutralDark02,

      error: AppColors.alertRed,
      onError: AppColors.neutralWhite,
      errorContainer: AppColors.alertRed,
      onErrorContainer: AppColors.neutralWhite,

      tertiary: AppColors.alertGreen,
      onTertiary: AppColors.neutralWhite,
      tertiaryContainer: AppColors.alertGreen,
      onTertiaryContainer: AppColors.neutralWhite,

      outline: AppColors.neutralGrey02,
      outlineVariant: AppColors.neutralGrey02,
    );
  }

  static TextTheme _buildTextTheme() {
    return const TextTheme(
      displayLarge: AppTextStyles.titleExtraLarge,
      displayMedium: AppTextStyles.titleAdminH1,
      displaySmall: AppTextStyles.headingSemibold,

      headlineLarge: AppTextStyles.titleAdminH1,
      headlineMedium: AppTextStyles.headingSemibold,
      headlineSmall: AppTextStyles.bodySemibold,

      titleLarge: AppTextStyles.bodySemibold,
      titleMedium: AppTextStyles.buttonLabel,
      titleSmall: AppTextStyles.bodyRegular,

      bodyLarge: AppTextStyles.bodyRegular,
      bodyMedium: AppTextStyles.bodySmall,
      bodySmall: AppTextStyles.captionSmall,

      labelLarge: AppTextStyles.buttonLabel,
      labelMedium: AppTextStyles.bodySmall,
      labelSmall: AppTextStyles.labelSmall,
    );
  }

  static ElevatedButtonThemeData _buildElevatedButtonTheme() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.branded01,
        foregroundColor: AppColors.neutralWhite,
        elevation: 2,
        shadowColor: Colors.black12,
        minimumSize: Size(double.infinity, AppDimensions.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        ),
        textStyle: AppTextStyles.buttonLabel,
      ),
    );
  }

  static CardThemeData _buildCardTheme() {
    return CardThemeData(
      color: AppColors.neutralWhite,
      elevation: 2,
      shadowColor: Colors.black12,
    );
  }

  static IconThemeData _buildIconTheme() {
    return const IconThemeData(
      color: AppColors.neutralDark01,
      size: AppDimensions.iconSize,
    );
  }

  static AppBarTheme _buildAppBarTheme() {
    return const AppBarTheme(
      backgroundColor: AppColors.neutralWhite,
      foregroundColor: AppColors.neutralDark01,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTextStyles.titleAdminH1,
      iconTheme: IconThemeData(
        color: AppColors.neutralDark01,
        size: AppDimensions.iconSize,
      ),
    );
  }
}
