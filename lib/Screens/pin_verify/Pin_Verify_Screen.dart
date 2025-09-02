import 'dart:io';

import 'package:gptbanqbusiness/constant_string/constant_strings.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:gptbanqbusiness/utils/custom_scroll_behavior.dart';
import 'package:gptbanqbusiness/utils/user_data_manager.dart';
import 'package:gptbanqbusiness/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:local_auth/local_auth.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class CardPinVerifyScreen extends StatefulWidget {
  CardPinVerifyScreen();

  @override
  _TransactionPinVerifyScreenState createState() =>
      _TransactionPinVerifyScreenState();
}

class _TransactionPinVerifyScreenState extends State<CardPinVerifyScreen> {
  int secondsCountDown = 60;
  TextEditingController controller = TextEditingController(text: "");
  String thisText = "";
  int pinLength = 4;
  bool hasError = false;
  String? errorMessage;
  final TextEditingController _pinEditingController =
      TextEditingController(text: '');


  String isUsingBiometric = '0';
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  getIsUsingBiometricAuth() async {
    String isBioMetric = await UserDataManager().getIsUsingBiometricAuth();

    if (isBioMetric == '1') {
      await _authorizeNow();
    }
  }

  Future<void> _authorizeNow() async {
    final canCheckBiometrics = await _localAuthentication.canCheckBiometrics;
    FocusScope.of(context).requestFocus(FocusNode());

    if (canCheckBiometrics) {
      List<BiometricType> availableBiometricTypes =
          await _localAuthentication.getAvailableBiometrics();

      if (Platform.isIOS) {
        debugPrint("ABABA **************** iOS");

        if (availableBiometricTypes.contains(BiometricType.strong) ||
            availableBiometricTypes.contains(BiometricType.face)) {
          final isAuthenticated = await _localAuthentication.authenticate(
              localizedReason: ConstantStrings.SCAN_TOUCH_ID,
              options: const AuthenticationOptions(stickyAuth: true));

          if (isAuthenticated) {
            Navigator.pop(context, true);

            debugPrint("store data in storage");
          } else {
            debugPrint("Not authenticated");
          }
          // Face ID.
        } else if (availableBiometricTypes
                .contains(BiometricType.fingerprint) ||
            availableBiometricTypes.contains(BiometricType.fingerprint)) {
          final isAuthenticated = await _localAuthentication.authenticate(
            localizedReason: ConstantStrings.SCAN_TOUCH_ID,
            options: const AuthenticationOptions(stickyAuth: true),
          );

          if (isAuthenticated) {
            Navigator.pop(context, true);
          } else {
            debugPrint("Not authenticated");
          }

          // Touch ID.
        }
      } else if (Platform.isAndroid) {
        debugPrint("ABABA **************** Android");

        if (availableBiometricTypes.contains(BiometricType.face) ||
            availableBiometricTypes.contains(BiometricType.strong)) {
          final isAuthenticated = await _localAuthentication.authenticate(
              localizedReason: ConstantStrings.SCAN_TOUCH_ID,
              options: const AuthenticationOptions(stickyAuth: true));

          if (isAuthenticated) {
            Navigator.pop(context, true);
          } else {
            debugPrint("Not authenticated");
          }
          // Face ID.
        } else if (availableBiometricTypes
                .contains(BiometricType.fingerprint) ||
            availableBiometricTypes.contains(BiometricType.strong)) {
          final isAuthenticated = await _localAuthentication.authenticate(
              localizedReason: ConstantStrings.SCAN_TOUCH_ID,
              options: const AuthenticationOptions(stickyAuth: true));

          if (isAuthenticated) {
            Navigator.pop(context, true);
          } else {
            debugPrint("Not authenticated");
          }
          // Touch ID.
        }
      }
    }
  }

