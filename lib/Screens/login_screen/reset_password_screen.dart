import 'package:gptbanqbusiness/Screens/Sign_up_screens/bloc/signup_bloc.dart';
import 'package:gptbanqbusiness/constant_string/User.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/input_fields/custom_color.dart';
import '../../widgets/buttons/default_back_button_widget.dart';
import '../../widgets/buttons/primary_button_widget.dart';
import '../../widgets/input_fields/password_input_field_with_title_widget.dart';
import '../../widgets/toast/toast_util.dart';

class ResetPasswordScreen extends StatefulWidget {
  ResetPasswordScreen({super.key, required this.userId, required this.message});

  String userId;
  String message;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _forgotPasswordFormKey = GlobalKey<FormState>();
  final SignupBloc _signupBloc = SignupBloc();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
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
          if (state.statusModel?.status == 0) {
            CustomToast.showError(
                context, "Sorry!", state.statusModel!.message!);
          }

          if (state.statusModel?.status == 1) {
            CustomToast.showSuccess(
                context, "Hey!", state.statusModel!.message!);

            Navigator.pushNamedAndRemoveUntil(
                context, 'login', (route) => false);
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
                    // reverse: true,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DefaultBackButtonWidget(onTap: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, 'login', (route) => false);
                          }),
                          Text(
                            'Reset Password',
                            style: GoogleFonts.inter(
                                color: CustomColor.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            width: 20,
                          )
                        ],
                      ),
                      const SizedBox(height: 30),
                      Form(
                        key: _forgotPasswordFormKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            PasswordInputFieldWithTitleWidget(
                              controller: _password,
                              hint: 'Enter your new password',
                              title: 'New Password',
                              // Title above the password field
                              onChange: () {},
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "New Password cannot be empty";
                                } else if (value.length < 6) {
                                  return "New Password must be at least 6 characters long";
                                }
                                return null;
                              },
                            ),
                            PasswordInputFieldWithTitleWidget(
                              controller: _confirmPassword,
                              hint: 'Re-enter your new password',
                              title: 'Confirm Password',
                              // Title above the password field
                              onChange: () {},
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Confirm Password cannot be empty";
                                } else if (value != _password.text) {
                                  return "Passwords do not match";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      PrimaryButtonWidget(
                        onPressed: () {
                          if (_forgotPasswordFormKey.currentState!.validate()) {
                            // Add your forgot password logic here

                            _signupBloc.add(ResetPasswordEvent(
                                userId: widget.userId,
                                password: _password.text,
                                confirmPassword: _confirmPassword.text));
                          }
                        },
                        buttonText: 'update',
                      ),
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
