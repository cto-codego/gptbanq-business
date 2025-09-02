// To parse this JSON data, do
//
//     final createIbanListModel = createIbanListModelFromJson(jsonString);

import 'dart:convert';

CreateIbanListModel createIbanListModelFromJson(String str) => CreateIbanListModel.fromJson(json.decode(str));

String createIbanListModelToJson(CreateIbanListModel data) => json.encode(data.toJson());

class CreateIbanListModel {
  final int? status;
  final String? message;
  final List<IbanListData>? iban;

  CreateIbanListModel({
    this.status,
    this.message,
    this.iban,
  });

  factory CreateIbanListModel.fromJson(Map<String, dynamic> json) => CreateIbanListModel(
    status: json["status"],
    message: json["message"],
    iban: json["iban"] == null ? [] : List<IbanListData>.from(json["iban"]!.map((x) => IbanListData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "iban": iban == null ? [] : List<dynamic>.from(iban!.map((x) => x.toJson())),
  };
}

class IbanListData {
  final String? name;
  final String? flag;

  IbanListData({
    this.name,
    this.flag,
  });

  factory IbanListData.fromJson(Map<String, dynamic> json) => IbanListData(
    name: json["name"],
    flag: json["flag"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "flag": flag,
  };
}
