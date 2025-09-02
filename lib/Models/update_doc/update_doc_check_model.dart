// To parse this JSON data, do
//
//     final updateDocCheckModel = updateDocCheckModelFromJson(jsonString);

import 'dart:convert';

UpdateDocCheckModel updateDocCheckModelFromJson(String str) => UpdateDocCheckModel.fromJson(json.decode(str));

String updateDocCheckModelToJson(UpdateDocCheckModel data) => json.encode(data.toJson());

class UpdateDocCheckModel {
  final int? status;
  final String? message;
  final UpdateDocData? updateDocData;

  UpdateDocCheckModel({
    this.status,
    this.message,
    this.updateDocData,
  });

  factory UpdateDocCheckModel.fromJson(Map<String, dynamic> json) => UpdateDocCheckModel(
    status: json["status"],
    message: json["message"],
    updateDocData: json["data"] == null ? null : UpdateDocData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": updateDocData?.toJson(),
  };
}

class UpdateDocData {
  final int? docStatus;
  final String? docType;
  final String? uniqueId;
  final int? docTypeStatus;
  final String? message;
  final String? rejectedReason;

  UpdateDocData({
    this.docStatus,
    this.docType,
    this.uniqueId,
    this.docTypeStatus,
    this.message,
    this.rejectedReason,
  });

  factory UpdateDocData.fromJson(Map<String, dynamic> json) => UpdateDocData(
    docStatus: _parseInt(json["status"]),
    docType: json["doc_type"],
    uniqueId: json["unique_id"],
    docTypeStatus: _parseInt(json["doc_type_status"]),
    message: json["message"],
    rejectedReason: json["rejected_reason"],
  );

  Map<String, dynamic> toJson() => {
    "status": docStatus,
    "doc_type": docType,
    "unique_id": uniqueId,
    "doc_type_status": docTypeStatus,
    "message": message,
    "rejected_reason": rejectedReason,
  };

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
}

