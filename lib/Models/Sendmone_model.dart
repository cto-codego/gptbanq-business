class SendmoneyModel {
  int? status;
  String? name,
      bic,
      iban,
      amount,
      commission,
      total,
      referncepayment,
      paymentoption,
      date,
      uniqueid,
      message;

  SendmoneyModel({
    this.status,
    this.amount,
    this.bic,
    this.commission,
    this.date,
    this.iban,
    this.message,
    this.name,
    this.paymentoption,
    this.referncepayment,
    this.total,
    this.uniqueid,
  });

  factory SendmoneyModel.fromJson(Map<String, dynamic> json) {
    return SendmoneyModel(
      status: json['status'] ?? 222,
      name: json['name'] ?? '',
      bic: json['bic'] ?? '',
      iban: json['iban'] ?? '',
      amount: json['amount'] ?? '',
      commission: json['commission'] ?? '',
      total: json['total'] ?? '',
      referncepayment: json['refernce_payment'] ?? '',
      paymentoption: json['payment_option'] ?? '',
      date: json['date'] ?? '',
      uniqueid: json['unique_id'] ?? '',
      message: json['message'] ?? '',
      
    );
  }
}
