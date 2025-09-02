import 'dart:async';
import 'package:gptbanqbusiness/Screens/wallet_transfer_section/bloc/wallet_transfer_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Models/wallet_transfer/wallet_transfer_iban_list_model.dart';
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

class WalletTransferDashboardScreen extends StatefulWidget {
  WalletTransferDashboardScreen({
    super.key,
  });

  @override
  State<WalletTransferDashboardScreen> createState() =>
      _WalletTransferDashboardScreenState();
}

class _WalletTransferDashboardScreenState
    extends State<WalletTransferDashboardScreen>
    with SingleTickerProviderStateMixin {
  final WalletTransferBloc _walletTransferBloc = WalletTransferBloc();
  bool active = true;

  String convertLabel = "";
  String senderIbanId = "";
  String senderIbanLabel = "";
  String senderIbanBalance = "";
  String senderIbanCurrency = "";

  late TargetPlatform? platform;

  final TextEditingController _receiverCurrencyController =
      TextEditingController();
  final TextEditingController receiverIbanId = TextEditingController();

  final TextEditingController receiverCurrencySymbolController =
      TextEditingController();
  final TextEditingController receiverBalanceCheckController =
      TextEditingController();

  String message = "";
  double fromIbanBalance = 0.00;
  double toIbanBalance = 0.00;

  FocusNode _amountFocusNode = FocusNode();
  FocusNode _receiverAmountFocusNode = FocusNode();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _receiverAmountController =
      TextEditingController();

  Future<void> _onRefresh() async {
    debugPrint('_onRefresh');
  }

  @override
  void initState() {
    super.initState();
    User.Screen = 'wallet transfer screen';

    _walletTransferBloc.add(WalletTransferIbanListEvent(ibanId: User.ibanId));
    _receiverAmountFocusNode.addListener(() {
      if (_receiverAmountFocusNode.hasFocus) {
        print('Receiver amount field is focused');
      } else {
        print('Receiver amount field lost focus');
      }
    });
  }

  @override
  void dispose() {
    _receiverAmountFocusNode.dispose();
    super.dispose();
  }

  void checkBalanceFn({
    required String senderIbanBalance,
    required String receiverIbanBalance,
  }) {
    try {
      final senderAmount =
          double.parse(senderIbanBalance.replaceAll(RegExp(r'[^0-9.]'), ''));
      final receiverAmount =
          double.parse(receiverIbanBalance.replaceAll(RegExp(r'[^0-9.]'), ''));

      setState(() {
        fromIbanBalance = senderAmount;
        toIbanBalance = receiverAmount;
        message = fromIbanBalance < toIbanBalance
            ? "You will convert a max of ${fromIbanBalance.toStringAsFixed(2)} $senderIbanCurrency"
            : "";
      });
    } catch (e) {
      setState(() {
        message = "Error checking balances";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.scaffoldBg,
      body: BlocListener(
        bloc: _walletTransferBloc,
        listener: (context, WalletTransferState state) async {
          if (state.walletTransferIbanListModel?.status == 1) {
            senderIbanId =
                state.walletTransferIbanListModel!.senderIban!.first.ibanId!;
            senderIbanLabel =
                state.walletTransferIbanListModel!.senderIban!.first.label!;
            senderIbanBalance =
                state.walletTransferIbanListModel!.senderIban!.first.balance!;
            senderIbanCurrency =
                state.walletTransferIbanListModel!.senderIban!.first.currency!;

            fromIbanBalance = double.parse(state
                .walletTransferIbanListModel!.senderIban!.first.balance!
                .toString());
          }

          if (state.statusModel?.status == 1) {
            CustomToast.showSuccess(
                context, "Hey!", state.statusModel!.message!);
            Navigator.pushNamedAndRemoveUntil(
                context, 'dashboard', (route) => false);
          } else if (state.statusModel?.status == 0) {
            CustomToast.showError(
                context, "Sorry!", state.statusModel!.message!);
          }
        },
        child: BlocBuilder(
          bloc: _walletTransferBloc,
          builder: (context, WalletTransferState state) {
            return SafeArea(
              child: ProgressHUD(
                inAsyncCall: state.isloading,
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
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 16),
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              if (senderIbanLabel.isNotEmpty)
                                Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 16),
                                  decoration: BoxDecoration(
                                      color: CustomColor
                                          .transactionFromContainerColor,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: CustomColor
                                              .dashboardProfileBorderColor)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Transfer from",
                                            style: GoogleFonts.inter(
                                              color: CustomColor.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15,
                                            ),
                                          ),
                                          Text(
                                            senderIbanLabel,
                                            style: GoogleFonts.inter(
                                              color: CustomColor
                                                  .touchIdSubtitleTextColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              if (state.walletTransferIbanListModel!
                                  .receiverIban!.isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Transfer to",
                                      style: GoogleFonts.inter(
                                        color: CustomColor.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    if (state.walletTransferIbanListModel!
                                        .receiverIban!.isNotEmpty)
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
                                            if (state
                                                .walletTransferIbanListModel!
                                                .receiverIban!
                                                .isNotEmpty)
                                              CustomCurrencySelector(
                                                ibanController: receiverIbanId,
                                                currencySymbol:
                                                    receiverCurrencySymbolController,
                                                balanceController:
                                                    receiverBalanceCheckController,
                                                onChanged: (value,
                                                    receiveIbanId,
                                                    receiverCurrencyBalance,
                                                    receiverCurrencySymbol) {
                                                  setState(() {
                                                    receiverIbanId.text =
                                                        receiveIbanId;
                                                    _receiverCurrencyController
                                                        .text = value;
                                                    receiverBalanceCheckController
                                                            .text =
                                                        receiverCurrencyBalance; // Fixed from == to =
                                                    receiverCurrencySymbolController
                                                            .text =
                                                        receiverCurrencySymbol;
                                                  });

                                                  _amountController.clear();
                                                  _receiverAmountController
                                                      .clear();
                                                },
                                                currencyList: state
                                                    .walletTransferIbanListModel!
                                                    .receiverIban!,
                                                controller:
                                                    _receiverCurrencyController,
                                                amountController:
                                                    _receiverAmountController,
                                                initialCurrency: state
                                                    .walletTransferIbanListModel!
                                                    .receiverIban!
                                                    .first
                                                    .currency!,
                                                focusNode:
                                                    _receiverAmountFocusNode,
                                                textInputField:
                                                    ExchangeInputFieldWidget(
                                                        controller:
                                                            _receiverAmountController,
                                                        hint: '',
                                                        autofocus: true,
                                                        focusNode:
                                                            _receiverAmountFocusNode,
                                                        readOnly: false,
                                                        isEmail: false,
                                                        isPassword: false,
                                                        keyboardType:
                                                            TextInputType.none,
                                                        suffixText:
                                                            receiverCurrencySymbolController
                                                                .text,
                                                        onChanged: (v) {
                                                          checkBalanceFn(
                                                              senderIbanBalance:
                                                                  fromIbanBalance
                                                                      .toString(),
                                                              receiverIbanBalance:
                                                                  _receiverAmountController
                                                                      .text);

                                                          print("textfield $v");

                                                          if (_receiverAmountController
                                                              .text
                                                              .isNotEmpty) {
                                                            setState(() {
                                                              toIbanBalance =
                                                                  double.parse(
                                                                      _receiverAmountController
                                                                          .text);
                                                            });
                                                          }
                                                        }),
                                              ),
                                          ],
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
                            onPressed: _receiverAmountController
                                        .text.isNotEmpty &&
                                    fromIbanBalance >= toIbanBalance
                                ? () {
                                    active = false;
                                    double senderAmount =
                                        double.parse(senderIbanBalance);
                                    double receiverAmount = double.parse(
                                        _receiverAmountController.text);
                                    if (senderAmount >= receiverAmount &&
                                        receiverAmount != 0) {
                                      _walletTransferBloc
                                          .add(WalletTransferMoveEvent(
                                        senderIbanId: senderIbanId,
                                        receiverIbanId: receiverIbanId.text,
                                        amount: _receiverAmountController.text,
                                      ));
                                    } else {
                                      CustomToast.showError(context, "Sorry!",
                                          "Insufficient balance");
                                    }
                                  }
                                : null,
                            apiBackgroundColor: CustomColor.primaryColor,
                            disabledColor:
                                CustomColor.primaryColor.withOpacity(0.3),
                            buttonText: 'Confirm Transfer',
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: const Color(0xffF7F9FD),
                            child: KeyPad2(
                              pinController: _receiverAmountController,
                              onChange: (String pin) {
                                setState(() {
                                  _receiverAmountController.text = pin;
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
              "Wallet Transfer",
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
  final List<ErIban> currencyList;
  final TextEditingController? controller;
  final TextEditingController? ibanController;
  final TextEditingController? balanceController;
  final TextEditingController? currencySymbol;
  final TextEditingController? amountController;
  final FocusNode? focusNode;
  final Function(String, String, String, String)? onChanged;
  final Widget? textInputField;
  final String initialCurrency;

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
    this.currencySymbol,
  });

  @override
  _CustomCurrencySelectorState createState() => _CustomCurrencySelectorState();
}

class _CustomCurrencySelectorState extends State<CustomCurrencySelector> {
  late ErIban selectedCurrency;
  late String currencyIbanId;

  @override
  void initState() {
    super.initState();

    if (widget.currencyList.isNotEmpty) {
      if (widget.initialCurrency.isNotEmpty) {
        selectedCurrency = widget.currencyList.firstWhere(
          (currency) => currency.label == widget.initialCurrency,
          orElse: () => widget.currencyList.first,
        );
      } else {
        selectedCurrency = widget.currencyList.first;
      }

      currencyIbanId = selectedCurrency.ibanId!;
      widget.ibanController!.text = currencyIbanId;
      widget.balanceController!.text = selectedCurrency.balance!;
      widget.currencySymbol!.text = selectedCurrency.currency!;

      if (widget.controller != null) {
        widget.controller?.text = selectedCurrency.currency!;
        currencyIbanId = selectedCurrency.ibanId!;
        widget.ibanController!.text = currencyIbanId;
        widget.balanceController!.text = selectedCurrency.balance!;
        widget.currencySymbol!.text = selectedCurrency.currency!;
        print("Currency list  ${widget.ibanController!.text}");
      }
    } else {
      print("Currency list is empty. Please check the data source.");
      selectedCurrency =
          ErIban(currency: "Default Currency", label: "default_flag_url");
      currencyIbanId = selectedCurrency.ibanId!;
      if (widget.controller != null) {
        widget.controller?.text = selectedCurrency.currency!;
        currencyIbanId = selectedCurrency.ibanId!;
        widget.ibanController!.text = currencyIbanId;
        widget.balanceController!.text = selectedCurrency.balance!;
        widget.currencySymbol!.text = selectedCurrency.currency!;
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
                              selectedCurrency.image!,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          RegExp(r'^[^\(]+')
                                  .stringMatch(selectedCurrency.label!) ??
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
                      "Balance: ${selectedCurrency.balance} ${selectedCurrency.currency}",
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
                .where((currency) => currency.label!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()))
                .toList();

            return Container(
              padding: EdgeInsets.all(16),
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                children: [
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
                      SizedBox(width: 48),
                    ],
                  ),
                  SizedBox(height: 10),
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

                            if (onChanged != null) {
                              onChanged(
                                  currency.label!,
                                  // Changed from toString() to currency!
                                  currency.ibanId!,
                                  currency.balance!,
                                  currency.currency!);
                            }

                            if (widget.controller != null) {
                              widget.controller?.text = currency.label!;
                              widget.ibanController?.text = currency.ibanId!;
                              widget.balanceController?.text =
                                  currency.balance!;
                              widget.currencySymbol?.text = currency.currency!;
                            }
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: NetworkImage(currency.image!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    currency.label!,
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
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
