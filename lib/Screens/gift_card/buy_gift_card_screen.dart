import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:gptbanqbusiness/Screens/Dashboard_screen/bloc/dashboard_bloc.dart';
import 'package:gptbanqbusiness/constant_string/User.dart';

import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/assets.dart';
import '../../utils/input_fields/custom_color.dart';
import '../../utils/user_data_manager.dart';
import '../../widgets/buttons/custom_floating_action_button.dart';
import '../../widgets/buttons/primary_button_widget.dart';
import '../../widgets/custom_image_widget.dart';
import '../../widgets/toast/toast_util.dart';

class BuyGiftCardScreen extends StatefulWidget {
  const BuyGiftCardScreen({super.key});

  @override
  State<BuyGiftCardScreen> createState() => _BuyGiftCardScreenState();
}

class _BuyGiftCardScreenState extends State<BuyGiftCardScreen> {
  bool active = false;

  bool shownotification = true;
  final DashboardBloc _giftCardListBloc = DashboardBloc();

  Future<void> _onRefresh() async {
    debugPrint('_onRefresh');

    _giftCardListBloc.add(GiftCardListEvent());
  }

  @override
  void initState() {
    super.initState();
    User.Screen = 'Buy Gift card';

    _giftCardListBloc.add(GiftCardListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColor.scaffoldBg,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: BlocListener(
            bloc: _giftCardListBloc,
            listener: (context, DashboardState state) {
              if (state.giftCardGetFeeTypeModel?.status == 1) {
                Navigator.pushNamed(context, 'buyGiftCardDetailsScreen');

              }

              if (state.statusModel?.status == 0) {
                CustomToast.showError(
                    context, "Sorry!", state.statusModel!.message!);
              }

              if (state.giftCardDetailsModel?.status == 1) {
                Navigator.pushNamedAndRemoveUntil(
                    context, 'userGiftCardDetailsScreen', (route) => false);
              }
            },
            child: BlocBuilder(
                bloc: _giftCardListBloc,
                builder: (context, DashboardState state) {
                  return SafeArea(
                    child: ProgressHUD(
                      inAsyncCall: state.isloading,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        child: RefreshIndicator(
                          onRefresh: _onRefresh,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.only(
                                      bottom: 30, top: 10),
                                  child: Text(
                                    'Gift Cards',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                        color: CustomColor.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  padding: EdgeInsets.only(
                                      left: 12, right: 12, top: 12),
                                  decoration: BoxDecoration(
                                    color: CustomColor.whiteColor,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0x14000000),
                                        // Hex color #00000014 (14 is the transparency in hexadecimal)
                                        offset: Offset(0, 1),
                                        // Horizontal and vertical offset
                                        blurRadius: 8,
                                        // Blur radius of the shadow
                                        spreadRadius: -2, // Spread radius
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(
                                        8), // Optional: add border radius
                                  ),
                                  child: Column(
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Row(
                                          children: [
                                            CustomImageWidget(
                                              imagePath:
                                                  StaticAssets.giftCardIcon,
                                              imageType: 'svg',
                                              height: 48,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Gift Card',
                                                    style: GoogleFonts.inter(
                                                        color:
                                                            CustomColor.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  Text(
                                                    'Buy gift cards for everyone on your list!\nFind the perfect gift for anyone.',
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.inter(
                                                        color: CustomColor.black
                                                            .withOpacity(0.7),
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      PrimaryButtonWidget(
                                        onPressed: () {
                                          _giftCardListBloc
                                              .add(GiftCardGetFeeTypeEvent());
                                        },
                                        buttonText: 'Buy Gift Card',
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    "Card List",
                                    style: GoogleFonts.inter(
                                      color: CustomColor.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                state.giftCardListModel!.cardList!.isNotEmpty
                                    ? Expanded(
                                        child: ListView.builder(
                                          itemCount: state.giftCardListModel!
                                              .cardList!.length,
                                          shrinkWrap: true,
                                          physics: const ScrollPhysics(),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return InkWell(
                                              onTap: () {
                                                var card = state
                                                    .giftCardListModel!
                                                    .cardList![index];
                                                UserDataManager()
                                                    .giftCardIbanSave(
                                                        card.cardId.toString());

                                                UserDataManager()
                                                    .giftCardDeleteCardIdSave(
                                                        card.cardId.toString());
                                                _giftCardListBloc.add(
                                                    GiftCardGetDetailsEvent());
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 12),
                                                // Spacing between each item
                                                padding:
                                                    const EdgeInsets.all(16),
                                                decoration: BoxDecoration(
                                                  color: CustomColor
                                                      .cryptoListContainerColor,
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                            height: 65,
                                                            width: 65,
                                                            alignment: Alignment
                                                                .center,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: CustomColor
                                                                  .whiteColor,
                                                            ),
                                                            child: state
                                                                        .giftCardListModel!
                                                                        .cardList![
                                                                            index]
                                                                        .image !=
                                                                    ""
                                                                ? Image.network(
                                                                    state
                                                                        .giftCardListModel!
                                                                        .cardList![
                                                                            index]
                                                                        .image
                                                                        .toString(),
                                                                    height: 45,
                                                                    width: 45,
                                                                    loadingBuilder: (BuildContext
                                                                            context,
                                                                        Widget
                                                                            child,
                                                                        ImageChunkEvent?
                                                                            loadingProgress) {
                                                                      if (loadingProgress ==
                                                                          null) {
                                                                        return child;
                                                                      } else {
                                                                        return const CircularProgressIndicator();
                                                                      }
                                                                    },
                                                                    errorBuilder: (BuildContext
                                                                            context,
                                                                        Object
                                                                            error,
                                                                        StackTrace?
                                                                            stackTrace) {
                                                                      // If network image fails to load, use local image instead
                                                                      return Image
                                                                          .asset(
                                                                        'images/master_card_logo.png',
                                                                        height:
                                                                            45,
                                                                        width:
                                                                            45,
                                                                      );
                                                                    },
                                                                  )
                                                                : Image.asset(
                                                                    'images/master_card_logo.png',
                                                                    height: 45,
                                                                    width: 45,
                                                                  ),
                                                          ),
                                                          const SizedBox(
                                                            width: 15,
                                                          ),
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  "${state.giftCardListModel!.cardList![index].cardNumber}",
                                                                  style: GoogleFonts.inter(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                                Text(
                                                                  "${state.giftCardListModel!.cardList![index].expiryDate}",
                                                                  style: GoogleFonts.inter(
                                                                      fontSize:
                                                                          11,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Color(
                                                                          0xffC4C4C4)),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Text(
                                                          "€${state.giftCardListModel!.cardList![index].loadedAmount}",
                                                          style: GoogleFonts.inter(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: CustomColor
                                                                  .green),
                                                        ),
                                                        Text(
                                                          "${state.giftCardListModel!.cardList![index].cardStatus}",
                                                          style: GoogleFonts.inter(
                                                              fontSize: 11,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: state
                                                                          .giftCardListModel!
                                                                          .cardList![
                                                                              index]
                                                                          .cardStatus ==
                                                                      "Active"
                                                                  ? CustomColor
                                                                      .green
                                                                  : CustomColor
                                                                      .errorColor),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    : Container(
                                        alignment: Alignment.center,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 20),
                                        child: Column(
                                          children: [
                                            CustomImageWidget(
                                              imagePath: StaticAssets.noCard,
                                              imageType: 'svg',
                                              height: 130,
                                            ),
                                            Text(
                                              "Card not purchased yet",
                                              style: GoogleFonts.inter(
                                                color: CustomColor.black
                                                    .withOpacity(0.6),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                              ]),
                        ),
                      ),
                    ),
                  );
                })),
        floatingActionButton: CustomFloatingActionButton());
  }
}
