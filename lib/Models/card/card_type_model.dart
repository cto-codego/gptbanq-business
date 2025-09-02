import 'dart:convert';

CardTypeModel cardTypeModelFromJson(String str) =>
    CardTypeModel.fromJson(json.decode(str));

String cardTypeModelToJson(CardTypeModel data) => json.encode(data.toJson());

class CardTypeModel {
  int? status;
  int? cardWithCardHolder;
  int? cardWithoutCardHolder;
  String? cardImage;
  Shipping? shipping;

  CardTypeModel({
    this.status,
    this.cardWithCardHolder,
    this.cardWithoutCardHolder,
    this.cardImage,
    this.shipping,
  });

  factory CardTypeModel.fromJson(Map<String, dynamic> json) => CardTypeModel(
        status: json["status"],
        cardWithCardHolder: json["card_with_card_holder"],
        cardWithoutCardHolder: json["card_without_card_holder"],
        cardImage: json["cardImage"],
        shipping: json["shipping"] == null
            ? null
            : Shipping.fromJson(json["shipping"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "card_with_card_holder": cardWithCardHolder,
        "card_without_card_holder": cardWithoutCardHolder,
        "cardImage": cardImage,
        "shipping": shipping?.toJson(),
      };
}

class Shipping {
  String? address;
  String? postalcode;
  String? city;
  List<Country> country;

  Shipping({
    this.address,
    this.postalcode,
    this.city,
    required this.country,
  });

  factory Shipping.fromJson(Map<String, dynamic> json) => Shipping(
        address: json["address"],
        postalcode: json["postalcode"],
        city: json["city"],
        country: json["country"] == null
            ? []
            : List<Country>.from(
                json["country"]!.map((x) => Country.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "postalcode": postalcode,
        "city": city,
        "country": country == null
            ? []
            : List<dynamic>.from(country!.map((x) => x.toJson())),
      };
}

class Country {
  String? countryCode;
  String? countryName;

  Country({
    this.countryCode,
    this.countryName,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        countryCode: json["country_code"],
        countryName: json["country_name"],
      );

  Map<String, dynamic> toJson() => {
        "country_code": countryCode,
        "country_name": countryName,
      };
}
