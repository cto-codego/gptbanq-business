import 'dart:convert';

DeleteCardBeneficiaryModel deleteCardBeneficiaryModelFromJson(String str) =>
    DeleteCardBeneficiaryModel.fromJson(json.decode(str));

String deleteCardBeneficiaryModelToJson(DeleteCardBeneficiaryModel data) =>
    json.encode(data.toJson());

class DeleteCardBeneficiaryModel {
  int? status;
  String? message;

  DeleteCardBeneficiaryModel({
    this.status,
    this.message,
  });

  factory DeleteCardBeneficiaryModel.fromJson(Map<String, dynamic> json) =>
      DeleteCardBeneficiaryModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