  @override
  void initState() {
    getIsUsingBiometricAuth();

    _pinEditingController.addListener(() {
      debugPrint('controller execute. pin:${_pinEditingController.text}');
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
          statusBarColor: Color(0xffFAFAFA),
          systemNavigationBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Color(0xffFAFAFA),
        ),
        child: Scaffold(
            backgroundColor: const Color(0xffFAFAFA),
            body: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: SafeArea(
                    child: ProgressHUD(
                      inAsyncCall: false,
                      child: SizedBox(
                        height: double.maxFinite,
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                  right: 20, left: 20, top: 50),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: SizedBox(
                                        width: 30,
                                        child: Image.asset(
                                            'images/backarrow.png')),
                                  ),
                                  const Expanded(
                                      child: Center(
                                    child: Text(
                                      'Pin Verification',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontFamily: 'pop',
                                          fontWeight: FontWeight.w600),
                                    ),
                                  )),
                                  Container(
                                    width: 30,
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height,
                                child: ScrollConfiguration(
                                  behavior: CustomScrollBehavior(),
                                  child: ListView(
                                    physics: const ScrollPhysics(),
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(
                                            left: 30, right: 30),
                                        child: ListView(
                                          shrinkWrap: true,
                                          physics: const ScrollPhysics(),
                                          children: <Widget>[
                                            const SizedBox(height: 46),
                                            const Text(
                                              'Please enter the 4 digit code to verify.',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 37),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Center(
                                                child: PinCodeTextField(
                                                  appContext: context,
                                                  pastedTextStyle:
                                                      const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                          fontFamily: 'pop'),
                                                  length: 4,
                                                  obscureText: true,
                                                  textStyle: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 16,
                                                      fontFamily: 'pop'),

                                                  blinkWhenObscuring: true,
                                                  backgroundColor:
                                                      Colors.transparent,

                                                  animationType:
                                                      AnimationType.fade,
                                                  autoUnfocus: true,
                                                  autoFocus: true,
                                                  validator: (value) {
                                                    return Validator
                                                        .validateValues(
                                                      value: value,
                                                    );
                                                  },
                                                  pinTheme: PinTheme(
                                                    shape:
                                                        PinCodeFieldShape.box,
                                                    disabledColor:
                                                        Colors.transparent,
                                                    activeColor: Colors.black,
                                                    selectedColor: Colors.black,
                                                    inactiveColor: Colors.black,
                                                    inactiveFillColor:
                                                        Colors.transparent,
                                                    selectedFillColor:
                                                        Colors.transparent,
                                                    fieldOuterPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 4),
                                                    borderWidth: 1,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    fieldHeight: 45,
                                                    fieldWidth: 45,
                                                    activeFillColor:
                                                        Colors.transparent,
                                                  ),
                                                  cursorColor: Colors.white,
                                                  animationDuration:
                                                      const Duration(
                                                          milliseconds: 300),
                                                  enableActiveFill: true,
                                                  controller:
                                                      _pinEditingController,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,

                                                  onCompleted: (v) async {
                                                    debugPrint("Completed");

                                                    if (_pinEditingController
                                                            .text.length ==
                                                        4) {
                                                      debugPrint(
                                                          "Pin Code *** : ${_pinEditingController.text}");

                                                      String userPin =
                                                          await UserDataManager()
                                                              .getPin();
                                                      debugPrint(
                                                          'userPin: $userPin');
                                                      if (userPin ==
                                                          _pinEditingController
                                                              .text) {

                                                        Navigator.pop(
                                                            context, true);
                                                      } else {
                                                        var snackBar =
                                                            const SnackBar(
                                                                content: Text(
                                                                    "Pin does not matched"));
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                snackBar);
                                                      }
                                                    }
                                                  },
                                                  // onTap: () {
                                                  //   print("Pressed");
                                                  // },
                                                  onChanged: (value) {},

                                                  enablePinAutofill: false,
                                                  errorTextMargin:
                                                      const EdgeInsets.only(
                                                          top: 10),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )))));
  }
}
