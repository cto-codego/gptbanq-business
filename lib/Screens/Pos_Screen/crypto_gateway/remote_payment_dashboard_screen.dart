import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:gptbanqbusiness/Screens/Pos_Screen/crypto_gateway/person_in_payment_option_screen.dart';
import 'package:gptbanqbusiness/Screens/Pos_Screen/crypto_gateway/store_screen.dart';
import 'package:gptbanqbusiness/cutom_weidget/input_textform.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gptbanqbusiness/constant_string/User.dart';
import 'package:gptbanqbusiness/cutom_weidget/custom_navigationBar.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import '../../../cutom_weidget/custom_keyboard.dart';
import '../../../utils/input_fields/custom_color.dart';
import '../../../widgets/buttons/default_back_button_widget.dart';
import '../../../widgets/buttons/primary_button_widget.dart';
import '../../../widgets/input_fields/amount_input_field_widget.dart';
import '../../../widgets/toast/toast_util.dart';
import '../bloc/pos_bloc.dart';

class RemotePaymentDashboardScreen extends StatefulWidget {
  RemotePaymentDashboardScreen({
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
  State<RemotePaymentDashboardScreen> createState() =>
      _RemotePaymentDashboardScreenState();
}

class _RemotePaymentDashboardScreenState
    extends State<RemotePaymentDashboardScreen> {
  bool active = false;

  bool shownotification = true;
  final PosBloc _posBloc = PosBloc();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
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
    User.Screen = 'remote payment screen';

    _posBloc.add(CoinListEvent());
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
        active = _amountController.text.isNotEmpty &&
            _emailController.text.isNotEmpty &
                _reasonController.text.isNotEmpty;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.scaffoldBg,
      body: Stack(
        children: [
          BlocListener(
              bloc: _posBloc,
              listener: (context, PosState state) {
                if (state.statusModel?.status == 0) {
                  CustomToast.showError(
                      context, "Sorry!", state.statusModel!.message!);
                }

                if (state.remotePaymentModel?.status == 1) {
                  CustomToast.showSuccess(
                      context, "Hey!", state.remotePaymentModel!.message);
                  Navigator.pushReplacement(
                    context,
                    PageTransition(
                      type: PageTransitionType.fade,
                      alignment: Alignment.center,
                      isIos: true,
                      duration: const Duration(milliseconds: 200),
                      child: StoreScreen(
                        storeName: widget.storeName,
                        storeId: widget.storeId,
                        storeCurrency: widget.storeCurrency,
                        storeCurrencyImage: widget.storeCurrencyImage,
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
                        child: RefreshIndicator(
                          onRefresh: _onRefresh,
                          child: Form(
                            key: _formkey,
                            child: ListView(
                              children: [
                                appBarSection(context, state),
                                Column(
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      child: AmountInputField(
                                        controller: _amountController,
                                        label: 'Enter Amount:',
                                        currencySymbol: widget.storeCurrency.toUpperCase(),
                                        suffixIcon: Container(
                                          width: 25,
                                          height: 25,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    widget.storeCurrencyImage),
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                        minAmount: 0,
                                        onChanged: (v) {
                                          _updateButtonState();
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      child: InputTextCustom(
                                        controller: _emailController,
                                        // keyboardType: TextInputType.number,
                                        hint: 'Enter Your email',
                                        label: 'Email',
                                        isEmail: true,
                                        isPassword: false,
                                        onChanged: () {
                                          _updateButtonState();
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      child: InputTextCustom(
                                        controller: _reasonController,
                                        // keyboardType: TextInputType.number,
                                        hint: 'Reason of Payment',
                                        label: 'Reason of Payment',
                                        isEmail: false,
                                        isPassword: false,
                                        onChanged: () {
                                          _updateButtonState();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 16),
                                  child: PrimaryButtonWidget(
                                    onPressed: active == false
                                        ? null
                                        : () {
                                            if (_formkey.currentState!
                                                .validate()) {
                                              active = false;

                                              _posBloc.add(RemotePaymentEvent(
                                                  reason:
                                                      _reasonController.text,
                                                  storeId: widget.storeId,
                                                  amount:
                                                      _amountController.text,
                                                  email: _emailController.text,
                                                  type: "remote"));
                                            }
                                          },
                                    buttonText: 'Submit',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  })),
        ],
      ),
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
            'Remote Payment',
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
