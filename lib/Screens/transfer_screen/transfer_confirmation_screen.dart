import 'dart:convert';
import 'dart:typed_data';

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
  final bool isSwift;

  const TransferConfirmationScreen({
    super.key,
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
    required this.type,
  });

  @override
  State<TransferConfirmationScreen> createState() =>
      _TransferConfirmationScreenState();
}

class _TransferConfirmationScreenState
    extends State<TransferConfirmationScreen> {
  final _transferBloc = TransferBloc();
  final faceSdk = FaceSDK.instance;
  final _location = Location();

  String status = "nil";
  String similarityStatus = "nil";
  String livenessStatus = "nil";
  String _similarity = "nil";
  double lat = 0, long = 0;
  bool buttonActive = true;
  String? _kycId;

  MatchFacesImage? image1; // profile
  MatchFacesImage? image2; // live

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    await _initLocation();
    await _initializeSdk();
    await _loadProfileImage();
  }

  Future<void> _initLocation() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return;
    }
    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }
    final loc = await _location.getLocation();
    if (!mounted) return;
    setState(() {
      lat = loc.latitude ?? 0;
      long = loc.longitude ?? 0;
    });
  }

  Future<void> _loadProfileImage() async {
    final url = User.profileimage;
    if (url == null || url.isEmpty) return;
    try {
      final r = await http.get(Uri.parse(url));
      if (r.statusCode == 200) {
        _setImage(r.bodyBytes, ImageType.PRINTED, 1);
      }
    } catch (_) {}
  }

  Future<void> _initializeSdk() async {
    setState(() => status = "Initializing...");
    final lic = await _loadAssetIfExists("assets/regula.license");
    final config = lic != null ? InitConfig(lic) : null;
    final (ok, err) = await faceSdk.initialize(config: config);
    if (!mounted) return;
    setState(() => status = ok ? "Ready" : (err?.message ?? "Init failed"));
  }

  Future<ByteData?> _loadAssetIfExists(String path) async {
    try {
      return await rootBundle.load(path);
    } catch (_) {
      return null;
    }
  }

  void _setImage(Uint8List bytes, ImageType type, int number) {
    setState(() {
      final mf = MatchFacesImage(bytes, type);
      if (number == 1) {
        image1 = mf;
        livenessStatus = "nil";
      } else {
        image2 = mf;
      }
      similarityStatus = "nil";
    });
  }

  Future<void> _startLiveness() async {
    try {
      setState(() => status = "Processing...");
      final result = await faceSdk.startLiveness(
        config: LivenessConfig(skipStep: [LivenessSkipStep.ONBOARDING_STEP]),
        notificationCompletion: (n) => debugPrint(n.status.toString()),
      );
      if (result.image == null) {
        if (mounted) setState(() => status = "Ready");
        return;
      }
      _setImage(result.image!, ImageType.LIVE, 2);
      if (!mounted) return;
      setState(() => livenessStatus = result.liveness.name.toLowerCase());
      await _matchFaces(); // proceed automatically
      if (mounted) setState(() => status = "Ready");
    } catch (e) {
      if (mounted) {
        CustomToast.showError(
            context, "Sorry!!", "Unable to start liveness. Try again.");
        setState(() => status = "Ready");
      }
    }
  }

  Future<void> _matchFaces() async {
    if (image1 == null || image2 == null) {
      CustomToast.showError(context, "Sorry!!", "Profile or selfie missing.");
      return;
    }
    setState(() {
      status = "Processing...";
      _similarity = "Processing...";
    });
    final req = MatchFacesRequest([image1!, image2!]);
    final resp = await faceSdk.matchFaces(req);
    final split = await faceSdk.splitComparedFaces(resp.results, 0.75);
    final matches = split.matchedFaces;
    final simPct = matches.isNotEmpty ? matches.first.similarity * 100 : 0.0;

    if (!mounted) return;
    setState(() {
      similarityStatus =
      matches.isNotEmpty ? "${simPct.toStringAsFixed(2)}%" : "failed";
      _similarity = simPct.toStringAsFixed(2);
      status = "Ready";
    });

    final facematch = simPct >= 90.0 ? 'yes' : 'no';
    final selfieB64 = image2 != null ? base64Encode(image2!.image) : '';

    _transferBloc.add(RegulaupdateBiometric(
      facematch: facematch,
      kycid: null, // fill if required by backend
      userimage: facematch == 'yes' ? selfieB64 : '',
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _transferBloc,
      listener: (context, TransferState state) {
        if (state.pushModel?.status == 2) {
          setState(() {
            buttonActive = true;
            _kycId = state.pushModel?.kycid; // <— save it
          });
          _startLiveness();
        } else if (state.pushModel?.status == 1) {
          setState(() => buttonActive = true);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => SuccessWidget(
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
          setState(() => buttonActive = true);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => SuccessWidget(
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

        // Regula biometric update response
        if (state.regulaModel?.status == 0) {
          setState(() => buttonActive = true);
          CustomToast.showError(
              context, "Sorry!!", state.regulaModel!.message!);
        } else if (state.regulaModel?.status == 1) {
          setState(() => buttonActive = true);
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
          setState(() => buttonActive = true);
          CustomToast.showError(
              context, "Sorry!!", state.statusModel!.message!);
        }
      },
      child: BlocBuilder<TransferBloc, TransferState>(
        bloc: _transferBloc,
        builder: (context, state) {
          return ProgressHUD(
            inAsyncCall: state.isloading,
            child: Scaffold(
              backgroundColor: CustomColor.scaffoldBg,
              resizeToAvoidBottomInset: false,
              body: SafeArea(
                child: Container(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            Padding(
                              padding:
                              const EdgeInsets.only(bottom: 30, top: 10),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  DefaultBackButtonWidget(
                                      onTap: () => Navigator.pop(context)),
                                  Text(
                                    'Transfer Confirmation',
                                    style: GoogleFonts.inter(
                                      color: CustomColor.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
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
                                color:
                                CustomColor.transactionFromContainerColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: CustomColor
                                        .dashboardProfileBorderColor),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Amount",
                                      style: GoogleFonts.inter(
                                        color: CustomColor.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      )),
                                  Text(widget.amount,
                                      style: GoogleFonts.inter(
                                        color: CustomColor
                                            .transactionDetailsTextColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20,
                                      )),
                                ],
                              ),
                            ),
                            Container(
                              margin:
                              const EdgeInsets.only(top: 10, bottom: 20),
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
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: Text('Detail Transaction',
                                        style: GoogleFonts.inter(
                                          color: CustomColor.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        )),
                                  ),
                                  if (widget.accountNumber.isNotEmpty)
                                    const SizedBox.shrink(),
                                  if (widget.accountNumber.isNotEmpty)
                                    DetailsRowWidget(
                                        label: "A/C:",
                                        value: widget.accountNumber),
                                  if (widget.bic.isNotEmpty)
                                    DetailsRowWidget(
                                        label: "BIC/SWIFT:", value: widget.bic),
                                  if (widget.iban.isNotEmpty)
                                    DetailsRowWidget(
                                        label: "IBAN", value: widget.iban),
                                  if (widget.ifsc.isNotEmpty)
                                    DetailsRowWidget(
                                        label: "IFSC", value: widget.ifsc),
                                  if (widget.bankCode.isNotEmpty)
                                    DetailsRowWidget(
                                        label: "Bank Code",
                                        value: widget.bankCode),
                                  if (widget.branchCode.isNotEmpty)
                                    DetailsRowWidget(
                                        label: "Branch Code",
                                        value: widget.branchCode),
                                  if (widget.aba.isNotEmpty)
                                    DetailsRowWidget(
                                        label: "Aba", value: widget.aba),
                                  if (widget.sortCode.isNotEmpty)
                                    DetailsRowWidget(
                                        label: "Sort Code",
                                        value: widget.sortCode),
                                  if (widget.clabe.isNotEmpty)
                                    DetailsRowWidget(
                                        label: "clabe", value: widget.clabe),
                                  if (widget.cnaps.isNotEmpty)
                                    DetailsRowWidget(
                                        label: "Cnaps", value: widget.cnaps),
                                  if (widget.bsbCode.isNotEmpty)
                                    DetailsRowWidget(
                                        label: "Bsb Code",
                                        value: widget.bsbCode),
                                  if (widget.institutionNo.isNotEmpty)
                                    DetailsRowWidget(
                                        label: "Institution No",
                                        value: widget.institutionNo),
                                  DetailsRowWidget(
                                      label: "Payment Type",
                                      value: widget.type),
                                  if (widget.commision.isNotEmpty)
                                    DetailsRowWidget(
                                        label: "Commissions",
                                        value: widget.commision),
                                  if (widget.refesnce.isNotEmpty)
                                    DetailsRowWidget(
                                        label: "Reference",
                                        value: widget.refesnce),
                                  if (widget.amount.isNotEmpty)
                                    DetailsRowWidget(
                                        label: "Amount", value: widget.amount),
                                  if (widget.exchangeAmount.isNotEmpty &&
                                      widget.provider != 'ccy')
                                    DetailsRowWidget(
                                        label: "Exchange Amount",
                                        value: widget.exchangeAmount),
                                  if (widget.exchangeRate.isNotEmpty &&
                                      widget.provider != 'ccy')
                                    DetailsRowWidget(
                                        label: "Exchange Rate",
                                        value: widget.exchangeRate),
                                  if (widget.trxFee.isNotEmpty)
                                    DetailsRowWidget(
                                        label: widget.trxLabel,
                                        value: widget.trxFee),
                                  if (widget.exchangeFee.isNotEmpty &&
                                      widget.provider != 'ccy')
                                    DetailsRowWidget(
                                        label: "Exchange Fee",
                                        value: widget.exchangeFee),
                                  if (widget.totalPay.isNotEmpty)
                                    DetailsRowWidget(
                                        label: "Your Total",
                                        value: widget.totalPay),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      PrimaryButtonWidget(
                        onPressed: buttonActive
                            ? () {
                          setState(() => buttonActive = false);
                          if (widget.isSwift) {
                            _transferBloc
                                .add(ApproveibanSwiftTransactionEvent(
                              uniqueId: widget.id,
                              completed: 'Completed',
                              lat: lat.toString(),
                              long: long.toString(),
                            ));
                          } else {
                            _transferBloc.add(ApproveibanTransactionEvent(
                              uniqueId: widget.id,
                              completed: 'Completed',
                              lat: lat.toString(),
                              long: long.toString(),
                            ));
                          }
                        }
                            : null,
                        buttonText: 'Transfer',
                      ),
                      const SizedBox(height: 12),
                      if (status == "Processing...")
                        Text("Verifying face...",
                            style: GoogleFonts.inter(fontSize: 12)),
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
        children: [
          Text(label,
              style: GoogleFonts.inter(
                color: CustomColor.transactionDetailsTextColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              )),
          Expanded(
            child: Text(value,
                textAlign: TextAlign.right,
                maxLines: 2,
                style: GoogleFonts.inter(
                  color: CustomColor.subtitleTextColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                )),
          ),
        ],
      ),
    );
  }
}
