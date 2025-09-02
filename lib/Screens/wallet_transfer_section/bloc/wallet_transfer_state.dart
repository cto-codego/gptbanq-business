part of 'wallet_transfer_bloc.dart';

@immutable
class WalletTransferState {
  SendmoneyModel? sendmoneyModel;
  PushModel? pushModel;
  bool? isloading;
  RegulaModel? regulaModel;
  StatusModel? statusModel;
  WalletTransferIbanListModel? walletTransferIbanListModel;

  WalletTransferState({
    this.isloading,
    this.regulaModel,
    this.pushModel,
    this.statusModel,
    this.sendmoneyModel,
    this.walletTransferIbanListModel,
  });

  factory WalletTransferState.init() {
    return WalletTransferState(
      isloading: false,
      regulaModel: RegulaModel(message: '', status: 222),
      pushModel: PushModel(message: '', status: 222),
      statusModel: StatusModel(message: '', status: 222),
      walletTransferIbanListModel: WalletTransferIbanListModel(
          status: 222, message: "", senderIban: [], receiverIban: []),
    );
  }

  WalletTransferState update({
    bool? isloading,
    BinficaryModel? binficaryModel,
    StatusModel? statusModel,
    PushModel? pushModel,
    RegulaModel? regulaModel,
    WalletTransferIbanListModel? walletTransferIbanListModel,
  }) {
    return WalletTransferState(
      isloading: isloading,
      regulaModel: regulaModel,
      statusModel: statusModel,
      pushModel: pushModel,
      walletTransferIbanListModel:
          walletTransferIbanListModel ?? this.walletTransferIbanListModel,
    );
  }
}
