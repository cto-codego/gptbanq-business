import 'package:gptbanqbusiness/Screens/Sign_up_screens/bloc/signup_bloc.dart';
import 'package:gptbanqbusiness/constant_string/User.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:gptbanqbusiness/utils/input_fields/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import '../../utils/assets.dart';
import '../../widgets/buttons/default_back_button_widget.dart';
import '../../widgets/buttons/primary_button_widget.dart';
import '../../widgets/custom_image_widget.dart';
import '../../widgets/input_fields/defult_input_field_with_title_widget.dart';
import '../../widgets/toast/toast_util.dart';
import 'forgot_password_otp_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _forgotPasswordFormKey = GlobalKey<FormState>();
  final SignupBloc _signupBloc = SignupBloc();
  final TextEditingController _emailController = TextEditingController();
  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(() {
      setState(() {});
    });
    User.Screen = 'Login';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.scaffoldBg,
      resizeToAvoidBottomInset: true, // Important for handling keyboard
      body: BlocListener(
        bloc: _signupBloc,
        listener: (context, SignupState state) {
          // Handle different states based on your loginResponse

          if (state.forgotPasswordModel?.status == 0) {
            CustomToast.showError(
                context, "Sorry!", state.forgotPasswordModel!.message!);
            Navigator.pushNamedAndRemoveUntil(
                context, 'forgotPasswordScreen', (route) => false);
          }

          if (state.forgotPasswordModel?.status == 1) {
            Navigator.push(
              context,
              PageTransition(
                child: ForgotPasswordOtpScreen(
                  uniqueId: state.forgotPasswordModel!.uniqueId!,
                  userId: state.forgotPasswordModel!.userId!,
                  message: state.forgotPasswordModel!.message!,
                ),
                type: PageTransitionType.fade,
                alignment: Alignment.center,
                duration: const Duration(milliseconds: 300),
                reverseDuration: const Duration(milliseconds: 200),
              ),
            );
          }
        },
        child: BlocBuilder(
          bloc: _signupBloc,
          builder: (context, SignupState state) {
            return ProgressHUD(
              inAsyncCall: state.isloading,
              child: SafeArea(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 40),
                  child: ListView(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DefaultBackButtonWidget(onTap: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, 'login', (route) => false);
                          }),
                          // Text(
                          //   'Forgot Password',
                          //   style: GoogleFonts.inter(
                          //       color: CustomColor.black,
                          //       fontSize: 18,
                          //       fontWeight: FontWeight.w500),
                          // ),
                          SizedBox(
                            width: 20,
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Image.asset(
                      //   'images/forgot-password.png',
                      //   height: 300,
                      // ),

                      Padding(
                        padding: const EdgeInsets.all(13.0),
                        child: CustomImageWidget(
                          imagePath: StaticAssets.forgotPassword,
                          imageType: 'svg',
                          height: 300,
                        ),
                      ),
                      Text(
                        'Forgot your Password?',
                        style: GoogleFonts.inter(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: CustomColor.black,
                        ),
                      ),
                      Text(
                        'Don\'t worry, it happens. We\'ll help you get back into your account. Please enter your email address below.',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: CustomColor.primaryTextHintColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Form(
                        key: _forgotPasswordFormKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // InputTextCustom(
                            //   controller: _emailController,
                            //   hint: 'Enter your email id',
                            //   label: 'Email account',
                            //   isEmail: true,
                            //   isPassword: false,
                            //   onChanged: () {},
                            // ),

                            DefaultInputFieldWithTitleWidget(
                              controller: _emailController,
                              title: 'Email Account',
                              hint: 'Email',
                              isEmail: true,
                              keyboardType: TextInputType.emailAddress,
                              isPassword: false,
                              onChanged: (value) {},
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      PrimaryButtonWidget(
                        onPressed: () {
                          if (_forgotPasswordFormKey.currentState!.validate()) {
                            // Add your forgot password logic here
                            _signupBloc.add(ForgotPasswordEvent(
                                email: _emailController.text));
                          }
                        },
                        buttonText: 'Submit',
                      ),
                      const SizedBox(height: 200),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
