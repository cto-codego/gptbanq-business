import 'dart:async';
import 'package:gptbanqbusiness/Screens/Sign_up_screens/bloc/signup_bloc.dart';
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
import '../bloc/Signup_respotary.dart';

class KycStartScreen extends StatefulWidget {
  const KycStartScreen({super.key});

  @override
  State<KycStartScreen> createState() => _KycStartScreenState();
}

class _KycStartScreenState extends State<KycStartScreen> {
  // SNSMobileSDK? snsMobileSDK;
  bool completed = false;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final SignupBloc _signupBloc = SignupBloc();
  SignupRespo signupRespo = SignupRespo();

  String message = "";
  Color idProofIconColor = CustomColor.kycContainerBgColor;
  String idProofTick = StaticAssets.arrowRight;
  String idProofMessage = "";
  Color addressProofIconColor = CustomColor.kycContainerBgColor;
  String addressProofTick = StaticAssets.arrowRight;

  String addressProofMessage = "";
  Color selfieIconColor = CustomColor.kycContainerBgColor;
  String selfieTick = StaticAssets.arrowRight;
  String selfieMessage = "";

  @override
  void initState() {
    super.initState();
    firebaseCloudMessaging_Listeners(context);
    _signupBloc.add(UserKycCheckStatusEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColor.scaffoldBg,
        resizeToAvoidBottomInset: false,
        body: BlocListener(
          bloc: _signupBloc,
          listener: (context, SignupState state) async {
            if (state.userKycCheckStatusModel?.status == 1) {
              //pending
              message = state.userKycCheckStatusModel!.message.toString();
              User.showAddressProof = state.userKycCheckStatusModel!.isWallet!;
            } else if (state.userKycCheckStatusModel?.status == 2) {
              //under review
              message = state.userKycCheckStatusModel!.message.toString();
              User.showAddressProof = state.userKycCheckStatusModel!.isWallet!;
            } else if (state.userKycCheckStatusModel?.status == 3) {
              //rejected
              message = state.userKycCheckStatusModel!.message.toString();
              User.showAddressProof = state.userKycCheckStatusModel!.isWallet!;
            } else if (state.userKycCheckStatusModel?.status == 4) {
              //verified
              message = state.userKycCheckStatusModel!.message.toString();
              User.showAddressProof = state.userKycCheckStatusModel!.isWallet!;
            }

            if (state.userKycCheckStatusModel?.idproof == 0) {
              idProofIconColor = CustomColor.whiteColor;
              idProofTick = StaticAssets.arrowRight;
              idProofMessage = Strings.identityDocumentsSubTitle;
            } else if (state.userKycCheckStatusModel?.idproof == 1) {
              idProofIconColor = CustomColor.kycContainerBgColor;
              idProofTick = StaticAssets.tick;
              idProofMessage = "Submitted";
            } else if (state.userKycCheckStatusModel?.idproof == 2) {
              idProofIconColor = CustomColor.kycContainerBgColor;
              idProofTick = StaticAssets.tick;
              idProofMessage = "Completed";
            }

            if (state.userKycCheckStatusModel?.addressproof == 0) {
              addressProofIconColor = CustomColor.whiteColor;
              addressProofTick = StaticAssets.arrowRight;
              addressProofMessage = Strings.addressProofSubTitle;
            } else if (state.userKycCheckStatusModel?.addressproof == 1) {
              addressProofIconColor = CustomColor.kycContainerBgColor;
              addressProofTick = StaticAssets.tick;

              addressProofMessage = "Submitted";
            } else if (state.userKycCheckStatusModel?.addressproof == 2) {
              addressProofIconColor = CustomColor.kycContainerBgColor;
              addressProofTick = StaticAssets.tick;

              addressProofMessage = "Completed";
            }

            if (state.userKycCheckStatusModel?.selfie == 0) {
              selfieIconColor = CustomColor.whiteColor;
              selfieTick = StaticAssets.arrowRight;
              selfieMessage = Strings.selfiesSubTitle;
            } else if (state.userKycCheckStatusModel?.selfie == 1) {
              selfieIconColor = CustomColor.kycContainerBgColor;
              selfieTick = StaticAssets.tick;

              selfieMessage = "Submitted";
            } else if (state.userKycCheckStatusModel?.selfie == 2) {
              selfieIconColor = CustomColor.kycContainerBgColor;
              selfieTick = StaticAssets.tick;

              selfieMessage = "Completed";
            }

            if (state.kycSubmitModel?.status == 1) {
              Navigator.pushNamedAndRemoveUntil(
                  context, 'kycStartScreen', (route) => false);
            }
          },
          child: BlocBuilder(
              bloc: _signupBloc,
              builder: (context, SignupState state) {
                return SafeArea(
                  child: ProgressHUD(
                    inAsyncCall: state.isloading,
                    child: Container(
                      width: double.maxFinite,
                      height: double.maxFinite,
                      padding:
                          const EdgeInsets.only(left: 16, right: 16, top: 30),
                      child: Column(
                        children: [
                          Expanded(
                            child: Column(
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
                                  Strings.kycStartTitle,
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.inter(
                                      color: CustomColor.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  Strings.kycStartSubTitle,
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.inter(
                                      color:
                                          CustomColor.primaryInputHintBorderColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.symmetric(vertical: 5),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: idProofIconColor,
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
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CustomImageWidget(
                                                  imagePath: StaticAssets.icDoc,
                                                  imageType: 'svg',
                                                  height: 25,
                                                ),
                                                const SizedBox(width: 5),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        Strings.identityDocuments,
                                                        style: GoogleFonts.inter(
                                                          color:
                                                              CustomColor.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      Text(
                                                        idProofMessage,
                                                        maxLines: 2,
                                                        overflow:
                                                            TextOverflow.ellipsis,
                                                        style: GoogleFonts.inter(
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
                                if (User.showAddressProof == 0)
                                  Container(
                                      alignment: Alignment.center,
                                      margin:
                                          const EdgeInsets.symmetric(vertical: 5),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      decoration: BoxDecoration(
                                          color: addressProofIconColor,
                                          borderRadius: BorderRadius.circular(12),
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
                                                      CrossAxisAlignment.start,
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
                                                            Strings.addressProof,
                                                            style: GoogleFonts.inter(
                                                                color: CustomColor
                                                                    .black,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          Text(
                                                            addressProofMessage,
                                                            maxLines: 2,
                                                            overflow: TextOverflow
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

                                Container(
                                    alignment: Alignment.center,
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    decoration: BoxDecoration(
                                        color: selfieIconColor,
                                        borderRadius: BorderRadius.circular(12),
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
                                                    CrossAxisAlignment.start,
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
                                                          style:
                                                              GoogleFonts.inter(
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
                                                          maxLines: 2,
                                                          overflow: TextOverflow
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
                                        message,
                                        textAlign: TextAlign.start,
                                        style: GoogleFonts.inter(
                                            color: Color(0xff393939),
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          state.userKycCheckStatusModel?.status == 2
                              ? Container()
                              : state.userKycCheckStatusModel?.isSubmit == 1
                                  ? PrimaryButtonWidget(
                                      onPressed: () {
                                        if (User.showAddressProof == 1) {
                                          _signupBloc
                                              .add(KycSubmitIsWalletEvent());
                                        } else if (User.showAddressProof == 0) {
                                          _signupBloc.add(KycSubmitEvent());
                                        } else {
                                          _signupBloc.add(KycSubmitEvent());
                                        }
                                      },
                                      buttonText: 'Submit',
                                    )
                                  : PrimaryButtonWidget(
                                      onPressed: () {
                                        int? idProof = state
                                            .userKycCheckStatusModel?.idproof;
                                        int? addressProof = state
                                            .userKycCheckStatusModel
                                            ?.addressproof;
                                        int? selfie =
                                            state.userKycCheckStatusModel?.selfie;
                                        if (idProof == 0) {
                                          Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              'kycScreen',
                                              (route) => false);
                                        } else if (addressProof == 0) {
                                          Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              'addressProofScreen',
                                              (route) => false);
                                        } else if (selfie == 0) {
                                          Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              'faceProofScreen',
                                              (route) => false);
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

  void iOS_Permission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true, badge: true, sound: true);

    debugPrint("123Settings registered: ${settings.authorizationStatus}");
  }

  void firebaseCloudMessaging_Listeners(BuildContext context) {
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        debugPrint(' kyc terminated');
        try {
          if (message.notification != null) {
            if (message.data['category'] == 'kyc_verified') {
              Navigator.pushNamedAndRemoveUntil(
                  context, 'setpin', (route) => false);
            } else if (message.data['category'] == 'kyc_rejected') {
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            }
          }
        } catch (e) {
          debugPrint(e.toString());
        }
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('A new onmessage event was published!');

      debugPrint('message *** ${message.data}');

      try {
        if (message.notification != null) {
          debugPrint(message.data['category']);

          if (message.data['category'] == 'kyc_verified') {
            Navigator.pushNamedAndRemoveUntil(
                context, 'setpin', (route) => false);
          } else if (message.data['category'] == 'kyc_rejected') {
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          }
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    });

    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('A new onMessageOpenedApp event was published!');

      try {
        if (message.notification != null) {
          if (message.data['category'] == 'kyc_verified') {
            Navigator.pushNamedAndRemoveUntil(
                context, 'setpin', (route) => false);
          } else if (message.data['category'] == 'kyc_rejected') {
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          }
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    });
  }
}

Future myBackgroundMessageHandler(RemoteMessage message) async {
  if (message.data.isNotEmpty) {
    // Handle data message
    debugPrint(
        'dashboard screen on myBackgroundMessageHandler dashboed $message');
    // final dynamic data = message.data;
  }

  if (message.notification != null) {
    // Handle notification message
    debugPrint(
        'dashboard screen on myBackgroundMessageHandler dashbord $message');
    // final dynamic notification = message.notification;
  }

  // Or do other work.
}
