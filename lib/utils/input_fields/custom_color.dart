import 'package:gptbanqbusiness/utils/user_data_manager.dart';
import 'package:flutter/material.dart';

class CustomColor {
  //default color will change from api
  static Color primaryColor = Color(0xFF132559);
  static Color disableColor = Color(0xFF8992AC);

  static Color transferButtonColor = Color(0xffB689FF);
  static Color depositButtonColor = Color(0xffB689FF);

  // Method to load colors asynchronously
  Future<void> loadColors() async {
    // Dark color
    String darkButtonColorString = await UserDataManager().getDarkButtonColor();
    primaryColor = _colorFromString(darkButtonColorString) ?? primaryColor;
    debugPrint("This is dark check : $darkButtonColorString");

    // Uncomment and modify for other button colors as needed
    String lightButtonColorString =
        await UserDataManager().getLightButtonColor();
    disableColor = _colorFromString(lightButtonColorString) ?? disableColor;
    debugPrint("This is disable check : $disableColor");

    String transferButtonColorString =
        await UserDataManager().getTransferButtonColor();
    transferButtonColor =
        _colorFromString(transferButtonColorString) ?? transferButtonColor;
    debugPrint("This is transfer check : $transferButtonColor");

    String depositButtonColorString =
        await UserDataManager().getDepositButtonColor();
    depositButtonColor =
        _colorFromString(depositButtonColorString) ?? depositButtonColor;
    debugPrint("This is deposit check : $depositButtonColor");
  }

  /// Converts a string to a Color object. Assumes the string is in the format "0xFFxxxxxx".
  Color? _colorFromString(String colorString) {
    try {
      // Ensure the color string is trimmed
      colorString = colorString.trim();

      // Remove the "0x" prefix if it exists
      if (colorString.startsWith("0x")) {
        colorString = colorString.substring(2);
      }

      // Parse the integer directly after removing the prefix
      return Color(int.parse(colorString, radix: 16));
    } catch (e) {
      // Handle any parsing errors
      print("Error parsing color: $e");
      return null; // Return null if there's an error
    }
  }

  Color secondaryColor = Color(0xFF555555);

  static const Color dashboardSendContainerColor = Color(0xffB689FF);

  static const Color transparent = Colors.transparent;

  static const Color splashBgColor = Color(0x99132559);
  static const Color appBgColor = Color(0xffffffff);
  static const Color appBarBackgroundColor = Color(0xffffffff);
  static const Color green = Color(0xff00710B);
  static const Color blue = Color(0xff4282FF);
  static const Color blueBorder = Color(0xff6AAAFF);
  static const Color warning = Colors.deepOrangeAccent;
  static const Color whiteColor = Color(0xffffffff);
  static const Color black = Color(0xff111111);
  static const Color scaffoldBg = Color(0xffffffff);

  //text color
  static const Color primaryTextColor = Color(0xffffffff);
  static const Color secondaryTextColor = Color(0xff111111);
  static const Color primaryTextHintColor = Color(0xff8F8F8F);
  static const Color primaryInputHintColor = Color(0xffF7F7F7);
  static const Color primaryInputHintBorderColor = Color(0xffC7C7C7);
  static const Color touchIdSubtitleTextColor = Color(0xff8F8F8F);
  static const Color inputFieldTitleTextColor = Color(0xff8F8F8F);
  static const Color subtitleTextColor = Color(0xff7C7C7C);
  static const Color errorColor = Color(0xffF04438);
  static const Color kycContainerBgColor = Color(0xffF7F7F7);
  static const Color hubContainerBgColor = Color(0xffF7F9FD);
  static const Color dashboardHintColor = Color(0xff7C8689);
  static const Color dashboardBgColor = Color(0xffF3F5F6);
  static const Color dashboardTopContainerColor = Color(0xffF6F9FC);
  static const Color dashboardTopContainerBorderColor = Color(0xff33A1DF);
  static const Color dashboardProfileBorderColor = Color(0xffE3E3E3);
  static const Color transactionDetailsTextColor = Color(0xff393939);
  static const Color transactionFromContainerColor = Color(0xFFF4F6F8);
  static const Color notificationBgColor = Color(0xFFF2F5F6);
  static const Color notificationBellBgColor = Color(0xFFECFCF3);
  static const Color selectContainerColor = Color(0xFFF5F5F5);
  static const Color currencyCustomSelectorColor = Color(0xFFEDEEF2);
  static const Color cryptoListContainerColor = Color(0xFFEFF4F5);
  static const Color noteContainerColor = Color(0xFFE8EBEC);
  static const Color stakingSmallContainerColor = Color(0xFFF2F2F7);
  static const Color profileImageContainerColor = Color(0xFFEDF0F5);

  //button color
  static const Color primaryButtonColor = Color(0xFF132559);
  static const Color secondaryButtonColor = Color(0xffffffff);

  static const Color rgbColor = Color.fromRGBO(251, 102, 58, 0.5);
  static Color unselectedItemColor =
      const Color.fromRGBO(255, 255, 255, 1).withOpacity(0.1);
}
