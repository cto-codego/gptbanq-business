class BankInfo {
  String ? bankName, account, bankSwiftCode, bankSwift, accountHolder;

  BankInfo({
    this.bankName,
    this.account,
    this.bankSwiftCode,
    this.bankSwift,
    this.accountHolder
  });

  factory BankInfo.fromJson(Map<String, dynamic> json) {
    return BankInfo(
      bankName: json['bankname'] ?? '',
      account: json['account'] ?? '',
      bankSwiftCode: json['bank_swift_code'] ?? '',
      bankSwift: json['bank_swift'] ?? '',
      accountHolder: json['account_holder'] ?? '',
     );
  }
}
