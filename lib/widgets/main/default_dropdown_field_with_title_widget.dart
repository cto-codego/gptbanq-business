import 'package:gptbanqbusiness/utils/validator.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/custom_style.dart';
import '../../utils/input_fields/custom_color.dart';

class DefaultDropDownFieldWithTitleWidget extends StatefulWidget {
  final SingleValueDropDownController controller;
  final String title;
  final String hint;
  final Function(DropDownValueModel?)? onChanged;
  final List<DropDownValueModel> dropDownList;
  final int dropDownItemCount;
  final bool showBorder;
  final BorderRadius borderRadius;

  const DefaultDropDownFieldWithTitleWidget({
    super.key,
    required this.controller,
    required this.title,
    required this.hint,
    required this.dropDownList,
    required this.dropDownItemCount,
    this.onChanged,
    this.showBorder = false,
    this.borderRadius = const BorderRadius.all(Radius.circular(11)),
  });

  @override
  State<DefaultDropDownFieldWithTitleWidget> createState() =>
      _DefaultDropDownFieldWithTitleWidgetState();
}

class _DefaultDropDownFieldWithTitleWidgetState
    extends State<DefaultDropDownFieldWithTitleWidget> {
  ValueNotifier<Color> titleColorNotifier =
      ValueNotifier<Color>(CustomColor.inputFieldTitleTextColor);

  @override
  void initState() {
    super.initState();
    // Listen to changes in the controller to update the title color
    widget.controller.addListener(() {
      setState(() {
        // Change border visibility and title color based on the selected value
        widget.controller.dropDownValue != null
            ? titleColorNotifier.value = CustomColor.primaryColor
            : titleColorNotifier.value = CustomColor.inputFieldTitleTextColor;
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
        DropDownTextField(
          controller: widget.controller,
          readOnly: true,
          // Set readOnly to true to make it a dropdown-only field
          clearOption: false,
          // Disable clear option to prevent clearing selected value
          validator: (value) {
            return Validator.validateValues(value: value);
          },
          dropDownIconProperty: IconProperty(
            icon: Icons.keyboard_arrow_down_outlined,
            color: CustomColor.black,
          ),
          textFieldDecoration: InputDecoration(
            contentPadding: const EdgeInsets.all(16),
            hintText: widget.hint,
            hintStyle: CustomStyle.loginInputTextHintStyle,
            filled: true,
            fillColor: CustomColor.whiteColor,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: widget.showBorder
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
          textStyle: CustomStyle.loginInputTextStyle,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          dropDownList: widget.dropDownList,
          dropDownItemCount: widget.dropDownItemCount,
          onChanged: (val) {
            if (widget.onChanged != null) {
              widget.onChanged!(val);
            }
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
