// To parse this JSON data, do
//
//     final userAppStatusModel = userAppStatusModelFromJson(jsonString);

import 'dart:convert';

UserAppStatusModel userAppStatusModelFromJson(String str) =>
    UserAppStatusModel.fromJson(json.decode(str));

String userAppStatusModelToJson(UserAppStatusModel data) =>
    json.encode(data.toJson());

class UserAppStatusModel {
  int? status;
  String? email;
  String? version;
  dynamic locationhide;
  Button? button;
  String? message;

  UserAppStatusModel({
    this.status,
    this.email,
    this.version,
    this.locationhide,
    this.button,
    this.message,
  });

  factory UserAppStatusModel.fromJson(Map<String, dynamic> json) =>
      UserAppStatusModel(
        status: json["status"],
        email: json["email"],
        version: json["version"],
        locationhide: json["locationhide"],
        button: Button.fromJson(json["button"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "email": email,
        "version": version,
        "locationhide": locationhide,
        "button": button!.toJson(),
        "message": message,
      };
}

class Button {
  String appDarkButtonColor;
  String appLightButtonColor;
  String transferButtonColor;
  String depositButtonColor;

  Button({
    required this.appDarkButtonColor,
    required this.appLightButtonColor,
    required this.transferButtonColor,
    required this.depositButtonColor,
  });

  factory Button.fromJson(Map<String, dynamic> json) => Button(
        appDarkButtonColor: json["app_dark_button_color"],
        appLightButtonColor: json["app_light_button_color"],
        transferButtonColor: json["transfer_button_color"],
        depositButtonColor: json["deposit_button_color"],
      );

  Map<String, dynamic> toJson() => {
        "app_dark_button_color": appDarkButtonColor,
        "app_light_button_color": appLightButtonColor,
        "transfer_button_color": transferButtonColor,
        "deposit_button_color": depositButtonColor,
      };
}
