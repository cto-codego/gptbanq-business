import 'package:gptbanqbusiness/utils/assets.dart';
import 'package:gptbanqbusiness/utils/input_fields/custom_color.dart';
import 'package:gptbanqbusiness/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';

import '../../utils/custom_style.dart';

class CryptoSearchInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const CryptoSearchInputWidget({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  State<CryptoSearchInputWidget> createState() =>
      _CryptoSearchInputWidgetState();
}

class _CryptoSearchInputWidgetState extends State<CryptoSearchInputWidget> {
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
    return TextField(
      controller: widget.controller,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        errorStyle: TextStyle(color: CustomColor.errorColor),
        contentPadding: const EdgeInsets.all(16),
        hintText: "Search",
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
            borderRadius: BorderRadius.circular(12)),
        errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: CustomColor.errorColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12)),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: CustomColor.errorColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
            borderSide:  BorderSide(
              color: CustomColor.primaryColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12)),
        border: OutlineInputBorder(
            borderSide:  BorderSide(
              color: CustomColor.primaryColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12)),
        disabledBorder: OutlineInputBorder(
            borderSide:  BorderSide(
              color: CustomColor.primaryColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12)),
        suffixIcon: Padding(
          padding: const EdgeInsets.all(14.0),
          child: CustomImageWidget(
            imagePath: StaticAssets.searchMd,
            imageType: 'svg',
            height: 18,
          ),
        ),
      ),
    );
  }
}
