import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/custom_style.dart';
import '../../utils/input_fields/custom_color.dart';

class DynamicInputFieldWithTitleWidget extends StatefulWidget {
  final TextEditingController controller;
  final String title;
  final String hint;
  // final String value;
  final bool isRequired; // Flag to indicate if input is required
  final TextInputType? keyboardType;
  final Function? onChanged;
  final String? pattern; // Pattern for validation
  final Function? onTap;
  final bool? readOnly;
  final BorderRadius borderRadius;
  final bool autofocus;
  final Widget? suffix;
  final Widget? suffixIcon;
  final Widget? prefix;
  final Widget? prefixIcon;

  const DynamicInputFieldWithTitleWidget({
    super.key,
    required this.controller,
    required this.hint,
    required this.title,
    // required this.value,
    this.isRequired = false, // Default is optional
    this.pattern,
    this.onChanged,
    this.onTap,
    this.readOnly,
    this.autofocus = false,
    this.borderRadius = const BorderRadius.only(
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
  });

  @override
  State<DynamicInputFieldWithTitleWidget> createState() =>
      _DynamicInputFieldWithTitleWidgetState();
}

class _DynamicInputFieldWithTitleWidgetState extends State<DynamicInputFieldWithTitleWidget> {
  FocusNode myFocusNode = FocusNode();
  ValueNotifier<Color> titleColorNotifier = ValueNotifier<Color>(CustomColor.inputFieldTitleTextColor);

  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(() {
      setState(() {
        titleColorNotifier.value = myFocusNode.hasFocus ? CustomColor.primaryColor : CustomColor.inputFieldTitleTextColor;
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
          // initialValue: widget.value,
          focusNode: myFocusNode,
          keyboardType: widget.keyboardType,
          validator: (value) {
            if (widget.isRequired && (value == null || value.isEmpty)) {
              return 'This field is required';
            }
            if (widget.pattern != null && value != null && !RegExp(widget.pattern!).hasMatch(value)) {
              return 'Invalid format';
            }
            return null;
          },
          onChanged: (v) {
            if (widget.onChanged != null) {
              widget.onChanged!();
            }
          },

          onTap: widget.onTap == null ? null : widget.onTap!(),
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
              borderSide: BorderSide(color: CustomColor.primaryColor, width: 1),
              borderRadius: widget.borderRadius,
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: CustomColor.errorColor, width: 1),
              borderRadius: widget.borderRadius,
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: CustomColor.errorColor, width: 1),
              borderRadius: widget.borderRadius,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: CustomColor.primaryColor, width: 1),
              borderRadius: widget.borderRadius,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: CustomColor.primaryColor, width: 1),
              borderRadius: widget.borderRadius,
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: CustomColor.primaryColor, width: 1),
              borderRadius: widget.borderRadius,
            ),
            suffix: widget.suffix,
            suffixIcon: widget.suffixIcon,
            prefix: widget.prefix,
            prefixIcon: widget.prefixIcon,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
