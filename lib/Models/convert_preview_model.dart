
class ConvertModel {
    ConvertModel({
        this.status,
        this.amount,
        this.payAmount,
        this.convertAmount,
        this.fee,
        this.getAmount,
        this.price,
        this.type,
        this.fromSymbol,
        this.toSymbol,
        this.message,
        this.showamount
    });

    int ?status;
    String? amount;
    String ?payAmount;
    String ?convertAmount;
    String ?fee;
    String ?getAmount;
    String ?price;
    String ?type;
    String ?fromSymbol;
    String ?toSymbol;
    String ?message;
    String ? showamount;

    factory ConvertModel.fromJson(Map<String, dynamic> json) => ConvertModel(
        status: json["status"] ?? 222,
        amount: json["amount"] ?? '',
        payAmount: json["pay_amount"] ??'',
        convertAmount: json["convert_amount"] ??'',
        fee: json["fee"]??'',
        getAmount: json["get_amount"] ??'',
        price: json["price"]??'',
        type: json["type"]??"",
        fromSymbol: json["from_symbol"] ?? "",
        toSymbol: json["to_symbol"] ?? '',
        message:  json['message'] ??'',
        showamount : json['showamount'] ?? '',
    );

   
}
