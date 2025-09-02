import 'package:gptbanqbusiness/utils/assets.dart';
import 'package:gptbanqbusiness/utils/input_fields/custom_color.dart';
import 'package:gptbanqbusiness/widgets/custom_image_widget.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomToast {
    static showSuccess(BuildContext context, String title, String subTitle) {
    _showToast(
        context, title, subTitle, Color(0xff12B76A), StaticAssets.successIcon);
  }

  static void showWarning(BuildContext context, String title, String subTitle) {
    _showToast(context, title, subTitle, Color(0xffF79009), StaticAssets.alertIcon);
  }

  static void showError(BuildContext context, String title, String subTitle) {
    _showToast(context, title, subTitle, Color(0xffF04438), StaticAssets.errorIcon);
  }

  static void showNotFound(
      BuildContext context, String title, String subTitle) {
    _showToast(context, title, subTitle, Color(0xffF79009), StaticAssets.alertIcon);
  }

  static void _showToast(BuildContext context, String title, String subtitle,
      Color bgColor, String icon) {
    DelightToastBar(
      autoDismiss: true, // Automatically dismiss after a short duration
      snackbarDuration: Duration(seconds: 3),
      position: DelightSnackbarPosition.top,
      builder: (context) => ToastCard(
        color: bgColor,
        leading: CustomImageWidget(
          imagePath: icon,
          imageType: 'svg',
          height: 36,
        ),
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: CustomColor.whiteColor,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 13,
            color: CustomColor.whiteColor.withOpacity(0.7),
          ),
        ),
        trailing: IconButton(
          icon: CustomImageWidget(
            imagePath: StaticAssets.close,
            imageType: 'svg',
            height: 30,
          ),
          onPressed: () {
            // Close the toast when the button is pressed
          },
        ),
      ),
    ).show(context);
  }
}
