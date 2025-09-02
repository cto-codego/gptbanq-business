import 'dart:convert';

TransactionApprovedModel transactionApprovedModelFromJson(String str) =>
    TransactionApprovedModel.fromJson(json.decode(str));

String transactionApprovedModelToJson(TransactionApprovedModel data) =>
    json.encode(data.toJson());

class TransactionApprovedModel {
  int? status;
  String? message;

  TransactionApprovedModel({
    this.status,
    this.message,
  });

  factory TransactionApprovedModel.fromJson(Map<String, dynamic> json) =>
      TransactionApprovedModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
