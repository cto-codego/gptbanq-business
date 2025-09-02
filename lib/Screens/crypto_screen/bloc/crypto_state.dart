part of 'crypto_bloc.dart';

class CryptoState {
  bool? isloading;
  StatusModel? statusModel;
  Coins? coins;
  CoindetailsModel? coindetailsModel;
  SendNetwork? sendNetwork;
  CoinQrcode? coinQrcode;
  ConvertModel? convertModel;
  Tokennetworks? tokennetworks;
  StakeOverviewModel? stakeOverviewModel;
  StakeProfitLogModel? stakeProfitLog;
  StakeStopModel? stakeStopModel;
  StakeFeeBalanceModel? stakeFeeBalanceModel;
  StakeOrderModel? stakeOrderModel;
  StakeConfirmModel? stakeConfirmModel;
  IbanlistModel? ibanlistModel;
  NewStakeRequestModel? newStakeRequestModel;
  StakePeriodModel? stakePeriodModel;
  StakeCustomPeriodModel? stakeCustomPeriodModel;
  IbanDepositEurToCryptoModel? ibanDepositEurToCryptoModel;
  IbanDepositEurToCryptoCancelModel? ibanDepositEurToCryptoCancelModel;
  EurWithdrawModel? eurWithdrawModel;
  IbanGetCustomAccountsModel? ibanGetCustomAccountsModel;

  CryptoState({
    this.isloading,
    this.coins,
    this.statusModel,
    this.coindetailsModel,
    this.sendNetwork,
    this.coinQrcode,
    this.convertModel,
    this.tokennetworks,
    this.stakeOverviewModel,
    this.stakeProfitLog,
    this.stakeStopModel,
    this.stakeFeeBalanceModel,
    this.stakeOrderModel,
    this.stakeConfirmModel,
    this.ibanlistModel,
    this.newStakeRequestModel,
    this.stakePeriodModel,
    this.stakeCustomPeriodModel,
    this.ibanDepositEurToCryptoModel,
    this.ibanDepositEurToCryptoCancelModel,
    this.eurWithdrawModel,
    this.ibanGetCustomAccountsModel,
  });

  factory CryptoState.init() {
    return CryptoState(
      isloading: false,
      statusModel: StatusModel(message: '', status: 222),
      ibanlistModel: IbanlistModel(ibaninfo: [], status: 222),
      tokennetworks: Tokennetworks(
        userAddresses: [UserAddresses(address: '', network: '', qrcode: '')],
      ),
      convertModel: ConvertModel(),
      coinQrcode:
          CoinQrcode(address: '', networkType: '', qrcode: '', name: ''),
      sendNetwork: SendNetwork(network: []),
      coindetailsModel: CoindetailsModel(
          coin: coininfo(
              image: '',
              currencyName: '',
              currencySymbol: '',
              paircurrency: "",
              cryptoBalance: ''),
          trx: [],
          stakingProfit: "",
          isCstaking: 0,
          isButton: 0),
      coins: Coins(coin: [], curruncylist: [], portfolio: '', status: 222),
      stakeOverviewModel: StakeOverviewModel(
          status: 222,
          logs: [],
          overview: Overview(symbol: "", totalAmount: "", totalProfit: ""),
          stakingProfit: "",
          isCstaking: 0,
          isButton: 0,
          isEdit: 222,
          period: "",
          amount: "",
          dailyprofit: "",
          thismonthprofit: ""),
      stakeProfitLog: StakeProfitLogModel(
        status: 222,
        logs: [],
      ),
      stakeStopModel: StakeStopModel(status: 222, message: ""),
      stakeFeeBalanceModel: StakeFeeBalanceModel(
          status: 222, coin: "", stakingProfit: "", balance: "", eurPrice: ""),
      stakeOrderModel: StakeOrderModel(
          status: 222,
          orderId: "",
          amount: "",
          coin: "",
          commission: "",
          profit: "",
          period: ""),
      stakeConfirmModel: StakeConfirmModel(status: 222, message: ""),
      newStakeRequestModel: NewStakeRequestModel(status: 222, message: ""),
      stakePeriodModel: StakePeriodModel(sttaus: 222, period: []),
      stakeCustomPeriodModel:
          StakeCustomPeriodModel(sttaus: 222, period: [], message: ""),
      ibanDepositEurToCryptoModel: IbanDepositEurToCryptoModel(
          status: 222, message: "", title: "", body: "", uniqueId: ""),
      ibanDepositEurToCryptoCancelModel:
          IbanDepositEurToCryptoCancelModel(status: 222, message: ""),
      eurWithdrawModel: EurWithdrawModel(
          status: 222, message: "", title: "", body: "", uniqueId: ""),
      ibanGetCustomAccountsModel:
          IbanGetCustomAccountsModel(status: 222, message: "", ibaninfo: []),
    );
  }

