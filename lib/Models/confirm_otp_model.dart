
class Confirmotp {
    Confirmotp({
        this.status,
        this.account,
        this.memo,
        this.amount,
        this.message,
    });

    int ?status;
    String? account;
    String ?memo;
    String ?amount;
    String ?message;

    factory Confirmotp.fromJson(Map<String, dynamic> json) => Confirmotp(
        status: json["status"],
        account: json["account"]??'',
        memo: json["memo"]??"",
        amount: json["amount"]??"",
        message: json["message"]??"",
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "account": account,
        "memo": memo,
        "amount": amount,
        "message": message,
    };
}