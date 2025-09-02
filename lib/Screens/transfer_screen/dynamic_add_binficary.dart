import 'package:gptbanqbusiness/Models/beneficiary/swift_add_beneficiary_model.dart';
import 'package:gptbanqbusiness/Screens/transfer_screen/bloc/transfer_bloc.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:gptbanqbusiness/cutom_weidget/text_uploadimages.dart';
import 'package:gptbanqbusiness/utils/assets.dart';
import 'package:gptbanqbusiness/utils/input_fields/custom_color.dart';
import 'package:gptbanqbusiness/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../Models/beneficiary/dynamic_beneficiary_field_model.dart'
    as dynamic_beneficiary;

import '../../widgets/buttons/default_back_button_widget.dart';
import '../../widgets/buttons/primary_button_widget.dart';
import '../../widgets/input_fields/dynamic_input_field_with_title_widget.dart';
import '../../widgets/main/beneficiary_Identification_type_widget.dart';
import '../../widgets/main/beneficiary_counntry_selector.dart';
import '../../widgets/main/beneficiary_currency_selector_widget.dart';
import '../../widgets/toast/toast_util.dart';

class DynamicAddBeneficiaryScreen extends StatefulWidget {
  const DynamicAddBeneficiaryScreen({super.key});

  @override
  State<DynamicAddBeneficiaryScreen> createState() =>
      _DynamicAddBeneficiaryScreenState();
}

