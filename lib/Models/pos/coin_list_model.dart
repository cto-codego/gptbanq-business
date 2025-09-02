// To parse this JSON data, do
//
//     final coinListModel = coinListModelFromJson(jsonString);

import 'dart:convert';

CoinListModel coinListModelFromJson(String str) => CoinListModel.fromJson(json.decode(str));

String coinListModelToJson(CoinListModel data) => json.encode(data.toJson());

class CoinListModel {
  final int? status;
  final String? message;
  final List<Coinlist>? coinlist;

  CoinListModel({
    this.status,
    this.message,
    this.coinlist,
  });

  factory CoinListModel.fromJson(Map<String, dynamic> json) => CoinListModel(
    status: json["status"],
    message: json["message"],
    coinlist: json["coinlist"] == null ? [] : List<Coinlist>.from(json["coinlist"]!.map((x) => Coinlist.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "coinlist": coinlist == null ? [] : List<dynamic>.from(coinlist!.map((x) => x.toJson())),
  };
}

class Coinlist {
  final String? symbol;
  final String? coinname;
  final String? price;
  final String? image;
  final String? network;

  Coinlist({
    this.symbol,
    this.coinname,
    this.price,
    this.image,
    this.network,
  });

  factory Coinlist.fromJson(Map<String, dynamic> json) => Coinlist(
    symbol: json["symbol"],
    coinname: json["coinname"],
    price: json["price"],
    image: json["image"],
    network: json["network"],
  );

  Map<String, dynamic> toJson() => {
    "symbol": symbol,
    "coinname": coinname,
    "price": price,
    "image": image,
    "network": network,
  };
}
