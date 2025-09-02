import 'dart:async';
import 'package:gptbanqbusiness/Screens/update_doc_section/bloc/update_doc_bloc.dart';
import 'package:gptbanqbusiness/Screens/update_doc_section/bloc/update_doc_repo.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:gptbanqbusiness/utils/assets.dart';
import 'package:gptbanqbusiness/widgets/custom_image_widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constant_string/User.dart';
import '../../../utils/input_fields/custom_color.dart';
import '../../../utils/strings.dart';
import '../../../widgets/buttons/primary_button_widget.dart';
import '../../../widgets/main_logo_widget.dart';

class UpdateDocScreen extends StatefulWidget {
  const UpdateDocScreen({super.key});

  @override
  State<UpdateDocScreen> createState() => _UpdateDocScreenState();
}

class _UpdateDocScreenState extends State<UpdateDocScreen> {
  // SNSMobileSDK? snsMobileSDK;
  bool completed = false;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  UpdateDocBloc _updateDocBloc = UpdateDocBloc();
  UpdateDocRepo updateDocRepo = UpdateDocRepo();

  String message = "";
  Color idProofIconColor = CustomColor.kycContainerBgColor;
  String idProofTick = StaticAssets.arrowRight;
  String idProofMessage = "Resubmit your Id Proof";
  Color addressProofIconColor = CustomColor.kycContainerBgColor;
  String addressProofTick = StaticAssets.arrowRight;

  String addressProofMessage = "Resubmit your address proof";
  Color selfieIconColor = CustomColor.kycContainerBgColor;
  String selfieTick = StaticAssets.arrowRight;
  String selfieMessage = "Resubmit your selfie";
  int updateDocStatus = User.updateDocStatus;

  int docStatusCheck = 0;
  int docTypeStatusCheck = 4;
  String userUniqueId = "";

  Timer? _statusTimer;

  @override
  void initState() {
    super.initState();
    _updateDocBloc.add(UpdateDocCheckStatusEvent());
  }

