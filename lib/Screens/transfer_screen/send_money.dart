import 'package:gptbanqbusiness/Screens/transfer_screen/transfer_confirmation_screen.dart';
import 'package:gptbanqbusiness/constant_string/User.dart';
import 'package:gptbanqbusiness/utils/input_fields/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gptbanqbusiness/Screens/transfer_screen/bloc/transfer_bloc.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:gptbanqbusiness/utils/validator.dart';
import 'package:flutter_face_api/flutter_face_api.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:seon_sdk_flutter_plugin/seon_sdk_flutter_plugin.dart';

import '../../utils/custom_style.dart';
import '../../widgets/buttons/default_back_button_widget.dart';
import '../../widgets/buttons/primary_button_widget.dart';
import '../../widgets/input_fields/amount_input_field_widget.dart';
import '../../widgets/input_fields/defult_input_field_with_title_widget.dart';
import '../../widgets/main/purpose_drodown_widget.dart';
import '../../widgets/main/transaction_user_data_widget.dart';
import '../../widgets/toast/toast_util.dart';

class SendMoneyScreen extends StatefulWidget {
  String? image, name, account, accountType, symbol;
  String id;

  SendMoneyScreen(
      {super.key,
      this.account,
      required this.id,
      this.image,
      this.name,
      this.accountType,
      this.symbol});

  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  final TransferBloc _transferBloc = TransferBloc();
  String _seonSession = 'Unknown';
  final _seonSdkFlutterPlugin = SeonSdkFlutterPlugin();

  bool sharedCost = false;
  bool instant = false;
  bool showPaymentCode = false;
  final _formKey = GlobalKey<FormState>();
  bool active = false;
  final TextEditingController _amount = TextEditingController();
  final TextEditingController _sePaSelectorController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _refrence = TextEditingController(text: '');

  final SingleValueDropDownController _iban = SingleValueDropDownController();
  final TextEditingController _ibanShowValueController =
      TextEditingController();
  final SingleValueDropDownController _payemntCode =
      SingleValueDropDownController();

  bool bordershoww = false;
  String? ibanid;
  String? paymentCode;

  MatchFacesImage? image1;
  MatchFacesImage? image2;
  bool isToggled = false;
  bool showSepaOption = false;

  var faceSdk = FaceSDK.instance;

  var status = "nil";
  var similarityStatus = "nil";
  var livenessStatus = "nil";

  var uiImage1 = Image.asset('images/portrait.png'); // Placeholder image
  var uiImage2 = Image.asset('images/portrait.png');

  String _similarity = "nil";

  // ignore: unused_field
  final String _liveness = "nil";

  Uint8List? bytes;

  getimage() async {
    bytes = (await NetworkAssetBundle(Uri.parse(User.profileimage!))
            .load(User.profileimage!))
        .buffer
        .asUint8List();
  }

  setImage(Uint8List bytes, ImageType type, int number) {
    similarityStatus = "nil";
    var mfImage = MatchFacesImage(bytes, type);
    if (number == 1) {
      image1 = mfImage;
      uiImage1 = Image.memory(bytes);
      livenessStatus = "nil";
    }
    if (number == 2) {
      image2 = mfImage;
      uiImage2 = Image.memory(bytes);
    }
  }

  @override
  void initState() {
    super.initState();
    _transferBloc.add(SepatypesEvent());
    _transferBloc.add(GetSwiftPaymentCodeEvent(id: widget.id));

    User.Screen = 'send money';
    _transferBloc.add(getibanlistEvent(beneficiaryId: widget.id));
    _amount.addListener(_updateButtonState);

    try {
      _seonSdkFlutterPlugin.setGeolocationEnabled(true);
      _seonSdkFlutterPlugin.setGeolocationTimeout(500);
      getFingerprint();
    } catch (e) {
      print('$e');
    }
  }

