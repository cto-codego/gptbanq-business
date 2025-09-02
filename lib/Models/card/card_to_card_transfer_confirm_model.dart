import 'dart:convert';

CardToCardTransferConfirmModel cardToCardTransferConfirmModelFromJson(
        String str) =>
    CardToCardTransferConfirmModel.fromJson(json.decode(str));

String cardToCardTransferConfirmModelToJson(
        CardToCardTransferConfirmModel data) =>
    json.encode(data.toJson());

class CardToCardTransferConfirmModel {
  int? status;
  String? message;

  CardToCardTransferConfirmModel({
    this.status,
    this.message,
  });

  factory CardToCardTransferConfirmModel.fromJson(Map<String, dynamic> json) =>
      CardToCardTransferConfirmModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
