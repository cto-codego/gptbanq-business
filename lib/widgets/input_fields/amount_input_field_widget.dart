import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/input_fields/custom_color.dart';
import '../../utils/validator.dart';

class AmountInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final double minAmount;
  final String label;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String currencySymbol;
  final String? suffixSymbol;
  final bool autofocus;
  final bool readOnly;
  void Function(String)? onChanged;

  AmountInputField({
    super.key,
    required this.controller,
    this.hintText = 'Amount',
    this.minAmount = 10.0,
    this.label = "Transfer Amount",
    this.currencySymbol = '€',
    this.autofocus = false,
    this.readOnly = false,
    this.onChanged,
    this.suffixSymbol = "",
    this.suffixIcon,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 5),
          child: Text(
            label,
            style: GoogleFonts.inter(
              color: CustomColor.black,
              fontWeight: FontWeight.w600,
              fontSize: 23,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          obscureText: false,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            return Validator.validateValues(
              value: value,
              isAmount: true,
              minAmount: minAmount,
            );
          },
          onChanged: onChanged,
          style: GoogleFonts.inter(
            fontSize: 40,
            fontWeight: FontWeight.w500,
            color: CustomColor.black,
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 1),
            prefix: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                currencySymbol,
                style: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                  color: CustomColor.black,
                ),
              ),
            ),
            prefixIcon: prefixIcon,
            suffix: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                suffixSymbol!,
                style: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                  color: CustomColor.black,
                ),
              ),
            ),
            suffixIcon: suffixIcon,
            errorStyle: GoogleFonts.inter(
              color: CustomColor.errorColor,
            ),
            hintText: hintText,
            hintStyle: GoogleFonts.inter(
              fontSize: 32,
              fontWeight: FontWeight.w500,
              color: CustomColor.primaryTextHintColor,
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: CustomColor.primaryInputHintBorderColor,
                width: 1,
              ),
            ),
            errorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: CustomColor.errorColor,
                width: 1,
              ),
            ),
            focusedErrorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: CustomColor.errorColor,
                width: 1,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: CustomColor.primaryColor,
                width: 1,
              ),
            ),
            border: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: CustomColor.primaryInputHintBorderColor,
                width: 1,
              ),
            ),
            disabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: CustomColor.primaryInputHintBorderColor,
                width: 1,
              ),
            ),
            enabled: true,
          ),
        ),
      ],
    );
  }
}