  @override
  void dispose() {
    _amount.removeListener(_updateButtonState);
    _amount.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        active = _formKey.currentState!.validate();
      });
    }
  }

  // Method to get fingerprint
  Future<void> getFingerprint() async {
    // setState(() {
    //   _isLoading = true;
    // });

    String fingerprint;
    try {
      fingerprint = await _seonSdkFlutterPlugin
              .getFingerprint("User-seon-session-data") ??
          'Error getting fingerprint';
    } catch (e) {
      fingerprint = 'Failed to get fingerprint $e';
    }

    if (!mounted) return;

    setState(() {
      _seonSession = fingerprint;
      // _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: CustomColor.whiteColor,
      body: SafeArea(
        child: BlocListener(
          bloc: _transferBloc,
          listener: (context, TransferState state) {
            if (state.sendmoneyModel?.status == 0) {
              CustomToast.showError(
                  context, "Sorry!", state.sendmoneyModel!.message!);
            } else if (state.sendmoneyModel?.status == 1) {
              Navigator.push(
                  context,
                  PageTransition(
                    child: TransferConfirmationScreen(
                      provider: "",
                      isSwift: false,
                      amount: state.sendmoneyModel!.amount!,
                      bic: state.sendmoneyModel!.bic!,
                      commision: state.sendmoneyModel!.commission!,
                      date: state.sendmoneyModel!.date!,
                      iban: state.sendmoneyModel!.iban!,
                      name: state.sendmoneyModel!.name!,
                      refesnce: state.sendmoneyModel!.referncepayment!,
                      type: state.sendmoneyModel!.paymentoption!,
                      id: state.sendmoneyModel!.uniqueid!,
                      image: widget.image!,
                      ifsc: '',
                      aba: '',
                      bankCode: '',
                      bsbCode: '',
                      clabe: '',
                      cnaps: '',
                      institutionNo: '',
                      sortCode: '',
                      accountNumber: '',
                      exchangeFee: '',
                      exchangeRate: '',
                      trxFee: '',
                      trxLabel: 'Transaction Fees',
                      exchangeAmount: '',
                      totalPay: '',
                      conversionAmount: '',
                      branchCode: "",
                    ),
                    type: PageTransitionType.bottomToTop,
                    alignment: Alignment.center,
                    duration: const Duration(milliseconds: 300),
                    reverseDuration: const Duration(milliseconds: 200),
                  ));
            }

            if (state.swiftPaymentModel?.status == 0) {
              CustomToast.showError(
                  context, "Sorry!", state.swiftPaymentModel!.message!);
            } else if (state.swiftPaymentModel?.status == 1) {
              Navigator.push(
                  context,
                  PageTransition(
                    child: TransferConfirmationScreen(
                      isSwift: true,
                      amount: state.swiftPaymentModel!.amount!,
                      bic: state.swiftPaymentModel!.bicSwift!,
                      provider: state.swiftPaymentModel!.provider!,
                      commision: "",
                      date: state.swiftPaymentModel!.date!,
                      iban: "",
                      name: state.swiftPaymentModel!.name!,
                      refesnce: state.swiftPaymentModel!.referncePayment!,
                      type: state.swiftPaymentModel!.paymentType!,
                      id: state.swiftPaymentModel!.uniqueId!,
                      exchangeRate: state.swiftPaymentModel!.exchangeRate!,
                      exchangeFee: state.swiftPaymentModel!.exchangeFee!,
                      trxFee: state.swiftPaymentModel!.internationalFee!,
                      trxLabel: state.swiftPaymentModel!.feeLabel!,
                      totalPay: state.swiftPaymentModel!.yourTotal!,
                      exchangeAmount: state.swiftPaymentModel!.exchangeAmount!,
                      ifsc: state.swiftPaymentModel!.ifsc!,
                      aba: state.swiftPaymentModel!.aba!,
                      bsbCode: state.swiftPaymentModel!.bsbCode!,
                      bankCode: state.swiftPaymentModel!.bankCode!,
                      image: state.swiftPaymentModel!.flag ?? widget.image!,
                      clabe: state.swiftPaymentModel!.clabe!,
                      cnaps: state.swiftPaymentModel!.cnaps!,
                      institutionNo: state.swiftPaymentModel!.institutionNo!,
                      sortCode: state.swiftPaymentModel!.sortCode!,
                      accountNumber: state.swiftPaymentModel!.accountNumber!,
                      conversionAmount: state.swiftPaymentModel!.exchangeFee!,
                      branchCode: state.swiftPaymentModel!.branchCode!,
                    ),
                    type: PageTransitionType.bottomToTop,
                    alignment: Alignment.center,
                    duration: const Duration(milliseconds: 300),
                    reverseDuration: const Duration(milliseconds: 200),
                  ));
            }

            if (state.swiftSendMoneyUserModel?.status == 1) {
              setState(() {
                showPaymentCode = true;
              });
            }
          },
          child: BlocBuilder(
            bloc: _transferBloc,
            builder: (context, TransferState state) {
              return ProgressHUD(
                inAsyncCall: state.isloading,
                child: Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 30, top: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    DefaultBackButtonWidget(onTap: () {
                                      Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          'beneficiaryListScreen',
                                          (route) => false);
                                    }),
                                    Text(
                                      '',
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
                              TransactionUserDataWidget(
                                name: widget.name!,
                                iban: widget.account!,
                                accountType: widget.accountType!,
                                image: widget.image!,
                              ),
                              Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    AmountInputField(
                                        controller: _amount,
                                        label: "Transfer Amount",
                                        // Custom label
                                        currencySymbol: widget.symbol!,
                                        autofocus: true,
                                        minAmount: 0,
                                        onChanged: (value) {
                                          _updateButtonState();
                                        }),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    DefaultInputFieldWithTitleWidget(
                                        controller: _refrence,
                                        title: 'Reference',
                                        hint: 'Reference',
                                        isEmail: false,
                                        keyboardType: TextInputType.name,
                                        isPassword: false,
                                        onChanged: (value) {
                                          _updateButtonState();
                                        }),
                                    if (showPaymentCode == true &&
                                        (state.swiftSendMoneyUserModel?.pc
                                                ?.isNotEmpty ??
                                            false))
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          PurposeDropdownWidget(
                                            controller:
                                                _purposeController,
                                            label: "Purpose of Payment",
                                            hint: 'Select your purpose',
                                            dataLList: state
                                                .swiftSendMoneyUserModel!
                                                .pc!,
                                            onChanged: (value) {
                                              paymentCode = value;
                                            },
                                          )
                                        ],
                                      ),
                                    if (state.ibanlistModel!.ibaninfo!
                                        .isNotEmpty)
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(
                                                    top: 10, bottom: 5),
                                            child: Text(
                                              "Select Account",
                                              style: GoogleFonts.inter(
                                                color: CustomColor
                                                    .inputFieldTitleTextColor,
                                                fontSize: 14,
                                                fontWeight:
                                                    FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          DropDownTextField(
                                            controller: _iban,
                                            clearOption: false,
                                            validator: (value) {
                                              return Validator
                                                  .validateValues(
                                                      value: value);
                                            },
                                            readOnly: true,
                                            dropDownIconProperty:
                                                IconProperty(
                                              icon: Icons
                                                  .keyboard_arrow_down,
                                              color: CustomColor.black,
                                            ),
                                            textFieldDecoration:
                                                InputDecoration(
                                              filled: true,
                                              fillColor: bordershoww
                                                  ? CustomColor.whiteColor
                                                  : CustomColor
                                                      .primaryInputHintColor,
                                              contentPadding:
                                                  const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20),
                                              hintText: 'Select Account',
                                              hintStyle: CustomStyle
                                                  .loginInputTextHintStyle,
                                              enabledBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: bordershoww
                                                      ? CustomColor
                                                          .primaryColor
                                                      : CustomColor
                                                          .primaryInputHintBorderColor,
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        11),
                                              ),
                                              errorBorder:
                                                  OutlineInputBorder(
                                                borderSide:
                                                    const BorderSide(
                                                        color: CustomColor
                                                            .errorColor,
                                                        width: 1),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        11),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide:
                                                    const BorderSide(
                                                        color: CustomColor
                                                            .errorColor,
                                                        width: 1),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        11),
                                              ),
                                              focusedBorder:
                                                  OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: CustomColor
                                                        .primaryInputHintBorderColor,
                                                    width: 1),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        11),
                                              ),
                                              border: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: CustomColor
                                                        .primaryInputHintBorderColor,
                                                    width: 1),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        11),
                                              ),
                                              disabledBorder:
                                                  OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: CustomColor
                                                        .primaryInputHintBorderColor,
                                                    width: 1),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        11),
                                              ),
                                              enabled: true,
                                            ),
                                            textStyle: GoogleFonts.inter(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: CustomColor.black,
                                            ),
                                            autovalidateMode:
                                                AutovalidateMode
                                                    .onUserInteraction,
                                            dropDownItemCount: state
                                                .ibanlistModel!
                                                .ibaninfo!
                                                .length,
                                            dropDownList: state
                                                .ibanlistModel!.ibaninfo!
                                                .map((ibanInfo) {
                                              return DropDownValueModel(
                                                name:
                                                    "${ibanInfo.label} (${ibanInfo.balance} ${ibanInfo.currency})",
                                                value: ibanInfo.ibanId,
                                              );
                                            }).toList(),
                                            onChanged: (val) {
                                              print(val.value);
                                              _updateButtonState();

                                              setState(() {
                                                ibanid =
                                                    val.value.toString();

                                                // Find the selected IBAN info based on the selected value
                                                var selectedIbanInfo =
                                                    state.ibanlistModel!
                                                        .ibaninfo!
                                                        .firstWhere(
                                                  (iban) =>
                                                      iban.ibanId ==
                                                      ibanid,
                                                );

                                                if (selectedIbanInfo !=
                                                    null) {
                                                  String provider =
                                                      selectedIbanInfo
                                                          .provider!; // Update the provider string

                                                  // Check the provider of the selected IBAN
                                                  if (provider ==
                                                      'pvnt') {
                                                    showSepaOption = true;
                                                  } else {
                                                    showSepaOption =
                                                        false;
                                                  }

                                                  // Update border visibility based on selection
                                                  bordershoww =
                                                      val != null;
                                                }
                                              });
                                            },
                                          ),
                                        ],
                                      )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              if (widget.accountType == "sepa" &&
                                  showSepaOption == true)
                                SizedBox(
                                  height: 41,
                                  child: Row(
                                    children: [
                                      state.sepatypesmodel!.types!
                                                  .instant ==
                                              ''
                                          ? Container()
                                          : SelectableButton(
                                              title: state.sepatypesmodel!
                                                  .types!.instant!,
                                              isSelected: instant,
                                              onTap: () {
                                                _updateButtonState();
                                                setState(() {
                                                  instant = true;
                                                });
                                              },
                                            ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      state.sepatypesmodel!.types!.sepa ==
                                              ''
                                          ? Container()
                                          : SelectableButton(
                                              title: state.sepatypesmodel!
                                                  .types!.sepa!,
                                              isSelected: !instant,
                                              onTap: () {
                                                _updateButtonState();
                                                setState(() {
                                                  instant = false;
                                                });
                                              },
                                            ),
                                    ],
                                  ),
                                ),
                              if (widget.accountType == "swift")
                                Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    "Shared cost",
                                    style: GoogleFonts.inter(
                                      color: CustomColor.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              if (widget.accountType == "swift")
                                SizedBox(
                                  height: 41,
                                  child: Row(
                                    children: [
                                      SelectableButton(
                                        title: "Yes",
                                        isSelected: sharedCost,
                                        onTap: () {
                                          _updateButtonState();
                                          setState(() {
                                            sharedCost = true;
                                          });
                                        },
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      SelectableButton(
                                        title: "No",
                                        isSelected: !sharedCost,
                                        onTap: () {
                                          _updateButtonState();
                                          setState(() {
                                            sharedCost = false;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              const SizedBox(
                                height: 40,
                              ),
                            ],
                          ),
                        ),
                      ),
                      PrimaryButtonWidget(
                        onPressed: active
                            ? () {
                                if (_formKey.currentState!.validate()) {
                                  active = false;

                                  if (widget.accountType == "swift" ||
                                      widget.accountType ==
                                          "local faster") {
                                    _transferBloc.add(SwiftSendmoneyEvent(
                                        amount: _amount.text,
                                        paymentoption: widget.accountType,
                                        refrence: _refrence.text,
                                        uniquid: widget.id,
                                        iban: ibanid,
                                        swiftShared: sharedCost ? 1 : 0,
                                        sendNotification: "",
                                        seOnSession: _seonSession,
                                        paymentCode: paymentCode ?? " "));
                                  } else {
                                    if (showSepaOption == true) {
                                      _transferBloc.add(SendmoneyEvent(
                                          amount: _amount.text,
                                          paymentoption: instant
                                              ? 'sepa instant'
                                              : 'sepa normal',
                                          refrence: _refrence.text,
                                          uniquid: widget.id,
                                          iban: ibanid));
                                    } else {
                                      _transferBloc.add(SendmoneyEvent(
                                          amount: _amount.text,
                                          paymentoption: 'sepa normal',
                                          refrence: _refrence.text,
                                          uniquid: widget.id,
                                          iban: ibanid));
                                    }
                                  }
                                }
                              }
                            : null,
                        buttonText: 'Next',
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class SelectableButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectableButton({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          // height: 41,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isSelected
                ? CustomColor.primaryColor
                : CustomColor.transactionFromContainerColor,
            border: Border.all(
              color: isSelected
                  ? Color(0xff007AFF)
                  : CustomColor.transactionFromContainerColor,
              // Change border color based on selection
              width: 2, // Adjust the border width if needed
            ),
          ),
          child: Text(
            title,
            style: GoogleFonts.inter(
              color: isSelected
                  ? CustomColor.whiteColor
                  : CustomColor.inputFieldTitleTextColor,
              // Change text color based on selection
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}

// Helper Method for Borders
OutlineInputBorder _getInputBorder(bool isFocused) {
  return OutlineInputBorder(
    borderSide: BorderSide(
      color: isFocused
          ? CustomColor.primaryColor
          : CustomColor.primaryInputHintBorderColor,
      width: 1,
    ),
    borderRadius: BorderRadius.circular(11),
  );
}
