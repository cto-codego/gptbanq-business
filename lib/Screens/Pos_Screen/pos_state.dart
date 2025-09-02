part of 'bloc/pos_bloc.dart';

@immutable
class PosState {
  bool? isloading;
  PosstatusModel? posstatusModel;
  Trxmodel? trxmodel;
  PosFeesModel? posFeesModel;
  Trxlogmodel? trxlogmodel;

  TerminalDevicesmodel? terminalDevicesmodel;
  CheckPosModuleModel? checkPosModuleModel;
  CryptoPosListModel? cryptoPosListModel;
  CoinListModel? coinListModel;
  CreateQrModel? createQrModel;
  GetCryptoTransactionInfoModel? getCryptoTransactionInfoModel;

  StatusModel? statusModel;
  CryptoOrderCancelModel? cryptoOrderCancelModel;
  StoreTransactionLogModel? storeTransactionLogModel;
  RemotePaymentModel? remotePaymentModel;
  CryptoGatewayCurrencyListModel? cryptoGatewayCurrencyListModel;

  PosState(
      {this.isloading,
      this.trxlogmodel,
      this.posFeesModel,
      this.cryptoGatewayCurrencyListModel,
      this.statusModel,
      this.trxmodel,
      this.terminalDevicesmodel,
      this.posstatusModel,
      this.checkPosModuleModel,
      this.cryptoPosListModel,
      this.coinListModel,
      this.createQrModel,
      this.getCryptoTransactionInfoModel,
      this.cryptoOrderCancelModel,
      this.storeTransactionLogModel,
      this.remotePaymentModel});

  factory PosState.init() {
    return PosState(
        isloading: false,
        posFeesModel: PosFeesModel(plan: Plan(monthlyFee: '', cardTrxFee: '')),
        trxlogmodel: Trxlogmodel(
            trx: [],
            totalCommission: '',
            totalPending: '0',
            totalCredit: '',
            totalTransacted: ''),
        trxmodel: Trxmodel(trx: [], totalAmount: ''),
        terminalDevicesmodel: TerminalDevicesmodel(termial: []),
        statusModel: StatusModel(status: 222, message: ''),
        checkPosModuleModel: CheckPosModuleModel(
            status: 222,
            isPos: 0,
            posplan: Posplan(
              planName: "",
              monthlyFee: "",
              cardTrxFee: "",
            ),
            cryptoTrxfee: ""),
        posstatusModel: PosstatusModel(ispos: 222, message: '', status: 222),
        cryptoPosListModel: CryptoPosListModel(status: 222, cryptopos: []),
        coinListModel: CoinListModel(status: 222, coinlist: [], message: ""),
        createQrModel: CreateQrModel(status: 222, uniqueId: "", message: ""),
        getCryptoTransactionInfoModel: GetCryptoTransactionInfoModel(
            status: 222,
            order: Order(
              time: "",
              address: "",
              qrcode: "",
              amount: "",
              cryptoAmount: "",
              currencyName: "",
              symbol: "",
              image: "",
              network: "",
              transactionId: "",
              copyCryptoAmount: ""
            )),
        cryptoOrderCancelModel:
            CryptoOrderCancelModel(status: 222, message: ""),
        remotePaymentModel: RemotePaymentModel(status: 222, message: ""),
        storeTransactionLogModel: StoreTransactionLogModel(
          status: 222,
          totalPaid: "",
          totalUnpaid: "",
          log: [],
        ),
        cryptoGatewayCurrencyListModel: CryptoGatewayCurrencyListModel(
          status: 222,
          message: "",
          currency: [],
        ));
  }

  PosState update({
    bool? isloading,
    Trxmodel? trxmodel,
    PosFeesModel? posFeesModel,
    Trxlogmodel? trxlogmodel,
    TerminalDevicesmodel? terminalDevicesmodel,
    PosstatusModel? posstatusModel,
    StatusModel? statusModel,
    CheckPosModuleModel? checkPosModuleModel,
    CryptoPosListModel? cryptoPosListModel,
    CoinListModel? coinListModel,
    CreateQrModel? createQrModel,
    GetCryptoTransactionInfoModel? getCryptoTransactionInfoModel,
    CryptoOrderCancelModel? cryptoOrderCancelModel,
    StoreTransactionLogModel? storeTransactionLogModel,
    RemotePaymentModel? remotePaymentModel,
    CryptoGatewayCurrencyListModel? cryptoGatewayCurrencyListModel,
  }) {
    return PosState(
      isloading: isloading,
      trxlogmodel: trxlogmodel ?? this.trxlogmodel,
      trxmodel: trxmodel ?? this.trxmodel,
      statusModel: statusModel,
      posFeesModel: posFeesModel ?? this.posFeesModel,
      terminalDevicesmodel: terminalDevicesmodel ?? this.terminalDevicesmodel,
      posstatusModel: posstatusModel,
      checkPosModuleModel: checkPosModuleModel ?? this.checkPosModuleModel,
      cryptoPosListModel: cryptoPosListModel ?? this.cryptoPosListModel,
      coinListModel: coinListModel ?? this.coinListModel,
      createQrModel: createQrModel ?? this.createQrModel,
      getCryptoTransactionInfoModel:
          getCryptoTransactionInfoModel ?? this.getCryptoTransactionInfoModel,
      cryptoOrderCancelModel:
          cryptoOrderCancelModel ?? this.cryptoOrderCancelModel,
      storeTransactionLogModel:
          storeTransactionLogModel ?? this.storeTransactionLogModel,
      remotePaymentModel: remotePaymentModel ?? this.remotePaymentModel,
      cryptoGatewayCurrencyListModel:
          cryptoGatewayCurrencyListModel ?? this.cryptoGatewayCurrencyListModel,
    );
  }
}