class _DynamicAddBeneficiaryScreenState
    extends State<DynamicAddBeneficiaryScreen> {
  final _formkey = GlobalKey<FormState>();

  bool indvidual = true;

  final TextEditingController _ibnan = TextEditingController();
  final TextEditingController _swift = TextEditingController();

  final TextEditingController _firstname = TextEditingController();

  final TextEditingController _lastname = TextEditingController();
  final TextEditingController _email = TextEditingController(text: '');

  final TextEditingController _image = TextEditingController(text: '');
  final TextEditingController _companyname = TextEditingController(text: '');
  final TextEditingController _ibanController = TextEditingController();
  final TextEditingController _currencyController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController beneficiaryIdentificationTypeController =
      TextEditingController();
  final TextEditingController beneficiaryIdentificationTypeValueController =
      TextEditingController();

  final TextEditingController _recipientCountryController =
      TextEditingController();

  XFile? image;

  final ImagePicker picker = ImagePicker();
  TransferBloc _transferBloc = TransferBloc();

  List<Country> _countryList = [];
  List<Curreny> currencies = [];
  List<Iban> iBans = [];
  List<String> beneficiaryIdentificationTypeList = [];
  String? selectedFlag; // Variable to store the selected flag

  // List of dynamic options
  List<dynamic_beneficiary.RecipientBankOption> options = [];

  bool recipientDetailsOptions = false;
  bool isClearInput = false;

  String? selectedOption;
  String? userCountryCode;
  String? recipientCountryCode;

  Map<String, TextEditingController> controllers = {};

  @override
  void initState() {
    _transferBloc.add(GetSwiftCountryListEvent());
    super.initState();
  }

  @override
  void dispose() {
    controllers.forEach((key, controller) {
      controller.dispose();
    });
    _currencyController.dispose();
    _ibanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _transferBloc,
      listener: (context, TransferState state) {
        if (state.statusModel?.status == 1) {
          Navigator.pushNamedAndRemoveUntil(
              context, 'beneficiaryListScreen', (route) => false);
        } else if (state.statusModel?.status == 0) {
          CustomToast.showError(context, "Sorry!", state.statusModel!.message!);
        }

        if (state.swiftAddBeneficiaryModel?.status == 1) {
          currencies = state.swiftAddBeneficiaryModel?.curreny ?? [];
          _countryList = state.swiftAddBeneficiaryModel?.country ?? [];
        }

        if (state.dynamicBeneficiaryFieldModel?.status == 1) {
          if (state
              .dynamicBeneficiaryFieldModel!.recipientBankOptions!.isNotEmpty) {
            recipientDetailsOptions = true;
            print(recipientDetailsOptions);
            options = state.dynamicBeneficiaryFieldModel!.recipientBankOptions!;
            selectedOption = options[0].type!;
          } else {
            recipientDetailsOptions = false;
          }
          isClearInput = false;
          beneficiaryIdentificationTypeList = state
                  .dynamicBeneficiaryFieldModel!
                  .beneficiaryIdentificationType! ??
              [];
        }
        if (state.dynamicBeneficiaryFieldModel?.status == 0) {
          isClearInput = false;
          CustomToast.showError(
              context, "Sorry!", state.dynamicBeneficiaryFieldModel!.message!);
        }

        if (state.dynamicAddBeneficiaryModel?.status == 0) {
          CustomToast.showError(
              context, "Sorry!", state.dynamicAddBeneficiaryModel!.message!);
        }
        if (state.dynamicAddBeneficiaryModel?.status == 1) {
          CustomToast.showSuccess(
              context, "Hey!", state.dynamicAddBeneficiaryModel!.message!);
          Navigator.pushNamedAndRemoveUntil(
              context, 'beneficiaryListScreen', (route) => false);
        }
      },
      child: BlocBuilder(
        bloc: _transferBloc,
        builder: (context, TransferState state) {
          return Scaffold(
            backgroundColor: CustomColor.scaffoldBg,
            body: SafeArea(
              child: ProgressHUD(
                inAsyncCall: state.isloading,
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DefaultBackButtonWidget(onTap: () {
                              Navigator.pushNamedAndRemoveUntil(context,
                                  'beneficiaryListScreen', (route) => false);
                            }),
                            Text(
                              'Add Beneficiary',
                              style: GoogleFonts.inter(
                                  color: CustomColor.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                            Container(
                              width: 20,
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 50,
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: CustomColor.selectContainerColor,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    indvidual = true;
                                  });
                                  if (userCountryCode!.isNotEmpty &&
                                      _currencyController.text.isNotEmpty) {
                                    isClearInput = true;
                                    _transferBloc.add(
                                        GetDynamicBeneficiaryFieldListEvent(
                                            country: userCountryCode!,
                                            currency: _currencyController.text,
                                            accountType: indvidual
                                                ? 'Personal'
                                                : 'Business'));
                                  }
                                },
                                child: Container(
                                  height: 42,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: indvidual
                                        ? CustomColor.whiteColor
                                        : CustomColor.selectContainerColor,
                                  ),
                                  child: Text(
                                    'Individual',
                                    style: GoogleFonts.inter(
                                        color: indvidual
                                            ? CustomColor.black
                                            : CustomColor.black
                                                .withOpacity(0.6),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    indvidual = false;
                                  });
                                  if (userCountryCode!.isNotEmpty &&
                                      _currencyController.text.isNotEmpty) {
                                    isClearInput = true;
                                    _transferBloc.add(
                                        GetDynamicBeneficiaryFieldListEvent(
                                            country: userCountryCode!,
                                            currency: _currencyController.text,
                                            accountType: indvidual
                                                ? 'Personal'
                                                : 'Business'));
                                  }
                                },
                                child: Container(
                                  height: 42,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: indvidual
                                        ? CustomColor.selectContainerColor
                                        : CustomColor.whiteColor,
                                  ),
                                  child: Text(
                                    'Business',
                                    style: GoogleFonts.inter(
                                        color: indvidual
                                            ? CustomColor.black.withOpacity(0.6)
                                            : CustomColor.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                          child: Form(
                              key: _formkey,
                              child: ListView(
                                shrinkWrap: true,
                                children: [
                                  BeneficiaryCountrySelector(
                                      controller: _countryController,
                                      label:
                                          'Country / region of recipient\'s account',
                                      hint: 'Select Country',
                                      countries: _countryList,
                                      onCurrencySelected: (value) {
                                        setState(() {
                                          userCountryCode = value;
                                          _currencyController
                                              .clear(); // Clear the currency controller
                                          isClearInput = true;
                                        });
                                      }),
                                  BeneficiaryCurrencySelectorWidget(
                                      controller: _currencyController,
                                      label: 'Currency',
                                      hint: 'Select Currency',
                                      currencies: currencies,
                                      onCurrencySelected: (value) {
                                        setState(() {
                                          isClearInput = true;
                                          recipientDetailsOptions = false;
                                        });

                                        _transferBloc.add(
                                            GetDynamicBeneficiaryFieldListEvent(
                                          country: userCountryCode!,
                                          currency: _currencyController.text,
                                          accountType: indvidual
                                              ? "Personal"
                                              : "Business",
                                        ));
                                      }),
                                  if (isClearInput == false)
                                    if (state.dynamicBeneficiaryFieldModel!
                                            .field!.isNotEmpty ||
                                        state.dynamicBeneficiaryFieldModel!
                                            .recipientBankOptions!.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Recipient Details",
                                              style: GoogleFonts.inter(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: CustomColor.black),
                                            ),
                                            if (recipientDetailsOptions == true)
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () {
                                                    showModalBottomSheet(
                                                      context: context,
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          CustomColor
                                                              .whiteColor,
                                                      barrierColor: Colors.black
                                                          .withOpacity(0.2),
                                                      builder: (BuildContext
                                                          context) {
                                                        return Container(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.5,
                                                          padding:
                                                              EdgeInsets.only(
                                                            top: 20,
                                                            right: 16,
                                                            left: 16,
                                                            bottom:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .viewInsets
                                                                    .bottom,
                                                          ),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  InkWell(
                                                                    onTap: () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child:
                                                                        CustomImageWidget(
                                                                      imagePath:
                                                                          StaticAssets
                                                                              .xClose,
                                                                      imageType:
                                                                          'svg',
                                                                      height:
                                                                          24,
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    // Wrap the Text with Expanded
                                                                    child: Text(
                                                                      "Choose which bank details to use",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      // Center align the text
                                                                      style: GoogleFonts
                                                                          .inter(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 24,
                                                                  )
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                  height: 20),
                                                              Expanded(
                                                                child: ListView(
                                                                  children:
                                                                      options.map(
                                                                          (option) {
                                                                    bool
                                                                        isSelected =
                                                                        selectedOption ==
                                                                            option.type; // Check if the option is selected

                                                                    return GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          selectedOption =
                                                                              option.type;
                                                                        });
                                                                        Navigator.pop(
                                                                            context); // Close the modal sheet after selection
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        margin: EdgeInsets.only(
                                                                            bottom:
                                                                                10),
                                                                        padding: EdgeInsets.symmetric(
                                                                            vertical:
                                                                                16,
                                                                            horizontal:
                                                                                16),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              CustomColor.hubContainerBgColor,
                                                                          // Highlight selected option
                                                                          borderRadius:
                                                                              BorderRadius.circular(8),
                                                                        ),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Icon(
                                                                              Icons.check_circle,
                                                                              color: isSelected ? CustomColor.primaryColor : CustomColor.primaryColor.withOpacity(0.4), // Show check icon for selected
                                                                            ),
                                                                            SizedBox(width: 8),
                                                                            Text(
                                                                              option.type!,
                                                                              style: TextStyle(
                                                                                color: CustomColor.primaryColor,
                                                                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, // Make text bold when selected
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }).toList(),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        selectedOption!,
                                                        style:
                                                            GoogleFonts.inter(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color:
                                                                    CustomColor
                                                                        .black),
                                                      ),
                                                      Icon(
                                                        Icons
                                                            .keyboard_arrow_down_rounded,
                                                        color:
                                                            CustomColor.black,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                  if (isClearInput == false)
                                    if (recipientDetailsOptions == true)
                                      if (options.isNotEmpty)
                                        Column(
                                          children: List.generate(
                                              options
                                                  .firstWhere((option) =>
                                                      option.type ==
                                                      selectedOption)
                                                  .field!
                                                  .length, (index) {
                                            dynamic_beneficiary.Field field =
                                                options
                                                    .firstWhere((option) =>
                                                        option.type ==
                                                        selectedOption)
                                                    .field![index];

                                            // Create a controller
                                            TextEditingController? controller =
                                                controllers[field.name];
                                            // Initialize the controller with a default value if applicable
                                            if (controller == null) {
                                              // Initialize the controller with a default value if applicable
                                              controller =
                                                  TextEditingController(
                                                text: field.value ?? "",
                                              );
                                              controllers[field.name!] =
                                                  controller; // Save it in the map
                                            }

                                            if (field.type == 'dropdown' &&
                                                field.name ==
                                                    'beneficiary_country') {
                                              return BeneficiaryCountrySelector(
                                                  controller:
                                                      _recipientCountryController,
                                                  label: 'Beneficiary Country',
                                                  hint: 'Select Country',
                                                  countries: _countryList,
                                                  onCurrencySelected: (value) {
                                                    recipientCountryCode =
                                                        value;
                                                    debugPrint(
                                                        "recipient Country code:$recipientCountryCode");
                                                  });
                                            } else {
                                              return Row(
                                                children: [
                                                  Expanded(
                                                    child:
                                                        DynamicInputFieldWithTitleWidget(
                                                      controller: controller,
                                                      title: field.label!,
                                                      hint: field.placeholder!,
                                                      isRequired:
                                                          field.validate ==
                                                                  "required"
                                                              ? true
                                                              : false,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      pattern: field.partner,
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }
                                          }),
                                        ),
                                  if (isClearInput == false)
                                    if (state.dynamicBeneficiaryFieldModel!
                                        .field!.isNotEmpty)
                                      Column(
                                        children: List.generate(
                                            state.dynamicBeneficiaryFieldModel!
                                                .field!.length, (index) {
                                          dynamic_beneficiary.Field field =
                                              state
                                                  .dynamicBeneficiaryFieldModel!
                                                  .field![index];

                                          TextEditingController? controller =
                                              controllers[field.name];
                                          if (controller == null) {
                                            // Initialize the controller with a default value if applicable
                                            controller = TextEditingController(
                                              text: field.value ?? "",
                                            );
                                            controllers[field.name!] =
                                                controller;
                                          }

                                          if (field.type == 'dropdown' &&
                                              field.name ==
                                                  'beneficiary_country') {
                                            return BeneficiaryCountrySelector(
                                                controller:
                                                    _recipientCountryController,
                                                label: 'Beneficiary Country',
                                                hint: 'Select Country',
                                                countries: _countryList,
                                                onCurrencySelected: (value) {
                                                  recipientCountryCode = value;
                                                  // value == User.countryCode;
                                                  print(
                                                      "recipient Country code:$recipientCountryCode");
                                                });
                                          } else {
                                            return Row(
                                              children: [
                                                Expanded(
                                                  child:
                                                      DynamicInputFieldWithTitleWidget(
                                                    controller: controller,
                                                    title: field.label!,
                                                    hint: field.placeholder!,
                                                    isRequired:
                                                        field.validate ==
                                                                "required"
                                                            ? true
                                                            : false,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    pattern: field.partner,
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                        }),
                                      ),
                                  if (isClearInput == false)
                                    if (state.dynamicBeneficiaryFieldModel!
                                            .isBeneficiaryIdentificationType ==
                                        1)
                                      BeneficiaryIdentificationTypeWidget(
                                        controller:
                                            beneficiaryIdentificationTypeController,
                                        label:
                                            'Beneficiary Identification Type',
                                        hint: 'Select Type',
                                        identificationTypes:
                                            beneficiaryIdentificationTypeList,
                                        onTypeSelected: (value) {},
                                      ),
                                  if (isClearInput == false)
                                    if (state.dynamicBeneficiaryFieldModel!
                                            .isBeneficiaryIdentificationType ==
                                        1)
                                      DynamicInputFieldWithTitleWidget(
                                        controller:
                                            beneficiaryIdentificationTypeValueController,
                                        title:
                                            'Beneficiary Identification value',
                                        hint:
                                            'Beneficiary Identification value',
                                        isRequired: true,
                                        keyboardType: TextInputType.text,
                                        // pattern: field.partner,
                                      ),
                                  if (isClearInput == false)
                                    if (state.dynamicBeneficiaryFieldModel!
                                            .field!.isNotEmpty ||
                                        state.dynamicBeneficiaryFieldModel!
                                            .recipientBankOptions!.isNotEmpty)
                                      Inputuploadimage(
                                        controller: _image,
                                        hint: 'Upload image',
                                        isEmail: false,
                                        ispassword: false,
                                        label: 'Beneficiary image',
                                        ontap: () async {
                                          image = await picker.pickImage(
                                              source: ImageSource.gallery);

                                          setState(() {
                                            _image.text = image!.name;
                                          });
                                        },
                                      ),
                                  if (isClearInput == false)
                                    if (state.dynamicBeneficiaryFieldModel!
                                            .field!.isNotEmpty ||
                                        state.dynamicBeneficiaryFieldModel!
                                            .recipientBankOptions!.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: PrimaryButtonWidget(
                                          onPressed: () {
                                            // Collect data from controllers to send in the event
                                            Map<String, String>
                                                dynamicFormData = {};

                                            controllers
                                                .forEach((key, controller) {
                                              dynamicFormData[key] = controller
                                                  .text; // Collect the values from controllers
                                            });
                                            print(dynamicFormData.toString());

                                            if (_formkey.currentState!
                                                .validate()) {
                                              _transferBloc.add(
                                                  AddDynamicBeneficiaryEvent(
                                                country: userCountryCode!,
                                                currency:
                                                    _currencyController.text,
                                                recipientCountry:
                                                    recipientCountryCode ?? "",
                                                accountType: indvidual
                                                    ? 'Personal'
                                                    : 'Business',
                                                dynamicFrom: dynamicFormData,
                                                beneficiaryIdentificationType:
                                                    beneficiaryIdentificationTypeController
                                                            .text ??
                                                        "",
                                                beneficiaryIdentificationValue:
                                                    beneficiaryIdentificationTypeValueController
                                                            .text ??
                                                        "",
                                                image: image?.path == null
                                                    ? ''
                                                    : image!.path,
                                              ));
                                            }
                                          },
                                          buttonText: 'Continue',
                                        ),
                                      ),
                                  const SizedBox(
                                    height: 10,
                                  )
                                ],
                              ))),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
