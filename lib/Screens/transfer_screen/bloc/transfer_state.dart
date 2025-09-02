part of 'transfer_bloc.dart';

@immutable
class TransferState {
  SendmoneyModel? sendmoneyModel;
  PushModel? pushModel;
  bool? isloading;
  RegulaModel? regulaModel;

  BinficaryModel? binficaryModel;
  StatusModel? statusModel;
  IbanlistModel? ibanlistModel;

  Sepatypesmodel? sepatypesmodel;

  BeneficiaryCountriesModel? beneficiaryCountriesModel;
  SwiftAddBeneficiaryModel? swiftAddBeneficiaryModel;
  DynamicBeneficiaryFieldModel? dynamicBeneficiaryFieldModel;
  DynamicAddBeneficiaryModel? dynamicAddBeneficiaryModel;
  SwiftPaymentModel? swiftPaymentModel;
  SwiftSendMoneyUserModel? swiftSendMoneyUserModel;

  TransferState({
    this.isloading,
    this.ibanlistModel,
    this.regulaModel,
    this.pushModel,
    this.sepatypesmodel,
    this.binficaryModel,
    this.statusModel,
    this.sendmoneyModel,
    this.beneficiaryCountriesModel,
    this.swiftAddBeneficiaryModel,
    this.dynamicBeneficiaryFieldModel,
    this.dynamicAddBeneficiaryModel,
    this.swiftPaymentModel,
    this.swiftSendMoneyUserModel,
  });

  factory TransferState.init() {
    return TransferState(
      isloading: false,
      regulaModel: RegulaModel(message: '', status: 222),
      ibanlistModel: IbanlistModel(ibaninfo: [], status: 222),
      pushModel: PushModel(message: '', status: 222),
      sepatypesmodel:
          Sepatypesmodel(status: 222, types: Types(instant: '', sepa: '')),
      sendmoneyModel: SendmoneyModel(),
      beneficiaryCountriesModel: BeneficiaryCountriesModel(
          status: 222, message: '', beneficiaryCountriesList: []),
      binficaryModel: BinficaryModel(
          data: [], status: 222, message: '', isPaymentPurposeCodes: 0),
      statusModel: StatusModel(message: '', status: 222),
      swiftAddBeneficiaryModel: SwiftAddBeneficiaryModel(
          status: 222, country: [], iban: [], curreny: []),
      dynamicBeneficiaryFieldModel: DynamicBeneficiaryFieldModel(
          status: 222,
          message: '',
          recipientBankOptions: [],
          field: [],
          country: [],
          isBeneficiaryIdentificationType: 0,
          beneficiaryIdentificationType: []),
      dynamicAddBeneficiaryModel:
          DynamicAddBeneficiaryModel(status: 222, message: ''),
      swiftPaymentModel: SwiftPaymentModel(
        status: 222,
        paymentType: "",
        accountNumber: "",
        bicSwift: "",
        aba: "",
        bankCode: "",
        bsbCode: "",
        clabe: "",
        cnaps: "",
        ifsc: "",
        institutionNo: "",
        paymentOption: "",
        uniqueId: "",
        amount: "",
        exchangeFee: "",
        exchangeRate: "",
        internationalFee: "",
        exchangeAmount: "",
        yourTotal: "",
        date: "",
        message: "",
        feeLabel: "",
        branchCode: "",
        provider: "",
        flag: ""

      ),
      swiftSendMoneyUserModel:
          SwiftSendMoneyUserModel(status: 222, pc: [], country: ''),
    );
  }

  TransferState update({
    bool? isloading,
    IbanlistModel? ibanlistModel,
    BinficaryModel? binficaryModel,
    StatusModel? statusModel,
    PushModel? pushModel,
    RegulaModel? regulaModel,
    SendmoneyModel? sendmoneyModel,
    BeneficiaryCountriesModel? beneficiaryCountriesModel,
    Sepatypesmodel? sepatypesmodel,
    SwiftAddBeneficiaryModel? swiftAddBeneficiaryModel,
    DynamicBeneficiaryFieldModel? dynamicBeneficiaryFieldModel,
    DynamicAddBeneficiaryModel? dynamicAddBeneficiaryModel,
    SwiftPaymentModel? swiftPaymentModel,
    SwiftSendMoneyUserModel? swiftSendMoneyUserModel,
  }) {
    return TransferState(
      isloading: isloading,
      binficaryModel: binficaryModel ?? this.binficaryModel,
      regulaModel: regulaModel,
      statusModel: statusModel,
      pushModel: pushModel,
      sendmoneyModel: sendmoneyModel,
      ibanlistModel: ibanlistModel ?? this.ibanlistModel,
      sepatypesmodel: sepatypesmodel ?? this.sepatypesmodel,
      beneficiaryCountriesModel:
          beneficiaryCountriesModel ?? this.beneficiaryCountriesModel,
      swiftAddBeneficiaryModel:
          swiftAddBeneficiaryModel ?? this.swiftAddBeneficiaryModel,
      dynamicBeneficiaryFieldModel:
          dynamicBeneficiaryFieldModel ?? this.dynamicBeneficiaryFieldModel,
      dynamicAddBeneficiaryModel:
          dynamicAddBeneficiaryModel ?? this.dynamicAddBeneficiaryModel,
      swiftPaymentModel: swiftPaymentModel ?? this.swiftPaymentModel,
      swiftSendMoneyUserModel:
          swiftSendMoneyUserModel ?? this.swiftSendMoneyUserModel,
    );
  }
}
