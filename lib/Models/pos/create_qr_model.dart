// To parse this JSON data, do
//
//     final createQrModel = createQrModelFromJson(jsonString);

import 'dart:convert';

CreateQrModel createQrModelFromJson(String str) => CreateQrModel.fromJson(json.decode(str));

String createQrModelToJson(CreateQrModel data) => json.encode(data.toJson());

class CreateQrModel {
  int? status;
  String? uniqueId;
  String? message;

  CreateQrModel({
    this.status,
    this.uniqueId,
    this.message,
  });

  factory CreateQrModel.fromJson(Map<String, dynamic> json) => CreateQrModel(
    status: json["status"],
    uniqueId: json["unique_id"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "unique_id": uniqueId,
    "message": message,
  };
}
