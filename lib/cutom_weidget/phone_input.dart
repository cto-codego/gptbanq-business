import 'package:gptbanqbusiness/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Models/base_model.dart';
import '../Models/country_info_model.dart';
import '../constant_string/User.dart';
import '../utils/custom_style.dart';
import '../utils/input_fields/custom_color.dart';
import '../widgets/buttons/custom_icon_button_widget.dart';
import '../widgets/custom_image_widget.dart';

class CustomPhoneInputFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final Function(String)? onChange;
  final Function()? onTap;
  final bool readOnly;
  final Function(CountryInfoModel) onCountrySelected;
  final appRepo; // Accept the appRepo as a parameter to load countries dynamically

  const CustomPhoneInputFieldWidget({
    Key? key,
    required this.controller,
    required this.label,
    required this.hint,
    this.onChange,
    this.onTap,
    this.readOnly = false,
    required this.onCountrySelected,
    required this.appRepo, // Required field for appRepo
  }) : super(key: key);

  @override
  State<CustomPhoneInputFieldWidget> createState() =>
      _CustomPhoneInputFieldWidgetState();
}

class _CustomPhoneInputFieldWidgetState
    extends State<CustomPhoneInputFieldWidget> {
  late CountryInfoModel
      _selectedCountry; // Stores the selected country information
  final FocusNode _focusNode = FocusNode(); // Focus node for TextField
  bool _showBorder = false; // Indicates if border should be shown
  bool _isCountryListLoaded =
      false; // Indicates if country list has been loaded
  List<CountryInfoModel> _countryList =
      []; // Country list to display in selector
  List<CountryInfoModel> filteredItems = []; // Filtered list based on search
  TextEditingController searchController =
      TextEditingController(); // Controller for search input

  @override
  void initState() {
    super.initState();
    _selectedCountry = CountryInfoModel(
        countryCode: "+1",
        countryName: "United States",
        image: "path_to_default_image"); // Set a default country
    _loadCountries(); // Call method to load countries from appRepo
    _focusNode.addListener(() {
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
    _focusNode.dispose(); // Dispose focusNode
    super.dispose();
  }

  void _showCountrySelector(BuildContext context) {
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
          builder: (context, StateSetter setStater) {
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
                  // Top Row with Title and Close Button
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
                            color: CustomColor.primaryInputHintBorderColor,
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
                            color: CustomColor.primaryInputHintBorderColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12)),
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: CustomColor.primaryInputHintBorderColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12)),
                      disabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: CustomColor.primaryInputHintBorderColor,
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

                  // Country list view
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredItems.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        CountryInfoModel country = filteredItems[index];
                        return InkWell(
                          onTap: () {
                            User.Phonecode = country.countryId!;
                            setState(() {
                              _selectedCountry = country;
                            });
                            widget.onCountrySelected(
                                _selectedCountry); // Callback on country select
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 20,
                            ),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color:
                                      CustomColor.primaryInputHintBorderColor,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Image.network(
                                  country.image!,
                                  height: 24,
                                  width: 32,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  country.countryName ?? '',
                                  style: GoogleFonts.inter(
                                    color: CustomColor.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  "+${country.countryCode}" ?? '',
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
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Input label
        Text(
          widget.label,
          style: CustomStyle.touchIdSubTitleTextStyle,
        ),
        const SizedBox(height: 8),

        // Input field with country code selector
        TextFormField(
          controller: widget.controller,
          readOnly: widget.readOnly,
          onTap: widget.onTap,
          keyboardType: TextInputType.number,
          onChanged: widget.onChange,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: widget.hint,
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
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: CustomColor.primaryInputHintBorderColor,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            prefixIcon: Container(
              padding: const EdgeInsets.only(left: 8),
              child: InkWell(
                onTap: () => _showCountrySelector(context),
                // Open country selector on tap
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.network(
                      _selectedCountry.image!,
                      height: 23,
                      width: 28,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null)
                          return child; // Image is loaded, return the child.
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                          ),
                        ); // Show a loading indicator while the image is loading.
                      },
                      errorBuilder: (BuildContext context, Object error,
                          StackTrace? stackTrace) {
                        return Container(
                          height: 24,
                          width: 32,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            // Background color for the placeholder.
                            borderRadius:
                                BorderRadius.circular(4), // Rounded corners.
                          ),
                          child: Icon(
                            Icons.error,
                            // You can also use any placeholder icon or image.
                            color: Colors.red, // Color of the error icon.
                            size: 16, // Size of the error icon.
                          ),
                        ); // Return an error icon or placeholder if the image fails to load.
                      },
                    ),
                    const SizedBox(width: 6),
                    Text("+${_selectedCountry.countryCode}" ?? '',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: CustomColor.black,
                        )),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20,
                    ),
                    Container(
                      width: 1.5,
                      margin: EdgeInsets.only(right: 5),
                      color: CustomColor.primaryInputHintBorderColor,
                      height: 30,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
