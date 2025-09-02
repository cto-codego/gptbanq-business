// To parse this JSON data, do
//
//     final remotePaymentModel = remotePaymentModelFromJson(jsonString);

import 'dart:convert';

RemotePaymentModel remotePaymentModelFromJson(String str) => RemotePaymentModel.fromJson(json.decode(str));

String remotePaymentModelToJson(RemotePaymentModel data) => json.encode(data.toJson());

class RemotePaymentModel {
  int status;
  String message;

  RemotePaymentModel({
    required this.status,
    required this.message,
  });

  factory RemotePaymentModel.fromJson(Map<String, dynamic> json) => RemotePaymentModel(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
