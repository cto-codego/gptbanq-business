import 'dart:convert';

DownloadTransactionModel downloadTransactionModelFromJson(String str) =>
    DownloadTransactionModel.fromJson(json.decode(str));

String downloadTransactionModelToJson(DownloadTransactionModel data) =>
    json.encode(data.toJson());

class DownloadTransactionModel {
  int? status;
  String? filelink;

  DownloadTransactionModel({
    this.status,
    this.filelink,
  });

  factory DownloadTransactionModel.fromJson(Map<String, dynamic> json) =>
      DownloadTransactionModel(
        status: json["status"],
        filelink: json["filelink"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "filelink": filelink,
      };
}
