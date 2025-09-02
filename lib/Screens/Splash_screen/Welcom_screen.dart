import 'package:flutter/material.dart';

import '../../utils/input_fields/custom_color.dart';
import '../../widgets/buttons/primary_button_widget.dart';
import '../../widgets/buttons/secondary_button_widget.dart';
import '../../widgets/main_logo_widget.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.scaffoldBg,
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const Expanded(
                  child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: MainLogoWidget(
                  width: double.maxFinite,
                ),
              )),
              PrimaryButtonWidget(
                onPressed: () {
                  Navigator.pushNamed(context, 'login');
                },
                buttonText: "Log In",
              ),
              // SecondaryButtonWidget(
              //   onPressed: () {
              //     Navigator.pushNamed(context, 'signUpScreen');
              //   },
              //   buttonText: "Sign Up",
              //   apiBackgroundColor: CustomColor.whiteColor,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
