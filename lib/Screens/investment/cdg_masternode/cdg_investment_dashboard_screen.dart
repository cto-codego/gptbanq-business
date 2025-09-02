import 'dart:io';

import 'package:gptbanqbusiness/Screens/investment/bloc/investment_bloc.dart';
import 'package:gptbanqbusiness/utils/assets.dart';
import 'package:gptbanqbusiness/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gptbanqbusiness/constant_string/User.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/input_fields/custom_color.dart';
import '../../../utils/strings.dart';
import '../../../widgets/buttons/custom_floating_action_button.dart';
import '../../../widgets/buttons/primary_button_widget.dart';
import '../../../widgets/toast/toast_util.dart';

class CdgInvestmentDashboardScreen extends StatefulWidget {
  CdgInvestmentDashboardScreen({super.key, this.isTcInvestmentCall});

  bool? isTcInvestmentCall;

  @override
  State<CdgInvestmentDashboardScreen> createState() =>
      _CdgInvestmentDashboardScreenState();
}

class _CdgInvestmentDashboardScreenState
    extends State<CdgInvestmentDashboardScreen> {
  bool active = false;

  bool shownotification = true;
  final InvestmentBloc _investmentBloc = InvestmentBloc();

  Future<void> _onRefresh() async {
    debugPrint('_onRefresh');

    _investmentBloc.add(CdgDeviceListEvent());
  }

  @override
  void initState() {
    super.initState();

    _investmentBloc.add(CdgDeviceListEvent());

    if (widget.isTcInvestmentCall == true) {
      _investmentBloc.add(SwiftTermsEvent(
          type: "cdg", deviceType: Platform.isAndroid ? "android" : "ios"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColor.scaffoldBg,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: AppBar(
          title: Text(
            '${Strings.coinName} Investment Dashboard',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
                color: CustomColor.black,
                fontSize: 18,
                fontWeight: FontWeight.w500),
          ),
          backgroundColor: CustomColor.scaffoldBg,
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          // leading: InkWell(
          //   onTap: () {
          //     Navigator.pop(context);
          //   },
          //   child: Padding(
          //     padding: const EdgeInsets.all(14.0),
          //     child: CustomImageWidget(
          //       imagePath: StaticAssets.arrowNarrowLeft,
          //       width: 15,
          //       height: 15,
          //     ),
          //   ),
          // ),
        ),
        body: BlocListener(
            bloc: _investmentBloc,
            listener: (context, InvestmentState state) {
              if (state.statusModel?.status == 0) {
                CustomToast.showError(
                    context, "Sorry!", state.statusModel!.message!);
              }

              if (state.cdgDeviceListModel?.status == 1) {
                User.isCdgShow = state.cdgDeviceListModel!.isCdg!;
              } else if (state.cdgDeviceListModel?.status == 0) {
                CustomToast.showError(
                    context, "Sorry!", state.cdgDeviceListModel!.message!);
              }
            },
            child: BlocBuilder(
                bloc: _investmentBloc,
                builder: (context, InvestmentState state) {
                  return SafeArea(
                    child: User.hidepage == 1
                        ? Center(
                            child: Text(
                            'Service Not Available',
                            style: GoogleFonts.inter(
                              color: CustomColor.primaryTextHintColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ))
                        : ProgressHUD(
                            inAsyncCall: state.isloading,
                            child: RefreshIndicator(
                              onRefresh: _onRefresh,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 16, right: 16, top: 10, bottom: 60),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.7,
                                      child: ListView.builder(
                                        itemCount: state
                                            .cdgDeviceListModel!.data!.length,
                                        itemBuilder: (context, index) {
                                          print(state
                                              .cdgDeviceListModel!.data!.length
                                              .toString());
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: InkWell(
                                              onTap: () {
                                                // showModalBottomSheet(
                                                //   context: context,
                                                //   isScrollControlled: true,
                                                //   elevation: 5,
                                                //   builder: (context) {
                                                //     return SizedBox(
                                                //       height:
                                                //           MediaQuery.of(context)
                                                //                   .size
                                                //                   .height *
                                                //               0.8,
                                                //       child:
                                                //           OrderCdgMasternodeSheet(
                                                //         quantity: state
                                                //             .cdgDeviceListModel!
                                                //             .quantity!,
                                                //         price: state
                                                //             .cdgDeviceListModel!
                                                //             .data![index]
                                                //             .labelDeviceCost!,
                                                //         type: state
                                                //             .cdgDeviceListModel!
                                                //             .data![index]
                                                //             .type!,
                                                //         profitPerDay: state
                                                //             .cdgDeviceListModel!
                                                //             .data![index]
                                                //             .labelProfit!,
                                                //         shipmentCost: state
                                                //             .cdgDeviceListModel!
                                                //             .data![index]
                                                //             .shippingCost!,
                                                //         shipmentCostValue: state
                                                //             .cdgDeviceListModel!
                                                //             .data![index]
                                                //             .shippingCost!,
                                                //         deviceCostValue: state
                                                //             .cdgDeviceListModel!
                                                //             .data![index]
                                                //             .deviceCost!,
                                                //       ),
                                                //     );
                                                //   },
                                                // );
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(16),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  color: CustomColor
                                                      .hubContainerBgColor,
                                                ),
                                                child: Column(
                                                  children: [
                                                    if (state
                                                        .cdgDeviceListModel!
                                                        .data![index]
                                                        .image!
                                                        .isNotEmpty)
                                                      Image.network(
                                                        state
                                                            .cdgDeviceListModel!
                                                            .data![index]
                                                            .image!,
                                                        height: 100,
                                                      ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 8),
                                                      child: Text(
                                                        state
                                                            .cdgDeviceListModel!
                                                            .data![index]
                                                            .type!,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style:
                                                            GoogleFonts.inter(
                                                          color:
                                                              CustomColor.black,
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8,
                                                          vertical: 4),
                                                      decoration: BoxDecoration(
                                                        color: CustomColor
                                                            .stakingSmallContainerColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16),
                                                        border: Border.all(
                                                          color: CustomColor
                                                              .dashboardProfileBorderColor,
                                                        ),
                                                      ),
                                                      child: RichText(
                                                        textAlign:
                                                            TextAlign.center,
                                                        text: TextSpan(
                                                          text:
                                                              'Guaranteed earnings ',
                                                          style:
                                                              GoogleFonts.inter(
                                                            color: CustomColor
                                                                .black
                                                                .withOpacity(
                                                                    0.7),
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                          children: [
                                                            TextSpan(
                                                              text:
                                                                  'up to ${state.cdgDeviceListModel!.data![index].labelProfit}',
                                                              style: GoogleFonts
                                                                  .inter(
                                                                color: CustomColor
                                                                    .black
                                                                    .withOpacity(
                                                                        0.7),
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text: ' per day',
                                                              style: GoogleFonts
                                                                  .inter(
                                                                color: CustomColor
                                                                    .black
                                                                    .withOpacity(
                                                                        0.7),
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Column(children: [
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .check_circle_outline,
                                                            color: Colors.green,
                                                            size: 18,
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              'Earn ${state.cdgDeviceListModel!.data![index].labelProfit} per day, with a minimum equivalent of ${state.cdgDeviceListModel!.data![index].labelEnduserProfit} daily.',
                                                              style: GoogleFonts
                                                                  .inter(
                                                                color: CustomColor
                                                                    .primaryTextHintColor,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .check_circle_outline,
                                                            color: Colors.green,
                                                            size: 18,
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              'Receive your CDG every 24 hours, with no delays',
                                                              style: GoogleFonts
                                                                  .inter(
                                                                color: CustomColor
                                                                    .primaryTextHintColor,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .check_circle_outline,
                                                            color: Colors.green,
                                                            size: 18,
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              'Your earnings are withdrawable at any time',
                                                              style: GoogleFonts
                                                                  .inter(
                                                                color: CustomColor
                                                                    .primaryTextHintColor,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .check_circle_outline,
                                                            color: Colors.green,
                                                            size: 18,
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              'Activate your masternode and enjoy passive income effortlessly.',
                                                              style: GoogleFonts
                                                                  .inter(
                                                                color: CustomColor
                                                                    .primaryTextHintColor,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ]),
                                                    const SizedBox(height: 10),
                                                    Image.asset(
                                                      StaticAssets
                                                          .cdgCurrencyIcon,
                                                      height: 57,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    PrimaryButtonWidget(
                                      onPressed: () {
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            'cdgMasternodeDashboardScreen',
                                            (route) => false);
                                      },
                                      buttonText: 'Dashboard',
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: CustomImageWidget(
              imagePath: StaticAssets.arrowNarrowLeft,
              width: 24,
              height: 24,
            ),
          ),
          Text(
            'Investment Dashboard',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
                color: CustomColor.black,
                fontSize: 18,
                fontWeight: FontWeight.w500),
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
