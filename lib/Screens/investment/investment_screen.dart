import 'dart:io';

import 'package:gptbanqbusiness/Screens/investment/bloc/investment_bloc.dart';
import 'package:gptbanqbusiness/Screens/investment/master_node_dashboard_screen.dart';
import 'package:gptbanqbusiness/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gptbanqbusiness/constant_string/User.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import '../../utils/input_fields/custom_color.dart';
import '../../widgets/buttons/custom_floating_action_button.dart';
import '../../widgets/buttons/primary_button_widget.dart';
import '../../widgets/toast/toast_util.dart';
import '../crypto_screen/staking_overivew.dart';

class InvestmentScreen extends StatefulWidget {
  InvestmentScreen({super.key, required this.isTcInvestmentCall});

  bool? isTcInvestmentCall;

  @override
  State<InvestmentScreen> createState() => _InvestmentScreenState();
}

class _InvestmentScreenState extends State<InvestmentScreen> {
  bool active = false;

  bool shownotification = true;
  final InvestmentBloc _investmentBloc = InvestmentBloc();

  Future<void> _onRefresh() async {
    debugPrint('_onRefresh');

    _investmentBloc.add(NodeCheckModuleEvent());
  }

  @override
  void initState() {
    super.initState();
    User.Screen = 'Investment screen';

    _investmentBloc.add(NodeCheckModuleEvent());

    if (widget.isTcInvestmentCall == true) {
      _investmentBloc.add(SwiftTermsEvent(
          type: "investment",
          deviceType: Platform.isAndroid ? "android" : "ios"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColor.scaffoldBg,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: BlocListener(
            bloc: _investmentBloc,
            listener: (context, InvestmentState state) {
              if (state.statusModel?.status == 0) {
                CustomToast.showError(
                    context, "Sorry!", state.statusModel!.message!);
              }
            },
            child: BlocBuilder(
                bloc: _investmentBloc,
                builder: (context, InvestmentState state) {
                  return User.hidepage == 1
                      ? Scaffold(
                          body: SafeArea(
                            child: Center(
                                child: Text(
                              'Service Not Available',
                              style: GoogleFonts.inter(
                                color: CustomColor.primaryTextHintColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                          ),
                        )
                      : SafeArea(
                          child: ProgressHUD(
                            inAsyncCall: state.isloading,
                            child: RefreshIndicator(
                              onRefresh: _onRefresh,
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 16, right: 16, top: 10, bottom: 60),
                                child: ListView(
                                  children: [
                                    appBarSection(context, state),
                                    Container(
                                      padding: const EdgeInsets.only(
                                          left: 16, right: 16, top: 16),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(16),
                                          ),
                                          color:
                                              CustomColor.hubContainerBgColor,
                                          image: DecorationImage(
                                            alignment: Alignment.topRight,
                                            image: AssetImage(
                                              // "images/investment/t_icon.png",
                                              StaticAssets.stake,
                                            ),
                                            scale: 3,
                                          )),
                                      child: Column(
                                        children: [
                                          // Image.asset(
                                          //   "images/investment/t_icon.png",
                                          //   height: 60,
                                          // ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 3, vertical: 8),
                                                child: Text("Staking",
                                                    style: GoogleFonts.inter(
                                                      color: CustomColor.black,
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    )),
                                              ),
                                              Text(
                                                  "${state.nodeCheckModuleModel?.wlMasternode!.toUpperCase()}",
                                                  style: GoogleFonts.inter(
                                                    color: CustomColor.black,
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.w500,
                                                  )),
                                            ],
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                                color: CustomColor
                                                    .stakingSmallContainerColor,
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                border: Border.all(
                                                  color: CustomColor
                                                      .dashboardProfileBorderColor,
                                                )),
                                            child: Text(
                                              'Guaranteed earnings up to ${state.nodeCheckModuleModel?.stakingProfit} per month',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.inter(
                                                color: CustomColor.black
                                                    .withOpacity(0.7),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            width: 250,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  // mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .check_circle_outline,
                                                      color: CustomColor
                                                          .primaryTextHintColor,
                                                      size: 18,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        'Profit credited every month',
                                                        textAlign:
                                                            TextAlign.left,
                                                        style:
                                                            GoogleFonts.inter(
                                                          color: CustomColor
                                                              .primaryTextHintColor,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  // mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .check_circle_outline,
                                                      color: CustomColor
                                                          .primaryTextHintColor,
                                                      size: 18,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        'You can unlock your investment\nwhenever you want',
                                                        textAlign:
                                                            TextAlign.left,
                                                        style:
                                                            GoogleFonts.inter(
                                                          color: CustomColor
                                                              .primaryTextHintColor,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          PrimaryButtonWidget(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  PageTransition(
                                                      type: PageTransitionType
                                                          .scale,
                                                      alignment:
                                                          Alignment.center,
                                                      isIos: true,
                                                      duration: const Duration(
                                                          microseconds: 500),
                                                      child: StakingOverviewScreen(
                                                          symbol:
                                                              "${state.nodeCheckModuleModel?.wlMasternode!}")));
                                            },
                                            buttonText: 'Next',
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                          left: 16, right: 16, top: 16),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(16),
                                          ),
                                          color:
                                              CustomColor.hubContainerBgColor,
                                          image: DecorationImage(
                                            alignment: Alignment.bottomRight,
                                            image: AssetImage(
                                              // "images/investment/t_icon.png",
                                              StaticAssets.masternode,
                                            ),
                                            scale: 1,
                                          )),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 3, vertical: 8),
                                                child: Text(
                                                    "Buy Virtual\nMaster Node",
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.inter(
                                                      color: CustomColor.black,
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    )),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                                color: CustomColor
                                                    .stakingSmallContainerColor,
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                border: Border.all(
                                                  color: CustomColor
                                                      .dashboardProfileBorderColor,
                                                )),
                                            child: Text(
                                              'up to ${state.nodeCheckModuleModel?.investmentProfit} per month',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.inter(
                                                color: CustomColor.black
                                                    .withOpacity(0.7),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            width: 250,
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .check_circle_outline,
                                                      color: CustomColor
                                                          .primaryTextHintColor,
                                                      size: 18,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        'Profit in ${state.nodeCheckModuleModel?.period} years',
                                                        // textAlign: TextAlign.left,
                                                        style:
                                                            GoogleFonts.inter(
                                                          color: CustomColor
                                                              .primaryTextHintColor,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .check_circle_outline,
                                                      color: CustomColor
                                                          .primaryTextHintColor,
                                                      size: 18,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        'Daily profit payment',
                                                        style:
                                                            GoogleFonts.inter(
                                                          color: CustomColor
                                                              .primaryTextHintColor,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          PrimaryButtonWidget(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                PageTransition(
                                                  type:
                                                      PageTransitionType.scale,
                                                  alignment: Alignment.center,
                                                  isIos: true,
                                                  duration: const Duration(
                                                      microseconds: 500),
                                                  child: MasterNodeDashboardScreen(
                                                      // profit: state
                                                      //     .nodeCheckModuleModel!
                                                      //     .enduserMasternodeProfit!,
                                                      // time: state
                                                      //     .nodeCheckModuleModel!
                                                      //     .period!,
                                                      ),
                                                ),
                                              );
                                            },
                                            buttonText: 'Next',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                })),
        floatingActionButton: CustomFloatingActionButton());
  }

  appBarSection(BuildContext context, state) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(bottom: 20, top: 10),
      child: Text(
        'Investment Dashboard',
        textAlign: TextAlign.center,
        style: GoogleFonts.inter(
            color: CustomColor.black,
            fontSize: 18,
            fontWeight: FontWeight.w500),
      ),
    );
  }
}
