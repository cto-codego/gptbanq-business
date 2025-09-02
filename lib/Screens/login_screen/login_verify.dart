import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

import 'package:gptbanqbusiness/Screens/Sign_up_screens/bloc/signup_bloc.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:gptbanqbusiness/utils/validator.dart';

import '../../utils/custom_style.dart';
import '../../utils/input_fields/custom_color.dart';
import '../../utils/input_fields/custom_pincode_input_field_widget.dart';
import '../../utils/strings.dart';
import '../../widgets/buttons/default_back_button_widget.dart';
import '../../widgets/buttons/primary_button_widget.dart';
import '../../widgets/toast/toast_util.dart';
import 'login_face_verification_screen.dart';

class LoginVerifyScreen extends StatefulWidget {
  String? userId, token;
  var loginCode;

  LoginVerifyScreen({
    Key? key,
    required this.token,
    this.userId,
    required this.loginCode,
  }) : super(key: key);

  @override
  State<LoginVerifyScreen> createState() => _LoginVerifyScreenState();
}

class _LoginVerifyScreenState extends State<LoginVerifyScreen> {
  final _formkey = GlobalKey<FormState>();

  final TextEditingController _pincontrol = TextEditingController();

  bool completed = false;
  final SignupBloc _signupBloc = SignupBloc();

  @override
  void initState() {
    super.initState();

    _pincontrol.text = widget.loginCode.toString();

    if (_pincontrol.text != '') {
      completed = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _signupBloc,
      listener: (context, SignupState state) {
        if (state.statusModel?.status == 0) {
          CustomToast.showError(context, "Sorry!", state.statusModel!.message!);
        }

        if (state.loginEmailVerifiedModel?.status == 1) {
          Navigator.pushNamedAndRemoveUntil(
              context, 'setpin', (route) => false);
        } else if (state.loginEmailVerifiedModel?.status == 2) {
          Navigator.push(
            context,
            PageTransition(
              child: LoginFaceVerificationScreen(
                profileImage: state.loginEmailVerifiedModel!.profileimage!,
                token: widget.token!,
                userId: widget.userId!,
                message: state.loginEmailVerifiedModel!.message!,
              ),
              type: PageTransitionType.fade,
              alignment: Alignment.center,
              duration: const Duration(milliseconds: 300),
              reverseDuration: const Duration(milliseconds: 200),
            ),
          );
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: CustomColor.scaffoldBg,
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
                        const EdgeInsets.only(left: 16, right: 16, top: 40),
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
                                height: 50,
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: Text(
                                  Strings.loginVerifyTitle,
                                  style: CustomStyle.loginVerifyTitleTextStyle,
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(horizontal: 30),
                                child: Text(
                                  Strings.loginVerifySubTitle,
                                  textAlign: TextAlign.center,
                                  style:
                                      CustomStyle.loginVerifySubTitleTextStyle,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Form(
                                  key: _formkey,
                                  child: CustomPinCodeInputFieldWidget(
                                    appContext: context,
                                    controller: _pincontrol,
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
                            ],
                          ),
                        ),
                        PrimaryButtonWidget(
                          onPressed: completed
                              ? () {
                                  if (_formkey.currentState!.validate()) {
                                    _signupBloc.add(
                                      LoginRequestVerifyEvent(
                                        userId: widget.userId!,
                                        token: widget.token!,
                                        verificationCode: _pincontrol.text,
                                      ),
                                    );
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
      ),
    );
  }
}
