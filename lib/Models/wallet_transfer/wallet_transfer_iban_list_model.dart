// To parse this JSON data, do
//
//     final walletTransferIbanListModel = walletTransferIbanListModelFromJson(jsonString);

import 'dart:convert';

WalletTransferIbanListModel walletTransferIbanListModelFromJson(String str) => WalletTransferIbanListModel.fromJson(json.decode(str));

String walletTransferIbanListModelToJson(WalletTransferIbanListModel data) => json.encode(data.toJson());

class WalletTransferIbanListModel {
  final int? status;
  final String? message;
  final List<ErIban>? senderIban;
  final List<ErIban>? receiverIban;

  WalletTransferIbanListModel({
    this.status,
    this.message,
    this.senderIban,
    this.receiverIban,
  });

  factory WalletTransferIbanListModel.fromJson(Map<String, dynamic> json) => WalletTransferIbanListModel(
    status: json["status"],
    message: json["message"],
    senderIban: json["sender_iban"] == null ? [] : List<ErIban>.from(json["sender_iban"]!.map((x) => ErIban.fromJson(x))),
    receiverIban: json["receiver_iban"] == null ? [] : List<ErIban>.from(json["receiver_iban"]!.map((x) => ErIban.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "sender_iban": senderIban == null ? [] : List<dynamic>.from(senderIban!.map((x) => x.toJson())),
    "receiver_iban": receiverIban == null ? [] : List<dynamic>.from(receiverIban!.map((x) => x.toJson())),
  };
}

class ErIban {
  final String? balance;
  final String? ibanId;
  final String? label;
  final String? image;
  final String? currency;

  ErIban({
    this.balance,
    this.ibanId,
    this.label,
    this.image,
    this.currency,
  });

  factory ErIban.fromJson(Map<String, dynamic> json) => ErIban(
    balance: json["balance"],
    ibanId: json["iban_id"],
    label: json["label"],
    image: json["image"],
    currency: json["currency"],
  );

  Map<String, dynamic> toJson() => {
    "balance": balance,
    "iban_id": ibanId,
    "label": label,
    "image": image,
    "currency": currency,
  };
}
