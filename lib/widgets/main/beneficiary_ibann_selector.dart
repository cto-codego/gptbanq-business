// ignore_for_file: camel_case_types, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Models/beneficiary/swift_add_beneficiary_model.dart';
import '../../utils/assets.dart';
import '../../utils/custom_style.dart';
import '../../utils/input_fields/custom_color.dart';
import '../buttons/custom_icon_button_widget.dart';
import '../custom_image_widget.dart';

class BeneficiaryIbanSelector extends StatefulWidget {
  final TextEditingController ibanController;
  final String label;
  final String hint;
  final List<Iban> ibans;

  const BeneficiaryIbanSelector({
    Key? key,
    required this.ibanController,
    required this.label,
    required this.hint,
    required this.ibans,
  }) : super(key: key);

  @override
  State<BeneficiaryIbanSelector> createState() => _BeneficiaryIbanSelectorState();
}

class _BeneficiaryIbanSelectorState extends State<BeneficiaryIbanSelector> {
  FocusNode _focusNode = FocusNode();
  bool _showBorder = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(),
        _buildTextFormField(context),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildLabel() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 5),
      child: Text(
        widget.label,
        style: GoogleFonts.inter(
          color: _focusNode.hasFocus
              ? CustomColor.primaryColor
              : CustomColor.inputFieldTitleTextColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTextFormField(BuildContext context) {
    return TextFormField(
      controller: widget.ibanController,

      focusNode: _focusNode,
      readOnly: true,
      onTap: () => _showIbanSelection(context),
      maxLines: 1,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: CustomStyle.loginInputTextStyle,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(16),
        hintText: widget.hint,
        hintStyle: CustomStyle.loginInputTextHintStyle,
        filled: true,
        fillColor: _focusNode.hasFocus
            ? CustomColor.whiteColor
            : CustomColor.primaryInputHintColor,
        enabledBorder: _buildBorder(_showBorder
            ? CustomColor.primaryColor
            : CustomColor.primaryInputHintBorderColor),
        focusedBorder: _buildBorder(CustomColor.primaryColor),
        suffixIcon: _buildSuffixIcon(),
      ),
    );
  }

  OutlineInputBorder _buildBorder(Color borderColor) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: borderColor, width: 1),
      borderRadius: BorderRadius.circular(11),
    );
  }

  Widget _buildSuffixIcon() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SvgPicture.asset(
        StaticAssets.chevronDown,
        colorFilter: ColorFilter.mode(CustomColor.black, BlendMode.srcIn),
      ),
    );
  }

  void _showIbanSelection(BuildContext context) {

    showModalBottomSheet(
      context: context,
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: CustomColor.whiteColor,
      barrierColor: Colors.black.withOpacity(0.2),
      useRootNavigator: true,
      builder: (context) {
        return _IbanSelectionModal(
          ibans: widget.ibans,
          onSelectIban: (iban) {
            setState(() {
              widget.ibanController.text = iban.name ?? '';
              _showBorder = true;
            });
            Navigator.pop(context);
          },
        );
      },
    );
  }
}

class _IbanSelectionModal extends StatefulWidget {
  final List<Iban> ibans;
  final ValueChanged<Iban> onSelectIban;

  const _IbanSelectionModal({
    Key? key,
    required this.ibans,
    required this.onSelectIban,
  }) : super(key: key);

  @override
  State<_IbanSelectionModal> createState() => _IbanSelectionModalState();
}

class _IbanSelectionModalState extends State<_IbanSelectionModal> {
  late List<Iban> filteredIbans;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredIbans = widget.ibans; // Initially show all IBANs
    searchController.addListener(_filterIbans);
  }

  @override
  void dispose() {
    searchController.removeListener(_filterIbans);
    searchController.dispose();
    super.dispose();
  }

  void _filterIbans() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredIbans = widget.ibans
          .where((iban) => iban.name?.toLowerCase().contains(query) ?? false)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: EdgeInsets.only(
        top: 20,
        right: 16,
        left: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _buildHeader(context),
          const SizedBox(height: 20),
          _buildSearchField(),
          const SizedBox(height: 20),
          Expanded(child: _buildIbanList()),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomIconButtonWidget(
          onTap: () => Navigator.pop(context),
          svgAssetPath: StaticAssets.closeBlack,
        ),
        Text(
          'Select IBAN',
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

  Widget _buildSearchField() {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        hintText: "Search IBAN",
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

  Widget _buildIbanList() {
    return ListView.builder(
      itemCount: filteredIbans.length,
      itemBuilder: (context, index) {
        final iban = filteredIbans[index];
        return InkWell(
          onTap: () => widget.onSelectIban(iban),
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
            child: Row(
              children: [
                const SizedBox(width: 10),
                Text(
                  iban.name ?? '',
                  style: GoogleFonts.inter(
                    color: CustomColor.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
