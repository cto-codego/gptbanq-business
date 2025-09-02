import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/custom_style.dart';
import '../utils/input_fields/custom_color.dart';

class Inputuploadimage extends StatefulWidget {
  final TextEditingController controller;
  final String label, hint;

  bool? isconirmpassword = false;

  String? password = '';

  bool isEmail, ispassword;

  bool? ishide = false;

  final ontap;

  Inputuploadimage(
      {super.key,
      required this.controller,
      required this.label,
      required this.hint,
      required this.isEmail,
      required this.ispassword,
      this.isconirmpassword,
      this.ontap,
      this.ishide,
      this.password});

  @override
  State<Inputuploadimage> createState() => _InputuploadimageState();
}

class _InputuploadimageState extends State<Inputuploadimage> {
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 5),
          child: Text(
            widget.label,
            style: GoogleFonts.inter(
              color: myFocusNode.hasFocus || bordershoww
                  ? CustomColor.primaryColor
                  : CustomColor.inputFieldTitleTextColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        TextFormField(
          controller: widget.controller,
          focusNode: myFocusNode,
          obscureText: widget.ishide ?? false,
          readOnly: true,
          onTap: () {
            widget.ontap();
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: (v) {
            setState(() {
              v == '' ? bordershoww = false : bordershoww = true;
            });
          },
          style: CustomStyle.loginInputTextStyle,
          decoration: InputDecoration(
            filled: true,
            fillColor: myFocusNode.hasFocus
                ? CustomColor.whiteColor
                : CustomColor.primaryInputHintColor,
            contentPadding: const EdgeInsets.all(16),
            hintText: widget.hint,
            hintStyle: CustomStyle.loginInputTextHintStyle,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: bordershoww
                      ? CustomColor.primaryColor
                      : CustomColor.primaryInputHintBorderColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(11)),
            errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: CustomColor.errorColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(11)),
            errorMaxLines: 2,
            focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: CustomColor.errorColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(11)),
            errorStyle: TextStyle(color: CustomColor.errorColor),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColor.primaryColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(11)),
            border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColor.primaryColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(11)),
            disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColor.primaryColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(11)),
            enabled: true,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
