import 'package:gptbanqbusiness/Models/bank_info.dart';

class SuccessTransfer {
  int? status;
  String? reference;
  BankInfo? bankInfo;
  String? message = '';

  SuccessTransfer({this.status, this.reference, this.bankInfo, this.message});

  factory SuccessTransfer.fromJson(Map<String, dynamic> json) {
    return SuccessTransfer(
      status: json['status'],
      message: json['message'],
      reference: json['reference'] ?? '',
      bankInfo: json['bank'] != null
          ? BankInfo.fromJson(json['bank'])
          : BankInfo(
              bankName: '',
              account: '',
              bankSwiftCode: '',
              bankSwift: '',
            ),
    );
  }
}
