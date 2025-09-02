import 'package:gptbanqbusiness/utils/assets.dart';
import 'package:gptbanqbusiness/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/custom_style.dart';
import '../../utils/input_fields/custom_color.dart';

class SearchInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onSearchChanged;

  const SearchInputWidget({
    super.key,
    required this.controller,
    this.hintText = 'Search...',
    this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        suffixIcon: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: CustomImageWidget(
              imagePath: StaticAssets.searchMd,
              imageType: 'svg',
              height: 18,
            )),
        hintText: hintText,
        hintStyle: CustomStyle.loginInputTextHintStyle,

        filled: true,
        fillColor: CustomColor.transactionFromContainerColor,
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          borderSide: const BorderSide(
            color: CustomColor.dashboardProfileBorderColor,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: CustomColor.dashboardProfileBorderColor,
            width: 1,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: CustomColor.dashboardProfileBorderColor,
            width: 1,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
      ),
      onChanged: onSearchChanged,
    );
  }
}
