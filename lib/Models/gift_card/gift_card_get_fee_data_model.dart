import 'dart:convert';

GiftCardGetFeeDataModel giftCardGetFeeDataModelFromJson(String str) =>
    GiftCardGetFeeDataModel.fromJson(json.decode(str));

String giftCardGetFeeDataModelToJson(GiftCardGetFeeDataModel data) =>
    json.encode(data.toJson());

class GiftCardGetFeeDataModel {
  int? status;
  List<Plan>? plan;
  String? image;
  List<String>? cardType;

  GiftCardGetFeeDataModel({
    this.status,
    this.plan,
    this.image,
    this.cardType,
  });

  factory GiftCardGetFeeDataModel.fromJson(Map<String, dynamic> json) =>
      GiftCardGetFeeDataModel(
        status: json["status"],
        plan: json["plan"] == null
            ? []
            : List<Plan>.from(json["plan"]!.map((x) => Plan.fromJson(x))),
        image: json["image"],
        cardType: json["cardType"] == null
            ? []
            : List<String>.from(json["cardType"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "plan": plan == null
            ? []
            : List<dynamic>.from(plan!.map((x) => x.toJson())),
        "image": image,
        "cardType":
            cardType == null ? [] : List<dynamic>.from(cardType!.map((x) => x)),
      };
}

class Plan {
  String? title;
  String? fee;

  Plan({
    this.title,
    this.fee,
  });

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
        title: json["title"],
        fee: json["fee"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "fee": fee,
      };
}
