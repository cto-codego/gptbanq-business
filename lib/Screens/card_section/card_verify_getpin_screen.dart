import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:gptbanqbusiness/Models/application.dart';
import 'package:gptbanqbusiness/Screens/Sign_up_screens/bloc/signup_bloc.dart';
import 'package:gptbanqbusiness/Screens/Sign_up_screens/touchID_screen.dart';
import 'package:gptbanqbusiness/constant_string/User.dart';
import 'package:gptbanqbusiness/constant_string/constant_strings.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:gptbanqbusiness/utils/location_serveci.dart';
import 'package:gptbanqbusiness/utils/user_data_manager.dart';
import 'package:gptbanqbusiness/utils/validator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:local_auth/local_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:seon_sdk_flutter_plugin/seon_sdk_flutter_plugin.dart';
import 'package:uuid/uuid.dart';

import '../../utils/assets.dart';
import '../../utils/custom_style.dart';
import '../../utils/input_fields/custom_color.dart';
import '../../utils/input_fields/custom_pincode_input_field_widget.dart';
import '../../utils/strings.dart';
import '../../widgets/toast/toast_util.dart';

class CardVerifyGetPinScreen extends StatefulWidget {
  const CardVerifyGetPinScreen({super.key});

  @override
  State<CardVerifyGetPinScreen> createState() => _CardVerifyGetPinScreenState();
}

class _CardVerifyGetPinScreenState extends State<CardVerifyGetPinScreen> {
  final _formkey = new GlobalKey<FormState>();
  final String seonSessionId = const Uuid().v4();
  String _seonSession = 'Unknown';
  bool _isLoading = false; // Add this state variable

  final _seonSdkFlutterPlugin = SeonSdkFlutterPlugin();

  TextEditingController _pincontrol = TextEditingController();

  SignupBloc _signupBloc = new SignupBloc();

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  FocusNode focusNode = FocusNode();
  LocalAuthentication _localAuthentication = LocalAuthentication();

  String currunttext = '';

  // Userstates _userstates = new Userstates();

  getIsUsingBiometricAuth() async {
    String isBioMetric = await UserDataManager().getIsUsingBiometricAuth();

    if (isBioMetric == '1') {
      await _authorizeNow();
    }
  }

