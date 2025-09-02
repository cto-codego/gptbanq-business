import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:gptbanqbusiness/Screens/crypto_screen/bloc/crypto_bloc.dart';
import 'package:gptbanqbusiness/Screens/crypto_screen/new_stake_scrreen.dart';
import 'package:gptbanqbusiness/Screens/crypto_screen/profit_log_screen.dart';
import 'package:gptbanqbusiness/Screens/crypto_screen/stake_screen.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:gptbanqbusiness/utils/assets.dart';
import 'package:gptbanqbusiness/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import '../../utils/input_fields/custom_color.dart';
import '../../widgets/buttons/default_back_button_widget.dart';
import '../../widgets/buttons/primary_button_widget.dart';
import '../../widgets/toast/toast_util.dart';

class StakingOverviewScreen extends StatefulWidget {
  final String symbol;

  const StakingOverviewScreen({super.key, required this.symbol});

  @override
  State<StakingOverviewScreen> createState() => _StakingOverviewScreenState();
}

class _StakingOverviewScreenState extends State<StakingOverviewScreen> {
  final CryptoBloc _cryptoBloc = CryptoBloc();

  Future<void> _onRefresh() async {
    debugPrint('_onRefresh');
    _cryptoBloc.add(StakeOverviewEvent(symbol: widget.symbol));
  }



  bool isStakeRequestInProgress = false;

