import 'package:gptbanqbusiness/utils/assets.dart';
import 'package:gptbanqbusiness/utils/input_fields/custom_color.dart';
import 'package:gptbanqbusiness/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constant_string/User.dart';
import '../../utils/custom_style.dart';
import '../../utils/strings.dart';
import '../../widgets/buttons/default_back_button_widget.dart';
import '../buttons/primary_button_widget.dart';

// Renamed enum to avoid conflict
enum SuccessImageType {
  success,
  error,
  warning,
}

class SuccessWidget extends StatefulWidget {
  SuccessWidget({
    super.key,
    required this.imageType, // Accepting image type as a parameter
    required this.title,
    required this.subTitle,
    required this.btnText,
    required this.onTap,
    required this.disableButton,
  });

  final SuccessImageType imageType; // Updated to the new enum name
  final String title;
  final String subTitle;
  final String btnText;
  final VoidCallback onTap;
  final bool disableButton; // Marked as final since it’s now immutable

  @override
  State<SuccessWidget> createState() => _SuccessWidgetState();
}

class _SuccessWidgetState extends State<SuccessWidget> {
  @override
  void initState() {
    super.initState();
    User.Screen = 'Success Screen';
  }

  // Method to get the image path based on the image type
  String _getImagePath() {
    switch (widget.imageType) {
      case SuccessImageType.success:
        return StaticAssets.successDialog; // Assuming you have a success icon
      case SuccessImageType.error:
        return StaticAssets.errorDialog; // Assuming you have an error icon
      case SuccessImageType.warning:
        return StaticAssets.warningDialog; // Assuming you have a warning icon
      default:
        return StaticAssets.warningDialog; // Fallback icon if needed
    }
  }

  String _getImageData() {
    switch (widget.imageType) {
      case SuccessImageType.success:
        return ""; // Assuming you have a success icon
      case SuccessImageType.error:
        return 'svg'; // Assuming you have an error icon
      case SuccessImageType.warning:
        return 'svg'; // Assuming you have a warning icon
      default:
        return 'svg'; // Fallback icon if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.scaffoldBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomImageWidget(
                imagePath: _getImagePath(),
                imageType: _getImageData(),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: CustomStyle.loginTitleStyle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10, top: 7),
                child: Text(
                  widget.subTitle,
                  textAlign: TextAlign.center,
                  style: CustomStyle.loginSubTitleStyle,
                ),
              ),
              const SizedBox(height: 10),
              if (widget.disableButton == true)
                Container()
              else
                PrimaryButtonWidget(
                  onPressed: widget.onTap,
                  buttonText: widget.btnText,
                ), // Space before buttons
            ],
          ),
        ),
      ),
      // bottomNavigationBar: CustomBottomBar(index: 0),
    );
  }

  Widget appBarSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DefaultBackButtonWidget(onTap: () {
            Navigator.pushNamedAndRemoveUntil(
                context, 'dashboard', (route) => false);
          }),
          Text(
            '',
            style: GoogleFonts.inter(
                color: CustomColor.black,
                fontSize: 18,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 20), // Changed from Container to SizedBox
        ],
      ),
    );
  }
}
