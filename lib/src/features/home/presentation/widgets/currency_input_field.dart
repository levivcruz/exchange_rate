import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/core.dart';

class CurrencyInputField extends StatelessWidget {
  final ValueChanged<String>? onChanged;

  const CurrencyInputField({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppDimensions.paddingHorizontal(AppDimensions.spacingMd),
      child: TextField(
        textCapitalization: TextCapitalization.characters,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z]')),
          LengthLimitingTextInputFormatter(3),
          TextInputFormatter.withFunction(
            (oldValue, newValue) =>
                newValue.copyWith(text: newValue.text.toUpperCase()),
          ),
        ],
        onChanged: onChanged,

        decoration: InputDecoration(
          labelText: 'Enter the currency code',
          labelStyle: AppTextStyles.bodySmall,
          floatingLabelStyle: const TextStyle(color: AppColors.branded01),
          filled: true,
          fillColor: AppColors.neutralGrey03,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.branded01, width: 2),
          ),
        ),
      ),
    );
  }
}
