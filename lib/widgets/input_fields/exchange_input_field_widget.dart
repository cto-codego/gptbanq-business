import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/input_fields/custom_color.dart';

class ExchangeInputFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final bool isEmail, isPassword, isSixteenDigits;
  final bool? isConfirmPassword;
  final String? password;
  final bool? isHide;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final Function? onTap;
  final bool? readOnly;
  final BorderRadius borderRadius;
  final bool autofocus;
  final Widget? prefixIcon;
  final String? suffixText; // Dynamic suffix text
  final FocusNode? focusNode; // Function to show the keypad


  const ExchangeInputFieldWidget({
    super.key,
    required this.controller,
    required this.hint,
    required this.isEmail,
    required this.isPassword,
    this.isSixteenDigits = false,
    this.isConfirmPassword,
    this.onChanged,
    this.onTap,
    this.isHide,
    this.readOnly,
    this.password,
    this.autofocus = false,
    this.borderRadius = const BorderRadius.all(Radius.circular(0)),
    this.keyboardType,
    this.prefixIcon,
    this.suffixText,
    this.focusNode,
  });

  @override
  State<ExchangeInputFieldWidget> createState() =>
      _ExchangeInputFieldWidgetState();
}

class _ExchangeInputFieldWidgetState extends State<ExchangeInputFieldWidget> {
  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (widget.prefixIcon != null) widget.prefixIcon!,
        Expanded(
          child: TextFormField(
            textAlign: TextAlign.right,
            // Aligns text to the right
            controller: widget.controller,
            focusNode: widget.focusNode,
            keyboardType: widget.keyboardType,

            obscureText: widget.isHide ?? false,
            onChanged: widget.onChanged,
            onTap: widget.onTap == null
                ? null
                : () {
                    widget.onTap!();
                  },
            readOnly: widget.readOnly ?? false,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: CustomColor.black,
            ),
            autofocus: widget.autofocus,
            decoration: InputDecoration(
              isDense: true,
              hintText: widget.hint,
              filled: true,
              fillColor: CustomColor.whiteColor,
              border: InputBorder.none,
              suffixText: widget.suffixText!,
              // border: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(12), // Set borderRadius to 12
              //   borderSide: BorderSide.none, // Optional: Removes the default border side color
              // ),
              suffixStyle: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: CustomColor.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
