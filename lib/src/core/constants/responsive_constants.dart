import 'package:flutter/material.dart';

class ResponsiveConstants {
  static double smallText(BuildContext context) =>
      MediaQuery.of(context).size.width * 0.03;

  static double normalText(BuildContext context) =>
      MediaQuery.of(context).size.width * 0.04;

  static double headerText(BuildContext context) =>
      MediaQuery.of(context).size.width * 0.06;

  static double iconLarge(BuildContext context) =>
      MediaQuery.of(context).size.width * 0.15;

  static double spacingXs(BuildContext context) =>
      MediaQuery.of(context).size.height * 0.01;

  static double footerHeight(BuildContext context) =>
      MediaQuery.of(context).size.height * 0.05;

  static double logoWidth(BuildContext context) =>
      MediaQuery.of(context).size.width * 0.4;

  static double logoHeight(BuildContext context) =>
      MediaQuery.of(context).size.height * 0.08;

  static double historicalDataHeight(BuildContext context) =>
      MediaQuery.of(context).size.height * 0.35;

  static EdgeInsets verticalPadding(BuildContext context, double percentage) =>
      EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * percentage,
      );

  static Widget verticalSpace(BuildContext context, double percentage) =>
      SizedBox(height: MediaQuery.of(context).size.height * percentage);
}
