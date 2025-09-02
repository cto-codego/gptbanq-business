import 'package:gptbanqbusiness/utils/input_fields/custom_color.dart';
import 'package:gptbanqbusiness/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/custom_style.dart';

class InputTextCustom extends StatefulWidget {
  final TextEditingController controller;
  final String label, hint;
  final String? suffixIconPath;
  final bool isEmail, isPassword, isSixteenDigits, autofocus;
  final bool? isConfirmPassword, isHide, readOnly;
  final TextInputType? keyboardType;
  final Function? onTap, onChanged;

  const InputTextCustom({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.isEmail,
    required this.isPassword,
    this.autofocus = false,
    this.isSixteenDigits = false,
    this.isConfirmPassword,
    this.onTap,
    this.isHide,
    this.readOnly,
    this.onChanged,
    this.keyboardType,
    this.suffixIconPath, // Made this nullable
  });

  @override
  State<InputTextCustom> createState() => _InputTextCustomState();
}

class _InputTextCustomState extends State<InputTextCustom> {
  FocusNode _focusNode = FocusNode();
  bool _isBorderVisible = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isBorderVisible =
            _focusNode.hasFocus || widget.controller.text.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 5),
          child: Text(
            widget.label,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: _isBorderVisible
                  ? CustomColor.primaryColor
                  : CustomColor.inputFieldTitleTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          autofocus: widget.autofocus,
          keyboardType: widget.keyboardType,
          obscureText: widget.isHide ?? false,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            return Validator.validateValues(
              value: value,
              isEmail: widget.isEmail,
              isChangePassword: widget.isPassword,
              isConfirmPassword: widget.isConfirmPassword ?? false,
              password: widget.isConfirmPassword == true
                  ? widget.controller.text
                  : '',
              isSixteenDigits: widget.isSixteenDigits,
            );
          },
          onChanged: (value) {
            setState(() {
              _isBorderVisible = value.isNotEmpty;
            });
            if (widget.onChanged != null) {
              widget.onChanged!();
            }
          },
          onTap: () {
            if (widget.onTap != null) {
              widget.onTap!();
            }
          },
          readOnly: widget.readOnly ?? false,
          style: CustomStyle.loginInputTextStyle,
          decoration: InputDecoration(
            errorStyle: TextStyle(color: CustomColor.errorColor),
            contentPadding: const EdgeInsets.all(16),
            hintText: widget.hint,
            hintStyle: CustomStyle.loginInputTextHintStyle,
            filled: true,
            fillColor: _focusNode.hasFocus
                ? CustomColor.whiteColor
                : CustomColor.primaryInputHintColor,
            // Fill color based on focus state
            suffixIcon: widget.suffixIconPath !=
                null // Check if suffixIconPath is provided
                ? Padding(
              padding: const EdgeInsets.all(12.0),
              child: SvgPicture.asset(
                widget.suffixIconPath!,
                height: 20, // Adjust height as needed
                width: 20, // Adjust width as needed
              ),
            )
                : null,
            enabledBorder:
            _buildBorder(CustomColor.primaryInputHintBorderColor),
            errorBorder: _buildErrorBorder(),
            focusedErrorBorder: _buildErrorBorder(),
            focusedBorder: _buildBorder(CustomColor.primaryColor),
            border: _buildBorder(CustomColor.primaryColor),
            disabledBorder: _buildBorder(CustomColor.primaryColor),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  OutlineInputBorder _buildBorder(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: 1),
      borderRadius: BorderRadius.circular(11),
    );
  }

  OutlineInputBorder _buildErrorBorder() {
    return OutlineInputBorder(
      borderSide: const BorderSide(color: CustomColor.errorColor, width: 1),
      borderRadius: BorderRadius.circular(11),
    );
  }
}
