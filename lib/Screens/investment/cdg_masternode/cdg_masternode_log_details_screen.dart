import 'package:gptbanqbusiness/Screens/investment/bloc/investment_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/input_fields/custom_color.dart';
import '../../../widgets/buttons/default_back_button_widget.dart';
import '../../../widgets/toast/toast_util.dart';

class CdgMasternodeLogDetailsScreen extends StatefulWidget {
  CdgMasternodeLogDetailsScreen({super.key, this.orderId});

  String? orderId;

  @override
  State<CdgMasternodeLogDetailsScreen> createState() =>
      _CdgMasternodeLogDetailsScreenState();
}

class _CdgMasternodeLogDetailsScreenState
    extends State<CdgMasternodeLogDetailsScreen> {
  bool active = false;

  final InvestmentBloc _investmentBloc = InvestmentBloc();

  bool isDailyRewards = true;

  Future<void> _onRefresh() async {
    debugPrint('_onRefresh');
  }

  @override
  void initState() {
    super.initState();
    _investmentBloc.add(CdgProfitLogEvent(orderId: widget.orderId!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.scaffoldBg,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: BlocListener(
          bloc: _investmentBloc,
          listener: (context, InvestmentState state) {
            if (state.cdgProfitLogModel?.status == 0) {
              CustomToast.showError(
                  context, "Sorry!", state.cdgProfitLogModel!.message!);
            }
          },
          child: BlocBuilder(
              bloc: _investmentBloc,
              builder: (context, InvestmentState state) {
                return SafeArea(
                  child: ProgressHUD(
                    inAsyncCall: state.isloading,
                    child: RefreshIndicator(
                      onRefresh: _onRefresh,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                appBarSection(context, state),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: 68,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                              border: Border.all(
                                                  color: Colors.grey
                                                      .withValues(alpha: 0.2)),
                                              color: CustomColor
                                                  .dashboardProfileBorderColor,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Serial Number",
                                                      style: GoogleFonts.inter(
                                                          color:
                                                              CustomColor.black,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    SizedBox(
                                                      width: 80,
                                                      child: Text(
                                                        state
                                                                .cdgProfitLogModel!
                                                                .serialNumber!
                                                                .isNotEmpty
                                                            ? state
                                                                .cdgProfitLogModel!
                                                                .serialNumber!
                                                            : "Pending",
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style:
                                                            GoogleFonts.inter(
                                                                color:
                                                                    CustomColor
                                                                        .black,
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                if (state.cdgProfitLogModel!
                                                    .deviceStatus!.isNotEmpty)
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                    decoration: BoxDecoration(
                                                        color: Colors.indigo,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16),
                                                        border: Border.all(
                                                          color:
                                                              Color(0xff37E01A),
                                                        )),
                                                    child: Text(
                                                      state.cdgProfitLogModel!
                                                          .deviceStatus!,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: GoogleFonts.inter(
                                                        color: CustomColor
                                                            .whiteColor,
                                                        fontSize: 8,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  )
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Container(
                                            height: 68,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                              border: Border.all(
                                                  color: Colors.grey
                                                      .withValues(alpha: 0.2)),
                                              color: CustomColor
                                                  .dashboardProfileBorderColor,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Total Paid",
                                                  style: GoogleFonts.inter(
                                                      color: CustomColor.black,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                if (state
                                                    .cdgProfitLogModel!
                                                    .totalEnduserProfit!
                                                    .isNotEmpty)
                                                  Text(
                                                    state.cdgProfitLogModel!
                                                        .totalEnduserProfit!,
                                                    style: GoogleFonts.inter(
                                                        color:
                                                            CustomColor.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                color: CustomColor.currencyCustomSelectorColor,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          isDailyRewards = true;
                                        });
                                      },
                                      child: Container(
                                        height: 41,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(24),
                                          color: isDailyRewards
                                              ? Colors.indigo
                                              : CustomColor
                                                  .currencyCustomSelectorColor,
                                          boxShadow: isDailyRewards
                                              ? [
                                                  BoxShadow(
                                                    color: Color(0x0D000000),
                                                    // Shadow color
                                                    offset: Offset(0, 2),
                                                    // Offset of the shadow
                                                    blurRadius: 4,
                                                    // Blur radius
                                                    spreadRadius:
                                                        0, // Spread radius (0px)
                                                  ),
                                                ]
                                              : [],
                                        ),
                                        child: Text(
                                          'Daily Rewards',
                                          style: GoogleFonts.inter(
                                              color: isDailyRewards
                                                  ? CustomColor.whiteColor
                                                  : Colors.grey
                                                      .withOpacity(0.6),
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          isDailyRewards = false;
                                        });
                                      },
                                      child: Container(
                                        height: 41,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(24),
                                          color: isDailyRewards
                                              ? CustomColor
                                                  .currencyCustomSelectorColor
                                              : Colors.indigo,
                                          boxShadow: isDailyRewards
                                              ? []
                                              : [
                                                  BoxShadow(
                                                    color: Color(0x0D000000),
                                                    // Shadow color
                                                    offset: Offset(0, 2),
                                                    // Offset of the shadow
                                                    blurRadius: 4,
                                                    // Blur radius
                                                    spreadRadius:
                                                        0, // Spread radius (0px)
                                                  ),
                                                ],
                                        ),
                                        child: Text(
                                          'Online Hours',
                                          style: GoogleFonts.inter(
                                              color: isDailyRewards
                                                  ? Colors.grey
                                                  : CustomColor.whiteColor,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            if (isDailyRewards == false)
                              Container(
                                alignment: Alignment.center,
                                height: 60,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '• 0:00-24:00 (CET +0), 24 Hours',
                                      style: GoogleFonts.inter(
                                          color: Colors.grey,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ),
                            isDailyRewards
                                ? Expanded(
                                    child: ListView.builder(
                                      itemCount: state
                                          .cdgProfitLogModel!.rewards!.length,
                                      itemBuilder: (context, index) {
                                        String year =
                                            state.cdgProfitLogModel!.year!;

                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (index == 0)
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 0),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 0),
                                                child: Text(
                                                  year,
                                                  style: GoogleFonts.inter(
                                                    color: Colors.grey,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 16, vertical: 2),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 12, vertical: 5),
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(16),
                                                ),
                                                color: CustomColor.whiteColor,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            state
                                                                .cdgProfitLogModel!
                                                                .rewards![index]
                                                                .date!,
                                                            style: GoogleFonts
                                                                .inter(
                                                              color: CustomColor
                                                                  .black,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    state
                                                        .cdgProfitLogModel!
                                                        .rewards![index]
                                                        .profit!,
                                                    style: GoogleFonts.inter(
                                                      color: CustomColor.black,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        );
                                      },
                                    ),
                                  )
                                : Expanded(
                                    child: ListView.builder(
                                      itemCount: state.cdgProfitLogModel!
                                          .onlinehour!.length,
                                      itemBuilder: (context, index) {
                                        String year =
                                            state.cdgProfitLogModel!.year!;

                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (index == 0)
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 0),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 0),
                                                child: Text(
                                                  year,
                                                  style: GoogleFonts.inter(
                                                    color: Colors.grey,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 16, vertical: 2),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 12, vertical: 5),
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(16),
                                                ),
                                                color: CustomColor.whiteColor,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            state
                                                                .cdgProfitLogModel!
                                                                .onlinehour![
                                                                    index]
                                                                .date!,
                                                            style: GoogleFonts
                                                                .inter(
                                                              color: CustomColor
                                                                  .black,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    state
                                                        .cdgProfitLogModel!
                                                        .onlinehour![index]
                                                        .hours!,
                                                    style: GoogleFonts.inter(
                                                      color: CustomColor.black,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 30, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DefaultBackButtonWidget(onTap: () {
            Navigator.pop(context);
          }),
          Text(
            'Details',
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
    );
  }
}
