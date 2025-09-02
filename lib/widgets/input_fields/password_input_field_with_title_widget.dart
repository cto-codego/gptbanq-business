import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/assets.dart'; // Import assets for SVG images
import '../../utils/custom_style.dart';
import '../../utils/input_fields/custom_color.dart'; // Custom color definitions

class PasswordInputFieldWithTitleWidget extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final String title; // Title text for the input field
  final bool readOnly;
  final Function() onChange;
  final String? Function(String?)? validator; // Allows passing custom validator
  final BorderRadius borderRadius;
  final bool autoFocus;

  const PasswordInputFieldWithTitleWidget({
    super.key,
    required this.controller,
    required this.hint,
    required this.title, // New title parameter for the widget
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
  State<PasswordInputFieldWithTitleWidget> createState() =>
      _PasswordInputFieldWithTitleWidgetState();
}

class _PasswordInputFieldWithTitleWidgetState
    extends State<PasswordInputFieldWithTitleWidget> {
  FocusNode myFocusNode = FocusNode();
  bool bordershoww = false;
  bool isHidden = true;
  ValueNotifier<Color> titleColorNotifier =
      ValueNotifier<Color>(CustomColor.inputFieldTitleTextColor);

  @override
  void initState() {
    super.initState();
    // Listen to focus changes and update title color
    myFocusNode.addListener(() {
      setState(() {
        titleColorNotifier.value = myFocusNode.hasFocus
            ? CustomColor.primaryColor
            : CustomColor.inputFieldTitleTextColor;
      });
    });
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
            contentPadding: const EdgeInsets.all(16),
            hintText: widget.hint,

            hintStyle: CustomStyle.loginInputTextHintStyle,
            filled: true,
            errorStyle: TextStyle(color: CustomColor.errorColor),
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
        ),
      ],
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
