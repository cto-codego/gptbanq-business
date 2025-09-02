part of 'investment_bloc.dart';

class InvestmentEvent {}

class NodeCheckModuleEvent extends InvestmentEvent {}

class NodeLogsEvent extends InvestmentEvent {}

class NodeProfitLogsEvent extends InvestmentEvent {
  String orderId;

  NodeProfitLogsEvent({required this.orderId});
}

class BuyMasterNodeInfoEvent extends InvestmentEvent {}

class NodeOrderEvent extends InvestmentEvent {
  int numberOfNode;
  String ibanId;

  NodeOrderEvent({required this.numberOfNode, required this.ibanId});
}

class SwiftTermsEvent extends InvestmentEvent {
  final String type, deviceType;

  SwiftTermsEvent({required this.type, required this.deviceType});
}

class IbanGetCustomAccountEvent extends InvestmentEvent {
  final String type, symbol;

  IbanGetCustomAccountEvent({required this.type, required this.symbol});
}

/*cdg masternode section */

class CdgDashboardEvent extends InvestmentEvent {}

class CdgDeviceListEvent extends InvestmentEvent {}

class CdgAccountsEvent extends InvestmentEvent {}

class CdgActiveEvent extends InvestmentEvent {
  final String type;

  CdgActiveEvent({required this.type});
}

class CdgMasternodeOrderEvent extends InvestmentEvent {
  final String deviceId,
      numberOfNode,
      ibanId,
      country,
      address,
      city,
      state,
      zipCode,
      surnameOrCompany,
      phone;

  CdgMasternodeOrderEvent({
    required this.deviceId,
    required this.numberOfNode,
    required this.ibanId,
    required this.country,
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.surnameOrCompany,
    required this.phone,
  });
}

class CdgProfitLogEvent extends InvestmentEvent {
  final String orderId;

  CdgProfitLogEvent({required this.orderId});
}

class CdgInviteEvent extends InvestmentEvent {
  final String name, email;

  CdgInviteEvent({required this.name, required this.email});
}

class CdgQrCodeEvent extends InvestmentEvent {
  final String serialNumber;

  CdgQrCodeEvent({required this.serialNumber});
}

class CdgDeviceActiveEvent extends InvestmentEvent {
  final String ibanId, cdgId, serialNumber;

  CdgDeviceActiveEvent(
      {required this.ibanId, required this.cdgId, required this.serialNumber});
}

class CdgConvertEvent extends InvestmentEvent {
  final String amount;

  CdgConvertEvent({required this.amount});
}

class CdgStakeListEvent extends InvestmentEvent {}
class CdgUnStakeEvent extends InvestmentEvent {}

class CdgStakeSelectedCdgIdEvent extends InvestmentEvent {
  final List<String> cdgStakeSelectedCdgId;

  CdgStakeSelectedCdgIdEvent({required this.cdgStakeSelectedCdgId});
}

class CdgStakePayNowEvent extends InvestmentEvent {
  final List<String> cdgStakeSelectedCdgId;
  final int boostPercentage;

  CdgStakePayNowEvent(
      {required this.cdgStakeSelectedCdgId, required this.boostPercentage});
}