  CryptoState update({
    bool? isloading,
    StatusModel? statusModel,
    IbanlistModel? ibanlistModel,
    Tokennetworks? tokennetworks,
    SendNetwork? sendNetwork,
    Coins? coins,
    CoindetailsModel? coindetailsModel,
    CoinQrcode? coinQrcode,
    ConvertModel? convertModel,
    StakeOverviewModel? stakeOverviewModel,
    StakeProfitLogModel? stakeProfitLog,
    StakeStopModel? stakeStopModel,
    StakeFeeBalanceModel? stakeFeeBalanceModel,
    StakeOrderModel? stakeOrderModel,
    StakeConfirmModel? stakeConfirmModel,
    NewStakeRequestModel? newStakeRequestModel,
    StakePeriodModel? stakePeriodModel,
    StakeCustomPeriodModel? stakeCustomPeriodModel,
    IbanDepositEurToCryptoModel? ibanDepositEurToCryptoModel,
    IbanDepositEurToCryptoCancelModel? ibanDepositEurToCryptoCancelModel,
    EurWithdrawModel? eurWithdrawModel,
    IbanGetCustomAccountsModel? ibanGetCustomAccountsModel,
  }) {
    return CryptoState(
      isloading: isloading,
      coins: coins ?? this.coins,
      ibanlistModel: ibanlistModel ?? this.ibanlistModel,
      statusModel: statusModel ?? this.statusModel,
      sendNetwork: sendNetwork ?? this.sendNetwork,
      coinQrcode: coinQrcode ?? this.coinQrcode,
      coindetailsModel: coindetailsModel ?? this.coindetailsModel,
      convertModel: convertModel,
      tokennetworks: tokennetworks ?? this.tokennetworks,
      stakeOverviewModel: stakeOverviewModel ?? this.stakeOverviewModel,
      stakeProfitLog: stakeProfitLog ?? this.stakeProfitLog,
      stakeStopModel: stakeStopModel ?? this.stakeStopModel,
      stakeFeeBalanceModel: stakeFeeBalanceModel ?? this.stakeFeeBalanceModel,
      stakeOrderModel: stakeOrderModel ?? this.stakeOrderModel,
      stakeConfirmModel: stakeConfirmModel ?? this.stakeConfirmModel,
      newStakeRequestModel: newStakeRequestModel ?? this.newStakeRequestModel,
      stakePeriodModel: stakePeriodModel ?? this.stakePeriodModel,
      stakeCustomPeriodModel:
          stakeCustomPeriodModel ?? this.stakeCustomPeriodModel,
      ibanDepositEurToCryptoModel:
          ibanDepositEurToCryptoModel ?? this.ibanDepositEurToCryptoModel,
      ibanDepositEurToCryptoCancelModel: ibanDepositEurToCryptoCancelModel ??
          this.ibanDepositEurToCryptoCancelModel,
      eurWithdrawModel: eurWithdrawModel ?? this.eurWithdrawModel,
      ibanGetCustomAccountsModel:
          ibanGetCustomAccountsModel ?? this.ibanGetCustomAccountsModel,
    );
  }
}
