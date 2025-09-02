import 'dart:async';

import 'package:gptbanqbusiness/Screens/crypto_screen/bloc/crypto_bloc.dart';
import 'package:gptbanqbusiness/cutom_weidget/custom_navigationBar.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/assets.dart';
import '../../utils/input_fields/custom_color.dart';
import '../../widgets/buttons/default_back_button_widget.dart';
import '../../widgets/custom_image_widget.dart';

class ProfitLogScreen extends StatefulWidget {
  final String orderId;

  const ProfitLogScreen({super.key, required this.orderId});

  @override
  State<ProfitLogScreen> createState() => _ProfitLogScreenState();
}

class _ProfitLogScreenState extends State<ProfitLogScreen> {
  final CryptoBloc _cryptoBloc = CryptoBloc();

  Future<void> _onRefresh() async {
    debugPrint('_onRefresh');
    _cryptoBloc.add(StakeProfitLogEvent(orderId: widget.orderId));
  }



  @override
  void initState() {
    super.initState();

    _cryptoBloc.add(StakeProfitLogEvent(orderId: widget.orderId));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.scaffoldBg,
      body: BlocListener(
          bloc: _cryptoBloc,
          listener: (context, CryptoState state) async {},
          child: BlocBuilder(
              bloc: _cryptoBloc,
              builder: (context, CryptoState state) {
                return SafeArea(
                  child: ProgressHUD(
                    inAsyncCall: state.isloading,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: RefreshIndicator(
                        onRefresh: _onRefresh,
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
                                    Navigator.pop(context);
                                  }),
                                  Text(
                                    "Profit Logs",
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
                            Expanded(
                                child: state.stakeProfitLog!.logs!.isNotEmpty
                                    ? ListView.builder(
                                  itemCount:
                                  state.stakeProfitLog!.logs!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 6),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                          color: CustomColor
                                              .cryptoListContainerColor,
                                          borderRadius:
                                          BorderRadius.circular(12)),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                              child: Row(
                                                children: [
                                                  Container(
                                                      width: 50,
                                                      height: 50,
                                                      decoration:
                                                      BoxDecoration(
                                                        shape:
                                                        BoxShape.circle,
                                                        color: CustomColor
                                                            .notificationBellBgColor,
                                                      ),
                                                      alignment:
                                                      Alignment.center,
                                                      child: const Icon(
                                                        Icons
                                                            .arrow_downward_rounded,
                                                        color:
                                                        Color(0xff9F9DF3),
                                                      )),
                                                  const SizedBox(
                                                    width: 19,
                                                  ),
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
                                                          "Profit",
                                                          style: GoogleFonts.inter(
                                                              color: Color(
                                                                  0xff26273C),
                                                              fontSize: 16,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w500),
                                                        ),
                                                        Text(
                                                          "Period",
                                                          style: GoogleFonts.inter(
                                                              color: CustomColor
                                                                  .black
                                                                  .withOpacity(
                                                                  0.7),
                                                              fontSize: 12,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w500),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              )),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                "${state.stakeProfitLog!.logs![index].profit} ${state.stakeProfitLog!.logs![index].coin}"
                                                    .toUpperCase(),
                                                style: GoogleFonts.inter(
                                                    color:
                                                    Color(0xff26273C),
                                                    fontSize: 15,
                                                    fontWeight:
                                                    FontWeight.w500),
                                              ),
                                              Text(
                                                "${state.stakeProfitLog!.logs![index].period}",
                                                style: GoogleFonts.inter(
                                                    color: CustomColor
                                                        .black
                                                        .withOpacity(0.7),
                                                    fontSize: 11,
                                                    fontWeight:
                                                    FontWeight.w500),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                )
                                    : Container(
                                  alignment: Alignment.center,
                                  padding:
                                  EdgeInsets.symmetric(vertical: 20),
                                  child: Column(
                                    children: [
                                      CustomImageWidget(
                                        imagePath:
                                        StaticAssets.noTransaction,
                                        imageType: 'svg',
                                        height: 130,
                                      ),
                                      Text(
                                        "No Transactions",
                                        style: GoogleFonts.inter(
                                          color: CustomColor.black
                                              .withOpacity(0.6),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
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
