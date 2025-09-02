import 'dart:convert';

CdgStakeListModel cdgStakeListModelFromJson(String str) =>
    CdgStakeListModel.fromJson(json.decode(str));

String cdgStakeListModelToJson(CdgStakeListModel data) =>
    json.encode(data.toJson());

class CdgStakeListModel {
  final int? status;
  final String? message;
  final List<Cdg>? cdg;

  CdgStakeListModel({
    this.status,
    this.message,
    this.cdg,
  });

  factory CdgStakeListModel.fromJson(Map<String, dynamic> json) =>
      CdgStakeListModel(
        status: json["status"],
        message: json["message"],
        cdg: json["cdg"] == null
            ? []
            : List<Cdg>.from(json["cdg"]!.map((x) => Cdg.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "cdg":
            cdg == null ? [] : List<dynamic>.from(cdg!.map((x) => x.toJson())),
      };
}

class Cdg {
  final String? image;
  final String? cdgId;
  final String? orderId;
  final String? serialNumber;
  final DateTime? activateDate;
  final String? status;

  Cdg({
    this.image,
    this.cdgId,
    this.orderId,
    this.serialNumber,
    this.activateDate,
    this.status,
  });

  factory Cdg.fromJson(Map<String, dynamic> json) => Cdg(
        image: json["image"],
        cdgId: json["cdg_id"],
        orderId: json["order_id"],
        serialNumber: json["serial_number"],
        activateDate: json["activate_date"] == null
            ? null
            : DateTime.parse(json["activate_date"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "cdg_id": cdgId,
        "order_id": orderId,
        "serial_number": serialNumber,
        "activate_date":
            "${activateDate!.year.toString().padLeft(4, '0')}-${activateDate!.month.toString().padLeft(2, '0')}-${activateDate!.day.toString().padLeft(2, '0')}",
        "status": status,
      };
}
