part of 'dashboard_bloc.dart';

@immutable
class DashboardEvent {}

class DashboarddataEvent extends DashboardEvent {}

class opendialog extends DashboardEvent {
  final bool? open;

  opendialog({this.open});
}

class ShareibanEvent extends DashboardEvent {
  final String? email, iban;

  ShareibanEvent({this.email, this.iban});
}

class closenotificationEvent extends DashboardEvent {
  final String? notifId;

  closenotificationEvent({this.notifId});
}

class OrdercardEvent extends DashboardEvent {
  final String? type;

  OrdercardEvent({this.type});
}

class confirmdebitorder extends DashboardEvent {}

class debitcardfees extends DashboardEvent {
  final String? type;

  debitcardfees({this.type});
}

class activateDebitwithcodeEvent extends DashboardEvent {
  final String? lastdigit, code;

  activateDebitwithcodeEvent({this.lastdigit, this.code});
}

class ActivateDebutcardEvent extends DashboardEvent {
  final String? cardnumber, mm, yy, cvv;

  ActivateDebutcardEvent({this.cardnumber, this.mm, this.yy, this.cvv});
}

class DebitcarddetailsEvent extends DashboardEvent {}

class debitcardinfoevent extends DashboardEvent {
  final String? cardid, pin;

  debitcardinfoevent({this.cardid, this.pin});
}

class transactiondetailsEvent extends DashboardEvent {
  final String? uniqueId;

  transactiondetailsEvent({this.uniqueId});
}

class DawnloadEvent extends DashboardEvent {
  final String? uniqueId;

  DawnloadEvent({this.uniqueId});
}

class ResetCardPinEvent extends DashboardEvent {
  final String? cardPin, cardId;

  ResetCardPinEvent({this.cardPin, this.cardId});
}

class UpdateCardSettingEvent extends DashboardEvent {
  final String? cardId, settingName, settingValue;

  UpdateCardSettingEvent({
    this.cardId,
    this.settingName,
    this.settingValue,
  });
}

class Movebalancetodebit extends DashboardEvent {
  final String? amount, ibanid;

  Movebalancetodebit({this.amount, this.ibanid});
}

class checkcardEvent extends DashboardEvent {}

class ApproveMoveWalletsEvent extends DashboardEvent {
  final String? uniqueId, completed;

  ApproveMoveWalletsEvent({
    this.uniqueId,
    this.completed,
  });
}

class ApproveTransactionEvent extends DashboardEvent {
  final String? uniqueId, completed;

  ApproveTransactionEvent({
    this.uniqueId,
    this.completed,
  });
}

class ApproveEurotoIbanEvent extends DashboardEvent {
  final String? uniqueId, completed;

  ApproveEurotoIbanEvent({
    this.uniqueId,
    this.completed,
  });
}

class ApproveEurotoCryptoEvent extends DashboardEvent {
  final String? uniqueId, completed;

  ApproveEurotoCryptoEvent({
    this.uniqueId,
    this.completed,
  });
}

class ApproveBrowserLoginEvent extends DashboardEvent {
  final String? uniqueId;
  final int? loginStatus;

  ApproveBrowserLoginEvent({this.uniqueId, this.loginStatus});
}

class TrxBiometricDetailsEvent extends DashboardEvent {
  final String? uniqueId;

  TrxBiometricDetailsEvent({this.uniqueId});
}

class TrxBiometricConfirmOrCancelEvent extends DashboardEvent {
  final String? uniqueId;
  final String? loginStatus;

  TrxBiometricConfirmOrCancelEvent({this.uniqueId, this.loginStatus});
}

// class checkupdate extends DashboardEvent {}

//gift card section

class GiftCardListEvent extends DashboardEvent {}

class GiftCardGetFeeTypeEvent extends DashboardEvent {}

class GiftCardGetFeeDataEvent extends DashboardEvent {
  final String amount;

  GiftCardGetFeeDataEvent({required this.amount});
}

class GiftCardGetOrderConfirmEvent extends DashboardEvent {}

class GiftCardGetDetailsEvent extends DashboardEvent {}

class GiftCardDeleteEvent extends DashboardEvent {}

class GiftCardShareEvent extends DashboardEvent {}

//card section

class CardListEvent extends DashboardEvent {}

class CardOrderTypeEvent extends DashboardEvent {}

class CardTypeEvent extends DashboardEvent {}

class CardGetTypeEvent extends DashboardEvent {}

class CardFeeEvent extends DashboardEvent {}


class CardDetailsEvent extends DashboardEvent {}

class CardActiveEvent extends DashboardEvent {}

class CardSettingsEvent extends DashboardEvent {}

class CardBlockUnblockEvent extends DashboardEvent {}

class CardReplaceEvent extends DashboardEvent {}

class CardIbanListEvent extends DashboardEvent {}


class CardTopupConfirmEvent extends DashboardEvent {
  String ibanId;
  CardTopupConfirmEvent({required this.ibanId});
}

class CardOrderConfirmEvent extends DashboardEvent {
  String ibanId;
  CardOrderConfirmEvent({required this.ibanId});
}

class CardTopupAmountEvent extends DashboardEvent {
  String ibanId;
  CardTopupAmountEvent({required this.ibanId});
}

class CardIbanCallEvent extends DashboardEvent {}

class CardTopUpIbanCallEvent extends DashboardEvent {}

//virtual card section

class CardBeneficiaryListEvent extends DashboardEvent {}

class AddCardBeneficiaryEvent extends DashboardEvent {}

class DeleteCardBeneficiaryEvent extends DashboardEvent {}

class CardToCardTransferFeesEvent extends DashboardEvent {}

class CardToCardTransferConfirmEvent extends DashboardEvent {}

class DownloadTransactionStatementEvent extends DashboardEvent {}

//iban
class getibanlistEvent extends DashboardEvent {
  getibanlistEvent();
}

class CreateibanEvent extends DashboardEvent {
  final String? Label, currency, iban;
  int isWallet;

  CreateibanEvent(
      {this.Label, this.currency, this.iban, required this.isWallet});
}

/*Multiple Iban create*/
class GetIbanCurrencyEvent extends DashboardEvent {}

class getMultipleIbanEvent extends DashboardEvent {
  final String currency;

  getMultipleIbanEvent({required this.currency});
}

class IbanSumSubVerified extends DashboardEvent {
  final String? currency, iban;

  IbanSumSubVerified({this.currency, this.iban});
}

class DynamicBeneficiaryCurrencyEvent extends DashboardEvent {}

class SwiftDepositEvent extends DashboardEvent {}

class SwiftTermsEvent extends DashboardEvent {
  final String? type, deviceType;

  SwiftTermsEvent({this.type, this.deviceType});
}

class DepositAccountDetailsEvent extends DashboardEvent {
  final String? ibanId;

  DepositAccountDetailsEvent({this.ibanId});
}

class ConvertCurrencyListEvent extends DashboardEvent {
  final String? buyCurrency;

  ConvertCurrencyListEvent({this.buyCurrency});
}

class TermsPdfEvent extends DashboardEvent {
  TermsPdfEvent();
}

class WalletTransferIbanListEvent extends DashboardEvent {
  String ibanId;

  WalletTransferIbanListEvent({required this.ibanId});
}

class RequestForSessionDataEvent extends DashboardEvent {
  final String uniqueId;

  RequestForSessionDataEvent(
      {required this.uniqueId});
}