  void _startStatusTimer() {
    if (_statusTimer != null && _statusTimer!.isActive)
      return; // Don't start again

    _statusTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      _updateDocBloc.add(UpdateDocCheckStatusEvent());
      print('API called every 1 minute because docStatus == 1');
    });
  }

  void _stopStatusTimer() {
    _statusTimer?.cancel();
    _statusTimer = null;
  }

  @override
  void dispose() {
    _stopStatusTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColor.scaffoldBg,
        resizeToAvoidBottomInset: false,
        body: BlocListener(
          bloc: _updateDocBloc,
          listener: (context, UpdateDocState state) async {
            if (state.updateDocCheckModel?.status == 1) {
              setState(() {
                docStatusCheck =
                    state.updateDocCheckModel!.updateDocData!.docStatus!;
                docTypeStatusCheck =
                    state.updateDocCheckModel!.updateDocData!.docTypeStatus!;
                userUniqueId =
                    state.updateDocCheckModel!.updateDocData!.uniqueId!;
                User.updateUniqueId =
                    state.updateDocCheckModel!.updateDocData!.uniqueId!;
                User.updateDocTypeStatus = state
                    .updateDocCheckModel!.updateDocData!.docTypeStatus!
                    .toString();

                print(docStatusCheck.toString() +
                    docTypeStatusCheck.toString() +
                    userUniqueId);
              });
            }

            if (state.updateDocCheckModel?.updateDocData!.docStatus! == 1) {
              _startStatusTimer();
            } else if (state.updateDocCheckModel?.updateDocData!.docStatus! ==
                3) {
              Navigator.pushNamedAndRemoveUntil(
                  context, 'dashboard', (route) => false);
            }
          },
          child: BlocBuilder(
              bloc: _updateDocBloc,
              builder: (context, UpdateDocState state) {
                return SafeArea(
                  child: ProgressHUD(
                    inAsyncCall: state.isloading,
                    child: Container(
                      width: double.maxFinite,
                      height: double.maxFinite,
                      padding:
                          const EdgeInsets.only(left: 16, right: 16, top: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          docStatusCheck == 1
                              ? Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 34,
                                        alignment: Alignment.center,
                                        child: Image.asset(
                                          'images/applogo.png',
                                          height: 34,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 42,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                state.updateDocCheckModel!
                                                    .updateDocData!.message!,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'pop',
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 50,
                                    ),
                                    Center(
                                      child: MainLogoWidget(
                                        width: 250.w,
                                        height: 120.h,
                                      ),
                                    ),

                                    Text(
                                      Strings.updateDocTitle,
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.inter(
                                          color: CustomColor.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      Strings.updateDocSubTitle,
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.inter(
                                          color: CustomColor
                                              .primaryInputHintBorderColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),

                                    //id proof
                                    if ((docStatusCheck == 0 ||
                                            docStatusCheck == 2) &&
                                        docTypeStatusCheck == 1)
                                      Container(
                                        alignment: Alignment.center,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: idProofIconColor,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: CustomColor
                                                .primaryInputHintBorderColor,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      CustomImageWidget(
                                                        imagePath:
                                                            StaticAssets.icDoc,
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
                                                              Strings
                                                                  .identityDocuments,
                                                              maxLines: 1,
                                                              style: GoogleFonts
                                                                  .inter(
                                                                color: CustomColor
                                                                    .black,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                            Text(
                                                              idProofMessage,
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: GoogleFonts
                                                                  .inter(
                                                                color: CustomColor
                                                                    .primaryInputHintBorderColor,
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            CustomImageWidget(
                                              imagePath: idProofTick,
                                              imageType: 'svg',
                                              height: 20,
                                            ),
                                          ],
                                        ),
                                      ),

                                    //address proof
                                    if ((docStatusCheck == 0 ||
                                            docStatusCheck == 2) &&
                                        docTypeStatusCheck == 2)
                                      Container(
                                          alignment: Alignment.center,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          decoration: BoxDecoration(
                                              color: addressProofIconColor,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: CustomColor
                                                    .primaryInputHintBorderColor,
                                              )),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        CustomImageWidget(
                                                          imagePath: StaticAssets
                                                              .addressProof,
                                                          imageType: 'svg',
                                                          height: 25,
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                Strings
                                                                    .addressProof,
                                                                maxLines: 1,
                                                                style: GoogleFonts.inter(
                                                                    color:
                                                                        CustomColor
                                                                            .black,
                                                                    fontSize: 16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                              Text(
                                                                addressProofMessage,
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: GoogleFonts.inter(
                                                                    color: CustomColor
                                                                        .primaryInputHintBorderColor,
                                                                    fontSize: 13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              CustomImageWidget(
                                                imagePath: addressProofTick,
                                                imageType: 'svg',
                                                height: 20,
                                              ),
                                            ],
                                          )),

                                    //selfie
                                    if ((docStatusCheck == 0 ||
                                            docStatusCheck == 2) &&
                                        (docTypeStatusCheck == 3 ||
                                            docTypeStatusCheck == 1))
                                      Container(
                                          alignment: Alignment.center,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          decoration: BoxDecoration(
                                              color: selfieIconColor,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: CustomColor
                                                    .primaryInputHintBorderColor,
                                              )),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        CustomImageWidget(
                                                          imagePath:
                                                              StaticAssets.selfie,
                                                          imageType: 'svg',
                                                          height: 25,
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                Strings.selfies,
                                                                maxLines: 1,
                                                                style: GoogleFonts.inter(
                                                                    color:
                                                                        CustomColor
                                                                            .black,
                                                                    fontSize: 16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                              Text(
                                                                selfieMessage,
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: GoogleFonts.inter(
                                                                    color: CustomColor
                                                                        .primaryInputHintBorderColor,
                                                                    fontSize: 13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              CustomImageWidget(
                                                imagePath: selfieTick,
                                                imageType: 'svg',
                                                height: 20,
                                              ),
                                            ],
                                          )),

                                    if (state.updateDocCheckModel!.updateDocData!
                                            .message!.isNotEmpty &&
                                        docStatusCheck != 2)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (state.updateDocCheckModel!
                                              .updateDocData!.message!.isNotEmpty)
                                            SizedBox(
                                              width: 30,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4,
                                                        horizontal: 5),
                                                child: CustomImageWidget(
                                                  imagePath: StaticAssets.info,
                                                  imageType: 'svg',
                                                  height: 13,
                                                ),
                                              ),
                                            ),
                                          Expanded(
                                            child: Text(
                                              state.updateDocCheckModel!
                                                  .updateDocData!.message!,
                                              textAlign: TextAlign.start,
                                              style: GoogleFonts.inter(
                                                  color: Color(0xff393939),
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      ),
                                    if (docStatusCheck == 2)
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 0, right: 0, top: 20),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(52.58),
                                            color: CustomColor.errorColor
                                                .withOpacity(0.2),
                                            border: Border.all(
                                                color: CustomColor.whiteColor,
                                                width: 2)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            if (docStatusCheck == 2)
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 10, vertical: 10),
                                                padding: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: CustomColor.errorColor,
                                                ),
                                                child: CustomImageWidget(
                                                  imagePath: StaticAssets.warning,
                                                  imageType: 'svg',
                                                  height: 16,
                                                ),
                                              ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(right: 8),
                                                child: Text(
                                                  state
                                                      .updateDocCheckModel!
                                                      .updateDocData!
                                                      .rejectedReason!,
                                                  textAlign: TextAlign.left,
                                                  style: GoogleFonts.inter(
                                                      color:
                                                          CustomColor.errorColor,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                          if (docStatusCheck == 0 || docStatusCheck == 2)
                            PrimaryButtonWidget(
                              onPressed: () {
                                if (docTypeStatusCheck == 1) {
                                  Navigator.pushNamedAndRemoveUntil(context,
                                      'updateIdProofScreen', (route) => false);
                                } else if (docTypeStatusCheck == 2) {
                                  Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      'updateAddressProofScreen',
                                      (route) => false);
                                } else if (docTypeStatusCheck == 3) {
                                  Navigator.pushNamedAndRemoveUntil(context,
                                      'updateFaceProofScreen', (route) => false);
                                } else {
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, '/', (route) => false);
                                }
                              },
                              buttonText: 'Continue',
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ));
  }

// Or do other work.
}
