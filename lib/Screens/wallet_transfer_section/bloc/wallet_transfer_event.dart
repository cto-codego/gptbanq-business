part of 'wallet_transfer_bloc.dart';

@immutable
class WalletTransferEvent {}

class WalletTransferIbanListEvent extends WalletTransferEvent {
  String ibanId;

  WalletTransferIbanListEvent({required this.ibanId});
}

class WalletTransferMoveEvent extends WalletTransferEvent {
  String senderIbanId, receiverIbanId, amount;

  WalletTransferMoveEvent(
      {required this.senderIbanId,
      required this.receiverIbanId,
      required this.amount});
}
