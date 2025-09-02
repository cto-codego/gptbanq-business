import 'dart:async';

import 'package:gptbanqbusiness/Screens/Sign_up_screens/bloc/signup_bloc.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:gptbanqbusiness/utils/assets.dart';
import 'package:gptbanqbusiness/utils/user_data_manager.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/input_fields/custom_color.dart';
import '../../../utils/strings.dart';
import '../../../widgets/buttons/primary_button_widget.dart';
import '../../../widgets/custom_image_widget.dart';
import '../bloc/Signup_respotary.dart';

class KycWelcomeScreen extends StatefulWidget {
  const KycWelcomeScreen({super.key});

  @override
  State<KycWelcomeScreen> createState() => _KycWelcomeScreenState();
}

class _KycWelcomeScreenState extends State<KycWelcomeScreen> {
  SignupRespo signupRespo = SignupRespo();
  bool completed = false;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final SignupBloc _signupBloc = SignupBloc();

  String token = "";
  String message = "";

  @override
  void initState() {
    super.initState();

    userData();
    firebaseCloudMessaging_Listeners(context);
  }

  Future<void> userData() async {
    String fetchedToken = await UserDataManager().getUserSumSubToken();
    String fetchedMessage = await UserDataManager().getStatusMessage();

    setState(() {
      token = fetchedToken;
      message = fetchedMessage;
    });
  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColor.scaffoldBg,
        resizeToAvoidBottomInset: false,
        body: BlocListener(
          bloc: _signupBloc,
          listener: (context, SignupState state) async {},
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
                          const EdgeInsets.only(left: 16, right: 16, top: 40),
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : Column(
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // MainLogoWidget(
                                      //   width: double.maxFinite,
                                      // ),
                                      CustomImageWidget(
                                        imagePath: StaticAssets.kycWelcome,
                                        imageType: 'svg',
                                        height: 250,
                                      ),
                                      const SizedBox(
                                        height: 50,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            Strings.kycWelcomeTitle,
                                            style: GoogleFonts.inter(
                                                color: CustomColor.black,
                                                fontSize: 28,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        // message,
                                        Strings.kycWelcomeSubTitle,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.inter(
                                            color: CustomColor.primaryInputHintBorderColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                      )
                                    ],
                                  ),
                                ),
                                PrimaryButtonWidget(
                                  onPressed: () {
                                    Navigator.pushNamedAndRemoveUntil(context,
                                        'kycStartScreen', (route) => false);
                                  },
                                  buttonText: 'Continue',
                                ),
                                const SizedBox(
                                  height: 10,
                                )
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
