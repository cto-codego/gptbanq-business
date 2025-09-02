import 'dart:convert';

import 'package:gptbanqbusiness/Screens/transfer_screen/bloc/transfer_bloc.dart';
import 'package:gptbanqbusiness/constant_string/User.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:gptbanqbusiness/widgets/toast/toast_util.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_face_api/flutter_face_api.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';

import 'package:http/http.dart' as http;

import '../../utils/input_fields/custom_color.dart';
import '../../widgets/buttons/default_back_button_widget.dart';
import '../../widgets/buttons/primary_button_widget.dart';
import '../../widgets/main/transaction_user_data_widget.dart';
import '../../widgets/success/success_widget.dart';
import '../../widgets/toast/custom_dialog_widget.dart';

class TransferConfirmationScreen extends StatefulWidget {
  final String name,
      bic,
      iban,
      aba,
      bsbCode,
      bankCode,
      clabe,
      ifsc,
      institutionNo,
      sortCode,
      cnaps,
      amount,
      date,
      commision,
      refesnce,
      type,
      id,
      accountNumber,
      exchangeRate,
      exchangeFee,
      trxFee,
      trxLabel,
      exchangeAmount,
      totalPay,
      conversionAmount,
      branchCode,
      provider,
      image;
  bool isSwift;

   TransferConfirmationScreen(
      {super.key,
      required this.name,
      required this.bic,
      required this.iban,
      required this.ifsc,
      required this.aba,
      required this.bankCode,
      required this.bsbCode,
      required this.clabe,
      required this.cnaps,
      required this.institutionNo,
      required this.sortCode,
      required this.amount,
      required this.date,
      required this.commision,
      required this.refesnce,
      required this.id,
      required this.image,
      required this.accountNumber,
      required this.exchangeFee,
      required this.exchangeRate,
      required this.trxFee,
      required this.trxLabel,
      required this.exchangeAmount,
      required this.totalPay,
      required this.conversionAmount,
      required this.branchCode,
      required this.isSwift,
      required this.provider,
      required this.type});

  @override
  State<TransferConfirmationScreen> createState() =>
      _TransferConfirmationScreenState();
}

