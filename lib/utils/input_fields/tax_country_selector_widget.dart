// ignore_for_file: camel_case_types, must_be_immutable

import 'package:gptbanqbusiness/constant_string/User.dart';
import 'package:gptbanqbusiness/utils/assets.dart';
import 'package:gptbanqbusiness/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Models/base_model.dart';
import '../../Models/country_info_model.dart';
import '../../widgets/buttons/custom_icon_button_widget.dart';
import '../../widgets/custom_image_widget.dart';
import '../custom_style.dart';
import 'custom_color.dart';

class TextCountrySelectorWidget extends StatefulWidget {
  final TextEditingController controller;
  final String label, hint, selectString;
  bool? nationality = true;
  final String? variable;
  final List listitems;
  final Function(String)? onChange;
  final bool readOnly;
  final Function(CountryInfoModel) onCountrySelected;
  final appRepo; // Accept the appRepo as a parameter to load countries dynamically

  TextCountrySelectorWidget({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.listitems,
    required this.selectString,
    this.nationality,
    this.variable,
    this.readOnly = false,
    required this.onCountrySelected,
    required this.appRepo,
    this.onChange, // Required field for appRepo
  });

  @override
  State<TextCountrySelectorWidget> createState() =>
      _TextCountrySelectorWidgetState();
}

class _TextCountrySelectorWidgetState extends State<TextCountrySelectorWidget> {
  late CountryInfoModel
      _selectedCountry; // Stores the selected country information
  FocusNode myFocusNode = FocusNode();
  bool bordershoww = false;
  bool _isCountryListLoaded =
      false; // Indicates if country list has been loaded
  TextEditingController searchController = TextEditingController();
  List<CountryInfoModel> _countryList =
      []; // Country list to display in selector
  List<CountryInfoModel> filteredItems = []; // Filtered list based on search

  @override
  void initState() {
    super.initState();
    _selectedCountry = CountryInfoModel(
        countryCode: "+1",
        countryName: "United States",
        image: "path_to_default_image"); // Set a default country
    _loadCountries(); // Call method to load countries from appRepo
    myFocusNode.addListener(() {
      setState(() {});
    });
  }

  // Function to load the country list using appRepo
  Future<void> _loadCountries() async {
    await widget.appRepo.GetCountries(); // Use appRepo to load the countries
    setState(() {
      _countryList =
          BaseModel.availableCountriesList; // Fetch country list from BaseModel
      filteredItems = _countryList; // Initialize filtered items
      _isCountryListLoaded = true; // Set flag to true once list is loaded
      if (_countryList.isNotEmpty) {
        _selectedCountry =
            _countryList.first; // Select the first country by default
        widget.onCountrySelected(
            _selectedCountry); // Call the callback function with selected country
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose(); // Dispose searchController
    myFocusNode.dispose(); // Dispose focusNode
    super.dispose();
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
              color: myFocusNode.hasFocus
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
          readOnly: true,
          onTap: () {
            showModalBottomSheet(
              context: context,
              isDismissible: true,
              enableDrag: true,
              isScrollControlled: true,
              backgroundColor: CustomColor.whiteColor,
              barrierColor: Colors.black.withOpacity(0.2),
              useRootNavigator: true,
              builder: (context) {
                return StatefulBuilder(
                  builder: (buildContext, StateSetter setStater) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.9,
                      padding: EdgeInsets.only(
                        top: 20,
                        right: 16,
                        left: 16,
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomIconButtonWidget(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                svgAssetPath: StaticAssets.xClose,
                              ),
                              Text(
                                'Select Country',
                                style: GoogleFonts.inter(
                                  color: CustomColor.primaryColor,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Search bar
                          TextField(
                            controller: searchController,
                            onChanged: (value) {
                              setStater(() {
                                filteredItems = value.isEmpty
                                    ? _countryList // Show full list if search is empty
                                    : _countryList
                                        .where((item) => item.countryName!
                                            .toLowerCase()
                                            .contains(value.toLowerCase()))
                                        .toList();
                              });
                            },
                            decoration: InputDecoration(
                              hintText: "Search Country",
                              hintStyle: CustomStyle.loginInputTextHintStyle,
                              filled: true,
                              fillColor: CustomColor.primaryInputHintColor,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        CustomColor.primaryInputHintBorderColor,
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
                                  borderSide: const BorderSide(
                                    color:
                                        CustomColor.primaryInputHintBorderColor,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(12)),
                              border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color:
                                        CustomColor.primaryInputHintBorderColor,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(12)),
                              disabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color:
                                        CustomColor.primaryInputHintBorderColor,
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
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: ListView.builder(
                              itemCount: filteredItems.length,
                              itemBuilder: (BuildContext context, int index) {
                                CountryInfoModel country = filteredItems[index];
                                return InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    widget.controller.text =
                                        country.countryName!;
                                    widget.nationality == true
                                        ? User.TaxCountry = country.countryId
                                        : User.TaxCountry = country.countryId;
                                    User.TaxCountry = country.countryId;
                                    setState(() {
                                      bordershoww = true;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 20,
                                    ),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: CustomColor
                                              .primaryInputHintBorderColor,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8),
                                          child: Image.network(
                                            filteredItems[index].image!,
                                            height: 24,
                                            width: 36,
                                          ),
                                        ),
                                        Text(
                                          filteredItems[index].countryName!,
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
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
          maxLines: 2,
          minLines: 1,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            return Validator.validateValues(
              value: value,
            );
          },
          onChanged: (v) {
            setState(() {
              v.isNotEmpty ? bordershoww = true : bordershoww = false;
            });
          },
          style: CustomStyle.loginInputTextStyle,
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
              borderSide: BorderSide(
                color: bordershoww
                    ? CustomColor.primaryColor
                    : CustomColor.primaryInputHintBorderColor,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(11),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: CustomColor.errorColor,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(11),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: CustomColor.errorColor,
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
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: CustomColor.primaryColor,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(11),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: CustomColor.primaryColor,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(11),
            ),
            enabled: true,
            suffixIcon: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SvgPicture.asset(
                StaticAssets.chevronDown,
                colorFilter: const ColorFilter.mode(
                  CustomColor.black,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
