
import 'package:gptbanqbusiness/Screens/crypto_screen/bloc/crypto_bloc.dart';
import 'package:gptbanqbusiness/cutom_weidget/custom_navigationBar.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/input_fields/custom_color.dart';
import '../../widgets/toast/toast_util.dart';

// ignore: must_be_immutable
class StakeConfirmScreen extends StatefulWidget {
  String orderId, amount, coin, commission, profit, period;

  StakeConfirmScreen(
      {super.key,
      required this.orderId,
      required this.amount,
      required this.coin,
      required this.commission,
      required this.profit,
      required this.period});

  @override
  State<StakeConfirmScreen> createState() => _StakeConfirmScreenState();
}

class _StakeConfirmScreenState extends State<StakeConfirmScreen> {
  final CryptoBloc _cryptoBloc = CryptoBloc();

  @override
  void initState() {
    super.initState();
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

            if (state.stakeConfirmModel != null &&
                state.stakeConfirmModel!.status == 1) {
              CustomToast.showSuccess(
                  context, "Thank You!!", state.stakeConfirmModel!.message!);

              Navigator.pushNamedAndRemoveUntil(
                  context, 'cryptoScreen', (route) => false);
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
                                  "Stake Details",
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
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Container(
                              // height: 250,
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
                                          "My Stake",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontFamily: 'pop',
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "${widget.amount} ${widget.coin}",
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
                                          "Commission",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontFamily: 'pop',
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          widget.commission,
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
                                          "Profit",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontFamily: 'pop',
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          widget.profit,
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
                                        Text(
                                          widget.period,
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
                              _cryptoBloc.add(
                                  StakeConfirmEvent(orderId: widget.orderId));
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40)),
                              backgroundColor: const Color(0xffF57B3E),
                              minimumSize: const Size.fromHeight(55),
                            ),
                            child: const Text(
                              'Confirm',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'pop'),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "About",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: 'pop',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                color:
                                    const Color(0xFF263159).withOpacity(0.05),
                              ),
                              child: const Column(
                                // mainAxisAlignment:
                                // MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Text(
                                      "When you send a staking request, the request status should be processing, our administrator will review it and activate the service, then your profit will start. When you want to unfreeze, the profit made for this month will be lost because the cancellation request arrives before the profit date.",
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontFamily: 'pop',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
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
