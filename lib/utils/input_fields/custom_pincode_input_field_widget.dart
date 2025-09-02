import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../custom_style.dart';
import 'custom_color.dart';

class CustomPinCodeInputFieldWidget extends StatelessWidget {
  final BuildContext appContext;
  final TextEditingController controller;
  final Function(String) onCompleted;
  final String? Function(String?)? validator;
  final bool autoFocus;

  const CustomPinCodeInputFieldWidget({
    super.key,
    required this.appContext,
    required this.controller,
    required this.onCompleted,
    this.validator,
    this.autoFocus = true,
  });

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: appContext,
      pastedTextStyle: CustomStyle.loginVerifyCodeTextStyle,
      length: 4,
      obscureText: false,
      textStyle: CustomStyle.loginVerifyCodeTextStyle,
      blinkWhenObscuring: true,
      backgroundColor: Colors.transparent,
      animationType: AnimationType.fade,
      autoUnfocus: true,
      autoFocus: autoFocus,
      validator: validator,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        disabledColor: Colors.transparent,
        activeColor: CustomColor.primaryInputHintBorderColor,
        selectedColor: CustomColor.primaryInputHintBorderColor,
        inactiveColor: CustomColor.primaryInputHintColor,
        inactiveFillColor: CustomColor.primaryInputHintColor,
        selectedFillColor: CustomColor.primaryInputHintColor,
        fieldOuterPadding: const EdgeInsets.symmetric(horizontal: 4),
        borderWidth: 1,
        borderRadius: BorderRadius.circular(11),
        fieldHeight: 60,
        fieldWidth: 60,
        activeFillColor:CustomColor.primaryInputHintColor,
      ),
      cursorColor: Colors.white,
      animationDuration: const Duration(milliseconds: 300),
      enableActiveFill: true,
      controller: controller,
      keyboardType: TextInputType.number,
      mainAxisAlignment: MainAxisAlignment.center,
      onCompleted: onCompleted,
      onChanged: (value) {},
      enablePinAutofill: false,
      errorTextMargin: const EdgeInsets.only(top: 10),
    );
  }
}