  getNewToken() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    UserDataManager().getPin().then((pin) {
      _signupBloc.add(GetUserPinEvent(
          userpin: pin, version: packageInfo.version, seonData: _seonSession));
    });
  }

  void firebaseCloudMessaging_Listeners(BuildContext context) {
    iOS_Permission();

    _firebaseMessaging.getToken().then((token) {
      User.deviceToken = token;
      print("_123firebaseMessaging.getToken:  " + token!);
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) async {
      if (message != null) {
        print('on Lunch');

        if (message.notification != null) {
          if (message.data['category'] == 'current-location') {
            if (await Permission.location.isGranted) {
              Locationservece().getCurrentLocation();
            }
          }

          // User.notification=1;
          // User.remoteMessage= message;
        }
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // if(message.notification != null)
      //           {
      //             User.notification=1;
      //             User.remoteMessage= message;
      //           }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print('dashboard screen on onResume $message');

      if (message.notification != null) {
        if (message.data['category'] == 'current-location') {
          if (await Permission.location.isGranted) {
            Locationservece().getCurrentLocation();
          }
        }

        // User.notification=1;
        // User.remoteMessage= message;
      }
    });

    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
  }

  void iOS_Permission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true, badge: true, sound: true);

    print("123Settings registered: ${settings.authorizationStatus}");
  }

  Future<void> _authorizeNow() async {
    final canCheckBiometrics = await _localAuthentication.canCheckBiometrics;
    FocusScope.of(context).requestFocus(new FocusNode());

    if (canCheckBiometrics) {
      List<BiometricType> availableBiometricTypes =
          await _localAuthentication.getAvailableBiometrics();

      if (Platform.isIOS) {
        print("ABABA **************** iOS");

        if (availableBiometricTypes.contains(BiometricType.face)) {
          final isAuthenticated = await _localAuthentication.authenticate(
              localizedReason: ConstantStrings.SCAN_TOUCH_ID,
              options: const AuthenticationOptions(
                  stickyAuth: true, useErrorDialogs: true));

          if (isAuthenticated) {
            getNewToken();

            print("store data in storage");
          } else {
            print("Not authenticated");
          }
          // Face ID.
        } else if (availableBiometricTypes
            .contains(BiometricType.fingerprint)) {
          final isAuthenticated = await _localAuthentication.authenticate(
              localizedReason: ConstantStrings.SCAN_TOUCH_ID,
              options: const AuthenticationOptions(
                  stickyAuth: true, useErrorDialogs: true));

          if (isAuthenticated) {
            getNewToken();
          } else {
            print("Not authenticated");
          }

          // Touch ID.
        }
      } else if (Platform.isAndroid) {
        print("ABABA **************** Android");

        if (availableBiometricTypes.contains(BiometricType.strong)) {
          final isAuthenticated = await _localAuthentication.authenticate(
              localizedReason: ConstantStrings.SCAN_TOUCH_ID,
              options: const AuthenticationOptions(
                  stickyAuth: true, useErrorDialogs: true));

          if (isAuthenticated) {
            getNewToken();
          } else {
            print("Not authenticated");
          }
          // Face ID.
        } else if (availableBiometricTypes
            .contains(BiometricType.fingerprint)) {
          final isAuthenticated = await _localAuthentication.authenticate(
              localizedReason: ConstantStrings.SCAN_TOUCH_ID,
              options: const AuthenticationOptions(
                  stickyAuth: true, useErrorDialogs: true));

          if (isAuthenticated) {
            getNewToken();
          } else {
            print("Not authenticated");
          }
          // Touch ID.
        }
      }
    }
  }

  @override
  void initState() {
    firebaseCloudMessaging_Listeners(context);

    super.initState();

    try {
      _seonSdkFlutterPlugin.setGeolocationEnabled(true);
      _seonSdkFlutterPlugin.setGeolocationTimeout(500);
      getFingerprint();
    } catch (e) {
      debugPrint('$e');
    }
  }

  // Method to get fingerprint
  Future<void> getFingerprint() async {
    setState(() {
      _isLoading = true;
    });

    String fingerprint;
    try {
      fingerprint = await _seonSdkFlutterPlugin
              .getFingerprint("${Strings.appName}-$seonSessionId") ??
          'Error getting fingerprint';
    } catch (e) {
      fingerprint = 'Failed to get fingerprint $e';
    }

    if (!mounted) return;

    setState(() {
      _seonSession = fingerprint;
      debugPrint(
          "Seon session ID ---------- ${Strings.appName}-$seonSessionId");
      debugPrint("Seon fingerprint ---------- $_seonSession");
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColor.scaffoldBg,
        resizeToAvoidBottomInset: false,
        body: BlocListener(
            bloc: _signupBloc,
            listener: (context, SignupState state) {
              debugPrint(
                  "------------------------------------testing ap-------------------");
              debugPrint(state.userGetPinModel?.status.toString());
              debugPrint(
                  "------------------------------------testing ap-------------------");
              if (state.userGetPinModel?.status == 1) {
                User.isIban = state.userGetPinModel?.isIban;
                User.hidepage = state.userGetPinModel!.hidepage!;
                User.isEu = state.userGetPinModel!.isEu!;

                debugPrint(
                    "------------------------------------testing ap-------------------");
                // debugPrint(_userstates.user.toString());
                debugPrint(
                    "------------------------------------testing ap-------------------");
                // Navigator.pushNamedAndRemoveUntil(
                //     context, 'debitCardScreen', (route) => false);
                Navigator.of(context).pop(true);
              } else if (state.userGetPinModel?.status == 0) {
                CustomToast.showError(
                    context, "Sorry!", state.userGetPinModel!.message!);
              }
              // TODO: implement listener
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
                            const EdgeInsets.only(left: 25, right: 25, top: 40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 100,
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                'Enter 4-digit Pin',
                                style: CustomStyle.loginVerifyTitleTextStyle,
                              ),
                            ),
                            const SizedBox(
                              height: 32,
                            ),
                            Form(
                                key: _formkey,
                                child: CustomPinCodeInputFieldWidget(
                                  appContext: context,
                                  controller: _pincontrol,
                                  onCompleted: (v) async {
                                    debugPrint("Completed");
                                    PackageInfo packageInfo =
                                        await PackageInfo.fromPlatform();

                                    String showNumber = await UserDataManager()
                                        .getCardNumberShow();

                                    showNumber == "false"
                                        ? UserDataManager()
                                            .cardNumberShowSave("true")
                                        : UserDataManager()
                                            .cardNumberShowSave("false");

                                    _signupBloc.add(GetUserPinEvent(
                                        userpin: _pincontrol.text,
                                        version: packageInfo.version,
                                        seonData: _seonSession));
                                  },
                                  validator: (value) {
                                    return Validator.validateValues(
                                        value:
                                            value!); // Replace with your validation logic
                                  },
                                )),
                            const SizedBox(
                              height: 72,
                            ),
                            Application.isBiometricsSupported
                                ? InkWell(
                                    onTap: () {
                                      Application.isBioMetric == '1'
                                          ? getIsUsingBiometricAuth()
                                          : UserDataManager()
                                              .getPin()
                                              .then((pin) => Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          TouchidScreen(
                                                        userPin: pin,
                                                      ),
                                                    ),
                                                  ));
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: SvgPicture.asset(
                                        StaticAssets.fingerprint,
                                        width: 100,
                                        height: 100,
                                      ),
                                    ),
                                  )
                                : Container(),
                            const SizedBox(
                              height: 24,
                            ),
                            Application.isBiometricsSupported
                                ? Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Use Finger Print or Face ID',
                                      textAlign: TextAlign.center,
                                      style:
                                          CustomStyle.setPinSubTitleTextStyle,
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                      ),
                    ),
                  );
                })));
  }
}

Future myBackgroundMessageHandler(RemoteMessage message) async {
  if (message.data.isNotEmpty) {
    // Handle data message
    print('get pin screen on myBackgroundMessageHandler   $message');
    // final dynamic data = message.data;
    if (message.data['category'] == 'current-location') {
      if (await Permission.location.isGranted) {
        Locationservece().getCurrentLocation();
      }
    }

    // User.notification=1;
    // User.remoteMessage= message;
  }

  if (message.notification != null) {
    // Handle notification message
    print('get pin on myBackgroundMessageHandler   $message');
    // final dynamic notification = message.notification;

    if (message.data['category'] == 'current-location') {
      if (await Permission.location.isGranted) {
        Locationservece().getCurrentLocation();
      }
    }
  }

  // Or do other work.
}
