import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:gptbanqbusiness/Screens/Sign_up_screens/bloc/signup_bloc.dart';
import 'package:gptbanqbusiness/Screens/investment/bloc/investment_bloc.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:gptbanqbusiness/utils/assets.dart';
import 'package:gptbanqbusiness/widgets/custom_image_widget.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Models/cdg/cdg_accounts_model.dart';
import '../../../utils/input_fields/custom_color.dart';
import '../../../utils/strings.dart';
import '../../../widgets/buttons/default_back_button_widget.dart';
import '../../../widgets/buttons/primary_button_widget.dart';
import '../../../widgets/main/default_dropdown_field_with_title_widget.dart';
import '../../../widgets/success/success_widget.dart';
import '../../../widgets/toast/toast_util.dart';

class ActiveCdgDeviceScreen extends StatefulWidget {
  const ActiveCdgDeviceScreen({super.key});

  @override
  State<ActiveCdgDeviceScreen> createState() => _ActiveCdgDeviceScreenState();
}

class _ActiveCdgDeviceScreenState extends State<ActiveCdgDeviceScreen> {
  final InvestmentBloc _investmentBloc = InvestmentBloc();
  final TextEditingController _qrScanController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.scaffoldBg,
      // allow layout to adjust for keyboard
      resizeToAvoidBottomInset: true,
      // Move the primary action button out of the body to avoid Column overflow
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: PrimaryButtonWidget(
            onPressed: () async {
              var result = await BarcodeScanner.scan();
              setState(() {
                _qrScanController.text = result.rawContent;
                debugPrint(_qrScanController.text);
                if (_qrScanController.text.isNotEmpty) {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    elevation: 5,
                    builder: (context) {
                      return Padding(
                        // keeps sheet above keyboard
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: ActiveMasternodeSheet(
                            qrCodeData: _qrScanController.text,
                          ),
                        ),
                      );
                    },
                  );
                }
              });
            },
            buttonText: 'Continue',
          ),
        ),
      ),
      body: BlocListener(
        bloc: _investmentBloc,
        listener: (context, InvestmentState state) {},
        child: BlocBuilder(
          bloc: _investmentBloc,
          builder: (context, InvestmentState state) {
            return SafeArea(
              child: ProgressHUD(
                inAsyncCall: state.isloading,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 30,
                        bottom: 16,
                      ),
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints(minHeight: constraints.maxHeight),
                        // IntrinsicHeight can help stretch to full height; safe to remove if undesired
                        child: IntrinsicHeight(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              appBarSection(context, state),
                              const SizedBox(height: 10),
                              Text(
                                "Activate your ${Strings.coinName} Device",
                                textAlign: TextAlign.left,
                                style: GoogleFonts.inter(
                                  color: CustomColor.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                "it will only take about 1 minutes",
                                textAlign: TextAlign.left,
                                style: GoogleFonts.inter(
                                  color:
                                      CustomColor.primaryInputHintBorderColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                  color: CustomColor.whiteColor,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color:
                                        CustomColor.primaryInputHintBorderColor,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              var result =
                                                  await BarcodeScanner.scan();

                                              setState(() {
                                                _qrScanController.text =
                                                    result.rawContent;

                                                debugPrint(
                                                    _qrScanController.text);
                                                if (_qrScanController
                                                    .text.isNotEmpty) {
                                                  showModalBottomSheet(
                                                    context: context,
                                                    isScrollControlled: true,
                                                    elevation: 5,
                                                    builder: (context) {
                                                      return Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                          bottom: MediaQuery.of(
                                                                  context)
                                                              .viewInsets
                                                              .bottom,
                                                        ),
                                                        child: SizedBox(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.5,
                                                          child:
                                                              ActiveMasternodeSheet(
                                                            qrCodeData:
                                                                _qrScanController
                                                                    .text,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                }
                                              });
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CustomImageWidget(
                                                  imagePath:
                                                      StaticAssets.selfie,
                                                  imageType: 'svg',
                                                  height: 25,
                                                ),
                                                const SizedBox(width: 5),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "QR Code",
                                                        style:
                                                            GoogleFonts.inter(
                                                          color:
                                                              CustomColor.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      Text(
                                                        "take the qrcode under the device",
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style:
                                                            GoogleFonts.inter(
                                                          color: CustomColor
                                                              .primaryInputHintBorderColor,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    CustomImageWidget(
                                      imagePath: StaticAssets.arrowRight,
                                      imageType: 'svg',
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 5),
                                    child: CustomImageWidget(
                                      imagePath: StaticAssets.info,
                                      imageType: 'svg',
                                      height: 13,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "We need make sure your detail match with QR. We will keep your data secure and confidential.",
                                      textAlign: TextAlign.start,
                                      style: GoogleFonts.inter(
                                        color: const Color(0xff393939),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 50),
                              Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                  color: CustomColor.whiteColor,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color:
                                        CustomColor.primaryInputHintBorderColor,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomImageWidget(
                                      imagePath: StaticAssets.qrScan,
                                      imageType: 'svg',
                                      height: 25,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      "verification code",
                                      style: GoogleFonts.inter(
                                        color: CustomColor.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
                              // Make the illustration flexible, not fixed 300px
                              AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Image.asset(
                                  StaticAssets.cdgDeviceInvisible,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              // Note: PrimaryButtonWidget removed from here; now in bottomNavigationBar
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget appBarSection(BuildContext context, state) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DefaultBackButtonWidget(onTap: () {
            Navigator.pop(context);
          }),
          Text(
            'Active CDG',
            style: GoogleFonts.inter(
              color: CustomColor.black,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            width: 20,
          )
        ],
      ),
    );
  }
}

class ActiveMasternodeSheet extends StatefulWidget {
  ActiveMasternodeSheet({super.key, required this.qrCodeData});

  String qrCodeData;

  @override
  State<ActiveMasternodeSheet> createState() => _ActiveMasternodeSheetState();
}

class _ActiveMasternodeSheetState extends State<ActiveMasternodeSheet> {
  final InvestmentBloc _investmentBloc = InvestmentBloc();
  final GlobalKey<FormState> _activeNFormKey = GlobalKey<FormState>();
  final TextEditingController _activeNumberController = TextEditingController();
  bool isButtonEnabled = false;
  bool isAccepted = false;

  final SingleValueDropDownController _ibanAccountDropDownController =
      SingleValueDropDownController();
  String selectedIban = '';
  String selectedIbanCurrency = '';
  dynamic ratePrince;
  double payableAmount = 0.00;
  String? ibanId;

  String activationFee = "";
  String coin = "";
  String cdgId = "";

  @override
  void initState() {
    super.initState();
    _investmentBloc.add(CdgQrCodeEvent(serialNumber: widget.qrCodeData));
    _investmentBloc.add(CdgActiveEvent(type: 'cdg-activate'));

    _activeNumberController.addListener(_checkFormValidity);
  }

  void _checkFormValidity() {
    setState(() {
      isButtonEnabled = _activeNumberController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _investmentBloc,
      listener: (context, InvestmentState state) {
        if (state.cdgQrCodeModel?.status == 1) {
          activationFee = state.cdgQrCodeModel!.activateFee ?? "";
          coin = state.cdgQrCodeModel!.coin ?? "";
          cdgId = state.cdgQrCodeModel!.cdgId ?? "";
        } else if (state.cdgQrCodeModel?.status == 0) {
          CustomToast.showError(
              context, "Sorry!", state.cdgQrCodeModel!.message ?? "Failed");
        }

        if (state.cdgAccountsModel?.status == 0) {
          CustomToast.showError(
              context, "Sorry!", state.cdgAccountsModel!.message ?? "Failed");
        }

        if (state.statusModel?.status == 1) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => SuccessWidget(
                imageType: SuccessImageType.success,
                title: 'Activation Success',
                subTitle: state.statusModel!.message ?? 'Success',
                btnText: 'Home',
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, "dashboard", (route) => false);
                },
                disableButton: false,
              ),
            ),
            (route) => false,
          );
        } else if (state.statusModel?.status == 0) {
          CustomToast.showError(
              context, "Sorry!", state.statusModel!.message ?? "Failed");
        }
      },
      child: BlocBuilder(
        bloc: _investmentBloc,
        builder: (context, InvestmentState state) {
          return Container(
            height: 260,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: CustomColor.scaffoldBg,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              border: Border(
                top: BorderSide(
                  color: Color(0xff797777),
                  width: 1, // Set the thickness of the top border
                ),
              ),
            ),
            child: ProgressHUD(
              inAsyncCall: state.isloading,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: CustomImageWidget(
                              imagePath: StaticAssets.xClose,
                              imageType: 'svg',
                              height: 26,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Text(
                            'Active Now',
                            textAlign: TextAlign.left,
                            style: GoogleFonts.inter(
                              color: CustomColor.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              height: 1,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                      ],
                    ),
                    Form(
                      key: _activeNFormKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: CustomColor.hubContainerBgColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Activation Fee',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    color: CustomColor.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  "$activationFee $coin",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    color: CustomColor.black.withOpacity(0.6),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if ((state.cdgAccountsModel?.cdgIbanInfo
                                      ?.isNotEmpty ??
                                  false) ==
                              true)
                            Padding(
                              padding: const EdgeInsets.only(top: 0),
                              child: DefaultDropDownFieldWithTitleWidget(
                                controller: _ibanAccountDropDownController,
                                title: "Pay with",
                                hint: "Select",
                                dropDownItemCount: state.cdgAccountsModel
                                        ?.cdgIbanInfo?.length ??
                                    0,
                                dropDownList:
                                    (state.cdgAccountsModel?.cdgIbanInfo ?? [])
                                        .map<DropDownValueModel>(
                                            (CdgIbaninfo iban) {
                                  return DropDownValueModel(
                                    name: "${iban.showlabel}",
                                    value: iban,
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  setState(() {
                                    selectedIban = (val as DropDownValueModel)
                                        .value
                                        ?.ibanId;
                                    ibanId = val.value.ibanId;
                                    selectedIbanCurrency =
                                        val.value.currency ?? '';
                                    debugPrint("iban id check $ibanId");

                                    // If you later re-enable price logic, keep null checks:
                                    // ratePrince = val.value.coinPrice?.toString() ?? "1";
                                  });
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isAccepted = !isAccepted;
                              });
                            },
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: isAccepted
                                    ? CustomColor.primaryColor
                                    : Colors.transparent,
                                border: Border.all(
                                  color: isAccepted
                                      ? CustomColor.primaryColor
                                      : Colors.grey,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: isAccepted
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 18,
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "I accept the Terms and Conditions",
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: isAccepted
                                    ? CustomColor.black
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Submit Button
                    PrimaryButtonWidget(
                      onPressed: isAccepted
                          ? () {
                              debugPrint("iban id check $ibanId");
                              if (_activeNFormKey.currentState?.validate() ??
                                  false) {
                                if (ibanId != null &&
                                    (state.cdgQrCodeModel?.cdgId?.isNotEmpty ??
                                        false)) {
                                  _investmentBloc.add(CdgDeviceActiveEvent(
                                    ibanId: ibanId!,
                                    cdgId: state.cdgQrCodeModel!.cdgId!,
                                    serialNumber: widget.qrCodeData,
                                  ));
                                } else {
                                  CustomToast.showError(context, "Sorry!",
                                      "Please select an account first.");
                                }
                              }
                            }
                          : null,
                      buttonText: 'Pay',
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class TermsContent extends StatefulWidget {
  final termsData;
  bool isAccepted;
  final ValueChanged<bool> onAcceptedChanged;
  final VoidCallback onSubmit;

  TermsContent({
    this.termsData,
    required this.isAccepted,
    required this.onAcceptedChanged,
    required this.onSubmit,
    super.key,
  });

  @override
  State<TermsContent> createState() => _TermsContentState();
}

class _TermsContentState extends State<TermsContent> {
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.74,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.isAccepted = !widget.isAccepted;
                          widget.onAcceptedChanged(widget.isAccepted);
                        });
                      },
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: widget.isAccepted
                              ? CustomColor.primaryColor
                              : Colors.transparent,
                          border: Border.all(
                            color: CustomColor.primaryColor,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: widget.isAccepted
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 18,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "I accept the Terms and Conditions",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Submit Button
                PrimaryButtonWidget(
                  onPressed: widget.isAccepted ? widget.onSubmit : null,
                  buttonText: 'Submit',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
