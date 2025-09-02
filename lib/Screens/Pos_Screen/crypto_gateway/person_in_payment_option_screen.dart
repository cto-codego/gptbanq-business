import 'package:gptbanqbusiness/Screens/Pos_Screen/bloc/pos_bloc.dart';
import 'package:gptbanqbusiness/Screens/Pos_Screen/crypto_gateway/store_screen.dart';
import 'package:gptbanqbusiness/utils/input_fields/custom_color.dart';
import 'package:gptbanqbusiness/widgets/input_fields/amount_input_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gptbanqbusiness/constant_string/User.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import '../../../cutom_weidget/custom_keyboard.dart';
import '../../../widgets/buttons/default_back_button_widget.dart';
import '../../../widgets/buttons/primary_button_widget.dart';
import '../../../widgets/toast/toast_util.dart';
import 'person_make_payment_screen.dart';

class PersonInPaymentOptionScreen extends StatefulWidget {
  PersonInPaymentOptionScreen(
      {super.key,
      required this.storeId,
      required this.amount,
      required this.storeCurrency,
      required this.storeCurrencyImage,
      required this.symbol,
      required this.storeName,
        this.email,
      required this.isPersonInPayment});

  String storeId;
  String storeName;
  String storeCurrency;
  String storeCurrencyImage;
  String amount;
  String? email;
  String symbol;
  bool isPersonInPayment;

  @override
  State<PersonInPaymentOptionScreen> createState() =>
      _PersonInPaymentOptionScreenState();
}

class _PersonInPaymentOptionScreenState
    extends State<PersonInPaymentOptionScreen> {
  final PosBloc _posBloc = PosBloc();
  int selectedIndex = -1; // -1 means no container is selected initially
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.scaffoldBg,
      body: BlocListener(
          bloc: _posBloc,
          listener: (context, PosState state) {
            if (state.statusModel?.status == 0) {
              CustomToast.showError(
                  context, "Sorry!", state.statusModel!.message!);
            }

            if (state.createQrModel?.status == 1) {
              if(widget.isPersonInPayment){
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
              }else{
                CustomToast.showSuccess(
                    context, "Hey!", state.createQrModel!.message!);
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
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        child: Column(
                          children: [
                            appBarSection(context, state),
                            SizedBox(
                              height: 20,
                            ),
                            Expanded(
                              child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),

                                itemCount:
                                    state.coinListModel!.coinlist!.length,
                                // Display 5 containers
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedIndex = index;
                                        symbol = state.coinListModel!
                                            .coinlist![index].symbol!;
                                        print(symbol);
                                      });
                                    },
                                    child: Container(
                                      // height: 100,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 0),
                                      padding: const EdgeInsets.all(12.0),
                                      decoration: BoxDecoration(
                                        color: selectedIndex == index
                                            ? CustomColor.primaryColor
                                            : CustomColor.hubContainerBgColor,
                                        borderRadius:
                                            BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Image.network(
                                            state.coinListModel!
                                                .coinlist![index].image!,
                                            height: 40,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.only(
                                                        left: 8, bottom: 3),
                                                child: Text(
                                                  "${state.coinListModel!.coinlist![index].coinname!} ${state.coinListModel!.coinlist![index].network!}",
                                                  style: GoogleFonts.inter(
                                                    fontSize: 16,
                                                    color: selectedIndex ==
                                                            index
                                                        ? CustomColor
                                                            .whiteColor
                                                        : CustomColor.black
                                                            .withOpacity(0.7),
                                                  ),
                                                ),
                                              ),
                                              // Padding(
                                              //   padding: const EdgeInsets
                                              //       .symmetric(horizontal: 8),
                                              //   child: Text(
                                              //     "1 ${state.coinListModel!.coinlist![index].symbol!} = ${state.coinListModel!.coinlist![index].price!}",
                                              //     style: GoogleFonts.inter(
                                              //       fontSize: 12,
                                              //       fontWeight: FontWeight.w500,
                                              //       color: selectedIndex ==
                                              //           index
                                              //           ? CustomColor
                                              //           .whiteColor.withOpacity(0.8)
                                              //           : CustomColor.black
                                              //           .withOpacity(0.7),
                                              //
                                              //     ),
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            PrimaryButtonWidget(
                              onPressed: selectedIndex == -1
                                  ? null
                                  : () {
                                      if (widget.isPersonInPayment) {
                                        _posBloc.add(CreateQrEvent(
                                            symbol: symbol,
                                            storeId: widget.storeId,
                                            amount: widget.amount,
                                            type: "person"));
                                      } else {
                                        _posBloc.add(CreateQrEvent(
                                            symbol: symbol,
                                            storeId: widget.storeId,
                                            amount: widget.amount,
                                            email: widget.email,
                                            type: "remote"));
                                      }
                                    },
                              buttonText: 'Submit',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              })),
    );
  }

  appBarSection(BuildContext context, state) {
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DefaultBackButtonWidget(
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Text(
            'Payment in person',
            style: GoogleFonts.inter(
                color: CustomColor.black,
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
