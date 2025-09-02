import 'dart:io';

import 'package:gptbanqbusiness/Screens/Sign_up_screens/bloc/signup_bloc.dart';
import 'package:gptbanqbusiness/Screens/Sign_up_screens/signup_section/signup_verify_email.dart';
import 'package:gptbanqbusiness/constant_string/User.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:gptbanqbusiness/utils/input_fields/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:seon_sdk_flutter_plugin/seon_sdk_flutter_plugin.dart';
import 'package:uuid/uuid.dart';

import '../../../utils/custom_style.dart';
import '../../../utils/strings.dart';
import '../../../utils/user_data_manager.dart';
import '../../../widgets/buttons/default_back_button_widget.dart';
import '../../../widgets/buttons/primary_button_widget.dart';
import '../../../widgets/input_fields/defult_input_field_with_title_widget.dart';
import '../../../widgets/input_fields/password_input_field_with_title_widget.dart';
import '../../../widgets/toast/toast_util.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final String seonSessionId = const Uuid().v4();
  String _seonSession = 'Unknown';
  bool _isLoading = false; // Add this state variable

  final _seonSdkFlutterPlugin = SeonSdkFlutterPlugin();

  final _formKey = GlobalKey<FormState>();
  FocusNode myFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  bool _isButtonEnabled = false;
  final SignupBloc _signupBloc = SignupBloc();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _validateForm() {
    setState(() {
      _isButtonEnabled = _firstNameController.text.isNotEmpty &&
          _lastNameController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _formKey.currentState?.validate() == true;
    });
  }

  @override
  void initState() {
    super.initState();
    _formKey.currentState?.validate();
    UserDataManager().clearUserIbanData();

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
      debugPrint("Seon session ID ---------- ${Strings.appName}-$seonSessionId");
      debugPrint("Seon fingerprint ---------- $_seonSession");
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.scaffoldBg,
      resizeToAvoidBottomInset: true,
      body: BlocListener(
          bloc: _signupBloc,
          listener: (context, SignupState state) {
            if (state.statusModel?.status == 0) {

              CustomToast.showError(
                  context, "Sorry!", state.statusModel!.message!);
            }

            if (state.userSignupAccountModel!.status == 1) {
              String email = state.userSignupAccountModel!.email.toString();
              String message = state.userSignupAccountModel!.message.toString();

              debugPrint("$email $message");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SignupEmailVerifyScreen(
                    email: email,
                    message: message,
                    deviceType: Platform.isAndroid ? "Android" : "iOS",
                  ),
                ),
              );
            }
          },
          child: BlocBuilder(
              bloc: _signupBloc,
              builder: (context, SignupState state) {
                return SafeArea(
                  child: ProgressHUD(
                    inAsyncCall: state.isloading,
                    child: Stack(
                      children: [
                        Container(
                          width: double.maxFinite,
                          height: double.maxFinite,
                          padding:
                              const EdgeInsets.only(left: 16, right: 16, top: 30),
                          child: ListView(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  DefaultBackButtonWidget(onTap: () {
                                    Navigator.pushNamedAndRemoveUntil(context,
                                        'WelcomeScreen', (route) => false);
                                  }),
                                 Container(),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                Strings.signUpTitle,
                                style: CustomStyle.loginTitleStyle,
                              ),
                              Text(
                                Strings.signUpSubTitle,
                                style: CustomStyle.loginSubTitleStyle,
                              ),
                              const SizedBox(
                                height: 22,
                              ),
                              Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      DefaultInputFieldWithTitleWidget(
                                        controller: _firstNameController,
                                        title: 'First name (as per bank account)',
                                        hint: 'First Name',
                                        isEmail: false,
                                        keyboardType: TextInputType.name,
                                        autofocus: true,
                                        isPassword: false,
                                        onChanged: (value) {
                                          _validateForm();
                                        },
                                      ),
                                      DefaultInputFieldWithTitleWidget(
                                        controller: _lastNameController,
                                        title: 'Last name (as per bank account)',
                                        hint: 'Last Name',
                                        isEmail: false,
                                        keyboardType: TextInputType.name,
                                        isPassword: false,
                                        onChanged: (value) {
                                          _validateForm();
                                        },
                                      ),
                                      DefaultInputFieldWithTitleWidget(
                                        controller: _emailController,
                                        title: 'Email Account',
                                        hint: 'Email',
                                        isEmail: true,
                                        keyboardType: TextInputType.emailAddress,
                                        isPassword: false,
                                        onChanged: (value) {
                                          _validateForm();
                                        },
                                      ),
                                      PasswordInputFieldWithTitleWidget(
                                        controller: _passwordController,
                                        hint: 'Enter your password',
                                        title: 'Password',
                                        // Title above the password field
                                        onChange: () {
                                          _validateForm();
                                        },
                                      ),
                                    ],
                                  )),
                              const SizedBox(
                                height: 30,
                              ),
                              PrimaryButtonWidget(
                                onPressed: _isButtonEnabled
                                    ? () {
                                        if (_formKey.currentState!.validate()) {
                                          _isButtonEnabled = false;
                                          User.email = _emailController.text;
                                          User.password =
                                              _passwordController.text;
                                          User.deviceType = Platform.isAndroid
                                              ? 'android'
                                              : 'ios';

                                          _signupBloc.add(UserSignupEvent(
                                              name: _firstNameController.text,
                                              surname: _lastNameController.text,
                                              email: _emailController.text,
                                              password: _passwordController.text,
                                              devictype: User.deviceType!,
                                              seonSession: _seonSession));


                                        }
                                      }
                                    : null,
                                buttonText: 'Continue',
                              ),
                            ],
                          ),
                        ),
                        if (_isLoading) // Show loading indicator if loading
                          ModalBarrier(
                            color: Colors.transparent,
                            dismissible: false,
                            onDismiss: () {},
                          ),
                        if (_isLoading) // Show loading indicator if loading
                          const Center(
                            child: SpinKitDualRing(
                              color: Color(0xff10245C), // Customize color here
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              })),
    );
  }
}
