// To parse this JSON data, do
//
//     final cdgDashboardModel = cdgDashboardModelFromJson(jsonString);

import 'dart:convert';

CdgDashboardModel cdgDashboardModelFromJson(String str) =>
    CdgDashboardModel.fromJson(json.decode(str));

String cdgDashboardModelToJson(CdgDashboardModel data) =>
    json.encode(data.toJson());

class CdgDashboardModel {
  final int? status;
  final String? message;
  final String? coin;
  final String? logo;
  final String? balance;
  final String? usdBalance;
  final String? price;
  final int? totalDevice;
  final int? totalWorking;
  final int? totalOffline;
  final String? popupText;
  final int? stakeUnStakeButton;
  final String? stakeBtn;
  final String? unStakeBtn;
  final String? unStakeAlert;
  final List<Device>? device;
  final List<Device>? offline;
  final List<Device>? working;

  CdgDashboardModel(
      {this.status,
      this.message,
      this.coin,
      this.logo,
      this.balance,
      this.usdBalance,
      this.price,
      this.totalDevice,
      this.totalWorking,
      this.totalOffline,
      this.stakeUnStakeButton,
      this.device,
      this.offline,
      this.working,
      this.stakeBtn,
      this.unStakeBtn,
      this.unStakeAlert,
      this.popupText});

  factory CdgDashboardModel.fromJson(Map<String, dynamic> json) =>
      CdgDashboardModel(
        status: json["status"],
        message: json["message"],
        coin: json["coin"],
        logo: json["logo"],
        balance: json["balance"],
        usdBalance: json["usd_balance"],
        price: json["price"],
        totalDevice: json["total_device"],
        totalWorking: json["total_working"],
        totalOffline: json["total_offline"],
        popupText: json["popup_text"],
        stakeUnStakeButton: json["stake_untsake_button"],
        stakeBtn: json["stake_btn"],
        unStakeBtn: json["unstake_btn"],
        unStakeAlert: json["unstake_alert"],
        device: json["device"] == null
            ? []
            : List<Device>.from(json["device"]!.map((x) => Device.fromJson(x))),
        offline: json["offline"] == null
            ? []
            : List<Device>.from(
                json["offline"]!.map((x) => Device.fromJson(x))),
        working: json["working"] == null
            ? []
            : List<Device>.from(
                json["working"]!.map((x) => Device.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "coin": coin,
        "logo": logo,
        "balance": balance,
        "usd_balance": usdBalance,
        "price": price,
        "total_device": totalDevice,
        "total_working": totalWorking,
        "total_offline": totalOffline,
        "popup_text": popupText,
        "stake_untsake_button": stakeUnStakeButton,
        "stake_btn": stakeBtn,
        "unstake_btn": unStakeBtn,
        "unstake_alert": unStakeAlert,
        "device": device == null
            ? []
            : List<dynamic>.from(device!.map((x) => x.toJson())),
        "offline": offline == null
            ? []
            : List<dynamic>.from(offline!.map((x) => x.toJson())),
        "working": working == null
            ? []
            : List<dynamic>.from(working!.map((x) => x.toJson())),
      };
}

class Device {
  final String? orderId;
  final String? serialNumber;
  final String? status;
  final String? image;

  Device({
    this.orderId,
    this.serialNumber,
    this.status,
    this.image,
  });

  factory Device.fromJson(Map<String, dynamic> json) => Device(
        orderId: json["order_id"],
        serialNumber: json["serial_number"],
        status: json["status"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "serial_number": serialNumber,
        "status": status,
        "image": image,
      };
}
