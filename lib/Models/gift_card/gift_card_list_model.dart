import 'dart:convert';

GiftCardListModel giftCardListFromJson(String str) =>
    GiftCardListModel.fromJson(json.decode(str));

String giftCardListToJson(GiftCardListModel data) => json.encode(data.toJson());

class GiftCardListModel {
  int? status;
  List<CardList>? cardList;

  GiftCardListModel({
    this.status,
    this.cardList,
  });

  factory GiftCardListModel.fromJson(Map<String, dynamic> json) =>
      GiftCardListModel(
        status: json["status"],
        cardList: json["cardList"] == null
            ? []
            : List<CardList>.from(
                json["cardList"]!.map((x) => CardList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "cardList": cardList == null
            ? []
            : List<dynamic>.from(cardList!.map((x) => x.toJson())),
      };
}

class CardList {
  String? cardId;
  String? balance;
  String? loadedAmount;
  String? cardNumber;
  String? expiryDate;
  String? cardStatus;
  DateTime? created;
  String? image;

  CardList({
    this.cardId,
    this.balance,
    this.loadedAmount,
    this.cardNumber,
    this.expiryDate,
    this.cardStatus,
    this.created,
    this.image,
  });

  factory CardList.fromJson(Map<String, dynamic> json) => CardList(
        cardId: json["card_id"] ?? "",
        balance: json["balance"] ?? "",
        loadedAmount: json["loaded_amount"] ?? "",
        cardNumber: json["card_number"] ?? "",
        expiryDate: json["expiry_date"] ?? "",
        cardStatus: json["card_status"] ?? "",
        created:
            json["created"] == null ? null : DateTime.parse(json["created"]),
        image: json["image"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "card_id": cardId,
        "balance": balance,
        "loaded_amount": loadedAmount,
        "card_number": cardNumber,
        "expiry_date": expiryDate,
        "card_status": cardStatus,
        "created": created?.toIso8601String(),
        "image": image,
      };
}
