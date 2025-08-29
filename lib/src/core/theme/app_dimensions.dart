import 'package:flutter/material.dart';

class AppDimensions {
  AppDimensions._(); //coverage:ignore-line

  static const double spacingXs = 4.0;

  static const double spacingSm = 8.0;

  static const double spacingMd = 16.0;

  static const double spacingLg = 24.0;

  static const double spacingXl = 32.0;

  static const double spacingXxl = 48.0;

  static const double buttonHeight = 48.0;

  static const double buttonHeightSm = 40.0;

  static const double buttonHeightXs = 32.0;

  static const double inputHeight = 48.0;

  static const double inputHeightSm = 40.0;

  static const double cardPadding = 16.0;

  static const double cardPaddingSm = 12.0;

  static const double cardPaddingLg = 24.0;

  static const double borderRadius = 8.0;

  static const double borderRadiusSm = 4.0;

  static const double borderRadiusLg = 12.0;

  static const double borderRadiusXl = 16.0;

  static const double borderWidth = 1.0;

  static const double borderWidthThick = 2.0;

  static const double iconSize = 24.0;

  static const double iconSizeSm = 16.0;

  static const double iconSizeLg = 32.0;

  static const double iconSizeXl = 48.0;

  static const double headerHeight = 60.0;

  static const double footerHeight = 30.0;

  static const double sectionSpacing = 32.0;

  static const double listItemSpacing = 12.0;

  static const double fieldGroupSpacing = 24.0;

  static EdgeInsets padding(double size) => EdgeInsets.all(size);

  static EdgeInsets paddingHorizontal(double size) =>
      EdgeInsets.symmetric(horizontal: size);

  static EdgeInsets paddingOnly({
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
  }) => EdgeInsets.only(left: left, top: top, right: right, bottom: bottom);

  static EdgeInsets marginHorizontal(double size) =>
      EdgeInsets.symmetric(horizontal: size);
}
