part of 'converter_bloc.dart';

@immutable
class ConverterState {
  final StatusModel? statusModel;
  final bool? isLoading;
  final UpdateModel? updateModel;
  final bool? open;
  final ConvertCurrencyListModel? convertCurrencyListModel;
  final CurrencyRateModel? currencyRateModel;
  final ConvertConfirmModel? convertConfirmModel;

  const ConverterState({
    this.statusModel,
    this.isLoading,
    this.updateModel,
    this.open,
    this.convertCurrencyListModel,
    this.currencyRateModel,
    this.convertConfirmModel,
  });

  factory ConverterState.init() {
    return ConverterState(
        statusModel: StatusModel(status: 222, message: ""),
        isLoading: false,
        open: false,
        updateModel: UpdateModel(
          message: '',
        ),
        convertCurrencyListModel: ConvertCurrencyListModel(
          status: 222,
          message: "",
          buyCurrency: "",
          sellCurrency: "",
          rate: "",
          rateLabel: "",
          sellcurrencyList: [],
          buycurrencyList: [],
        ),
        currencyRateModel: CurrencyRateModel(
          status: 222,
          message: "",
          rate: "",
          sellCurrency: "",
          buyCurrency: "",
          rateLabel: "",
        ),
        convertConfirmModel: ConvertConfirmModel(status: 222, message: ""));
  }

  ConverterState update({
    StatusModel? statusModel,
    bool? isLoading,
    bool? open,
    UpdateModel? updateModel,
    ConvertCurrencyListModel? convertCurrencyListModel,
    CurrencyRateModel? currencyRateModel,
    ConvertConfirmModel? convertConfirmModel,
  }) {
    return ConverterState(
        isLoading: isLoading,
        open: open,
        updateModel: updateModel,
        convertCurrencyListModel:
            convertCurrencyListModel ?? this.convertCurrencyListModel,
        currencyRateModel: currencyRateModel ?? this.currencyRateModel,
        convertConfirmModel: convertConfirmModel ?? this.convertConfirmModel,
        statusModel: statusModel);
  }
}
