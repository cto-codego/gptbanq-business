
import 'dart:io';

import 'package:gptbanqbusiness/Screens/Sign_up_screens/bloc/signup_bloc.dart';
import 'package:gptbanqbusiness/Screens/login_screen/login_verify.dart';
import 'package:gptbanqbusiness/constant_string/User.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:gptbanqbusiness/utils/input_fields/custom_color.dart';
import 'package:gptbanqbusiness/utils/user_data_manager.dart';
import 'package:gptbanqbusiness/widgets/buttons/default_back_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';
import 'package:seon_sdk_flutter_plugin/seon_sdk_flutter_plugin.dart';

import '../../utils/custom_style.dart';
import '../../utils/permissions/permission_manager.dart';
import '../../utils/strings.dart';
import '../../widgets/buttons/primary_button_widget.dart';
import '../../widgets/input_fields/default_input_field_widget.dart';
import '../../widgets/input_fields/default_password_input_field_widget.dart';
import '../../widgets/toast/toast_util.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _seonSession = 'Unknown';
  bool _isLoading = false;

  final _loginFormKey = GlobalKey<FormState>();
  final _seonSdkFlutterPlugin = SeonSdkFlutterPlugin();
  final SignupBloc _signupBloc = SignupBloc();

  bool? show = false;

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  FocusNode myFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  // New state variable to track if the button should be enabled
  bool isButtonEnabled = false;

  @override
  void initState() {
    UserDataManager().clearUserIbanData();
    try {
      _seonSdkFlutterPlugin.setGeolocationEnabled(true);
      _seonSdkFlutterPlugin.setGeolocationTimeout(500);
      getFingerprint();
    } catch (e) {
      print('$e');
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      PermissionManager.checkAndRequestPermissions(
        context,
        onDataCollected: (jsonData) {
          print('Collected JSON data in AnotherScreen: $jsonData');
          UserDataManager().userDeviceInfoSave(jsonData.toString());
        },
      );
    });

    _loginFormKey.currentState?.validate();
    super.initState();

    myFocusNode.addListener(() {
      setState(() {});
    });

    User.Screen = 'Login';

    passwordFocusNode.addListener(() {
      setState(() {});
    });

    // Add listeners to email and password fields to enable/disable the button
    _email.addListener(_checkFormValidity);
    _password.addListener(_checkFormValidity);
  }

  // Method to get fingerprint
  Future<void> getFingerprint() async {
    setState(() {
      _isLoading = true;
    });

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
      _isLoading = false;
    });
  }

  // New method to check if both email and password are filled
  void _checkFormValidity() {
    setState(() {
      isButtonEnabled = _email.text.isNotEmpty && _password.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: CustomColor.scaffoldBg,
      body: BlocListener(
        bloc: _signupBloc,
        listener: (context, SignupState state) {
          if (state.loginResponse?.status == 1) {
            UserDataManager()
                .statusMessageSave(state.loginResponse!.message.toString());
            Navigator.push(
              context,
              PageTransition(
                child: LoginVerifyScreen(
                    loginCode: state.loginResponse!.loginCode!,
                    token: state.loginResponse!.token,
                    userId: state.loginResponse!.userId),
                type: PageTransitionType.fade,
                alignment: Alignment.center,
                duration: const Duration(milliseconds: 300),
                reverseDuration: const Duration(milliseconds: 200),
              ),
            );
          } else if (state.loginResponse?.status == 0) {
            CustomToast.showError(
                context, "Sorry!", state.loginResponse!.message!);
          } else if (state.loginResponse?.status == 2) {
            //go to onboard profile
            UserDataManager()
                .statusMessageSave(state.loginResponse!.message.toString());
            Navigator.pushNamedAndRemoveUntil(
                context, 'signUpUserInfoPage1Screen', (route) => false);
          } else if (state.loginResponse?.status == 3) {
            //go to kyc screen
            UserDataManager()
                .statusMessageSave(state.loginResponse!.message.toString());

            Navigator.pushNamedAndRemoveUntil(
                context, 'kycWelcomeScreen', (route) => false);
          }
        },
        child: BlocBuilder(
          bloc: _signupBloc,
          builder: (context, SignupState state) {
            return ProgressHUD(
              inAsyncCall: state.isloading,
              child: SafeArea(
                child: Stack(
                  children: [
                    Container(
                      width: double.maxFinite,
                      height: double.maxFinite,
                      padding:
                          const EdgeInsets.only(left: 16, right: 16, top: 40),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              DefaultBackButtonWidget(onTap: () {
                                Navigator.pushNamedAndRemoveUntil(
                                    context, 'WelcomeScreen', (route) => false);
                              }),
                              Container()
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(Strings.loginTitle,
                                style: CustomStyle.loginTitleStyle),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text(Strings.loginSubTitle,
                                style: CustomStyle.loginSubTitleStyle),
                          ),
                          const SizedBox(
                            height: 22,
                          ),
                          Expanded(
                            child: Form(
                              key: _loginFormKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  DefaultInputFieldWidget(
                                    controller: _email,
                                    hint: 'Email',
                                    isEmail: true,
                                    keyboardType: TextInputType.emailAddress,
                                    autofocus: true,
                                    isPassword: false,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(11),
                                      topRight: Radius.circular(11),
                                      bottomLeft: Radius.zero,
                                      bottomRight: Radius.zero,
                                    ),
                                    onChanged: _checkFormValidity,
                                  ),
                                  DefaultPasswordInputFieldWidget(
                                    controller: _password,
                                    hint: 'Password',
                                    onChange: _checkFormValidity,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.zero,
                                      topRight: Radius.zero,
                                      bottomLeft: Radius.circular(11),
                                      bottomRight: Radius.circular(11),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    padding: EdgeInsets.symmetric(vertical: 7),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            'forgotPasswordScreen',
                                            (route) => true);
                                      },
                                      child: Text(Strings.forgotPassword,
                                          style: CustomStyle
                                              .loginForgotPassTextStyle),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          PrimaryButtonWidget(
                            onPressed: isButtonEnabled
                                ? () {
                                    if (_loginFormKey.currentState!
                                        .validate()) {
                                      _signupBloc.add(siginInEvent(
                                        email: _email.text,
                                        password: _password.text,
                                        devictype: Platform.isAndroid
                                            ? 'android'
                                            : 'ios',
                                        seonSession: _seonSession,
                                      ));
                                    }
                                  }
                                : null,
                            // Disable button if fields are empty
                            buttonText: 'Log In',
                            // apiBackgroundColor: isButtonEnabled
                            //     ? const Color(0xff10245C)
                            //     : Colors.grey, // Change color if disabled
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                    if (_isLoading)
                       Center(
                        child: SpinKitDualRing(
                          color: CustomColor.primaryColor,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
