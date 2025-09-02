import 'package:gptbanqbusiness/Models/Crypto_coins_model.dart';
import 'package:gptbanqbusiness/Screens/crypto_screen/WithdrawEuro_screen.dart';
import 'package:gptbanqbusiness/Screens/crypto_screen/bloc/crypto_bloc.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:gptbanqbusiness/utils/input_fields/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import '../../constant_string/User.dart';
import '../../utils/assets.dart';
import '../../widgets/buttons/custom_floating_action_button.dart';
import '../../widgets/buttons/default_back_button_widget.dart';
import '../../widgets/custom_image_widget.dart';

// ignore: must_be_immutable
class EuroScreen extends StatefulWidget {
  String symbol;

  EuroScreen({super.key, required this.symbol});

  @override
  State<EuroScreen> createState() => _CoinDetailsState();
}

class _CoinDetailsState extends State<EuroScreen> {
  final CryptoBloc _cryptoBloc = CryptoBloc();

  List<Coin>? Eurocoin = [
    Coin(image: '', currencyName: '', currencySymbol: '', fiatBalance: '')
  ];

  Future<void> _onRefresh() async {
    print('_onRefresh');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    User.Screen = 'Euro coin';

    _cryptoBloc.add(GetcoinDetailsEvent(symbol: widget.symbol));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColor.scaffoldBg,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
                                      '',
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
                              Container(
                                margin: EdgeInsets.only(bottom: 10),
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: CustomColor.whiteColor,
                                  borderRadius: BorderRadius.circular(
                                      16.0), // Rounded corners (16.dp)
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0x14000000),
                                      offset: Offset(0, 1),
                                      blurRadius: 8,
                                      spreadRadius: -2,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        state.coindetailsModel!.coin!.image!
                                                .isEmpty
                                            ? Container()
                                            : Container(
                                                width: 48,
                                                height: 48,
                                                margin: const EdgeInsets.only(
                                                    right: 10),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                    image: NetworkImage(state
                                                        .coindetailsModel!
                                                        .coin!
                                                        .image!),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 5),
                                              child: Text(
                                                'My cash portfolio',
                                                style: GoogleFonts.inter(
                                                  color: CustomColor
                                                      .inputFieldTitleTextColor,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: state
                                                            .coindetailsModel!
                                                            .coin!
                                                            .currencyName ??
                                                        '',
                                                    style: GoogleFonts.inter(
                                                      color: CustomColor.black,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        '/${state.coindetailsModel!.coin!.currencySymbol!}',
                                                    style: GoogleFonts.inter(
                                                      color: CustomColor
                                                          .inputFieldTitleTextColor,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    Text(
                                      state.coindetailsModel!.coin!
                                              .cryptoBalance ??
                                          '',
                                      style: GoogleFonts.inter(
                                        color: CustomColor.black,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            type: PageTransitionType.scale,
                                            alignment: Alignment.center,
                                            isIos: true,
                                            duration: const Duration(
                                                microseconds: 500),
                                            child: WithdrawEuro(
                                                symbol: state.coindetailsModel!
                                                    .coin!.currencySymbol!,
                                                image: state.coindetailsModel!
                                                    .coin!.image!,
                                                isBuy: true),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        decoration: BoxDecoration(
                                            color:
                                                CustomColor.hubContainerBgColor,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 36,
                                              height: 36,
                                              margin: EdgeInsets.only(right: 8),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: CustomColor.whiteColor,
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: CustomImageWidget(
                                                  imagePath:
                                                      StaticAssets.deposit,
                                                  imageType: 'svg',
                                                  height: 18,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "Deposit",
                                              style: GoogleFonts.inter(
                                                  color:
                                                      CustomColor.primaryColor,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            type: PageTransitionType.scale,
                                            alignment: Alignment.center,
                                            isIos: true,
                                            duration: const Duration(
                                                microseconds: 500),
                                            child: WithdrawEuro(
                                                symbol: state.coindetailsModel!
                                                    .coin!.currencySymbol!,
                                                image: state.coindetailsModel!
                                                    .coin!.image!,
                                                isBuy: false),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        decoration: BoxDecoration(
                                            color:
                                                CustomColor.hubContainerBgColor,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 36,
                                              height: 36,
                                              margin: EdgeInsets.only(right: 8),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: CustomColor.whiteColor,
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: CustomImageWidget(
                                                  imagePath:
                                                      StaticAssets.withdraw,
                                                  imageType: 'svg',
                                                  height: 18,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "Withdraw",
                                              style: GoogleFonts.inter(
                                                  color:
                                                      CustomColor.primaryColor,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  'Transaction Logs',
                                  style: GoogleFonts.inter(
                                    color: CustomColor.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: state.coindetailsModel!.trx!.isNotEmpty
                                      ? ListView.builder(
                                          itemCount: state
                                              .coindetailsModel!.trx!.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return InkWell(
                                              onTap: () {
                                                showModalBottomSheet(
                                                    context: context,
                                                    isDismissible: true,
                                                    enableDrag: true,
                                                    isScrollControlled: true,
                                                    backgroundColor:
                                                        CustomColor.whiteColor,
                                                    barrierColor: Colors.black
                                                        .withOpacity(0.7),
                                                    useRootNavigator: true,
                                                    builder: (context) {
                                                      return Stack(
                                                        children: [
                                                          Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(24),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: CustomColor
                                                                    .whiteColor,
                                                                borderRadius: BorderRadius.only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            24),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            24)),
                                                              ),
                                                              child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    ListView(
                                                                      shrinkWrap:
                                                                          true,
                                                                      scrollDirection:
                                                                          Axis.vertical,
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(right: 8),
                                                                              child: CustomImageWidget(
                                                                                imagePath: StaticAssets.reviewTransaction,
                                                                                imageType: 'svg',
                                                                                height: 40,
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    "Review Transaction",
                                                                                    style: GoogleFonts.inter(color: CustomColor.black, fontSize: 16, fontWeight: FontWeight.w600),
                                                                                  ),
                                                                                  Text(
                                                                                    state.coindetailsModel!.trx![index].description!,
                                                                                    style: GoogleFonts.inter(color: CustomColor.primaryTextHintColor, fontSize: 14, fontWeight: FontWeight.w400),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .symmetric(
                                                                              vertical: 15),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    state.coindetailsModel!.trx![index].status!,
                                                                                    style: GoogleFonts.inter(color: CustomColor.primaryTextHintColor, fontSize: 13, fontWeight: FontWeight.w400),
                                                                                  ),
                                                                                  Text(
                                                                                    state.coindetailsModel!.trx![index].amount!,
                                                                                    style: GoogleFonts.inter(color: Color(0xff34C759), fontSize: 28, fontWeight: FontWeight.w500),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              Container(
                                                                                height: 44,
                                                                                width: 44,
                                                                                padding: EdgeInsets.all(8.0),
                                                                                decoration: BoxDecoration(
                                                                                  color: CustomColor.hubContainerBgColor,
                                                                                  borderRadius: BorderRadius.circular(12),
                                                                                ),
                                                                                child: CustomImageWidget(
                                                                                  imagePath: StaticAssets.wallet,
                                                                                  imageType: 'svg',
                                                                                  height: 21,
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          padding:
                                                                              EdgeInsets.all(16.0),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                CustomColor.hubContainerBgColor,
                                                                            borderRadius:
                                                                                BorderRadius.circular(12),
                                                                          ),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Text(
                                                                                    'Fees',
                                                                                    textAlign: TextAlign.center,
                                                                                    style: GoogleFonts.inter(
                                                                                      color: CustomColor.black,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      fontSize: 14,
                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    state.coindetailsModel!.trx![index].fees!,
                                                                                    textAlign: TextAlign.center,
                                                                                    style: GoogleFonts.inter(
                                                                                      color: CustomColor.black.withOpacity(0.6),
                                                                                      fontWeight: FontWeight.w400,
                                                                                      fontSize: 14,
                                                                                    ),                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              const SizedBox(height: 10),
                                                                              Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                   Text(
                                                                                    'Amount',
                                                                                    textAlign: TextAlign.center,
                                                                                    style: GoogleFonts.inter(
                                                                                      color: CustomColor.black,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      fontSize: 14,
                                                                                    ),                                                                                  ),
                                                                                  Text(
                                                                                    state.coindetailsModel!.trx![index].amount!,
                                                                                    textAlign: TextAlign.center,
                                                                                    style: GoogleFonts.inter(
                                                                                      color: CustomColor.black.withOpacity(0.6),
                                                                                      fontWeight: FontWeight.w400,
                                                                                      fontSize: 14,
                                                                                    ),                                                                                   ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ])),
                                                          Positioned(
                                                              top: 20,
                                                              right: 20,
                                                              child: InkWell(
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    CustomImageWidget(
                                                                  imagePath:
                                                                      StaticAssets
                                                                          .closeBlack,
                                                                  imageType:
                                                                      'svg',
                                                                  height: 20,
                                                                ),
                                                              ))
                                                        ],
                                                      );
                                                    });
                                              },
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 6),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 8),
                                                decoration: BoxDecoration(
                                                    color: CustomColor
                                                        .cryptoListContainerColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16)),
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
                                                          width: 48,
                                                          height: 48,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 8),
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: CustomColor
                                                                  .whiteColor),
                                                          alignment:
                                                              Alignment.center,
                                                          child: state
                                                                      .coindetailsModel!
                                                                      .trx![
                                                                          index]
                                                                      .sign ==
                                                                  'up'
                                                              ? const Icon(
                                                                  Icons
                                                                      .arrow_upward_rounded,
                                                                  color: Color(
                                                                      0xffFFB2B2),
                                                                )
                                                              : const Icon(
                                                                  Icons
                                                                      .arrow_downward_rounded,
                                                                  color: Color(
                                                                      0xffFFB2B2),
                                                                ),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                state
                                                                    .coindetailsModel!
                                                                    .trx![index]
                                                                    .type!,
                                                                style: GoogleFonts.inter(
                                                                    color: CustomColor
                                                                        .black,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                              Text(
                                                                state
                                                                    .coindetailsModel!
                                                                    .trx![index]
                                                                    .date!,
                                                                style: GoogleFonts.inter(
                                                                    color: CustomColor
                                                                        .primaryTextHintColor,
                                                                    fontSize:
                                                                        13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                              )
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
                                                        Text(
                                                          state
                                                              .coindetailsModel!
                                                              .trx![index]
                                                              .amount!,
                                                          style: GoogleFonts.inter(
                                                              color: CustomColor
                                                                  .black,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                        Text(
                                                          state
                                                              .coindetailsModel!
                                                              .trx![index]
                                                              .total!,
                                                          style: GoogleFonts.inter(
                                                              color: CustomColor
                                                                  .primaryTextHintColor,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
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
                                                imagePath:
                                                    StaticAssets.noTransaction,
                                                imageType: 'svg',
                                                height: 130,
                                              ),
                                              Text(
                                                "No Transaction",
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
        floatingActionButton: CustomFloatingActionButton());
  }
}
