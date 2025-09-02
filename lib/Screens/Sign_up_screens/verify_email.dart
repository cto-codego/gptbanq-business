import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:gptbanqbusiness/Screens/Sign_up_screens/bloc/signup_bloc.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:gptbanqbusiness/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:seon_sdk_flutter_plugin/seon_sdk_flutter_plugin.dart';

import '../../Config/bloc/app_bloc.dart';
import '../../Config/bloc/app_respotary.dart';
import '../../utils/user_data_manager.dart';

class VerifyemailScreen extends StatefulWidget {
  const VerifyemailScreen({super.key});

  @override
  State<VerifyemailScreen> createState() => _VerifyemailScreenState();
}

class _VerifyemailScreenState extends State<VerifyemailScreen> {
  final _formkey = new GlobalKey<FormState>();

  final TextEditingController _pincontrol = TextEditingController();

  bool completed = false;
  final SignupBloc _signupBloc = SignupBloc();
  String _seonSession = 'Unknown';
  final _seonSdkFlutterPlugin = SeonSdkFlutterPlugin();

  AppRespo appRespo = AppRespo();
  final AppBloc _appBloc = AppBloc();

  @override
  void initState() {
    UserDataManager().clearUserIbanData();
    _seonSdkFlutterPlugin.setGeolocationEnabled(true);
    _seonSdkFlutterPlugin.setGeolocationTimeout(500);
    getFingerprint();

    appRespo.getUserStatus();
    _appBloc.add(UserstatusEvent());
    super.initState();
  }

  // Method to get fingerprint
  Future<void> getFingerprint() async {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
            statusBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Colors.white),
        child: BlocListener(
            bloc: _signupBloc,
            listener: (context, SignupState state) {
              if (state.statusModel?.status == 0) {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.error,
                  animType: AnimType.rightSlide,
                  desc: state.statusModel?.message,
                  btnCancelText: 'OK',
                  buttonsTextStyle: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'pop',
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                  btnCancelOnPress: () {},
                ).show();
              } else if (state.statusModel?.status == 1) {
                print(_seonSession.toString());
                _signupBloc
                    .add(SignupPersonalDataEvent());
              }

              if (state.signUpResponseModel?.status == 1) {
                // Navigator.pushNamedAndRemoveUntil(
                //     context, 'firstkyc', (route) => false);

                _signupBloc.add(KycGetUserStatusEvent());
              } else if (state.signUpResponseModel?.status == 0) {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.error,
                  animType: AnimType.rightSlide,
                  desc: state.signUpResponseModel?.message,
                  btnCancelText: 'OK',
                  buttonsTextStyle: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'pop',
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                  btnCancelOnPress: () {},
                ).show();
              }

              if (state.getKycUserStatusModel?.status == 5 ||
                  state.getKycUserStatusModel!.sendlink == 2) {
                Navigator.pushNamedAndRemoveUntil(
                    context, 'kycScreen', (route) => false);

                // _signupBloc.add(KycGetUserStatusEvent());
              } else if (state.signUpResponseModel?.status == 0) {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.error,
                  animType: AnimType.rightSlide,
                  desc: state.signUpResponseModel?.message,
                  btnCancelText: 'OK',
                  buttonsTextStyle: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'pop',
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                  btnCancelOnPress: () {},
                ).show();
              }
            },
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: SafeArea(
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: BlocBuilder(
                      bloc: _signupBloc,
                      builder: (context, SignupState state) {
                        return ProgressHUD(
                          inAsyncCall: state.isloading,
                          child: Container(
                            width: double.maxFinite,
                            height: double.maxFinite,
                            padding: const EdgeInsets.only(
                                left: 25, right: 25, top: 40),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          width: 24,
                                          height: 24,
                                          alignment: Alignment.center,
                                          child: Image.asset(
                                            'images/backarrow.png',
                                            width: 24,
                                            height: 24,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 100,
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        child: const Text(
                                          "What's the code?",
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontFamily: 'pop',
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff2C2C2C)),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        child: const Text(
                                          "Enter the code sent to your mail here",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'pop',
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff2C2C2C)),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 32,
                                      ),
                                      Form(
                                          key: _formkey,
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 30),
                                            child: PinCodeTextField(
                                              appContext: context,
                                              pastedTextStyle: const TextStyle(
                                                  color: Color(0xff090B78),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  fontFamily: 'pop'),
                                              length: 4,
                                              obscureText: false,
                                              textStyle: const TextStyle(
                                                  color: Color(0xff000000),
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12,
                                                  fontFamily: 'pop'),

                                              blinkWhenObscuring: true,
                                              backgroundColor:
                                                  Colors.transparent,

                                              animationType: AnimationType.fade,
                                              autoUnfocus: true,
                                              autoFocus: true,
                                              validator: (value) {
                                                return Validator.validateValues(
                                                  value: value!,
                                                );
                                              },
                                              pinTheme: PinTheme(
                                                shape: PinCodeFieldShape.box,
                                                disabledColor:
                                                    Colors.transparent,
                                                activeColor:
                                                    const Color(0xff090B78),
                                                selectedColor:
                                                    const Color(0xff090B78),
                                                inactiveColor:
                                                    const Color(0xff090B78),
                                                inactiveFillColor:
                                                    Colors.transparent,
                                                selectedFillColor:
                                                    Colors.transparent,
                                                fieldOuterPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4),
                                                borderWidth: 1,
                                                borderRadius:
                                                    BorderRadius.circular(11),
                                                fieldHeight: 43,
                                                fieldWidth: 43,
                                                activeFillColor:
                                                    Colors.transparent,
                                              ),
                                              cursorColor: Colors.white,
                                              animationDuration: const Duration(
                                                  milliseconds: 300),
                                              enableActiveFill: true,
                                              controller: _pincontrol,
                                              keyboardType:
                                                  TextInputType.number,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,

                                              onCompleted: (v) {
                                                setState(() {
                                                  completed = true;
                                                });
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
                                          )),
                                      const SizedBox(
                                        height: 72,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 60,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(11)),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        if (_formkey.currentState!.validate()) {
                                          // _signupBloc.add(otpVerifyEvent(
                                          //     otp: _pincontrol.text));
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: completed
                                              ? const Color(0xff10245C)
                                              : const Color(0xffC4C4C4),
                                          elevation: 0,
                                          shadowColor: Colors.transparent,
                                          minimumSize:
                                              const Size.fromHeight(40),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(11))),
                                      child: const Text(
                                        'Verify',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontFamily: 'pop',
                                            fontWeight: FontWeight.w500),
                                      )),
                                ),
                                const SizedBox(
                                  height: 30,
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ),
            )));
  }
}
