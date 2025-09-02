// ignore_for_file: camel_case_types, must_be_immutable

import 'package:gptbanqbusiness/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/custom_style.dart';
import '../../utils/input_fields/custom_color.dart';
import '../buttons/custom_icon_button_widget.dart';
import '../custom_image_widget.dart';

class BeneficiaryIdentificationTypeWidget extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final List<String> identificationTypes;
  final Function(String?)? onTypeSelected;

  const BeneficiaryIdentificationTypeWidget({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.identificationTypes,
    required this.onTypeSelected,
  });

  @override
  State<BeneficiaryIdentificationTypeWidget> createState() => _BeneficiaryIdentificationTypeWidgetState();
}

class _BeneficiaryIdentificationTypeWidgetState extends State<BeneficiaryIdentificationTypeWidget> {
  FocusNode myFocusNode = FocusNode();
  bool isBorderHighlighted = false;
  String searchQuery = '';

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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label for the input field
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 5),
          child: Text(
            widget.label,
            style: GoogleFonts.inter(
              color: myFocusNode.hasFocus
                  ? CustomColor.primaryColor
                  : CustomColor.inputFieldTitleTextColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        // Main TextFormField that triggers the bottom sheet
        TextFormField(
          controller: widget.controller,
          focusNode: myFocusNode,
          readOnly: true,
          onTap: () => _showIdentificationTypeSelectionSheet(context),
          maxLines: 1,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: CustomStyle.loginInputTextStyle,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(16),
            hintText: widget.hint,
            hintStyle: CustomStyle.loginInputTextHintStyle,
            filled: true,
            fillColor: myFocusNode.hasFocus
                ? CustomColor.whiteColor
                : CustomColor.primaryInputHintColor,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: isBorderHighlighted
                    ? CustomColor.primaryColor
                    : CustomColor.primaryInputHintBorderColor,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(11),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: CustomColor.primaryColor,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(11),
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SvgPicture.asset(
                StaticAssets.chevronDown,
                colorFilter: ColorFilter.mode(
                  CustomColor.black,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  void _showIdentificationTypeSelectionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: CustomColor.whiteColor,
      barrierColor: Colors.black.withOpacity(0.2),
      builder: (context) {
        return StatefulBuilder(
          builder: (buildContext, setState) {
            // Filtered identification list based on search query
            final filteredTypes = widget.identificationTypes
                .where((type) => type
                .toLowerCase()
                .contains(searchQuery.toLowerCase()))
                .toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              padding: EdgeInsets.only(
                top: 20,
                right: 16,
                left: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                children: [
                  // Header with close button and title
                  _buildSheetHeader(context),
                  const SizedBox(height: 20),
                  // Search bar
                  _buildSearchField(setState),
                  const SizedBox(height: 10),
                  // Identification types list view
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredTypes.length,
                      itemBuilder: (context, index) {
                        return _buildIdentificationTypeItem(filteredTypes[index]);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Builds the header for the bottom sheet
  Row _buildSheetHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomIconButtonWidget(
          onTap: () => Navigator.pop(context),
          svgAssetPath: StaticAssets.closeBlack,
        ),
        Text(
          'Select Identification Type',
          style: GoogleFonts.inter(
            color: CustomColor.primaryColor,
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 20),
      ],
    );
  }

  // Builds the search field within the bottom sheet
  TextField _buildSearchField(StateSetter setState) {
    return TextField(
      onChanged: (value) {
        setState(() {
          searchQuery = value;
        });
      },
      decoration: InputDecoration(
        hintText: "Search Identification Type",
        hintStyle: CustomStyle.loginInputTextHintStyle,
        filled: true,
        fillColor: CustomColor.primaryInputHintColor,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: CustomColor.primaryInputHintBorderColor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: CustomColor.primaryInputHintBorderColor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
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

  // Builds individual identification type list items
  Widget _buildIdentificationTypeItem(String type) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        widget.controller.text = type;
        setState(() {
          isBorderHighlighted = true;
        });

        // Trigger the callback if it’s provided
        if (widget.onTypeSelected != null) {
          widget.onTypeSelected!(type);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: CustomColor.primaryInputHintBorderColor,
              width: 1,
            ),
          ),
        ),
        child: Text(
          type,
          style: GoogleFonts.inter(
            color: CustomColor.black,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
