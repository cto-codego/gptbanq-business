// To parse this JSON data, do
//
//     final planlinkmodel = planlinkmodelFromJson(jsonString);

import 'dart:convert';

Planlinkmodel planlinkmodelFromJson(String str) => Planlinkmodel.fromJson(json.decode(str));

String planlinkmodelToJson(Planlinkmodel data) => json.encode(data.toJson());

class Planlinkmodel {
    int ?status;
    String ?personPriceLink;
    String ?businessPriceLink;

    Planlinkmodel({
        this.status,
        this.personPriceLink,
        this.businessPriceLink,
    });

    factory Planlinkmodel.fromJson(Map<String, dynamic> json) => Planlinkmodel(
        status: json["status"],
        personPriceLink: json["person_price_link"],
        businessPriceLink: json["business_price_link"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "person_price_link": personPriceLink,
        "business_price_link": businessPriceLink,
    };
}
