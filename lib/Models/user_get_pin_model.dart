// To parse this JSON data, do
//
//     final userGetPinModel = userGetPinModelFromJson(jsonString);

import 'dart:convert';

UserGetPinModel userGetPinModelFromJson(String str) =>
    UserGetPinModel.fromJson(json.decode(str));

String userGetPinModelToJson(UserGetPinModel data) =>
    json.encode(data.toJson());

class UserGetPinModel {
  int? status;
  String? token;
  String? defaultWallet;
  String? symbol;
  dynamic hidepage;
  String? risk;
  int? isIban;
  String? message;
  int? isCryptoMerchant;
  int? isEu;
  int? showgc;
  int? tcInvestment;
  int? tcCrypto;
  int? isWallet;
  int? isCardEu;
  int? hidecdg;
  int? hideinvest;
  int? tcCdg;

  UserGetPinModel({
    this.status,
    this.token,
    this.defaultWallet,
    this.symbol,
    this.hidepage,
    this.risk,
    this.isIban,
    this.message,
    this.isCryptoMerchant,
    this.isEu,
    this.showgc,
    this.tcInvestment,
    this.tcCrypto,
    this.isWallet,
    this.isCardEu,
    this.hidecdg,
    this.tcCdg,
    this.hideinvest,
  });

  factory UserGetPinModel.fromJson(Map<String, dynamic> json) =>
      UserGetPinModel(
        status: json["status"],
        token: json["token"],
        defaultWallet: json["default_wallet"],
        symbol: json["symbol"],
        hidepage: json["hidepage"],
        risk: json["risk"],
        isIban: json["is_iban"],
        message: json["message"],
        isCryptoMerchant: json["is_crypto_merchant"],
        isEu: json["is_eu"],
        showgc: json["showgc"],
        tcInvestment: json["tc_investment"],
        tcCrypto: json["tc_crypto"],
        isWallet: json["is_wallet"],
        isCardEu: json["is_card_eu"],
        hidecdg: json["hidecdg"],
        hideinvest: json["hideinvest"],
        tcCdg: json["tc_cdg"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "token": token,
        "default_wallet": defaultWallet,
        "symbol": symbol,
        "hidepage": hidepage,
        "risk": risk,
        "is_iban": isIban,
        "message": message,
        "is_crypto_merchant": isCryptoMerchant,
        "is_eu": isEu,
        "showgc": showgc,
        "tc_investment": tcInvestment,
        "tc_crypto": tcCrypto,
        "is_wallet": isWallet,
        "is_card_eu": isCardEu,
        "hidecdg": hidecdg,
        "hideinvest": hideinvest,
        "tc_cdg": tcCdg,
      };
}
