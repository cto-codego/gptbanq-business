part of 'investment_bloc.dart';

class InvestmentState {
  bool? isloading;
  StatusModel? statusModel;
  UnStakeModel? unStakeModel;
  NodeCheckModuleModel? nodeCheckModuleModel;
  NodeLogsModel? nodeLogsModel;
  NodeProfitLogModel? nodeProfitLogModel;
  BuyMasterNodeModel? buyMasterNodeModel;
  IbanGetCustomAccountsModel? ibanGetCustomAccountsModel;
  CdgDeviceListModel? cdgDeviceListModel;
  CdgAccountsModel? cdgAccountsModel;
  CdgDashboardModel? cdgDashboardModel;
  CdgProfitLogModel? cdgProfitLogModel;
  CdgQrCodeModel? cdgQrCodeModel;
  CdgStakeListModel? cdgStakeListModel;
  CdgStakeOverviewModel? cdgStakeOverviewModel;

  InvestmentState(
      {this.isloading,
      this.statusModel,
      this.nodeCheckModuleModel,
      this.nodeLogsModel,
      this.nodeProfitLogModel,
      this.buyMasterNodeModel,
      this.ibanGetCustomAccountsModel,
      this.cdgDeviceListModel,
      this.cdgAccountsModel,
      this.cdgDashboardModel,
      this.cdgProfitLogModel,
      this.cdgQrCodeModel,
      this.cdgStakeListModel,
      this.cdgStakeOverviewModel,
      this.unStakeModel});

  factory InvestmentState.init() {
    return InvestmentState(
      isloading: false,
      statusModel: StatusModel(message: '', status: 222),
      unStakeModel: UnStakeModel(message: '', status: 222),
      nodeCheckModuleModel: NodeCheckModuleModel(
        status: 222,
        isInvestment: 1,
        stakingProfit: "",
        enduserMasternodeProfit: "",
        period: "",
        wlMasternode: "",
        investmentProfit: "",
      ),
      nodeLogsModel: NodeLogsModel(
        status: 222,
        availableBalance: "",
        numberNode: 0,
        order: [],
      ),
      nodeProfitLogModel: NodeProfitLogModel(
        status: 222,
        orderId: "",
        totalPaid: "",
        logs: [],
      ),
      buyMasterNodeModel: BuyMasterNodeModel(
        status: 222,
        coin: "",
        totalPaymentDay: "",
        termsCondition: "",
        perDayProfit: "",
        dropList: [],
      ),
      ibanGetCustomAccountsModel:
          IbanGetCustomAccountsModel(status: 222, message: "", ibaninfo: []),
      cdgDeviceListModel: CdgDeviceListModel(
          status: 222, message: "", isCdg: 0, data: [], quantity: []),
      cdgAccountsModel:
          CdgAccountsModel(status: 222, message: "", cdgIbanInfo: []),
      cdgDashboardModel: CdgDashboardModel(
        status: 222,
        message: "",
        logo: "",
        price: "",
        usdBalance: "",
        balance: "",
        totalDevice: 0,
        totalOffline: 0,
        totalWorking: 0,
        popupText: "",
        device: [],
        offline: [],
        working: [],
      ),
      cdgProfitLogModel: CdgProfitLogModel(
        status: 222,
        message: "",
        year: "",
        serialNumber: "",
        deviceStatus: "",
        totalEnduserProfit: "",
        onlinehour: [],
        rewards: [],
      ),
      cdgQrCodeModel: CdgQrCodeModel(
        status: 222,
        message: "",
        cdgId: "",
        coin: "",
        activateFee: "",
      ),
      cdgStakeListModel: CdgStakeListModel(status: 222, message: "", cdg: []),
      cdgStakeOverviewModel: CdgStakeOverviewModel(
          status: 222,
          message: "",
          list: ListClass(),
          boostNote: "",
          pay1PercentageBoot: "",
          payBasedOnBasePrice: "",
          defaultPay: "",
          btnTitle: "",
          coin: "",
          cdgTitle: "",
          cdgBalance: ""),
    );
  }

  InvestmentState update({
    bool? isloading,
    StatusModel? statusModel,
    NodeCheckModuleModel? nodeCheckModuleModel,
    NodeLogsModel? nodeLogsModel,
    NodeProfitLogModel? nodeProfitLogModel,
    BuyMasterNodeModel? buyMasterNodeModel,
    IbanGetCustomAccountsModel? ibanGetCustomAccountsModel,
    CdgDeviceListModel? cdgDeviceListModel,
    CdgAccountsModel? cdgAccountsModel,
    CdgDashboardModel? cdgDashboardModel,
    CdgProfitLogModel? cdgProfitLogModel,
    CdgQrCodeModel? cdgQrCodeModel,
    CdgStakeListModel? cdgStakeListModel,
    CdgStakeOverviewModel? cdgStakeOverviewModel,
    UnStakeModel? unStakeModel,
  }) {
    return InvestmentState(
      isloading: isloading,
      statusModel: statusModel ?? this.statusModel,
      nodeCheckModuleModel: nodeCheckModuleModel ?? this.nodeCheckModuleModel,
      nodeLogsModel: nodeLogsModel ?? this.nodeLogsModel,
      nodeProfitLogModel: nodeProfitLogModel ?? this.nodeProfitLogModel,
      buyMasterNodeModel: buyMasterNodeModel ?? this.buyMasterNodeModel,
      ibanGetCustomAccountsModel:
          ibanGetCustomAccountsModel ?? this.ibanGetCustomAccountsModel,
      cdgDeviceListModel: cdgDeviceListModel ?? this.cdgDeviceListModel,
      cdgAccountsModel: cdgAccountsModel ?? this.cdgAccountsModel,
      cdgDashboardModel: cdgDashboardModel ?? this.cdgDashboardModel,
      cdgProfitLogModel: cdgProfitLogModel ?? this.cdgProfitLogModel,
      cdgQrCodeModel: cdgQrCodeModel ?? this.cdgQrCodeModel,
      cdgStakeListModel: cdgStakeListModel ?? this.cdgStakeListModel,
      cdgStakeOverviewModel:
          cdgStakeOverviewModel ?? this.cdgStakeOverviewModel,
      unStakeModel: unStakeModel ?? this.unStakeModel,
    );
  }
}
