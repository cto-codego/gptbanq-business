import 'dart:convert';

StakeConfirmModel stakeConfirmModelFromJson(String str) =>
    StakeConfirmModel.fromJson(json.decode(str));

String stakeConfirmModelToJson(StakeConfirmModel data) =>
    json.encode(data.toJson());

class StakeConfirmModel {
  int? status;
  String? message;

  StakeConfirmModel({
    this.status,
    this.message,
  });

  factory StakeConfirmModel.fromJson(Map<String, dynamic> json) =>
      StakeConfirmModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
