import 'package:gptbanqbusiness/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/custom_style.dart';
import '../../utils/input_fields/custom_color.dart'; // Import Google Fonts

class DefaultPasswordInputFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final bool readOnly;
  final Function() onChange;
  final String? Function(String?)? validator; // Allows passing custom validator
  final BorderRadius borderRadius;
  final bool autoFocus;

  const DefaultPasswordInputFieldWidget({
    super.key,
    required this.controller,
    required this.hint,
    this.readOnly = false,
    this.autoFocus = false,
    required this.onChange,
    this.validator, // Custom validator passed when creating this widget
    this.borderRadius = const BorderRadius.only(
      topLeft: Radius.circular(11),
      topRight: Radius.circular(11),
      bottomLeft: Radius.circular(11),
      bottomRight: Radius.circular(11),
    ),
  });

  @override
  State<DefaultPasswordInputFieldWidget> createState() =>
      _DefaultPasswordInputFieldWidgetState();
}

class _DefaultPasswordInputFieldWidgetState
    extends State<DefaultPasswordInputFieldWidget> {
  FocusNode myFocusNode = FocusNode();
  bool bordershoww = false;
  bool isHidden = true;

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
      obscureText: isHidden,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: widget.validator ?? _defaultPasswordValidator,
      // Use passed validator if available
      onChanged: (v) {
        setState(() {
          bordershoww = v.isNotEmpty;
        });
        widget.onChange();
      },
      readOnly: widget.readOnly,
      style: CustomStyle.loginInputTextStyle,
      autofocus: widget.autoFocus,
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
        suffixIcon: IconButton(
          icon: SvgPicture.asset(
            isHidden ? StaticAssets.eyeOff : StaticAssets.eyeOn,
            colorFilter: ColorFilter.mode(
              CustomColor.black,
              BlendMode.srcIn,
            ),
            width: 20, // Adjust the width as needed
            height: 20, // Adjust the height as needed
          ),
          onPressed: () {
            setState(() {
              isHidden = !isHidden;
            });
          },
        ),
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

  String? _defaultPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least 1 uppercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least 1 digit';
    }
    if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
      return 'Password must contain at least 1 special character';
    }
    return null;
  }
}
