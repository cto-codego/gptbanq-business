import 'dart:async';
import 'dart:io';

import 'package:gptbanqbusiness/Models/convert/convert_currency_list_model.dart';
import 'package:gptbanqbusiness/Screens/currency_convert_screen/bloc/converter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constant_string/User.dart';
import '../../cutom_weidget/custom_keyboard.dart';
import '../../cutom_weidget/cutom_progress_bar.dart';
import '../../utils/assets.dart';
import '../../utils/custom_style.dart';
import '../../utils/input_fields/custom_color.dart';
import '../../widgets/buttons/primary_button_widget.dart';
import '../../widgets/custom_image_widget.dart';
import '../../widgets/input_fields/exchange_input_field_widget.dart';
import '../../widgets/toast/custom_dialog_widget.dart';
import '../../widgets/toast/toast_util.dart';

class CurrencyExchangeDashboardScreen extends StatefulWidget {
  String buyCurrency;

  CurrencyExchangeDashboardScreen({
    super.key,
    required this.buyCurrency,
  });

  @override
  State<CurrencyExchangeDashboardScreen> createState() =>
      _CurrencyExchangeDashboardScreenState();
}

class _CurrencyExchangeDashboardScreenState
    extends State<CurrencyExchangeDashboardScreen>
    with SingleTickerProviderStateMixin {
  final ConverterBloc _converterBloc = ConverterBloc();
  bool active = true;
  bool callCurrencyList = true;
  final _formKey = GlobalKey<FormState>();

  String convertRate = "0.00";
  String convertLabel = "";

  late TargetPlatform? platform;

  final TextEditingController _fromCurrencyController = TextEditingController();
  final TextEditingController _toCurrencyController = TextEditingController();
  final TextEditingController sellCurrencyIbanId = TextEditingController();
  final TextEditingController buyCurrencyIbanId = TextEditingController();
  final TextEditingController sellCurrencySymbolController =
  TextEditingController();
  final TextEditingController buyCurrencySymbolController =
  TextEditingController();
  final TextEditingController sellBalanceCheckController =
  TextEditingController();
  final TextEditingController buyBalanceCheckController =
  TextEditingController();

  // String sellCurrencyIbanId = "";
  // String buyCurrencyIbanId = "";
  String message = "";
  double sellUserBalance1 = 0.00;
  double convertBalance = 0.00;
  bool _isTimerRunning = false;

  // Create FocusNodes
  FocusNode _amountFocusNode = FocusNode();
  FocusNode _convertedAmountFocusNode = FocusNode();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _convertedAmountController =
  TextEditingController();

  Timer? _updateRateTimer; // Declare a Timer variable

  Future<void> _onRefresh() async {
    debugPrint('_onRefresh');
  }

  @override
  void initState() {
    super.initState();
    User.Screen = 'converter screen';

    print(widget.buyCurrency);
    if (callCurrencyList == true) {
      _converterBloc
          .add(ConvertCurrencyListEvent(buyCurrency: widget.buyCurrency));
    }

    // Determine the platform
    if (Platform.isAndroid) {
      platform = TargetPlatform.android;
    } else {
      platform = TargetPlatform.iOS;
    }

    // Add listeners to the FocusNodes
    _amountFocusNode.addListener(_focusListener);
    _convertedAmountFocusNode.addListener(_focusListener);
    // Set initial currency and ibanId

    //call fn
    _startUpdateRateTimer();
  }

  void _focusListener() {
    setState(() {});
  }

  @override
  void dispose() {
    // Dispose of the FocusNodes
    _amountFocusNode.removeListener(_focusListener);
    _convertedAmountFocusNode.removeListener(_focusListener);
    _amountController.dispose();
    _convertedAmountController.dispose();
    _amountFocusNode.dispose();
    _convertedAmountFocusNode.dispose();
    // Stop the timer
    _stopUpdateRateTimer();
    super.dispose();
  }

  void _startUpdateRateTimer() {
    if (_isTimerRunning)
      return; // Prevent starting a new timer if one is already running

    _updateRateTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      if (sellCurrencyIbanId.text.isNotEmpty &&
          buyCurrencyIbanId.text.isNotEmpty) {
        updateCurrencyRate(); // Call the updateCurrencyRate function
      }
    });

    _isTimerRunning = true; // Set the flag to true
  }

  void _stopUpdateRateTimer() {
    if (_updateRateTimer != null) {
      _updateRateTimer!.cancel(); // Cancel the timer if it's running
      _updateRateTimer = null; // Set it to null to avoid using it again
      _isTimerRunning = false; // Reset the flag
    }
  }

  updateCurrencyRate() {
    _converterBloc.add(CurrencyRateNoLoadingEvent(
      sellCurrency: sellCurrencyIbanId.text,
      // Use the IBAN ID here
      buyCurrency: buyCurrencyIbanId.text,
    ));
  }

  void _onAmountChanged(String value, String conversionRate) {
    // Convert the amount based on the conversion rate
    double amount = double.tryParse(value) ?? 0.0;
    double rate = double.tryParse(conversionRate) ?? 1.0;
    double convertedAmount = amount * rate;

    // Update the converted amount controller
    _convertedAmountController.text = convertedAmount.toStringAsFixed(2);

    if (value.isNotEmpty) {
      checkBalanceFn(
        sellUserBalance:
        sellBalanceCheckController.text.replaceAll(RegExp(r'[^0-9.]'), ''),
        amountConvertBalance:
        _amountController.text.replaceAll(RegExp(r'[^0-9.]'), ''),
      );
    }
  }

  void _onConvertedAmountChanged(String value, String conversionRate) {
    // Convert the amount back based on the conversion rate
    double convertedAmount = double.tryParse(value) ?? 0.0;
    double rate = double.tryParse(conversionRate) ?? 1.0;
    double amount = convertedAmount / rate;

    // Update the amount controller
    _amountController.text = amount.toStringAsFixed(2);

    if (_amountController.text.isNotEmpty) {
      print(
          "check--------- ${sellBalanceCheckController.text} > amount ${_amountController.text}");
      checkBalanceFn(
        sellUserBalance:
        sellBalanceCheckController.text.replaceAll(RegExp(r'[^0-9.]'), ''),
        amountConvertBalance:
        _amountController.text.replaceAll(RegExp(r'[^0-9.]'), ''),
      );
    }
  }

  checkBalanceFn({
    required String sellUserBalance,
    required String amountConvertBalance,
  }) {
    // Remove all non-numeric characters
    sellUserBalance = sellUserBalance.replaceAll(RegExp(r'[^0-9.]'), '');
    amountConvertBalance =
        amountConvertBalance.replaceAll(RegExp(r'[^0-9.]'), '');

    sellUserBalance1 = double.parse(sellUserBalance);
    convertBalance = double.parse(amountConvertBalance);

    if (sellUserBalance1 < convertBalance) {
      message = "You will convert a max of ${sellBalanceCheckController.text}";
    } else {
      message = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.scaffoldBg,
      body: BlocListener(
        bloc: _converterBloc,
        listener: (context, ConverterState state) async {
          if (state.statusModel?.status == 0) {
            CustomDialogWidget.showErrorDialog(
              context: context,
              title: "Sorry",
              subTitle: state.statusModel!.message!,
              btnOkText: 'Ok',
            );
          }

          if (callCurrencyList == true) {
            if (state.convertCurrencyListModel!.status == 1) {
              convertRate = state.convertCurrencyListModel!.rate!;
              convertLabel = state.convertCurrencyListModel!.rateLabel!;
              callCurrencyList = false;
            }
          }

          if (state.currencyRateModel!.status == 1) {
            convertRate = state.currencyRateModel!.rate!;
            convertLabel = state.currencyRateModel!.rateLabel!;
            message = "";
            // Check if amountController is not empty
            if (_amountController.text.isNotEmpty) {
              _onAmountChanged(
                  _amountController.text, convertRate); // Call _onAmountChanged
            }
          } else if (state.currencyRateModel!.status == 0) {
            message = state.currencyRateModel!.message!;
          }

          if (state.convertCurrencyListModel?.status == 0) {
            message = state.convertCurrencyListModel!.message!;
          }

          if (state.convertConfirmModel?.status == 1) {
            CustomToast.showSuccess(
                context, "Hey!", state.convertConfirmModel!.message!);
            active = true;
            Navigator.pushNamedAndRemoveUntil(
                context, 'dashboard', (route) => false);
          } else if (state.convertConfirmModel?.status == 0) {
            CustomToast.showError(
                context, "Sorry!", state.convertConfirmModel!.message!);
            active = true;
            // Navigator.pushNamedAndRemoveUntil(
            //     context, 'dashboard', (route) => false);
          }
        },
        child: BlocBuilder(
          bloc: _converterBloc,
          builder: (context, ConverterState state) {
            return SafeArea(
              child: ProgressHUD(
                inAsyncCall: state.isLoading,
                child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: Container(
                    padding: EdgeInsets.only(
                      top: 16,
                    ),
                    child: Column(
                      children: [
                        _appBarTextSectionWidget(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Row(
                            children: [
                              CustomImageWidget(
                                imagePath: StaticAssets.rateIcon,
                                imageType: 'svg',
                                height: 10,
                                width: 10,
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  convertLabel,
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      color: CustomColor.black),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding:
                          EdgeInsets.symmetric(horizontal: 5, vertical: 16),
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            // mainAxisSize: MainAxisSize.min,
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 16,
                                            top: 8,
                                            right: 0,
                                            bottom: 20),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(20),
                                          border: Border.all(
                                              color: CustomColor.primaryColor,
                                              width: 0.5),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            if (state.convertCurrencyListModel!
                                                .sellCurrency!.isNotEmpty)
                                              CustomCurrencySelector(
                                                ibanController:
                                                sellCurrencyIbanId,
                                                balanceController:
                                                sellBalanceCheckController,
                                                currencySymbol:
                                                sellCurrencySymbolController,
                                                onChanged: (value,
                                                    sellIbanId,
                                                    sellCurrencyBalance,
                                                    sellCurrencySymbol) {
                                                  _fromCurrencyController.text =
                                                      value;
                                                  sellCurrencyIbanId.text =
                                                      sellIbanId;
                                                  sellBalanceCheckController
                                                      .text =
                                                      sellCurrencyBalance;
                                                  sellCurrencySymbolController
                                                      .text =
                                                      sellCurrencySymbol;
                                                  print(
                                                      "Sell Currency IBAN ID: $sellCurrencyIbanId"); // Debugging
                                                  print(
                                                      "Buy Currency IBAN ID: $buyCurrencyIbanId"); // Debugging

                                                  _converterBloc
                                                      .add(CurrencyRateEvent(
                                                    sellCurrency:
                                                    sellCurrencyIbanId.text,
                                                    // Use the IBAN ID here
                                                    buyCurrency:
                                                    buyCurrencyIbanId.text,
                                                  ));

                                                  _amountController.clear();
                                                  _convertedAmountController
                                                      .clear();
                                                },
                                                currencyList: state
                                                    .convertCurrencyListModel!
                                                    .sellcurrencyList!,
                                                controller:
                                                _fromCurrencyController,
                                                amountController:
                                                _amountController,
                                                initialCurrency: state
                                                    .convertCurrencyListModel!
                                                    .sellCurrency!,
                                                focusNode: _amountFocusNode,
                                                textInputField:
                                                ExchangeInputFieldWidget(
                                                    controller:
                                                    _amountController,
                                                    hint: '',
                                                    autofocus: true,
                                                    focusNode:
                                                    _amountFocusNode,
                                                    readOnly: false,
                                                    isEmail: false,
                                                    isPassword: false,
                                                    keyboardType:
                                                    TextInputType.none,
                                                    suffixText:
                                                    sellCurrencySymbolController
                                                        .text,
                                                    onChanged: (v) {
                                                      _onAmountChanged(
                                                          v,
                                                          state
                                                              .convertCurrencyListModel!
                                                              .rate!);
                                                    }),
                                              ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 16,
                                            top: 8,
                                            right: 0,
                                            bottom: 20),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(20),
                                          border: Border.all(
                                              color: CustomColor.primaryColor,
                                              width: 0.5),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            if (state.convertCurrencyListModel!
                                                .buyCurrency!.isNotEmpty)
                                              CustomCurrencySelector(
                                                ibanController:
                                                buyCurrencyIbanId,
                                                currencySymbol:
                                                buyCurrencySymbolController,
                                                balanceController:
                                                buyBalanceCheckController,
                                                onChanged: (value,
                                                    buyIbanId,
                                                    buyCurrencyBalance,
                                                    buyCurrencySymbol) {
                                                  buyCurrencyIbanId.text =
                                                      buyIbanId;
                                                  _toCurrencyController.text =
                                                      value;
                                                  buyBalanceCheckController
                                                      .text ==
                                                      buyCurrencyBalance;
                                                  buyCurrencySymbolController
                                                      .text = buyCurrencySymbol;


                                                  print(
                                                      "Sell Currency IBAN ID: $sellCurrencyIbanId + symbol $sellCurrencySymbolController"); // Debugging
                                                  print(
                                                      "Buy Currency IBAN ID: $buyCurrencyIbanId + symbol $buyCurrencySymbolController"); // Debugging

                                                  _converterBloc
                                                      .add(CurrencyRateEvent(
                                                    sellCurrency:
                                                    sellCurrencyIbanId.text,
                                                    // Use the IBAN ID here
                                                    buyCurrency:
                                                    buyCurrencyIbanId.text,
                                                  ));

                                                  _amountController.clear();
                                                  _convertedAmountController
                                                      .clear();
                                                },
                                                currencyList: state
                                                    .convertCurrencyListModel!
                                                    .buycurrencyList!,
                                                controller:
                                                _toCurrencyController,
                                                amountController:
                                                _convertedAmountController,
                                                initialCurrency: state
                                                    .convertCurrencyListModel!
                                                    .buyCurrency!,
                                                focusNode:
                                                _convertedAmountFocusNode,
                                                textInputField:
                                                ExchangeInputFieldWidget(
                                                    controller:
                                                    _convertedAmountController,
                                                    hint: '',
                                                    autofocus: true,
                                                    focusNode:
                                                    _convertedAmountFocusNode,
                                                    readOnly: false,
                                                    isEmail: false,
                                                    isPassword: false,
                                                    keyboardType:
                                                    TextInputType.none,
                                                    suffixText:
                                                    buyCurrencySymbolController
                                                        .text,
                                                    onChanged: (v) {
                                                      _onConvertedAmountChanged(
                                                          v,
                                                          state
                                                              .convertCurrencyListModel!
                                                              .rate!);
                                                    }),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: CustomColor.whiteColor,
                                        border: Border.all(
                                          color: CustomColor.primaryColor,
                                        )),
                                    padding: EdgeInsets.all(8),
                                    child: Icon(
                                      Icons.arrow_downward_rounded,
                                      color: CustomColor.primaryColor,
                                      size: 24,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, top: 10),
                          child: PrimaryButtonWidget(
                            onPressed: active &&
                                _fromCurrencyController.text !=
                                    _toCurrencyController.text &&
                                sellUserBalance1 >= convertBalance
                                ? () {
                              active = false;
                              _converterBloc
                                  .add(CurrencyConvertConfirmEvent(
                                buyCurrencyId: buyCurrencyIbanId.text,
                                sellCurrencyId: sellCurrencyIbanId.text,
                                amount: _convertedAmountController.text,
                              ));
                            }
                                : null,
                            apiBackgroundColor: message.isNotEmpty
                                ? CustomColor.errorColor
                                : CustomColor.primaryColor,
                            disabledColor: message.isNotEmpty
                                ? CustomColor.errorColor
                                : CustomColor.primaryColor.withOpacity(0.3),
                            buttonText: message.isNotEmpty
                                ? message
                                : 'Convert to ${_toCurrencyController.text} ${_convertedAmountController.text}',
                          ),
                        ),

                        if (_amountFocusNode.hasFocus)
                          Expanded(
                            // height: 300,
                            child: Container(
                              color: const Color(0xffF7F9FD),
                              child: KeyPad2(
                                pinController: _amountController,
                                onChange: (String pin) {
                                  setState(() {
                                    _amountController.text =
                                        pin; // Update the controller text
                                    _onAmountChanged(
                                        _amountController.text, convertRate);
                                  });
                                },
                              ),
                            ),
                          ),

                        // if(_convertedAmountController.addListener(_amountListener))
                        if (_convertedAmountFocusNode.hasFocus)
                          Expanded(
                            // height: 300,
                            child: Container(
                              color: const Color(0xffF7F9FD),
                              child: KeyPad2(
                                pinController: _convertedAmountController,
                                onChange: (String pin) {
                                  setState(() {
                                    _convertedAmountController.text =
                                        pin; // Update the controller text
                                    _onConvertedAmountChanged(
                                        _convertedAmountController.text,
                                        convertRate);
                                  });
                                },
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _appBarTextSectionWidget() {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              _stopUpdateRateTimer();
              Navigator.pushNamedAndRemoveUntil(
                  context, 'dashboard', (route) => false);
            },
            child: CustomImageWidget(
              imagePath: StaticAssets.arrowNarrowLeft,
              height: 24,
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              "Exchange",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: CustomColor.black,
              ),
            ),
          ),
          SizedBox(
            width: 24,
            height: 24,
          )
        ],
      ),
    );
  }
}

class Currency {
  final String flag;
  final String currency;

  Currency({required this.flag, required this.currency});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Currency) return false;
    return flag == other.flag && currency == other.currency;
  }

  @override
  int get hashCode => flag.hashCode ^ currency.hashCode;
}

class CustomCurrencySelector extends StatefulWidget {
  final List<CurrencyList> currencyList;
  final TextEditingController? controller;
  final TextEditingController? ibanController;
  final TextEditingController? balanceController;
  final TextEditingController? currencySymbol;
  final TextEditingController? amountController;
  final FocusNode? focusNode;
  final Function(String, String, String, String)? onChanged;
  final Widget? textInputField;
  final String initialCurrency; // Add this parameter for initial currency

  const CustomCurrencySelector({
    super.key,
    required this.currencyList,
    this.controller,
    required this.ibanController,
    required this.balanceController,
    this.amountController,
    required this.onChanged,
    this.focusNode,
    required this.initialCurrency,
    this.textInputField,
    this.currencySymbol, // Accept initial currency value
  });

  @override
  _CustomCurrencySelectorState createState() => _CustomCurrencySelectorState();
}

class _CustomCurrencySelectorState extends State<CustomCurrencySelector> {
  late CurrencyList selectedCurrency;
  late String currencyIbanId;

  @override
  void initState() {
    super.initState();

    // Check if the currency list is not empty
    if (widget.currencyList.isNotEmpty) {
      // If initialCurrency is provided, find the corresponding currency
      if (widget.initialCurrency.isNotEmpty) {
        selectedCurrency = widget.currencyList.firstWhere(
              (currency) => currency.currency == widget.initialCurrency,
          orElse: () => widget
              .currencyList.first, // Fallback to the first item if no match
        );
      } else {
        // Fallback to the first item if initialCurrency is empty
        selectedCurrency = widget.currencyList.first;
      }

      // Set the currencyIbanId based on the selected currency
      currencyIbanId = selectedCurrency.ibanId!;
      widget.ibanController!.text = currencyIbanId;
      widget.balanceController!.text = selectedCurrency.balance!;
      widget.currencySymbol!.text = selectedCurrency.symbol!;

      // If a controller is passed, set its initial value
      if (widget.controller != null) {
        widget.controller?.text = selectedCurrency.currency!;
        currencyIbanId = selectedCurrency.ibanId!;
        widget.ibanController!.text = currencyIbanId;
        widget.balanceController!.text = selectedCurrency.balance!;
        widget.currencySymbol!.text = selectedCurrency.symbol!;
        print("Currency list  ${widget.ibanController!.text}");
      }
    } else {
      // Handle the case where the currency list is empty
      print("Currency list is empty. Please check the data source.");
      // You might want to set a default value or show an error message
      selectedCurrency =
          CurrencyList(currency: "Default Currency", flag: "default_flag_url");
      currencyIbanId = selectedCurrency.ibanId!; // Set a default ibanId
      if (widget.controller != null) {
        widget.controller?.text = selectedCurrency.currency!;
        currencyIbanId = selectedCurrency.ibanId!;
        widget.ibanController!.text = currencyIbanId;
        widget.balanceController!.text = selectedCurrency.balance!;
        widget.currencySymbol!.text = selectedCurrency.symbol!;
        print(widget.ibanController!.text);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () =>
          _showCurrencyPicker(context, widget.onChanged, currencyIbanId),
      child: Container(
        decoration: BoxDecoration(
          color: CustomColor.whiteColor,
        ),
        padding: EdgeInsets.only(top: 15, left: 5, right: 5, bottom: 5),
        margin: EdgeInsets.only(right: 5),
        child: Row(
          children: [
            Flexible(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(
                              selectedCurrency.flag!,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          RegExp(r'^[^\(]+')
                              .stringMatch(selectedCurrency.currency!) ??
                              '',
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                            color: CustomColor.black,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: CustomColor.black,
                        size: 24,
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      "Balance: ${selectedCurrency.balance}",
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                        color: CustomColor.black.withOpacity(0.6),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 4,
              child: widget.textInputField!,
            ),
          ],
        ),
      ),
    );
  }

  void _showCurrencyPicker(BuildContext context,
      Function(String, String, String, String)? onChanged, String currencyId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: CustomColor.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (context) {
        String searchQuery = '';

        return StatefulBuilder(
          builder: (context, setState) {
            final filteredCurrencies = widget.currencyList
                .where((currency) => currency.currency!
                .toLowerCase()
                .contains(searchQuery.toLowerCase()))
                .toList();

            return Container(
              padding: EdgeInsets.all(16),
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                children: [
                  // Header with close button and title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        "Select Currency",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: CustomColor.black,
                        ),
                      ),
                      SizedBox(width: 48), // Spacer for alignment
                    ],
                  ),
                  SizedBox(height: 10),
                  // Search Bar
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Search Currency",
                      hintStyle: CustomStyle.loginInputTextHintStyle,
                      filled: true,
                      fillColor: CustomColor.primaryInputHintColor,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: CustomColor.primaryInputHintBorderColor,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: CustomColor.primaryInputHintBorderColor,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: CustomImageWidget(
                          imagePath: StaticAssets.searchMd,
                          imageType: 'svg',
                          height: 18,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Currency List
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredCurrencies.length,
                      itemBuilder: (context, index) {
                        final currency = filteredCurrencies[index];
                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedCurrency = currency;
                              currencyId = currency.ibanId!;
                            });
                            // Trigger the onChanged callback if provided
                            if (onChanged != null) {
                              onChanged(
                                  selectedCurrency.toString(),
                                  currency.ibanId!,
                                  currency.balance!,
                                  currency.symbol!);
                              print("${currency.balance} money check");
                            }

                            if (widget.controller != null) {
                              currencyId = currency.ibanId!;

                              widget.controller?.text =
                              selectedCurrency.currency!;

                              widget.balanceController!.text =
                              currency.balance!;
                            }
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                // Currency Flag
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: NetworkImage(currency.flag!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                // Currency Name
                                Expanded(
                                  child: Text(
                                    currency.currency!,
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                      color: CustomColor.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
