import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/core.dart';

class LogoSectionWidget extends StatelessWidget {
  const LogoSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: AppDimensions.padding(AppDimensions.spacingMd),
          child: SizedBox(
            width: ResponsiveConstants.logoWidth(context),
            height: ResponsiveConstants.logoHeight(context),
            child: SvgPicture.asset(
              'assets/images/logo.svg',
              fit: BoxFit.contain,
            ),
          ),
        ),

        Container(
          height: AppDimensions.borderWidthThick,
          color: AppColors.neutralGrey02,
          margin: AppDimensions.marginHorizontal(AppDimensions.spacingMd),
        ),
      ],
    );
  }
}
