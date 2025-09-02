import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/custom_style.dart';
import '../../utils/input_fields/custom_color.dart';
import '../../utils/validator.dart';

class DefaultInputFieldWithTitleWidget extends StatefulWidget {
  final TextEditingController controller;
  final String title;
  final String hint;
  final bool isEmail, isPassword, isSixteenDigits;
  final bool? isConfirmPassword;
  final String? password;
  final bool? isHide;
  final TextInputType? keyboardType;
  final Function? onChanged;
  final Function? onTap;
  final bool? readOnly;
  final BorderRadius borderRadius;
  final bool autofocus;
  final Widget? suffix;
  final Widget? suffixIcon;
  final Widget? prefix;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;

  const DefaultInputFieldWithTitleWidget({
    super.key,
    required this.controller,
    required this.hint,
    required this.title,
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
    this.borderRadius = const BorderRadius.only(
      // Default border radius
      topLeft: Radius.circular(11),
      topRight: Radius.circular(11),
      bottomLeft: Radius.circular(11),
      bottomRight: Radius.circular(11),
    ),
    this.keyboardType,
    this.suffix,
    this.suffixIcon,
    this.prefixIcon,
    this.prefix,
    this.validator,
  });

  @override
  State<DefaultInputFieldWithTitleWidget> createState() =>
      _DefaultInputFieldWithTitleWidgetState();
}

class _DefaultInputFieldWithTitleWidgetState
    extends State<DefaultInputFieldWithTitleWidget> {
  FocusNode myFocusNode = FocusNode();
  bool bordershoww = false;
  ValueNotifier<Color> titleColorNotifier =
      ValueNotifier<Color>(CustomColor.inputFieldTitleTextColor);

  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(() {
      setState(() {
        titleColorNotifier.value = myFocusNode.hasFocus
            ? CustomColor.primaryColor
            : CustomColor.inputFieldTitleTextColor;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 5),
          child: ValueListenableBuilder(
            valueListenable: titleColorNotifier,
            builder: (context, Color titleColor, child) {
              return Text(
                widget.title,
                style: GoogleFonts.inter(
                  color: titleColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              );
            },
          ),
        ),
        TextFormField(
          controller: widget.controller,
          focusNode: myFocusNode,
          keyboardType: widget.keyboardType,
          obscureText: widget.isHide ?? false,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: widget.validator ??
              (value) {
                return Validator.validateValues(
                  value: value,
                  isEmail: widget.isEmail,
                  isChangePassword: widget.isPassword,
                  isConfirmPassword: widget.isConfirmPassword ?? false,
                  password: widget.password ?? '',
                  isSixteenDigits: widget.isSixteenDigits,
                );
              },
          onChanged: (v) {
            setState(() {
              v.isNotEmpty ? bordershoww = true : bordershoww = false;
            });
            if (widget.onChanged != null) {
              widget.onChanged!(v); // Pass the 'v' parameter here
            }
          },
          onTap: widget.onTap == null
              ? null
              : () {
                  setState(() {
                    widget.controller.text.isNotEmpty
                        ? bordershoww = true
                        : bordershoww = false;
                  });
                  widget.onTap!();
                },
          readOnly: widget.readOnly ?? false,
          style: CustomStyle.loginInputTextStyle,
          autofocus: widget.autofocus,
          decoration: InputDecoration(
            errorStyle: TextStyle(color: CustomColor.errorColor),
            contentPadding: const EdgeInsets.all(16),
            hintText: widget.hint,
            hintStyle: CustomStyle.loginInputTextHintStyle,
            filled: true,
            fillColor: myFocusNode.hasFocus
                ? CustomColor.whiteColor
                : CustomColor.primaryInputHintColor,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: CustomColor.primaryColor,
                width: 1,
              ),
              borderRadius: widget.borderRadius,
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: CustomColor.errorColor,
                width: 1,
              ),
              borderRadius: widget.borderRadius,
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: CustomColor.errorColor,
                width: 1,
              ),
              borderRadius: widget.borderRadius,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: CustomColor.primaryColor,
                width: 1,
              ),
              borderRadius: widget.borderRadius,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: CustomColor.primaryColor,
                width: 1,
              ),
              borderRadius: widget.borderRadius,
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: CustomColor.primaryColor,
                width: 1,
              ),
              borderRadius: widget.borderRadius,
            ),
            suffix: widget.suffix,
            suffixIcon: widget.suffixIcon,
            prefix: widget.prefix,
            prefixIcon: widget.prefixIcon,
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}
