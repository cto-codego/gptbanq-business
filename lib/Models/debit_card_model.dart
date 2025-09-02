// To parse this JSON data, do
//
//     final DebitFees = DebitFeesFromJson(jsonString);

import 'dart:convert';

DebitFees DebitFeesFromJson(String str) => DebitFees.fromJson(json.decode(str));


class DebitFees {
    String ?symbol;
    int ? isShipping;
    String ? shippingCost;
    String  ? serviceFee;
    int ?status;
    String? bankBalance;
    String ?currencyName;
    String ?planName;
    String ?label;
    String ?cardType;
    String ? message ;

    DebitFees({
        this.symbol,
        this.isShipping,
        this.shippingCost,
        this.serviceFee,
        this.status,
        this.bankBalance,
        this.currencyName,
        this.planName,
        this.label,
        this.message,
        this.cardType,
    });

    factory DebitFees.fromJson(Map<String, dynamic> json) => DebitFees(
        symbol: json["symbol"] ?? '',
        isShipping: json["is_shipping"] ?? 222,
        shippingCost: json["shipping_cost"] ?? '',
        serviceFee: json["service_fee"] ?? '',
        status: json["status"] ?? 222,
        bankBalance: json["bank_balance"] ?? '',
        currencyName: json["currency_name"] ?? '',
        planName: json["plan_name"] ?? '',
        label: json["label"] ?? '',
        cardType: json["card_type"] ?? '',
        message: json['message']   ?? ''  );

   
}
