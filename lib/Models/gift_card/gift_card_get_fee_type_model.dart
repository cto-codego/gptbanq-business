import 'dart:convert';

GiftCardGetFeeTypeModel giftCardGetFeeTypeModelFromJson(String str) =>
    GiftCardGetFeeTypeModel.fromJson(json.decode(str));

String giftCardGetFeeTypeModelToJson(GiftCardGetFeeTypeModel data) =>
    json.encode(data.toJson());

class GiftCardGetFeeTypeModel {
  int? status;
  String? image;
  List<String>? cardType;
  List<Iban>? iban;

  GiftCardGetFeeTypeModel({
    this.status,
    this.image,
    this.cardType,
    this.iban,
  });

  factory GiftCardGetFeeTypeModel.fromJson(Map<String, dynamic> json) =>
      GiftCardGetFeeTypeModel(
        status: json["status"] ?? 0,
        image: json["image"] ?? "",
        cardType: json["cardType"] == null
            ? []
            : List<String>.from(json["cardType"]!.map((x) => x)),
        iban: json["iban"] == null
            ? []
            : List<Iban>.from(json["iban"]!.map((x) => Iban.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "image": image,
        "cardType":
            cardType == null ? [] : List<dynamic>.from(cardType!.map((x) => x)),
        "iban": iban == null
            ? []
            : List<dynamic>.from(iban!.map((x) => x.toJson())),
      };
}

class Iban {
  String? ibanId;
  String? label;

  Iban({
    this.ibanId,
    this.label,
  });

  factory Iban.fromJson(Map<String, dynamic> json) => Iban(
        ibanId: json["iban_id"],
        label: json["label"],
      );

  Map<String, dynamic> toJson() => {
        "iban_id": ibanId,
        "label": label,
      };
}
