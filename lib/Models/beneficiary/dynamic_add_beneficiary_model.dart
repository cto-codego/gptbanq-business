// To parse this JSON data, do
//
//     final dynamicAddBeneficiaryModel = dynamicAddBeneficiaryModelFromJson(jsonString);

import 'dart:convert';

DynamicAddBeneficiaryModel dynamicAddBeneficiaryModelFromJson(String str) => DynamicAddBeneficiaryModel.fromJson(json.decode(str));

String dynamicAddBeneficiaryModelToJson(DynamicAddBeneficiaryModel data) => json.encode(data.toJson());

class DynamicAddBeneficiaryModel {
  int? status;
  String? message;

  DynamicAddBeneficiaryModel({
    this.status,
    this.message,
  });

  factory DynamicAddBeneficiaryModel.fromJson(Map<String, dynamic> json) => DynamicAddBeneficiaryModel(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
