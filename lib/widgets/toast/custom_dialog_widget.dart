import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:gptbanqbusiness/utils/assets.dart';
import 'package:gptbanqbusiness/utils/input_fields/custom_color.dart';
import 'package:gptbanqbusiness/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../buttons/primary_button_widget.dart';

class CustomDialogWidget {
  // Success Dialog
  static void showSuccessDialog({
    required BuildContext context,
    required String title,
    required String subTitle,
    String? btnOkText,
    VoidCallback? btnOkOnPress,
    bool dismissOnTouchOutside = true,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.rightSlide,
      dismissOnTouchOutside: dismissOnTouchOutside,
      body: _customBodySuccessWidget(
          image: StaticAssets.successDialog,
          title: title,
          subTitle: subTitle,
          color: CustomColor.green.withOpacity(0.2)),
      btnOkText: btnOkText ?? 'Great!',
      btnOkOnPress: btnOkOnPress ?? () {},
      btnOkColor: CustomColor.primaryColor,
    ).show();
  }

  // Error Dialog
  static void showErrorDialog({
    required BuildContext context,
    required String title,
    required String subTitle,
    String? btnOkText,
    VoidCallback? btnOkOnPress,
    bool dismissOnTouchOutside = true,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      dialogBackgroundColor: CustomColor.whiteColor,
      animType: AnimType.rightSlide,
      dismissOnTouchOutside: dismissOnTouchOutside,
      body: _customBodyWidget(
          image: StaticAssets.errorDialog,
          title: title,
          subTitle: subTitle,
          color: CustomColor.errorColor.withOpacity(0.2)),
      btnOkText: btnOkText ?? 'Retry',
      btnOkOnPress: btnOkOnPress ?? () {},
    ).show();
  }

  // Not Found Dialog
  static void showNotFoundDialog({
    required BuildContext context,
    required String title,
    required String subTitle,
    String? btnOkText,
    VoidCallback? btnOkOnPress,
    bool dismissOnTouchOutside = true,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.topSlide,
      dismissOnTouchOutside: dismissOnTouchOutside,
      body: _customBodyWidget(
          image: StaticAssets.warningDialog,
          title: title,
          subTitle: subTitle,
          color: CustomColor.green.withOpacity(0.2)),
      btnOkText: btnOkText ?? 'Close',
      dialogBackgroundColor: CustomColor.whiteColor,
      btnOkOnPress: btnOkOnPress ?? () {},
      btnOkColor: CustomColor.primaryColor,
    ).show();
  }

  // Warning Dialog
  static void showWarningDialog({
    required BuildContext context,
    required String title,
    required String subTitle,
    String? btnOkText,
    String? btnCancelText,
    VoidCallback? btnOkOnPress,
    VoidCallback? btnCancelOnPress,
    bool dismissOnTouchOutside = true,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.bottomSlide,
      dismissOnTouchOutside: dismissOnTouchOutside,
      body: _customBodyWidget(
          image: StaticAssets.warningDialog,
          title: title,
          subTitle: subTitle,
          color: CustomColor.green.withOpacity(0.2)),
      btnOkText: btnOkText ?? 'Understood',
      btnCancelText: btnCancelText ?? 'Cancel',
      btnOkOnPress: btnOkOnPress ?? () {},
      btnCancelOnPress: btnCancelOnPress,
      btnOkColor: CustomColor.primaryColor,
    ).show();
  }

  // Custom container widget that you can modify to include extra data
  static Widget _customBodyWidget(
      {required String image,
      required String title,
      required Color color,
      required String subTitle}) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          CustomImageWidget(
            imagePath: image,
            imageType: 'svg',
            height: 56,
            width: 56,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: CustomColor.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              subTitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: CustomColor.black,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }


  static Widget _customBodySuccessWidget(
      {required String image,
        required String title,
        required Color color,
        required String subTitle}) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          Image.asset(
           image,
            height: 95,
            width: 95,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: CustomColor.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              subTitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: CustomColor.black,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
