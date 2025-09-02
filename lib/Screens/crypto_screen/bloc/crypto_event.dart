part of 'crypto_bloc.dart';

class CryptoEvent {}

class GetcoinsEvent extends CryptoEvent {}

class RefreshGetcoinsEvent extends CryptoEvent {}

class GetcoinDetailsEvent extends CryptoEvent {
  String? symbol;

  GetcoinDetailsEvent({this.symbol});
}

class UpdateGetcoinDetailsEvent extends CryptoEvent {
  String? symbol;

  UpdateGetcoinDetailsEvent({this.symbol});
}

class GetnetworkEvent extends CryptoEvent {
  String? symbol;

  GetnetworkEvent({this.symbol});
}

class GenerateQrcodeNetworksEvent extends CryptoEvent {
  String? symbol;

  GenerateQrcodeNetworksEvent({this.symbol});
}

class SendCoinEvent extends CryptoEvent {
  String? currencyId, amount, address, network, memo;

  SendCoinEvent({this.currencyId, this.amount, this.address, this.network, this.memo});
}

class GenerateaddressEvent extends CryptoEvent {
  String? symbol;

  GenerateaddressEvent({this.symbol});
}

class ConvercoinEvent extends CryptoEvent {
  String? basesymbol, from, to, amount;

  ConvercoinEvent({this.basesymbol, this.from, this.to, this.amount});
}

class ConfirmConvertevent extends CryptoEvent {
  String? amount;
  String? to_coin;
  String? from_coin;
  String? type;
  String? base_coin_symbol;

  ConfirmConvertevent(
      {this.amount,
      this.to_coin,
      this.from_coin,
      this.type,
      this.base_coin_symbol});
}

class MovetoIbanEvent extends CryptoEvent {
  String? amount, ibanid;

  MovetoIbanEvent({this.amount, this.ibanid});
}

class MoveEurotocryptoEvent extends CryptoEvent {
  String? amount, ibanid;

  MoveEurotocryptoEvent({this.amount, this.ibanid});
}

class ApproveMoveWalletsEvent extends CryptoEvent {
  String? uniqueId, completed;

  ApproveMoveWalletsEvent({
    this.uniqueId,
    this.completed,
  });
}

class ApproveTransactionEvent extends CryptoEvent {
  String? uniqueId, completed;

  ApproveTransactionEvent({
    this.uniqueId,
    this.completed,
  });
}

class ApproveEurotoIbanEvent extends CryptoEvent {
  String? uniqueId, completed;

  ApproveEurotoIbanEvent({
    this.uniqueId,
    this.completed,
  });
}

class ApproveEurotoCryptoEvent extends CryptoEvent {
  String? uniqueId, completed;

  ApproveEurotoCryptoEvent({
    this.uniqueId,
    this.completed,
  });
}

class StakeOverviewEvent extends CryptoEvent {
  String? symbol;

  StakeOverviewEvent({this.symbol});
}

class StakeProfitLogEvent extends CryptoEvent {
  String? orderId;

  StakeProfitLogEvent({this.orderId});
}

class StakeStopEvent extends CryptoEvent {
  String? orderId;

  StakeStopEvent({this.orderId});
}

class StakeFeeEvent extends CryptoEvent {
  String? symbol;

  StakeFeeEvent({this.symbol});
}

class StakeOrderEvent extends CryptoEvent {
  String? symbol, amount;

  StakeOrderEvent({this.symbol, this.amount});
}

class StakeConfirmEvent extends CryptoEvent {
  String? orderId;

  StakeConfirmEvent({this.orderId});
}

class getibanlistEvent extends CryptoEvent {
  getibanlistEvent();
}

class StakeRequestEvent extends CryptoEvent {
  String? symbol, amount, period, isCustom, ibanId;

  StakeRequestEvent(
      {this.symbol, this.amount, this.period, this.isCustom, this.ibanId});
}

class StakePeriodEvent extends CryptoEvent {
  StakePeriodEvent();
}

class SwiftTermsEvent extends CryptoEvent {
  final String type, deviceType;

  SwiftTermsEvent({required this.type, required this.deviceType});
}

class IbanGetCustomAccountEvent extends CryptoEvent {
  final String type, symbol;

  IbanGetCustomAccountEvent({required this.type, required this.symbol});
}
