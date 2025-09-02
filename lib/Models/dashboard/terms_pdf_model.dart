// To parse this JSON data, do
//
//     final termsPdfModel = termsPdfModelFromJson(jsonString);

import 'dart:convert';

TermsPdfModel termsPdfModelFromJson(String str) => TermsPdfModel.fromJson(json.decode(str));

String termsPdfModelToJson(TermsPdfModel data) => json.encode(data.toJson());

class TermsPdfModel {
  final int? status;
  final String? message;
  final String? tcpdf;
  final String? tccdgpdf;

  TermsPdfModel({
    this.status,
    this.message,
    this.tcpdf,
    this.tccdgpdf,
  });

  factory TermsPdfModel.fromJson(Map<String, dynamic> json) => TermsPdfModel(
    status: json["status"],
    message: json["message"],
    tcpdf: json["tcpdf"],
    tccdgpdf: json["tccdgpdf"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "tccdgpdf": tccdgpdf,
  };
}
