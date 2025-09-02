// To parse this JSON data, do
//
//     final coins = coinsFromJson(jsonString);

import 'dart:convert';

Coins coinsFromJson(String str) => Coins.fromJson(json.decode(str));


class Coins {
    Coins({
         this.status,
         this.portfolio,
         this.coin,
         this.curruncylist
    });

    int ?status;
    String? portfolio;
    List<Coin>? coin;
      List<Coin>? curruncylist;


    factory Coins.fromJson(Map<String, dynamic> json) => Coins(
        status: json["status"],
        portfolio: json["portfolio"],
        coin: List<Coin>.from(json["coin"].map((x) => Coin.fromJson(x))),
        curruncylist: List<Coin>.from(json["coin"].map((x) => Coin.fromJson(x))),

    );

    
}

class Coin {
    Coin({
         this.coinid,
         this.coinType,
         this.currencySymbol,
         this.currencyName,
         this.image,
         this.cmcRank,
         this.blockNumber,
         this.isLocal,
         this.isGenerate,
         this.price,
         this.change24H,
         this.withdrawalStatus,
         this.depositStatus,
         this.isMemo,
         this.expoloerLink,
         this.officialLink,
         this.decimal,
         this.buyCrypto,
         this.sellCrypto,
         this.isQrcode,
         this.cryptoBalance,
         this.fiatBalance,
         this.isCoinbaseCoin,
        this.noCoinbaseCoin,
    });

    String ?coinid;
    String ?coinType;
    String ?currencySymbol;
    String ?currencyName;
    String ?image;
    String ?cmcRank;
    String ?blockNumber;
    String ?isLocal;
    int ?isGenerate;
    String? price;
    String ?change24H;
    String ?withdrawalStatus;
    String ?depositStatus;
    String ?isMemo;
    String ?expoloerLink;
    String ?officialLink;
    String ?decimal;
    int ?buyCrypto;
    int ?sellCrypto;
    String ?isQrcode;
    String ?cryptoBalance;
    String ?fiatBalance;
    String ?isCoinbaseCoin;
    String ?noCoinbaseCoin;

    factory Coin.fromJson(Map<String, dynamic> json) => Coin(
        coinid: json["coinid"],
        coinType: json["coin_type"],
        currencySymbol: json["currency_symbol"],
        currencyName: json["currency_name"],
        image: json["image"],
        cmcRank: json["cmc_rank"],
        blockNumber: json["block_number"],
        isLocal: json["is_local"],
        isGenerate: json["is_generate"],
        price: json["price"],
        change24H: json["change_24h"],
        withdrawalStatus: json["withdrawal_status"],
        depositStatus: json["deposit_status"],
        isMemo: json["is_memo"],
        expoloerLink: json["expoloer_link"],
        officialLink: json["official_link"],
        decimal: json["decimal"],
        buyCrypto: json["buy_crypto"],
        sellCrypto: json["sell_crypto"],
        isQrcode: json["is_qrcode"],
        cryptoBalance: json["crypto_balance"],
        fiatBalance: json["fiat_balance"],
        isCoinbaseCoin: json["is_coinbase_coin"],
        noCoinbaseCoin: json["no_coinbase_coin"],
    );

   
}
