// To parse this JSON data, do
//
//     final binficaryModel = binficaryModelFromJson(jsonString);

import 'dart:convert';

BinficaryModel binficaryModelFromJson(String str) =>
    BinficaryModel.fromJson(json.decode(str));

class BinficaryModel {
    int? status;
    List<Datum>? data;
    String? message;
    int? isPaymentPurposeCodes;

    BinficaryModel({this.status, this.data, this.message,  this.isPaymentPurposeCodes});

    factory BinficaryModel.fromJson(Map<String, dynamic> json) => BinficaryModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        message: json['message'] ?? '',
        isPaymentPurposeCodes: json['is_payment_purpose_codes'],
    );
}

class Datum {
    String? currency;
    String? uniqueId;
    String? name;
    String? account;
    String? status;
    String? created;
    String? country;
    String? accountType;
    String? profileimage;
    String? flag;
    int? beneficaryStatus;
    String? beneficaryMsg;

    Datum({
        this.currency,
        this.uniqueId,
        this.name,
        this.account,
        this.status,
        this.created,
        this.country,
        this.accountType,
        this.profileimage,
        this.flag,
        this.beneficaryStatus,
        this.beneficaryMsg,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        currency: json["currency"] ?? "",
        uniqueId: json["unique_id"] ?? "",
        name: json["name"] ?? "",
        account: json["account"] ?? "",
        status: json["status"] ?? "",
        created: json["created"] ?? '',
        country: json["country"] ?? '',
        accountType: json["account_type"] ?? '',
        profileimage: json["profileimage"] ?? '',
        flag: json["flag"] ?? '',
        beneficaryStatus: json["beneficary_status"] ?? 1,
        beneficaryMsg: json["beneficary_msg"] ?? '',
    );
}
