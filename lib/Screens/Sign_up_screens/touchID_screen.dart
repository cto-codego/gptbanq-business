import 'dart:io';

import 'package:gptbanqbusiness/Models/application.dart';
import 'package:gptbanqbusiness/constant_string/constant_strings.dart';
import 'package:gptbanqbusiness/utils/input_fields/custom_color.dart';
import 'package:gptbanqbusiness/utils/user_data_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_auth/local_auth.dart';

import '../../utils/assets.dart';
import '../../utils/custom_style.dart';
import '../../utils/strings.dart';
import '../../widgets/buttons/default_back_button_widget.dart';
import '../../widgets/buttons/primary_button_widget.dart';

class TouchidScreen extends StatefulWidget {
  final String? userPin;

  const TouchidScreen({super.key, this.userPin});

  @override
  State<TouchidScreen> createState() => _TouchidScreenState();
}

class _TouchidScreenState extends State<TouchidScreen> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  Future<void> _authorizeNow() async {
    final canCheckBiometrics = await _localAuthentication.canCheckBiometrics;
    FocusScope.of(context).requestFocus(FocusNode());

    if (canCheckBiometrics) {
      List<BiometricType> availableBiometricTypes =
          await _localAuthentication.getAvailableBiometrics();

      debugPrint(
          availableBiometricTypes.contains(BiometricType.face).toString());

      if (Platform.isIOS) {
        debugPrint("ABABA **************** iOS");

        if (availableBiometricTypes.contains(BiometricType.face)) {
          final isAuthenticated = await _localAuthentication.authenticate(
            localizedReason: ConstantStrings.ACTIVE_TOUCH_ID,
            options: const AuthenticationOptions(stickyAuth: true),
          );

          if (isAuthenticated) {
            debugPrint('widget.userPin: ${widget.userPin}');
            UserDataManager().savePin(widget.userPin!);
            UserDataManager().saveIsUsingBiometricAuth('1');
            Application.isBioMetric = '1';

            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Your Face-Id is Ready to Use"),
            ));

            Navigator.pushNamedAndRemoveUntil(
                context, "getpin", (route) => false);

            debugPrint("store data in storage");
          } else {
            UserDataManager().saveIsUsingBiometricAuth('0');
            Application.isBioMetric = '0';
            debugPrint("Not authenticated");
          }
          // Face ID.
        } else if (availableBiometricTypes
            .contains(BiometricType.fingerprint)) {
          final isAuthenticated = await _localAuthentication.authenticate(
            localizedReason: ConstantStrings.ACTIVE_TOUCH_ID,
            options: const AuthenticationOptions(stickyAuth: true),
          );

          if (isAuthenticated) {
            debugPrint('widget.userPin: ${widget.userPin}');
            UserDataManager().savePin(widget.userPin!);
            UserDataManager().saveIsUsingBiometricAuth('1');
            Application.isBioMetric = '1';
            debugPrint("store data in storage");
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Your Face-Id is Ready to Use"),
            ));
            Navigator.pushNamedAndRemoveUntil(
                context, "getpin", (route) => false);
          } else {
            UserDataManager().saveIsUsingBiometricAuth('0');
            Application.isBioMetric = '0';
            debugPrint("Not authenticated");
          }

          // Touch ID.
        }
      } else if (Platform.isAndroid) {
        debugPrint("ABABA **************** Android");

        if (availableBiometricTypes.contains(BiometricType.strong)) {
          final isAuthenticated = await _localAuthentication.authenticate(
            localizedReason: ConstantStrings.ACTIVE_TOUCH_ID,
            options: const AuthenticationOptions(stickyAuth: true),
          );

          if (isAuthenticated) {
            debugPrint('user Pin: ${widget.userPin}');
            UserDataManager().savePin(widget.userPin!);
            UserDataManager().saveIsUsingBiometricAuth('1');
            Application.isBioMetric = '1';
            debugPrint("store data in storage isAndroid");
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Your Face-Id is Ready to Use"),
            ));

            Navigator.pushNamedAndRemoveUntil(
                context, "getpin", (route) => false);
          } else {
            UserDataManager().saveIsUsingBiometricAuth('0');
            Application.isBioMetric = '0';
            debugPrint("Not authenticated");
          }
          // Face ID.
        } else if (availableBiometricTypes
            .contains(BiometricType.fingerprint)) {
          debugPrint('finger');
          final isAuthenticated = await _localAuthentication.authenticate(
            localizedReason: ConstantStrings.ACTIVE_TOUCH_ID,
            options: const AuthenticationOptions(
                stickyAuth: true, useErrorDialogs: true, biometricOnly: true),
          );

          if (isAuthenticated) {
            debugPrint('user Pin: ${widget.userPin}');
            UserDataManager().savePin(widget.userPin!);
            UserDataManager().saveIsUsingBiometricAuth('1');
            Application.isBioMetric = '1';
            debugPrint("store data in storage Android");

            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Your Face-Id is Ready to Use"),
            ));

            Navigator.pushNamedAndRemoveUntil(
                context, "getpin", (route) => false);
          } else {
            UserDataManager().saveIsUsingBiometricAuth('0');
            Application.isBioMetric = '0';
            debugPrint("Not authenticated");
          }
          // Touch ID.
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.scaffoldBg,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          width: double.maxFinite,
          height: double.maxFinite,
          padding: const EdgeInsets.only(left: 16, right: 16, top: 40),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DefaultBackButtonWidget(onTap: () {
                          Navigator.pop(context);
                        }),
                        Container()
                      ],
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        Strings.touchIdTitle,
                        style: CustomStyle.loginVerifyTitleTextStyle,
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        StaticAssets.fingerprint,
                        height: 200,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                        alignment: Alignment.center,
                        child: Text(
                          Strings.touchIdSubTitle1,
                          textAlign: TextAlign.center,
                          style: CustomStyle.setPinSubTitleTextStyle,
                        )),
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                        alignment: Alignment.center,
                        child: Text(
                          Strings.touchIdSubTitle2,
                          textAlign: TextAlign.center,
                          style: CustomStyle.loginVerifySubTitleTextStyle,
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 25),
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                UserDataManager().saveIsUsingBiometricAuth('0');
                Application.isBioMetric = '0';

                Navigator.pushNamedAndRemoveUntil(
                    context, "getpin", (route) => false);
              },
              child: Text(
                Strings.skip,
                textAlign: TextAlign.center,
                style: CustomStyle.skipTextStyle,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            PrimaryButtonWidget(
              onPressed: () => _authorizeNow(),
              buttonText: 'Confirm',
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