class _TransferConfirmationScreenState
    extends State<TransferConfirmationScreen> {
  var status = "nil";
  var similarityStatus = "nil";
  var livenessStatus = "nil";
  String _similarity = "nil";
  String _liveness = "nil";
  String userimage = '';
  String? kycid;
  double lat = 0, long = 0;
  bool buttonActive = true;
  var uiImage1 = Image.asset('images/portrait.png'); // Placeholder image
  var uiImage2 = Image.asset('images/portrait.png');

  var faceSdk = FaceSDK.instance;

  MatchFacesImage? image1;
  MatchFacesImage? image2;
  Uint8List? bytes;

  final TransferBloc _transferBloc = TransferBloc();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  Location location = Location();

  getimage() async {
    bytes = (await NetworkAssetBundle(Uri.parse(User.profileimage!))
            .load(User.profileimage!))
        .buffer
        .asUint8List();
  }

  Future<void> loadImageFromUrl(String url, int number) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setImage(response.bodyBytes, ImageType.GHOST_PORTRAIT, number);
      } else {
        throw Exception('Failed to load image');
      }
    } catch (e) {
      print('Error loading image from URL: $e');
    }
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

  startLiveness() async {
    var result = await faceSdk.startLiveness(
      config: LivenessConfig(skipStep: [LivenessSkipStep.ONBOARDING_STEP]),
      notificationCompletion: (notification) {
        print(notification.status);
      },
    );
    if (result.image == null) return;
    setImage(result.image!, ImageType.LIVE, 2);
    livenessStatus = result.liveness.name.toLowerCase();

    String userImage = base64Encode(result.image!);
    print(userImage);

    if (image2 != null) {
      // Ensure that the second image is set before calling matchFaces
      matchFaces();
    } else {
      status = "Please set the second image before matching!";
    }
  }

  matchFaces() async {
    if (image1 == null || image2 == null) return;
    setState(() => _similarity = "Processing...");
    status = "Processing...";
    var request = MatchFacesRequest([image1!, image2!]);
    var response = await faceSdk.matchFaces(request);
    var split = await faceSdk.splitComparedFaces(response.results, 0.75);
    var match = split.matchedFaces;
    similarityStatus = "failed";

    if (match.isNotEmpty) {
      similarityStatus = "${(match[0].similarity * 100).toStringAsFixed(2)}%";
      _similarity = (match[0].similarity * 100).toStringAsFixed(2);

      if (double.parse(_similarity) > 90.00) {
        _transferBloc.add(RegulaupdateBiometric(
            facematch: 'yes', kycid: kycid, userimage: userimage));
      } else if (double.parse(_similarity) < 90.00) {
        _transferBloc.add(RegulaupdateBiometric(
            facematch: 'no', kycid: kycid, userimage: ''));
      }
    } else {
      _transferBloc.add(
          RegulaupdateBiometric(facematch: 'no', kycid: kycid, userimage: ''));
    }
  }

  Future<bool> initialize() async {
    status = "Initializing...";
    var license = await loadAssetIfExists("assets/regula.license");
    InitConfig? config = license != null ? InitConfig(license) : null;
    var (success, error) = await faceSdk.initialize(config: config);
    if (!success) {
      status = error!.message;
      print("${error.code}: ${error.message}");
    }
    return success;
  }

  Future<ByteData?> loadAssetIfExists(String path) async {
    try {
      return await rootBundle.load(path);
    } catch (_) {
      return null;
    }
  }

  void init() async {
    if (!await initialize()) return;
    status = "Ready";
  }

  @override
  void initState() {
    super.initState();

    loadImageFromUrl(User.profileimage!, 1);

    location.getLocation().then((location) {
      setState(() {
        lat = location.latitude!;
        long = location.longitude!;
      });
    });
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.scaffoldBg,
      resizeToAvoidBottomInset: false,
      body: BlocListener(
        bloc: _transferBloc,
        listener: (context, TransferState state) {
          if (state.pushModel?.status == 2) {
            buttonActive = true;
            kycid = state.pushModel?.kycid;

            startLiveness();

            state.isloading = true;
          } else if (state.pushModel?.status == 1) {
            buttonActive = true;
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => SuccessWidget(
                  disableButton: false,
                  imageType: SuccessImageType.success,
                  title: 'Transaction Success',
                  subTitle: state.pushModel!.message!,
                  btnText: 'Home',
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, "dashboard", (route) => false);
                  },
                ),
              ),
              (route) => false,
            );
          } else if (state.pushModel?.status == 0) {
            buttonActive = true;
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => SuccessWidget(
                  disableButton: false,
                  imageType: SuccessImageType.error,
                  title: 'Transaction Failed!',
                  subTitle: state.pushModel!.message!,
                  btnText: 'Home',
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, "dashboard", (route) => false);
                  },
                ),
              ),
              (route) => false,
            );
          }

          if (state.regulaModel?.status == 0) {
            buttonActive = true;
            CustomToast.showError(
                context, "Sorry!!", state.regulaModel!.message!);
          } else if (state.regulaModel?.status == 1) {
            buttonActive = true;
            CustomDialogWidget.showSuccessDialog(
              context: context,
              title: "Hey!",
              subTitle: state.regulaModel!.message!,
              btnOkText: "ok",
              btnOkOnPress: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, 'dashboard', (route) => false);
              },
            );
          }

          if (state.statusModel?.status == 0) {
            buttonActive = true;
            CustomToast.showError(
                context, "Sorry!!", state.statusModel!.message!);
          }
        },
        child: BlocBuilder(
          bloc: _transferBloc,
          builder: (context, TransferState state) {
            return SafeArea(
              child: ProgressHUD(
                inAsyncCall: state.isloading,
                child: Container(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 30, top: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      DefaultBackButtonWidget(onTap: () {
                                        Navigator.pop(context);
                                      }),
                                      Text(
                                        'Transfer Confirmation',
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
                                  name: widget.name,
                                  iban: widget.iban.isNotEmpty
                                      ? widget.iban
                                      : widget.accountNumber,
                                  accountType: widget.type,
                                  image: widget.image,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 16),
                                  decoration: BoxDecoration(
                                      color: CustomColor
                                          .transactionFromContainerColor,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: CustomColor
                                              .dashboardProfileBorderColor)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Amount",
                                        style: GoogleFonts.inter(
                                          color: CustomColor.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        widget.amount,
                                        style: GoogleFonts.inter(
                                          color: CustomColor
                                              .transactionDetailsTextColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      top: 10, bottom: 20),
                                  padding: const EdgeInsets.all(16),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: CustomColor
                                            .dashboardProfileBorderColor),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.topLeft,
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
                                        child: Text(
                                          'Detail Transaction',
                                          style: GoogleFonts.inter(
                                              color: CustomColor.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      if (widget.accountNumber.isNotEmpty)
                                        DetailsRowWidget(
                                          label: "A/C:",
                                          value: widget.accountNumber,
                                        ),
                                      if (widget.bic.isNotEmpty)
                                        DetailsRowWidget(
                                          label: "BIC/SWIFT:",
                                          value: widget.bic,
                                        ),
                                      if (widget.iban.isNotEmpty)
                                        DetailsRowWidget(
                                          label: "IBAN",
                                          value: widget.iban,
                                        ),
                                      if (widget.ifsc.isNotEmpty)
                                        DetailsRowWidget(
                                          label: "IFSC",
                                          value: widget.ifsc,
                                        ),
                                      if (widget.bankCode.isNotEmpty)
                                        DetailsRowWidget(
                                          label: "Bank Code",
                                          value: widget.bankCode,
                                        ),
                                      if (widget.branchCode.isNotEmpty)
                                        DetailsRowWidget(
                                          label: "Branch Code",
                                          value: widget.branchCode,
                                        ),
                                      if (widget.aba.isNotEmpty)
                                        DetailsRowWidget(
                                          label: "Aba",
                                          value: widget.aba,
                                        ),
                                      if (widget.sortCode.isNotEmpty)
                                        DetailsRowWidget(
                                          label: "Sort Code",
                                          value: widget.sortCode,
                                        ),
                                      if (widget.clabe.isNotEmpty)
                                        DetailsRowWidget(
                                          label: "clabe",
                                          value: widget.clabe,
                                        ),
                                      if (widget.cnaps.isNotEmpty)
                                        DetailsRowWidget(
                                          label: "Cnaps",
                                          value: widget.cnaps,
                                        ),
                                      if (widget.bsbCode.isNotEmpty)
                                        DetailsRowWidget(
                                          label: "Bsb Code",
                                          value: widget.bsbCode,
                                        ),
                                      if (widget.institutionNo.isNotEmpty)
                                        DetailsRowWidget(
                                          label: "Institution No",
                                          value: widget.institutionNo,
                                        ),
                                      DetailsRowWidget(
                                        label: "Payment Type",
                                        value: widget.type,
                                      ),
                                      if (widget.commision.isNotEmpty)
                                        DetailsRowWidget(
                                          label: "Commissions",
                                          value: widget.commision,
                                        ),
                                      if (widget.refesnce.isNotEmpty)
                                        DetailsRowWidget(
                                          label: "Reference",
                                          value: widget.refesnce,
                                        ),
                                      if (widget.amount.isNotEmpty)
                                        DetailsRowWidget(
                                          label: "Amount",
                                          value: widget.amount,
                                        ),
                                      if (widget.exchangeAmount.isNotEmpty && widget.provider.toString() != 'ccy')
                                        DetailsRowWidget(
                                          label: "Exchange Amount",
                                          value: widget.exchangeAmount,
                                        ),

                                      if (widget.exchangeRate.isNotEmpty && widget.provider.toString() != 'ccy')
                                        DetailsRowWidget(
                                          label: "Exchange Rate",
                                          value: widget.exchangeRate,
                                        ),
                                      if (widget.trxFee.isNotEmpty)
                                        DetailsRowWidget(
                                          label: widget.trxLabel,
                                          value: widget.trxFee,
                                        ),
                                      if (widget.exchangeFee.isNotEmpty && widget.provider.toString() != 'ccy')
                                        DetailsRowWidget(
                                          label: "Exchange Fee",
                                          value: widget.exchangeFee,
                                        ),
                                      if (widget.totalPay.isNotEmpty)
                                        DetailsRowWidget(
                                          label: "Your Total",
                                          value: widget.totalPay,
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      PrimaryButtonWidget(
                        onPressed: buttonActive
                            ? () {
                                buttonActive = false;
                                if(widget.isSwift == true){
                                  _transferBloc.add(ApproveibanSwiftTransactionEvent(
                                      uniqueId: widget.id,
                                      completed: 'Completed',
                                      lat: lat.toString(),
                                      long: long.toString()));
                                }else{
                                  _transferBloc.add(ApproveibanTransactionEvent(
                                      uniqueId: widget.id,
                                      completed: 'Completed',
                                      lat: lat.toString(),
                                      long: long.toString()));
                                }

                              }
                            : null,
                        buttonText: 'Transfer',
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void iOS_Permission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true, badge: true, sound: true);

    debugPrint("123Settings registered: ${settings.authorizationStatus}");
  }
}

class DetailsRowWidget extends StatelessWidget {
  final String label;
  final String value;

  const DetailsRowWidget({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              color: CustomColor.transactionDetailsTextColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              maxLines: 2,
              style: GoogleFonts.inter(
                color: CustomColor.subtitleTextColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
