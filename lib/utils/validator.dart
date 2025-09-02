import 'package:gptbanqbusiness/constant_string/constant_strings.dart';

class Validator {
  static String? validateValues({
    String? value,
    String? title,
    bool isEmail = false,
    bool isPhoneNumber = false,
    bool isPhoneOrEmail = false,
    bool isConfirmPassword = false,
    bool isChangePassword = false,
    bool isSixteenDigits = false,
    String password = '',
    bool isPlace = false,
    bool isResendPassword = false,
    bool isOTPCode = false,
    bool isAccountNumber = false,
    bool isAmount = false,
    double minAmount = 0.0,
    double maxAmount = 1000000000.0,
  }) {
    if (value!.isEmpty) {
      return ConstantStrings.FIELD_CAN_NOT_BLANK;
    } else if (isEmail && value.isNotEmpty) {
      if (!RegExp(
              r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
          .hasMatch(value.toLowerCase())) {
        return ConstantStrings.INVALID_EMAIL;
      }
    } else if (isPhoneOrEmail && value.isNotEmpty) {
      if (!RegExp(
              r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
          .hasMatch(value)) {
        if ((!RegExp("^[+]*(0|[1-9][0-9]*)\$").hasMatch(value)) ||
            (value.length < 8)) {
          return ConstantStrings.INVALID_EMAIL_PHONE;
        }
      }
    } else if (isConfirmPassword && value.isNotEmpty) {
      if (value != password) return ConstantStrings.PASSWORD_NOT_MATCHED;
    } else if (isPhoneNumber && value.length < 8) {
      return ConstantStrings.INVALID_FORMAT;
    } else if (isSixteenDigits && value.length != 16) {
      return "The field must be exactly 16 digits.";
    } else if (isChangePassword) {
      if (!RegExp(
              "^(?=.*[0-9])(?=.*[!@#\$%^&\*\(\)_\+=,\.<>\/{}?;:~\'\"])(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{6,}\$")
          .hasMatch(value)) {
        return ConstantStrings.INVALID_PASSWORD;
      }
    } else if (isAccountNumber && value.length < 8) {
      return ConstantStrings.INVALID_ACCOUNT_NUMBER;
    } else if (isPlace && value.length > 32) {
      // return ConstantStrings().AT_MOST_32;
    } else if (isOTPCode) {
      if ((!RegExp("^([0-9]*)\$").hasMatch(value))) {
        return ConstantStrings.ONLY_DIGITS;
      } else if (value.length != 4) return ConstantStrings.WRONG_LENGTH_OF_CODE;
    }

    // Amount validation (only when isAmount is true)
    if (isAmount && value.isNotEmpty) {
      // Replace comma with dot to allow both formats
      String normalizedValue = value.replaceAll(',', '.');

      // Check if the normalized value is a valid decimal number
      if (!RegExp(r'^\d+(\.\d{1,6})?$').hasMatch(normalizedValue)) {
        return "Please enter a valid number (e.g., 11.000000 or 11).";
      }

      // Parse the amount value using the normalized format
      double amount = double.parse(normalizedValue);

      // Validate minimum and maximum amount
      if (amount < minAmount) {
        return "Min. amount is ${minAmount.toString()}.";
      }
      if (maxAmount != null && amount > maxAmount) {
        return "Max. amount is ${maxAmount.toString()}.";
      }
    }

    return null;
  }
}
