import 'package:gptbanqbusiness/utils/validator.dart';
import 'package:flutter/material.dart';

import '../../utils/custom_style.dart';
import '../../utils/input_fields/custom_color.dart';

class DefaultInputFieldWidget extends StatefulWidget {
  final TextEditingController controller;
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

  const DefaultInputFieldWidget({
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
    this.borderRadius = const BorderRadius.only(
      // Default border radius
      topLeft: Radius.circular(11),
      topRight: Radius.circular(11),
      bottomLeft: Radius.circular(11),
      bottomRight: Radius.circular(11),
    ),
    this.keyboardType,
  });

  @override
  State<DefaultInputFieldWidget> createState() =>
      _DefaultInputFieldWidgetState();
}

class _DefaultInputFieldWidgetState extends State<DefaultInputFieldWidget> {
  FocusNode myFocusNode = FocusNode();
  bool bordershoww = false;

  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: myFocusNode,
      keyboardType: widget.keyboardType,
      obscureText: widget.isHide ?? false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
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
          widget.onChanged!();
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
        errorStyle: TextStyle(
            color: CustomColor.errorColor
        ),
        contentPadding: const EdgeInsets.all(16),
        hintText: widget.hint,
        hintStyle: CustomStyle.loginInputTextHintStyle,
        filled: true,
        fillColor: myFocusNode.hasFocus
            ? CustomColor.whiteColor
            : CustomColor.primaryInputHintColor,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: bordershoww
                ? CustomColor.primaryColor
                : CustomColor.primaryInputHintBorderColor,
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
          borderSide:  BorderSide(
            color: CustomColor.primaryColor,
            width: 1,
          ),
          borderRadius: widget.borderRadius,
        ),
        border: OutlineInputBorder(
          borderSide:  BorderSide(
            color: CustomColor.primaryColor,
            width: 1,
          ),
          borderRadius: widget.borderRadius,
        ),
        disabledBorder: OutlineInputBorder(
          borderSide:  BorderSide(
            color: CustomColor.primaryColor,
            width: 1,
          ),
          borderRadius: widget.borderRadius,
        ),
      ),
    );
  }
}
