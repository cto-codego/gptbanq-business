import 'package:gptbanqbusiness/Screens/Sign_up_screens/bloc/signup_bloc.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:gptbanqbusiness/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Config/bloc/app_bloc.dart';
import '../../../Config/bloc/app_respotary.dart';
import '../../../utils/custom_style.dart';
import '../../../utils/input_fields/custom_color.dart';
import '../../../utils/input_fields/custom_pincode_input_field_widget.dart';
import '../../../utils/strings.dart';
import '../../../widgets/buttons/default_back_button_widget.dart';
import '../../../widgets/buttons/primary_button_widget.dart';
import '../../../widgets/toast/toast_util.dart';

class SignupEmailVerifyScreen extends StatefulWidget {
  const SignupEmailVerifyScreen(
      {super.key,
      required this.email,
      required this.message,
      required this.deviceType});

  final String email;
  final String message;
  final String deviceType;

  @override
  State<SignupEmailVerifyScreen> createState() =>
      _SignupEmailVerifyScreenState();
}

class _SignupEmailVerifyScreenState extends State<SignupEmailVerifyScreen> {
  final _formKey = new GlobalKey<FormState>();

  final TextEditingController _pinControl = TextEditingController();

  bool completed = false;
  final SignupBloc _signupBloc = SignupBloc();

  AppRespo appRepo = AppRespo();
  final AppBloc _appBloc = AppBloc();

  @override
  void initState() {
    appRepo.getUserStatus();
    _appBloc.add(UserstatusEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
        bloc: _signupBloc,
        listener: (context, SignupState state) {
          if (state.statusModel?.status == 0) {
            CustomToast.showError(
                context, "Sorry!", state.statusModel!.message!);
          }

          if (state.signupEmailVerifiedModel?.status == 1) {
            Navigator.pushNamedAndRemoveUntil(
                context, 'signUpUserInfoPage1Screen', (route) => false);
          }
        },
        child: Scaffold(
          backgroundColor: CustomColor.scaffoldBg,
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: BlocBuilder(
                bloc: _signupBloc,
                builder: (context, SignupState state) {
                  return ProgressHUD(
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    DefaultBackButtonWidget(onTap: () {
                                      Navigator.pop(context);
                                    }),
                                  Container()
                                  ],
                                ),
                                const SizedBox(
                                  height: 100,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    Strings.loginVerifyTitle,
                                    style:
                                        CustomStyle.loginVerifyTitleTextStyle,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(horizontal: 30),
                                  child: Text(
                                    widget.message,
                                    textAlign: TextAlign.center,
                                    style: CustomStyle
                                        .loginVerifySubTitleTextStyle,
                                  ),
                                ),
                                const SizedBox(
                                  height: 32,
                                ),
                                // Form(
                                //     key: _formKey,
                                //     child: Container(
                                //       margin: const EdgeInsets.symmetric(
                                //           horizontal: 30),
                                //       child: PinCodeTextField(
                                //         appContext: context,
                                //         pastedTextStyle: const TextStyle(
                                //             color: Color(0xff090B78),
                                //             fontWeight: FontWeight.bold,
                                //             fontSize: 14,
                                //             fontFamily: 'pop'),
                                //         length: 4,
                                //         obscureText: false,
                                //         textStyle: const TextStyle(
                                //             color: Color(0xff000000),
                                //             fontWeight: FontWeight.w500,
                                //             fontSize: 12,
                                //             fontFamily: 'pop'),
                                //
                                //         blinkWhenObscuring: true,
                                //         backgroundColor:
                                //         Colors.transparent,
                                //
                                //         animationType: AnimationType.fade,
                                //         autoUnfocus: true,
                                //         autoFocus: true,
                                //         validator: (value) {
                                //           return Validator.validateValues(
                                //             value: value!,
                                //           );
                                //         },
                                //         pinTheme: PinTheme(
                                //           shape: PinCodeFieldShape.box,
                                //           disabledColor:
                                //           Colors.transparent,
                                //           activeColor:
                                //           const Color(0xff090B78),
                                //           selectedColor:
                                //           const Color(0xff090B78),
                                //           inactiveColor:
                                //           const Color(0xff090B78),
                                //           inactiveFillColor:
                                //           Colors.transparent,
                                //           selectedFillColor:
                                //           Colors.transparent,
                                //           fieldOuterPadding:
                                //           const EdgeInsets.symmetric(
                                //               horizontal: 4),
                                //           borderWidth: 1,
                                //           borderRadius:
                                //           BorderRadius.circular(11),
                                //           fieldHeight: 43,
                                //           fieldWidth: 43,
                                //           activeFillColor:
                                //           Colors.transparent,
                                //         ),
                                //         cursorColor: Colors.white,
                                //         animationDuration: const Duration(
                                //             milliseconds: 300),
                                //         enableActiveFill: true,
                                //         controller: _pinControl,
                                //         keyboardType:
                                //         TextInputType.number,
                                //         mainAxisAlignment:
                                //         MainAxisAlignment.center,
                                //
                                //         onCompleted: (v) {
                                //           setState(() {
                                //             completed = true;
                                //           });
                                //         },
                                //         // onTap: () {
                                //         //   print("Pressed");
                                //         // },
                                //         onChanged: (value) {},
                                //         enablePinAutofill: false,
                                //         errorTextMargin:
                                //         const EdgeInsets.only(
                                //             top: 10),
                                //       ),
                                //     )),

                                Form(
                                    key: _formKey,
                                    child: CustomPinCodeInputFieldWidget(
                                      appContext: context,
                                      controller: _pinControl,
                                      onCompleted: (value) {
                                        setState(() {
                                          completed = true;
                                        });
                                        debugPrint('Completed: $value');
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
                              ],
                            ),
                          ),
                          PrimaryButtonWidget(
                            onPressed: completed
                                ? () {
                                    if (_formKey.currentState!.validate()) {
                                      _signupBloc.add(otpVerifyEvent(
                                          otp: _pinControl.text,
                                          email: widget.email,
                                          deviceType: widget.deviceType));
                                    }
                                  }
                                : null,
                            buttonText: 'Verify',
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ));
  }
}
