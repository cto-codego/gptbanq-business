// To parse this JSON data, do
//
//     final newStakeRequestModel = newStakeRequestModelFromJson(jsonString);

import 'dart:convert';

NewStakeRequestModel newStakeRequestModelFromJson(String str) =>
    NewStakeRequestModel.fromJson(json.decode(str));

String newStakeRequestModelToJson(NewStakeRequestModel data) =>
    json.encode(data.toJson());

class NewStakeRequestModel {
  int? status;
  String? message;

  NewStakeRequestModel({
    this.status,
    this.message,
  });

  factory NewStakeRequestModel.fromJson(Map<String, dynamic> json) =>
      NewStakeRequestModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
