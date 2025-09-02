import 'dart:convert';

CardOderDetailsModel cardOderDetailsModelFromJson(String str) =>
    CardOderDetailsModel.fromJson(json.decode(str));

String cardOderDetailsModelToJson(CardOderDetailsModel data) =>
    json.encode(data.toJson());

class CardOderDetailsModel {
  int? status;
  Cardv? card;
  String? symbol;

  CardOderDetailsModel({
    this.status,
    this.card,
    this.symbol,
  });

  factory CardOderDetailsModel.fromJson(Map<String, dynamic> json) =>
      CardOderDetailsModel(
        status: json["status"],
        card: json["card"] == null ? null : Cardv.fromJson(json["card"]),
        symbol: json["symbol"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "card": card?.toJson(),
        "symbol": symbol,
      };
}

class Cardv {
  String? title;
  String? fee;
  String? shippingCost;
  String? total;

  Cardv({
    this.title,
    this.fee,
    this.shippingCost,
    this.total,
  });

  factory Cardv.fromJson(Map<String, dynamic> json) => Cardv(
        title: json["title"],
        fee: json["fee"],
        shippingCost: json["shipping_cost"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "fee": fee,
        "shipping_cost": shippingCost,
        "total": total,
      };
}
