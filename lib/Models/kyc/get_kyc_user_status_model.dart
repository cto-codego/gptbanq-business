import 'dart:convert';

GetKycUserStatusModel getKycUserStatusModelFromJson(String str) =>
    GetKycUserStatusModel.fromJson(json.decode(str));

String getKycUserStatusModelToJson(GetKycUserStatusModel data) =>
    json.encode(data.toJson());

class GetKycUserStatusModel {
  int? status;
  String? version;
  int? locationhide;
  int? isSetpin;
  int? sendlink;
  String? message;

  GetKycUserStatusModel({
    this.status,
    this.version,
    this.locationhide,
    this.isSetpin,
    this.sendlink,
    this.message,
  });

  factory GetKycUserStatusModel.fromJson(Map<String, dynamic> json) =>
      GetKycUserStatusModel(
        status: json["status"],
        version: json["version"],
        locationhide: json["locationhide"],
        isSetpin: json["is_setpin"],
        sendlink: json["sendlink"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "version": version,
        "locationhide": locationhide,
        "is_setpin": isSetpin,
        "sendlink": sendlink,
        "message": message,
      };
}
