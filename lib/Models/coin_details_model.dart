// To parse this JSON data, do
//
//     final coindetailsModel = coindetailsModelFromJson(jsonString);

import 'dart:convert';

CoindetailsModel coindetailsModelFromJson(String str) =>
    CoindetailsModel.fromJson(json.decode(str));

class CoindetailsModel {
  int? status;
  int? btnBuy;
  int? btnSell;
  int? btnDeposit;
  int? btnWithdraw;
  coininfo? coin;
  List<Trx>? trx;
  String? stakingProfit;
  int? isCstaking;
  int? isButton;
  String? paircurrency;

  CoindetailsModel({
    this.status,
    this.btnBuy,
    this.btnDeposit,
    this.btnSell,
    this.btnWithdraw,
    this.coin,
    this.trx,
    this.stakingProfit,
    this.isCstaking,
    this.isButton,
    this.paircurrency,
  });

  factory CoindetailsModel.fromJson(Map<String, dynamic> json) =>
      CoindetailsModel(
        status: json["status"],
        btnBuy: json["btn_buy"],
        btnSell: json["btn_sell"],
        btnWithdraw: json["btn_withdraw"],
        btnDeposit: json["btn_deposit"],
        coin: coininfo.fromJson(json["coin"]),
        trx: List<Trx>.from(json["trx"].map((x) => Trx.fromJson(x))),
        stakingProfit: json["staking_profit"],
        isCstaking: json["is_cstaking"],
        isButton: json["is_button"],
        paircurrency: json["paircurrency"],
      );
}

class coininfo {
  String? coinid;
  String? coinType;
  String? currencySymbol;
  String? currencyName;
  String? image;
  String? cmcRank;
  String? blockNumber;
  String? isLocal;
  String? change24H;
  String? withdrawalStatus;
  String? depositStatus;
  String? isMemo;
  String? expoloerLink;
  String? officialLink;
  String? decimal;
  String? isQrcode;
  String? fiatBalance;
  String? price;
  String? cryptoBalance;
  String? isCoinbaseCoin;
  String? paircurrency;

  coininfo({
    this.coinid,
    this.coinType,
    this.currencySymbol,
    this.currencyName,
    this.image,
    this.cmcRank,
    this.blockNumber,
    this.isLocal,
    this.change24H,
    this.withdrawalStatus,
    this.depositStatus,
    this.isMemo,
    this.expoloerLink,
    this.officialLink,
    this.decimal,
    this.isQrcode,
    this.fiatBalance,
    this.price,
    this.cryptoBalance,
    this.isCoinbaseCoin,
    this.paircurrency,
  });

  factory coininfo.fromJson(Map<String, dynamic> json) => coininfo(
        coinid: json["coinid"],
        coinType: json["coin_type"],
        currencySymbol: json["currency_symbol"],
        currencyName: json["currency_name"],
        image: json["image"],
        cmcRank: json["cmc_rank"],
        blockNumber: json["block_number"],
        isLocal: json["is_local"],
        change24H: json["change_24h"],
        withdrawalStatus: json["withdrawal_status"],
        depositStatus: json["deposit_status"],
        isMemo: json["is_memo"],
        expoloerLink: json["expoloer_link"],
        officialLink: json["official_link"],
        decimal: json["decimal"],
        isQrcode: json["is_qrcode"],
        fiatBalance: json["fiat_balance"],
        price: json["price"],
        cryptoBalance: json["crypto_balance"],
        isCoinbaseCoin: json["is_coinbase_coin"],
        paircurrency: json["paircurrency"],
      );

  Map<String, dynamic> toJson() => {
        "coinid": coinid,
        "coin_type": coinType,
        "currency_symbol": currencySymbol,
        "currency_name": currencyName,
        "image": image,
        "cmc_rank": cmcRank,
        "block_number": blockNumber,
        "is_local": isLocal,
        "change_24h": change24H,
        "withdrawal_status": withdrawalStatus,
        "deposit_status": depositStatus,
        "is_memo": isMemo,
        "expoloer_link": expoloerLink,
        "official_link": officialLink,
        "decimal": decimal,
        "is_qrcode": isQrcode,
        "fiat_balance": fiatBalance,
        "price": price,
        "crypto_balance": cryptoBalance,
        "is_coinbase_coin": isCoinbaseCoin,
        "paircurrency": paircurrency,
      };
}

class Trx {
  String? sign;
  String? description;
  String? type;
  String? transactionId;
  String? status;
  String? amount;
  String? fees;
  String? total;
  String? date;
  String? coinsymbol;

  Trx({
    this.sign,
    this.description,
    this.type,
    this.transactionId,
    this.status,
    this.amount,
    this.fees,
    this.total,
    this.date,
    this.coinsymbol,
  });

  factory Trx.fromJson(Map<String, dynamic> json) => Trx(
        sign: json["sign"],
        description: json["description"],
        type: json["type"],
        transactionId: json["transaction_id"],
        status: json["status"],
        amount: json["amount"],
        fees: json["fees"],
        total: json["total"],
        date: json["date"],
        coinsymbol: json["coinsymbol"],
      );

  Map<String, dynamic> toJson() => {
        "sign": sign,
        "description": description,
        "type": type,
        "transaction_id": transactionId,
        "status": status,
        "amount": amount,
        "fees": fees,
        "total": total,
        "date": date,
        "coinsymbol": coinsymbol,
      };
}
