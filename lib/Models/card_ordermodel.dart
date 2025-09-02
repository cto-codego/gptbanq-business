// To parse this JSON data, do
//
//     final cardordermodel = cardordermodelFromJson(jsonString);

import 'dart:convert';

Cardordermodel cardordermodelFromJson(String str) => Cardordermodel.fromJson(json.decode(str));


class Cardordermodel {
    int ? status;
    int ? isCardOrder;
    String ? message ;

    Cardordermodel({
        this.status,
        this.isCardOrder,
        this.message
    });

    factory Cardordermodel.fromJson(Map<String, dynamic> json) => Cardordermodel(
        status: json["status"],
        isCardOrder: json["is_card_order"] ?? 222,
        message: json['message'] ?? ''

    );

 
}
