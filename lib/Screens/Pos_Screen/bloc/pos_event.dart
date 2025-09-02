part of 'pos_bloc.dart';

@immutable
abstract class PosEvent {}

class checkposEvent extends PosEvent {}

class RequestposEvent extends PosEvent {}

class GetterminalEvent extends PosEvent {}

class GettransactionsEvent extends PosEvent {
  int? page;
  String? trid, date;

  GettransactionsEvent({this.date, this.page, this.trid});
}

class GettrxlogEvent extends PosEvent {
  int? page;
  String? trid, date, status;

  GettrxlogEvent({this.date, this.page, this.trid, this.status});
}

class posplanEvent extends PosEvent {}

class CheckPosModuleEvent extends PosEvent {}

class CryptoPosListEvent extends PosEvent {}

class CreateCryptoStoreEvent extends PosEvent {
  String label, currency;

  CreateCryptoStoreEvent({required this.label, required this.currency});
}

class CoinListEvent extends PosEvent {}

class CreateQrEvent extends PosEvent {
  String symbol, amount, storeId, type;
  String? email;

  CreateQrEvent(
      {required this.symbol,
      required this.storeId,
      required this.amount,
      required this.type,
      this.email});
}

class GetCryptoTransactionInfoEvent extends PosEvent {
  String uniqueId;

  GetCryptoTransactionInfoEvent({required this.uniqueId});
}

class CryptoOrderCancelEvent extends PosEvent {
  String uniqueId;

  CryptoOrderCancelEvent({required this.uniqueId});
}

class StoreTransactionLogEvent extends PosEvent {
  String storeId;

  StoreTransactionLogEvent({required this.storeId});
}

class TransactionDetailsEvent extends PosEvent {
  String uniqueId;

  TransactionDetailsEvent({required this.uniqueId});
}

class RemotePaymentEvent extends PosEvent {
  String reason, amount, storeId, type, email;

  RemotePaymentEvent(
      {required this.reason,
      required this.storeId,
      required this.amount,
      required this.type,
      required this.email});
}

class CryptoGatewayCurrencyListEvent extends PosEvent {
  CryptoGatewayCurrencyListEvent();
}
