// To parse this JSON data, do
//
//     final cdgDeviceListModel = cdgDeviceListModelFromJson(jsonString);

import 'dart:convert';

CdgDeviceListModel cdgDeviceListModelFromJson(String str) =>
    CdgDeviceListModel.fromJson(json.decode(str));

String cdgDeviceListModelToJson(CdgDeviceListModel data) =>
    json.encode(data.toJson());

class CdgDeviceListModel {
  final int? status;
  final String? message;
  final int? isCdg;
  final List<Datum>? data;
  final List<int>? quantity;

  CdgDeviceListModel({
    this.status,
    this.message,
    this.isCdg,
    this.data,
    this.quantity,
  });

  factory CdgDeviceListModel.fromJson(Map<String, dynamic> json) =>
      CdgDeviceListModel(
        status: json["status"],
        message: json["message"],
        isCdg: json["is_cdg"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        quantity: json["quantity"] == null
            ? []
            : List<int>.from(json["quantity"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "is_cdg": isCdg,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "quantity":
            quantity == null ? [] : List<dynamic>.from(quantity!.map((x) => x)),
      };
}

class Datum {
  final String? id;
  final String? type;
  final String? image;
  final String? labelShippingCost;
  final String? labelDeviceCost;
  final String? labelProfit;
  final String? labelEnduserProfit;
  final String? deviceCost;
  final String? shippingCost;
  final String? image2;

  Datum({
    this.id,
    this.type,
    this.image,
    this.labelShippingCost,
    this.labelDeviceCost,
    this.labelProfit,
    this.labelEnduserProfit,
    this.deviceCost,
    this.shippingCost,
    this.image2,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        type: json["type"],
        image: json["image"],
        labelShippingCost: json["label_shippingCost"],
        labelDeviceCost: json["label_device_cost"],
        labelProfit: json["label_profit"],
        labelEnduserProfit: json["label_enduser_profit"],
        deviceCost: json["device_cost"],
        shippingCost: json["shippingCost"],
        image2: json["image_2"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "image": image,
        "label_shippingCost": labelShippingCost,
        "label_device_cost": labelDeviceCost,
        "label_profit": labelProfit,
        "label_enduser_profit": labelEnduserProfit,
        "device_cost": deviceCost,
        "shippingCost": shippingCost,
        "image_2": image2,
      };
}
