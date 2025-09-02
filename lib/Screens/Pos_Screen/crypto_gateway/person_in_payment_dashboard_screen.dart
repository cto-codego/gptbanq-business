import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:gptbanqbusiness/Screens/Pos_Screen/bloc/pos_bloc.dart';
import 'package:gptbanqbusiness/Screens/Pos_Screen/crypto_gateway/person_in_payment_option_screen.dart';
import 'package:gptbanqbusiness/Screens/Pos_Screen/crypto_gateway/store_screen.dart';
import 'package:gptbanqbusiness/cutom_weidget/input_textform.dart';
import 'package:gptbanqbusiness/utils/assets.dart';
import 'package:gptbanqbusiness/utils/input_fields/custom_color.dart';
import 'package:gptbanqbusiness/widgets/custom_image_widget.dart';
import 'package:gptbanqbusiness/widgets/input_fields/amount_input_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gptbanqbusiness/constant_string/User.dart';
import 'package:gptbanqbusiness/cutom_weidget/custom_navigationBar.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import '../../../cutom_weidget/custom_crypto_keyboard.dart';
import '../../../cutom_weidget/custom_keyboard.dart';
import '../../../widgets/buttons/default_back_button_widget.dart';
import '../../../widgets/buttons/primary_button_widget.dart';
import '../../../widgets/toast/toast_util.dart';
import 'person_make_payment_screen.dart';

class PersonInPaymentDashboardScreen extends StatefulWidget {
  PersonInPaymentDashboardScreen({
    super.key,
    required this.storeId,
    required this.storeName,
    required this.storeCurrency,
    required this.storeCurrencyImage,
  });

  String storeId;
  String storeName;
  String storeCurrency;
  String storeCurrencyImage;

  @override
  State<PersonInPaymentDashboardScreen> createState() =>
      _PersonInPaymentDashboardScreenState();
}

class _PersonInPaymentDashboardScreenState
    extends State<PersonInPaymentDashboardScreen> {
  bool active = false;

  bool shownotification = true;
  final PosBloc _posBloc = PosBloc();
  TextEditingController _amountController = TextEditingController();
  int selectedIndex = -1; // -1 means no container is selected initially
  final _formkey = new GlobalKey<FormState>();
  String symbol = "";

  Future<void> _onRefresh() async {
    debugPrint('_onRefresh');

    _posBloc.add(CoinListEvent());
  }

  @override
  void initState() {
    super.initState();
    User.Screen = 'person in payment screen';

    _posBloc.add(CoinListEvent());
    _amountController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _amountController.removeListener(_updateButtonState);
    _amountController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    if (_formkey.currentState?.validate() ?? false) {
      setState(() {
        active = _amountController.text.isNotEmpty;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.scaffoldBg,
      body: BlocListener(
          bloc: _posBloc,
          listener: (context, PosState state) {
            if (state.coinListModel?.status == 0) {
              CustomToast.showError(
                  context, "Sorry!", state.coinListModel!.message!);
            }

            if (state.createQrModel?.status == 1) {
              Navigator.pushReplacement(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  alignment: Alignment.center,
                  isIos: true,
                  duration: const Duration(milliseconds: 200),
                  child: PersonMakePaymentScreen(
                    uniqueId: state.createQrModel!.uniqueId!,
                  ),
                ),
              );
            }
          },
          child: BlocBuilder(
              bloc: _posBloc,
              builder: (context, PosState state) {
                return SafeArea(
                  child: ProgressHUD(
                    inAsyncCall: state.isloading,
                    child: Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          appBarSection(context, state),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: AmountInputField(
                              controller: _amountController,
                              label: 'Enter Amount:',
                              minAmount: 0,
                              currencySymbol:
                                  widget.storeCurrency.toUpperCase(),
                              suffixIcon: Container(
                                width: 20,
                                height: 20,
                                margin: EdgeInsets.only(left: 5, right: 5, top: 5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(
                                        widget.storeCurrencyImage,
                                      ),
                                      fit: BoxFit.cover),
                                ),
                              ),
                              readOnly: true,
                              onChanged: (v) {},
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 25, horizontal: 16),
                            child: PrimaryButtonWidget(
                              onPressed: active == false
                                  ? null
                                  : () {
                                      if (_formkey.currentState!.validate()) {
                                        active = false;

                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            type: PageTransitionType.fade,
                                            alignment: Alignment.center,
                                            isIos: true,
                                            duration: const Duration(
                                                milliseconds: 200),
                                            child: PersonInPaymentOptionScreen(
                                              storeCurrency:
                                                  widget.storeCurrency,
                                              storeName: widget.storeName,
                                              storeId: widget.storeId,
                                              symbol: symbol,
                                              amount: _amountController.text,
                                              isPersonInPayment: true,
                                              storeCurrencyImage:
                                                  widget.storeCurrencyImage,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                              buttonText: 'Submit',
                            ),
                          ),
                          Expanded(
                              child: Container(
                            color: const Color(0xffF7F9FD),
                            child: CustomCryptoKeyboard(
                              currency: widget.storeCurrency,
                              pinController: _amountController,
                              onChange: (String pin) {
                                _amountController.text = pin;
                              },
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                );
              })),
    );
  }

  appBarSection(BuildContext context, state) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DefaultBackButtonWidget(
            onTap: () {
              Navigator.pushReplacement(
                context,
                PageTransition(
                  type: PageTransitionType.scale,
                  alignment: Alignment.center,
                  isIos: true,
                  duration: const Duration(microseconds: 500),
                  child: StoreScreen(
                    storeId: widget.storeId,
                    storeName: widget.storeName,
                    storeCurrency: widget.storeCurrency,
                    storeCurrencyImage: widget.storeCurrencyImage,
                    // profit: widget.profit,
                    // time: widget.time,
                    // orderId: state
                    //     .nodeLogsModel!
                    //     .order![index]
                    //     .orderId!,
                  ),
                ),
              );
            },
          ),
          const Text(
            'Payment in person',
            style: TextStyle(
                color: Color(0xff000000),
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.w500,
                height: 1),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }
}
