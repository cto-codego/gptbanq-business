import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:gptbanqbusiness/Screens/crypto_screen/bloc/crypto_bloc.dart';
import 'package:gptbanqbusiness/Screens/crypto_screen/stake_confirm_screen.dart';
import 'package:gptbanqbusiness/cutom_weidget/custom_navigationBar.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

import '../../utils/input_fields/custom_color.dart';
import '../../widgets/toast/toast_util.dart';

class StakingScreen extends StatefulWidget {
  final String symbol;

  const StakingScreen({super.key, required this.symbol});

  @override
  State<StakingScreen> createState() => _StakingScreenState();
}

class _StakingScreenState extends State<StakingScreen> {
  final CryptoBloc _cryptoBloc = CryptoBloc();
  final TextEditingController _amountController = TextEditingController();



  @override
  void initState() {
    super.initState();

    _cryptoBloc.add(StakeFeeEvent(symbol: widget.symbol));
    _cryptoBloc.add(StakeOverviewEvent(symbol: widget.symbol));
  }

  @override
  void dispose() {
    _cryptoBloc.close(); // Close the bloc
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.scaffoldBg,
      body: BlocListener(
          bloc: _cryptoBloc,
          listener: (context, CryptoState state) async {
            if (state.statusModel != null && state.statusModel!.status == 0) {
              CustomToast.showError(
                  context, "Sorry!", state.statusModel!.message!);
            }

            if (state.stakeOrderModel != null &&
                state.stakeOrderModel!.status == 1) {
              String orderId = state.stakeOrderModel!.orderId!;
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.scale,
                  alignment: Alignment.center,
                  isIos: true,
                  duration: const Duration(microseconds: 500),
                  child: StakeConfirmScreen(
                    orderId: orderId,
                    amount: state.stakeOrderModel!.amount!,
                    coin: state.stakeOrderModel!.coin!,
                    commission: state.stakeOrderModel!.commission!,
                    profit: state.stakeOrderModel!.profit!,
                    period: state.stakeOrderModel!.period!,
                  ),
                ),
              );
            }

            if (state.stakeOverviewModel!.status == 1) {
              _amountController.text =
                  state.stakeOverviewModel!.amount.toString();
            }
          },
          child: BlocBuilder(
              bloc: _cryptoBloc,
              builder: (context, CryptoState state) {
                return SafeArea(
                  child: ProgressHUD(
                    inAsyncCall: state.isloading,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: ListView(
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: SizedBox(
                                      width: 30,
                                      child:
                                      Image.asset('images/backarrow.png')),
                                ),
                                const Text(
                                  "Staking",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontFamily: 'pop',
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 30),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Container(
                              height: 140,
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                color:
                                const Color(0xFF263159).withOpacity(0.05),
                              ),
                              child: Column(
                                // mainAxisAlignment:
                                // MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Amount",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontFamily: 'pop',
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "1 ${state.stakeFeeBalanceModel!.coin} = ${state.stakeFeeBalanceModel!.eurPrice}",
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontFamily: 'pop',
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: TextFormField(
                                      autofocus: true,
                                      controller: _amountController,
                                      readOnly:
                                      state.stakeOverviewModel!.isEdit == 0
                                          ? false
                                          : true,
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter an amount';
                                        }
                                        final amount = double.tryParse(value);
                                        if (amount == null ||
                                            amount <
                                                double.parse(state
                                                    .stakeOverviewModel!.amount
                                                    .toString())) {
                                          return 'Amount must be at least 500';
                                        }
                                        return null;
                                      },
                                      style: const TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                      decoration: InputDecoration(
                                          contentPadding:
                                          const EdgeInsets.all(0),
                                          hintText: '000.00',
                                          hintStyle: const TextStyle(
                                              fontFamily: 'pop',
                                              fontSize: 30,
                                              height: 2,
                                              fontWeight: FontWeight.w900,
                                              color: Color(0xffC4C4C4)),
                                          enabledBorder:
                                          const OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.transparent,
                                              width: 0,
                                            ),
                                          ),
                                          errorBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.transparent,
                                              width: 0,
                                            ),
                                          ),
                                          errorMaxLines: 1,
                                          errorStyle: const TextStyle(
                                            fontFamily: 'pop',
                                            fontSize: 12,
                                            color: Colors.transparent,
                                          ),
                                          focusedBorder:
                                          const OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.transparent,
                                              width: 0,
                                            ),
                                          ),
                                          suffixText:
                                          state.stakeFeeBalanceModel!.coin!,
                                          suffixStyle: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Container(
                              height: 163,
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                color:
                                const Color(0xFF263159).withOpacity(0.05),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Price",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontFamily: 'pop',
                                              fontWeight: FontWeight.bold),
                                        ),
                                        if (state.stakeFeeBalanceModel!
                                            .eurPrice!.isNotEmpty)
                                          Text(
                                            state.stakeFeeBalanceModel!
                                                .eurPrice!,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontFamily: 'pop',
                                                fontWeight: FontWeight.bold),
                                          ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Available Balance",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontFamily: 'pop',
                                              fontWeight: FontWeight.bold),
                                        ),
                                        if (state.stakeFeeBalanceModel!.balance!
                                            .isNotEmpty)
                                          Text(
                                            state
                                                .stakeFeeBalanceModel!.balance!,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontFamily: 'pop',
                                                fontWeight: FontWeight.bold),
                                          ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Staking Profit",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontFamily: 'pop',
                                              fontWeight: FontWeight.bold),
                                        ),
                                        if (state.stakeFeeBalanceModel!
                                            .stakingProfit!.isNotEmpty)
                                          Text(
                                            state.stakeFeeBalanceModel!
                                                .stakingProfit!,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontFamily: 'pop',
                                                fontWeight: FontWeight.bold),
                                          ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Period",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontFamily: 'pop',
                                              fontWeight: FontWeight.bold),
                                        ),
                                        if (state.stakeOverviewModel!.period!
                                            .isNotEmpty)
                                          Text(
                                            "${state.stakeOverviewModel!.period!} Month",
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontFamily: 'pop',
                                                fontWeight: FontWeight.bold),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _cryptoBloc.add(StakeOrderEvent(
                                  symbol: state.stakeFeeBalanceModel!.coin,
                                  amount: _amountController.text));
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40)),
                              backgroundColor: const Color(0xffF57B3E),
                              minimumSize: const Size.fromHeight(55),
                            ),
                            child: const Text(
                              'Continue',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'pop'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              })),
      bottomNavigationBar: CustomBottomBar(index: 1),
    );
  }
}
