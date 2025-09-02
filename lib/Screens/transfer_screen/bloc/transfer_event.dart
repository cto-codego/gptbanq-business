part of 'transfer_bloc.dart';

@immutable
class TransferEvent {}

class binficarylistEvent extends TransferEvent {
  String ibanId;

  binficarylistEvent({required this.ibanId});
}

class AddExternalbenficaryEvent extends TransferEvent {
  String? firstname, lastname, bic, image, email, iban, companyname, type;

  AddExternalbenficaryEvent(
      {this.email,
      this.iban,
      this.image,
      this.firstname,
      this.bic,
      this.lastname,
      this.companyname,
      this.type});
}

class SendmoneyEvent extends TransferEvent {
  String? refrence, uniquid, amount, paymentoption, iban;

  SendmoneyEvent(
      {this.amount,
      this.refrence,
      this.uniquid,
      this.paymentoption,
      this.iban});
}

class SwipconfirmEvent extends TransferEvent {
  String? unique_id;

  SwipconfirmEvent({this.unique_id});
}

class DeleteBeneficiaryEvent extends TransferEvent {
  String? uniqueId;

  DeleteBeneficiaryEvent({this.uniqueId});
}

class ApproveibanTransactionEvent extends TransferEvent {
  String completed, lat, long, uniqueId;

  ApproveibanTransactionEvent(
      {required this.completed,
      required this.lat,
      required this.long,
      required this.uniqueId});
}

class ApproveibanSwiftTransactionEvent extends TransferEvent {
  String completed, lat, long, uniqueId;

  ApproveibanSwiftTransactionEvent(
      {required this.completed,
      required this.lat,
      required this.long,
      required this.uniqueId});
}

class SepatypesEvent extends TransferEvent {}

class RegulaupdateBiometric extends TransferEvent {
  String? facematch, kycid, userimage;

  RegulaupdateBiometric({this.facematch, this.kycid, this.userimage});
}

class getibanlistEvent extends TransferEvent {
  String beneficiaryId;

  getibanlistEvent({required this.beneficiaryId});
}

class GetSwiftCountryListEvent extends TransferEvent {}

class GetDynamicBeneficiaryFieldListEvent extends TransferEvent {
  String country, currency, accountType;

  GetDynamicBeneficiaryFieldListEvent(
      {required this.country,
      required this.currency,
      required this.accountType});
}

class AddDynamicBeneficiaryEvent extends TransferEvent {
  String? country,
      currency,
      accountType,
      recipientCountry,
      image,
      beneficiaryIdentificationType,
      beneficiaryIdentificationValue;
  Map<String, dynamic> dynamicFrom;

  AddDynamicBeneficiaryEvent({
    required this.country,
    required this.currency,
    required this.accountType,
    required this.recipientCountry,
    required this.dynamicFrom,
    this.image,
    this.beneficiaryIdentificationType,
    this.beneficiaryIdentificationValue,
  });
}

class SwiftSendmoneyEvent extends TransferEvent {
  String? refrence,
      uniquid,
      amount,
      paymentoption,
      iban,
      sendNotification,
      seOnSession,
      paymentCode;
  int? swiftShared;

  SwiftSendmoneyEvent({
    this.amount,
    this.refrence,
    this.uniquid,
    this.paymentoption,
    this.iban,
    this.swiftShared,
    this.seOnSession,
    this.paymentCode,
    this.sendNotification,
  });
}

class GetSwiftPaymentCodeEvent extends TransferEvent {
  String id;

  GetSwiftPaymentCodeEvent({
    required this.id,
  });
}