  @override
  void initState() {
    super.initState();
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
            if (state.statusModel != null && state.statusModel?.status == 0) {
              CustomToast.showError(
                  context, "Sorry!", state.statusModel!.message!);
            }

            if (state.stakeStopModel != null &&
                state.stakeStopModel!.status == 1) {
              CustomToast.showSuccess(
                  context, "Hey!!", state.statusModel!.message!);
            }
          },
          child: BlocBuilder(
              bloc: _cryptoBloc,
              builder: (context, CryptoState state) {
                return RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: SafeArea(
                    child: ProgressHUD(
                      inAsyncCall: state.isloading,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                              const EdgeInsets.only(bottom: 30, top: 10),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  DefaultBackButtonWidget(onTap: () {
                                    Navigator.pushNamedAndRemoveUntil(context,
                                        'investmentScreen', (route) => false);
                                  }),
                                  Text(
                                    "${state.stakeOverviewModel!.overview!.symbol!} Staking Overview",
                                    style: GoogleFonts.inter(
                                        color: CustomColor.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Container(
                                    width: 20,
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 80,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 5),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 8),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            const BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                            color: CustomColor
                                                .hubContainerBgColor, // Using hex color with opacity
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        right: 5),
                                                    child: CustomImageWidget(
                                                      imagePath: StaticAssets
                                                          .totalAmount,
                                                      imageType: 'svg',
                                                      height: 18,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Total Amount",
                                                    textAlign:
                                                    TextAlign.center,
                                                    style: GoogleFonts.inter(
                                                        color: CustomColor
                                                            .primaryTextHintColor,
                                                        fontSize: 13,
                                                        fontWeight:
                                                        FontWeight.w400),
                                                  ),
                                                ],
                                              ),
                                              if (state
                                                  .stakeOverviewModel!
                                                  .overview!
                                                  .totalAmount!
                                                  .isNotEmpty)
                                                Text(
                                                  "${state.stakeOverviewModel!.overview!.totalAmount!.toString()}  ${state.stakeOverviewModel!.overview!.symbol!.toString()} ",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.inter(
                                                      color:
                                                      CustomColor.black,
                                                      fontSize: 13,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 80,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 5),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 8),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            const BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                            color: CustomColor
                                                .hubContainerBgColor, // Using hex color with opacity
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        right: 5),
                                                    child: CustomImageWidget(
                                                      imagePath: StaticAssets
                                                          .totalProfit,
                                                      imageType: 'svg',
                                                      height: 18,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Total Profit",
                                                    textAlign:
                                                    TextAlign.center,
                                                    style: GoogleFonts.inter(
                                                        color: CustomColor
                                                            .primaryTextHintColor,
                                                        fontSize: 13,
                                                        fontWeight:
                                                        FontWeight.w400),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                "${state.stakeOverviewModel!.overview!.totalProfit!}  ${state.stakeOverviewModel!.overview!.symbol!} ",
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.inter(
                                                    color: CustomColor.black,
                                                    fontSize: 13,
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 80,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 5),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 8),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            const BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                            color: CustomColor
                                                .hubContainerBgColor, // Using hex color with opacity
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        right: 5),
                                                    child: CustomImageWidget(
                                                      imagePath: StaticAssets
                                                          .monthProfit,
                                                      imageType: 'svg',
                                                      height: 18,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      "This Month's Profit",
                                                      textAlign:
                                                      TextAlign.center,
                                                      style: GoogleFonts.inter(
                                                          color: CustomColor
                                                              .primaryTextHintColor,
                                                          fontSize: 13,
                                                          fontWeight:
                                                          FontWeight
                                                              .w400),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              if (state
                                                  .stakeOverviewModel!
                                                  .thismonthprofit!
                                                  .isNotEmpty)
                                                Text(
                                                  "${state.stakeOverviewModel!.thismonthprofit}  ${state.stakeOverviewModel!.overview!.symbol!.toString()} ",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.inter(
                                                      color:
                                                      CustomColor.black,
                                                      fontSize: 13,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 80,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 5),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 8),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            const BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                            color: CustomColor
                                                .hubContainerBgColor, // Using hex color with opacity
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        right: 5),
                                                    child: CustomImageWidget(
                                                      imagePath: StaticAssets
                                                          .dailyProfit,
                                                      imageType: 'svg',
                                                      height: 18,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Daily Profit",
                                                    textAlign:
                                                    TextAlign.center,
                                                    style: GoogleFonts.inter(
                                                        color: CustomColor
                                                            .primaryTextHintColor,
                                                        fontSize: 13,
                                                        fontWeight:
                                                        FontWeight.w400),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                "${state.stakeOverviewModel!.dailyprofit!}  ${state.stakeOverviewModel!.overview!.symbol!} ",
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.inter(
                                                    color: CustomColor.black,
                                                    fontSize: 13,
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            state.stakeOverviewModel!.isCstaking == 0
                                ? Container()
                                : state.stakeOverviewModel!.isCstaking == 1 &&
                                state.stakeOverviewModel!.isButton ==
                                    2
                                ? PrimaryButtonWidget(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.scale,
                                    alignment: Alignment.center,
                                    isIos: true,
                                    duration: const Duration(
                                        microseconds: 500),
                                    child: StakingScreen(
                                        symbol: widget.symbol),
                                  ),
                                );
                              },
                              buttonText: state.stakeOverviewModel!
                                  .stakingProfit!.isNotEmpty
                                  ? state.stakeOverviewModel!
                                  .stakingProfit!
                                  : "",
                            )
                                : state.stakeOverviewModel!.isCstaking ==
                                1 &&
                                state.stakeOverviewModel!
                                    .isButton ==
                                    0
                                ? PrimaryButtonWidget(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType
                                        .scale,
                                    alignment: Alignment.center,
                                    isIos: true,
                                    duration: const Duration(
                                        microseconds: 500),
                                    child: NewStakingScreen(
                                        symbol: widget.symbol),
                                  ),
                                ).then((value) {
                                  _cryptoBloc.add(
                                      StakeOverviewEvent(
                                          symbol:
                                          widget.symbol));
                                });
                              },
                              buttonText: state
                                  .stakeOverviewModel!
                                  .stakingProfit ??
                                  "",
                            )
                                : state.stakeOverviewModel!
                                .isCstaking ==
                                1 &&
                                state.stakeOverviewModel!
                                    .isButton ==
                                    1
                                ? ElevatedButton(
                                onPressed: () {},
                                style:
                                ElevatedButton.styleFrom(
                                  elevation: 0,
                                  shape:
                                  RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius
                                          .circular(
                                          40)),
                                  backgroundColor:
                                  Colors.grey,
                                  minimumSize:
                                  const Size.fromHeight(
                                      55),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment
                                      .center,
                                  children: [
                                    Container(
                                        height: 40,
                                        padding:
                                        const EdgeInsets
                                            .all(5),
                                        decoration:
                                        BoxDecoration(
                                          color: const Color(
                                              0xFF263159)
                                              .withOpacity(
                                              0.05),
                                          shape:
                                          BoxShape.circle,
                                        ),
                                        child: Image.asset(
                                          'images/stake.png',
                                          height: 15,
                                        )),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    if (state
                                        .stakeOverviewModel!
                                        .stakingProfit!
                                        .isNotEmpty)
                                      Text(
                                        state
                                            .stakeOverviewModel!
                                            .stakingProfit!,
                                        style:
                                        const TextStyle(
                                            color: Colors
                                                .white,
                                            fontSize: 14,
                                            fontWeight:
                                            FontWeight
                                                .w500,
                                            fontFamily:
                                            'pop'),
                                      ),
                                  ],
                                ))
                                : Container(),
                            Text(
                              "Stake Logs",
                              style: GoogleFonts.inter(
                                  color: CustomColor.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                            Expanded(
                                child:
                                state.stakeOverviewModel!.logs!.isNotEmpty
                                    ? ListView.builder(
                                  itemCount: state
                                      .stakeOverviewModel!
                                      .logs!
                                      .length,
                                  itemBuilder:
                                      (BuildContext context,
                                      int index) {
                                    final log = state
                                        .stakeOverviewModel!
                                        .logs![index];

                                    return InkWell(
                                      onTap: () {},
                                      child: Container(
                                        margin: const EdgeInsets
                                            .symmetric(vertical: 6),
                                        padding: const EdgeInsets
                                            .symmetric(
                                            horizontal: 12,
                                            vertical: 8),
                                        decoration: BoxDecoration(
                                            color: CustomColor
                                                .cryptoListContainerColor,
                                            borderRadius:
                                            BorderRadius
                                                .circular(16)),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .center,
                                          children: [
                                            Expanded(
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Text(
                                                            "Invest: ${log.amount}  ${log.coin}",
                                                            style: GoogleFonts.inter(
                                                                color: CustomColor
                                                                    .black,
                                                                fontSize:
                                                                14,
                                                                fontWeight:
                                                                FontWeight.w500),
                                                          ),
                                                          Text(
                                                            "Profit:  ${log.totalProfit}  ${log.coin}",
                                                            style: GoogleFonts.inter(
                                                                color: CustomColor
                                                                    .black,
                                                                fontSize:
                                                                14,
                                                                fontWeight:
                                                                FontWeight.w500),
                                                          ),
                                                          Text(
                                                            "Period: ${log.period}",
                                                            style: GoogleFonts.inter(
                                                                color: CustomColor
                                                                    .primaryTextHintColor,
                                                                fontSize:
                                                                11,
                                                                fontWeight:
                                                                FontWeight.w500),
                                                          ),
                                                          Text(
                                                            "Status: ${log.status}",
                                                            style: GoogleFonts.inter(
                                                                color: CustomColor
                                                                    .primaryTextHintColor,
                                                                fontSize:
                                                                11,
                                                                fontWeight:
                                                                FontWeight.w500),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                )),
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .end,
                                              children: [
                                                log.status ==
                                                    "Active"
                                                    ? InkWell(
                                                  onTap: () {
                                                    AwesomeDialog(
                                                      context:
                                                      context,
                                                      dialogType:
                                                      DialogType.noHeader,
                                                      animType:
                                                      AnimType.bottomSlide,
                                                      title:
                                                      "Do you want to stop?",
                                                      desc:
                                                      "You will lose profit.",
                                                      titleTextStyle: GoogleFonts.inter(
                                                          fontSize:
                                                          20,
                                                          fontWeight:
                                                          FontWeight.w500,
                                                          color: CustomColor.black),
                                                      descTextStyle: GoogleFonts.inter(
                                                          fontSize:
                                                          14,
                                                          fontWeight:
                                                          FontWeight.w500,
                                                          color: CustomColor.black.withOpacity(0.7)),
                                                      btnCancelText:
                                                      'cancel',
                                                      btnOkText:
                                                      "Confirm",
                                                      btnOkColor:
                                                      CustomColor.primaryColor,
                                                      btnCancelColor:
                                                      CustomColor.errorColor,
                                                      buttonsTextStyle: GoogleFonts.inter(
                                                          fontSize:
                                                          13,
                                                          fontWeight:
                                                          FontWeight.w500,
                                                          color: CustomColor.whiteColor),
                                                      btnCancelOnPress:
                                                          () {},
                                                      btnOkOnPress:
                                                          () {
                                                        _cryptoBloc
                                                            .add(StakeStopEvent(orderId: log.orderId!.isNotEmpty ? log.orderId! : ""));
                                                      },
                                                    ).show();
                                                  },
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      40),
                                                  splashColor: Colors
                                                      .grey
                                                      .withOpacity(
                                                      0.2),
                                                  child:
                                                  Container(
                                                    width:
                                                    110,
                                                    margin: const EdgeInsets
                                                        .all(
                                                        5),
                                                    padding: const EdgeInsets
                                                        .all(
                                                        10),
                                                    decoration:
                                                    BoxDecoration(
                                                      color: CustomColor
                                                          .whiteColor,
                                                      borderRadius:
                                                      BorderRadius.circular(40),
                                                    ),
                                                    alignment:
                                                    Alignment
                                                        .center,
                                                    child:
                                                    Text(
                                                      'Stop',
                                                      style: GoogleFonts
                                                          .inter(
                                                        color:
                                                        Color(0xff26273C),
                                                        fontSize:
                                                        11,
                                                        fontWeight:
                                                        FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                    : Container(),
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      PageTransition(
                                                        type: PageTransitionType
                                                            .scale,
                                                        alignment:
                                                        Alignment
                                                            .center,
                                                        isIos: true,
                                                        duration: const Duration(
                                                            microseconds:
                                                            500),
                                                        child: ProfitLogScreen(
                                                            orderId: log.orderId!.isNotEmpty
                                                                ? log.orderId!
                                                                : ""),
                                                      ),
                                                    ).then((value) {
                                                      _cryptoBloc.add(
                                                          StakeProfitLogEvent(
                                                              orderId:
                                                              log.orderId!.isNotEmpty ? log.orderId! : ""));
                                                    });
                                                  },
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                      40),
                                                  splashColor: Colors
                                                      .grey
                                                      .withOpacity(
                                                      0.2),
                                                  // Optional: Customize splash color
                                                  child: Container(
                                                    width: 110,
                                                    margin:
                                                    const EdgeInsets
                                                        .all(5),
                                                    padding:
                                                    const EdgeInsets
                                                        .all(
                                                        10),
                                                    decoration:
                                                    BoxDecoration(
                                                      color: Colors
                                                          .white,
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                          40),
                                                    ),
                                                    alignment:
                                                    Alignment
                                                        .center,
                                                    child: Text(
                                                      'Profit Log',
                                                      style:
                                                      GoogleFonts
                                                          .inter(
                                                        color: Color(
                                                            0xff26273C),
                                                        fontSize:
                                                        11,
                                                        fontWeight:
                                                        FontWeight
                                                            .w500,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                )
                                    : Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 20),
                                  child: Column(
                                    children: [
                                      CustomImageWidget(
                                        imagePath: StaticAssets
                                            .noTransaction,
                                        imageType: 'svg',
                                        height: 130,
                                      ),
                                      Text(
                                        "No Transaction",
                                        style: GoogleFonts.inter(
                                          color: CustomColor.black
                                              .withOpacity(0.6),
                                          fontWeight:
                                          FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              })),
    );
  }
}
