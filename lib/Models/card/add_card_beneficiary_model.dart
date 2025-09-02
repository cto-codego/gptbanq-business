import 'dart:convert';

AddCardBeneficiaryModel addCardBeneficiaryModelFromJson(String str) =>
    AddCardBeneficiaryModel.fromJson(json.decode(str));

String addCardBeneficiaryModelToJson(AddCardBeneficiaryModel data) =>
    json.encode(data.toJson());

class AddCardBeneficiaryModel {
  int? status;
  String? message;

  AddCardBeneficiaryModel({
    this.status,
    this.message,
  });

  factory AddCardBeneficiaryModel.fromJson(Map<String, dynamic> json) =>
      AddCardBeneficiaryModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
