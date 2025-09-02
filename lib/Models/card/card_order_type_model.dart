// To parse this JSON data, do
//
//     final cardOrderTypeModel = cardOrderTypeModelFromJson(jsonString);

import 'dart:convert';

CardOrderTypeModel cardOrderTypeModelFromJson(String str) =>
    CardOrderTypeModel.fromJson(json.decode(str));

String cardOrderTypeModelToJson(CardOrderTypeModel data) =>
    json.encode(data.toJson());

class CardOrderTypeModel {
  final int? status;
  final Cardtype? cardtype;
  final Prepaid? prepaid;
  final Debit? debit;

  CardOrderTypeModel({
    this.status,
    this.cardtype,
    this.prepaid,
    this.debit,
  });

  factory CardOrderTypeModel.fromJson(Map<String, dynamic> json) =>
      CardOrderTypeModel(
        status: json["status"],
        cardtype: json["cardtype"] == null
            ? null
            : Cardtype.fromJson(json["cardtype"]),
        prepaid:
        json["prepaid"] == null ? null : Prepaid.fromJson(json["prepaid"]),
        debit: json["debit"] == null ? null : Debit.fromJson(json["debit"]),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "cardtype": cardtype?.toJson(),
    "prepaid": prepaid?.toJson(),
    "debit": debit?.toJson(),
  };
}

class Cardtype {
  final int? isPhysical;
  final int? isVirtual;

  Cardtype({
    this.isPhysical,
    this.isVirtual,
  });

  factory Cardtype.fromJson(Map<String, dynamic> json) => Cardtype(
    isPhysical: json["is_physical"],
    isVirtual: json["is_virtual"],
  );

  Map<String, dynamic> toJson() => {
    "is_physical": isPhysical,
    "is_virtual": isVirtual,
  };
}

class Debit {
  final String? isDebitcard;
  final String? image;

  Debit({
    this.isDebitcard,
    this.image,
  });

  factory Debit.fromJson(Map<String, dynamic> json) => Debit(
    isDebitcard: json["is_debitcard"].toString(),
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "is_debitcard": isDebitcard,
    "image": image,
  };
}

class Prepaid {
  final String? isPrepaid;
  final String? image;

  Prepaid({
    this.isPrepaid,
    this.image,
  });

  factory Prepaid.fromJson(Map<String, dynamic> json) => Prepaid(
    isPrepaid: json["is_prepaid"].toString(),
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "is_prepaid": isPrepaid,
    "image": image,
  };
}
