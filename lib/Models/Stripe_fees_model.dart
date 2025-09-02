
class Stripefees {
    Stripefees({
        this.status,
        this.fee,
        this.amount,
        this.totalPay,
        this.sendToStripe,
        this.messgage
    });

    int ?status;
    String? fee;
    String ?amount;
    String ?totalPay;
    String ?sendToStripe;
    String ?messgage;

    factory Stripefees.fromJson(Map<String, dynamic> json) => Stripefees(
        status: json["status"],
        fee: json["fee"],
        amount: json["amount"],
        totalPay: json["total_pay"],
        sendToStripe: json["send_to_stripe"],
        messgage: json['message']??'',
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "fee": fee,
        "amount": amount,
        "total_pay": totalPay,
        "send_to_stripe": sendToStripe,
    };
}
