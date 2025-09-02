
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Models/card/card_details_model.dart';
import '../../Models/card/card_iban_get_custom_account_model.dart';
import '../../constant_string/User.dart';
import '../../cutom_weidget/cutom_progress_bar.dart';
import '../../cutom_weidget/input_textform.dart';
import '../../utils/assets.dart';
import '../../utils/custom_style.dart';
import '../../utils/input_fields/custom_color.dart';
import '../../utils/user_data_manager.dart';
import '../../utils/webview_screen.dart';
import '../../widgets/buttons/default_back_button_widget.dart';
import '../../widgets/buttons/primary_button_widget.dart';
import '../../widgets/custom_image_widget.dart';
import '../../widgets/main/card_transaction_details_widget.dart';
import '../../widgets/main/default_dropdown_field_with_title_widget.dart';
import '../../widgets/main_logo_widget.dart';
import '../../widgets/toast/toast_util.dart';
import '../Dashboard_screen/bloc/dashboard_bloc.dart';

class DebitCardScreen extends StatefulWidget {
  const DebitCardScreen({super.key});

  @override
  State<DebitCardScreen> createState() => _DebitCardScreenState();
}

class _DebitCardScreenState extends State<DebitCardScreen> {
  bool active = false;
  bool isInstant = false;

  bool isInstantPhysical = false;
  bool isInstantVirtual = false;
  int? cardActive;
  String? isPrepaidCard;
  String? isVirtualCard;
  String? isPrepaidDebit;
  String? showNumber;
  String? textStatus;
  String? cardDetailsShowStatus;
  int iframe = 0;
  String iframeUrl = "";

  final TextEditingController _searchController = TextEditingController();
  List<CardTrx> _filteredTransactions = [];

  List empList = [];
  List filteredList = [];

  bool showNotification = true;
  final DashboardBloc _cardDetailsBloc = DashboardBloc();

  Future<void> _onRefresh() async {
    debugPrint('_onRefresh');

    _cardDetailsBloc.add(DashboarddataEvent());
    _cardDetailsBloc.add(CardDetailsEvent());
  }

  @override
  void initState() {
    super.initState();
    User.Screen = 'card Details screen';

    _cardDetailsBloc.add(DashboarddataEvent());
    _cardDetailsBloc.add(CardDetailsEvent());
    numberShow();
    // GetIPAddress().getIps();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  numberShow() async {
    showNumber = await UserDataManager().getCardNumberShow();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.scaffoldBg,
      body: BlocListener(
          bloc: _cardDetailsBloc,
          listener: (context, DashboardState state) {
            if (state.statusModel?.status == 0) {
              CustomToast.showError(
                  context, "Sorry!", state.statusModel!.message!);
            }

            if (state.userCardDetailsModel?.status == 1) {
              cardActive =
                  state.userCardDetailsModel!.userCardDetails!.isActive;
              _filteredTransactions =
                  state.userCardDetailsModel!.userCardDetails!.cardTrx!;
              print(_filteredTransactions.toString());

              // "cardType":"Prepaid Card"
              isPrepaidCard = state
                  .userCardDetailsModel!.userCardDetails!.cardType
                  .toString();
              isVirtualCard = state
                  .userCardDetailsModel!.userCardDetails!.cardMaterial
                  .toString();
              isPrepaidDebit = state
                  .userCardDetailsModel!.userCardDetails!.isPrepaidDebit
                  .toString();
              textStatus = state
                  .userCardDetailsModel!.userCardDetails!.textStatus
                  .toString();
              cardDetailsShowStatus = state
                  .userCardDetailsModel!.userCardDetails!.status
                  .toString();
              print("cardDetailsShowStatus$cardDetailsShowStatus");

              UserDataManager().cardToCardTransferSenderIdSave(
                  state.userCardDetailsModel!.userCardDetails!.cid.toString());

              // _filteredTransactions = _transactions;
            }

            if (state.cardActiveModel?.status == 1) {
              Navigator.pushNamedAndRemoveUntil(
                  context, 'debitCardScreen', (route) => false);
            }

            if (state.cardBlockUnblockModel?.status == 1) {
              Navigator.pushNamedAndRemoveUntil(
                  context, 'debitCardScreen', (route) => false);
            }
          },
          child: BlocBuilder(
              bloc: _cardDetailsBloc,
              builder: (context, DashboardState state) {
                return SafeArea(
                  child: ProgressHUD(
                    inAsyncCall: state.isloading,
                    child: RefreshIndicator(
                      onRefresh: _onRefresh,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              appBarSection(context, state),
                              cardSection(context, state),
                              if (cardActive == 2)
                                cardTemporarilyBlockedSection(context),
                              if (cardActive == 0 && isVirtualCard != "virtual")
                                cardActiveSection(context),
                              const SizedBox(height: 10),
                              if (textStatus != "Requested")
                                topUpWidget(context, state),
                              // if (textStatus != "Requested")
                              //   cardToCardTransferWidget(context, state),
                              // if (cardDetailsShowStatus != "0")
                              //   virtualCardDetailsSection(context, state),

                              state.userCardDetailsModel!.userCardDetails!
                                      .cardTrx!.isEmpty
                                  ? Container(
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
                                    )
                                  : transaction(context, state),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              })),
    );
  }

  appBarSection(BuildContext context, DashboardState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DefaultBackButtonWidget(onTap: () {
            Navigator.pushNamedAndRemoveUntil(
                context, 'cardScreen', (route) => false);
          }),
          Padding(
            padding: EdgeInsets.only(left: 40),
            child: Text(
              'Card',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  color: CustomColor.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Row(
            children: [
              if (cardDetailsShowStatus != "0")
                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.pushNamedAndRemoveUntil(
                        context, 'cardVerifyGetPinScreen', (route) => true);
                    iframe =
                        state.userCardDetailsModel!.userCardDetails!.isiframe!;
                    iframeUrl =
                        state.userCardDetailsModel!.userCardDetails!.iframeurl!;

                    if (result == true) {
                      if (iframe == 0) {
                        showModalBottomSheet(
                          context: context,
                          elevation: 5,
                          isScrollControlled: true,
                          builder: (context) {
                            return Material(
                              color: CustomColor.scaffoldBg,
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(20)),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 20),
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: ListView(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            alignment: Alignment.topLeft,
                                            child: GestureDetector(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: CustomImageWidget(
                                                  imagePath:
                                                      StaticAssets.xClose,
                                                  imageType: 'svg',
                                                  height: 24,
                                                )),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                "Card Details",
                                                style: GoogleFonts.inter(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                    color: CustomColor.black),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 24,
                                          ),
                                        ],
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 0, vertical: 10),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0, vertical: 8),
                                        child: Column(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Card Number',
                                                    textAlign: TextAlign.left,
                                                    style: GoogleFonts.inter(
                                                      color: CustomColor.black
                                                          .withOpacity(0.7),
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      height: 1,
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        state
                                                            .userCardDetailsModel!
                                                            .userCardDetails!
                                                            .fullcardnumber
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.right,
                                                        style:
                                                            GoogleFonts.inter(
                                                          color:
                                                              CustomColor.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          height: 1,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 3),
                                                        child: InkWell(
                                                          child: const Icon(
                                                              Icons.copy,
                                                              size: 16),
                                                          onTap: () {
                                                            Clipboard.setData(
                                                                ClipboardData(
                                                              text: state
                                                                  .userCardDetailsModel!
                                                                  .userCardDetails!
                                                                  .fullcardnumber
                                                                  .toString(),
                                                            ));
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              const SnackBar(
                                                                  content: Text(
                                                                      'Card number copied')),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Expiry',
                                                    textAlign: TextAlign.left,
                                                    style: GoogleFonts.inter(
                                                      color: CustomColor.black
                                                          .withOpacity(0.7),
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      height: 1,
                                                    ),
                                                  ),
                                                  Text(
                                                    state.userCardDetailsModel!
                                                        .userCardDetails!.expiry
                                                        .toString(),
                                                    style: GoogleFonts.inter(
                                                      color: CustomColor.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      height: 1,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'CVV',
                                                    textAlign: TextAlign.left,
                                                    style: GoogleFonts.inter(
                                                      color: CustomColor.black
                                                          .withOpacity(0.7),
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      height: 1,
                                                    ),
                                                  ),
                                                  Text(
                                                    state.userCardDetailsModel!
                                                        .userCardDetails!.cvv
                                                        .toString(),
                                                    style: GoogleFonts.inter(
                                                      color: CustomColor.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      height: 1,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                      /*  Container(
                                              alignment: Alignment.centerLeft,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    state.userCardDetailsModel!
                                                        .userCardDetails!.cvv
                                                        .toString(),
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(Icons.copy,
                                                        color: Colors.white),
                                                    onPressed: () {
                                                      Clipboard.setData(
                                                          ClipboardData(
                                                        text: state
                                                            .userCardDetailsModel!
                                                            .userCardDetails!
                                                            .cvv
                                                            .toString(),
                                                      ));
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                            content: Text(
                                                                'Copied to clipboard')),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 8),*/
                                      /*   Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  state
                                                      .userCardDetailsModel!
                                                      .userCardDetails!
                                                      .fullcardnumber
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.copy,
                                                      color: Colors.white),
                                                  onPressed: () {
                                                    Clipboard.setData(
                                                        ClipboardData(
                                                      text: state
                                                          .userCardDetailsModel!
                                                          .userCardDetails!
                                                          .fullcardnumber
                                                          .toString(),
                                                    ));
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                          content: Text(
                                                              'Copied to clipboard')),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),*/
                                      /*  Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  state.userCardDetailsModel!
                                                      .userCardDetails!.expiry
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.copy,
                                                      color: Colors.white),
                                                  onPressed: () {
                                                    Clipboard.setData(
                                                        ClipboardData(
                                                      text: state
                                                          .userCardDetailsModel!
                                                          .userCardDetails!
                                                          .expiry
                                                          .toString(),
                                                    ));
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                          content: Text(
                                                              'Copied to clipboard')),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                state
                                                            .userCardDetailsModel!
                                                            .userCardDetails!
                                                            .cardHolderName
                                                            .toString() ==
                                                        "null"
                                                    ? ""
                                                    : state
                                                        .userCardDetailsModel!
                                                        .userCardDetails!
                                                        .cardHolderName
                                                        .toString(),
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),*/
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else if (iframe == 1) {
                        print(iframeUrl);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WebViewScreen(url: iframeUrl),
                          ),
                        );
                      }
                    }
                  },
                  child: Icon(
                    Icons.remove_red_eye,
                    color: CustomColor.black,
                    size: 30,
                  ),
                ),
              if (cardDetailsShowStatus != "0")
                SizedBox(
                  width: 10,
                ),
              textStatus == "Requested"
                  ? GestureDetector(
                      onTap: () {},
                      child: CustomImageWidget(
                        imagePath: StaticAssets.setting,
                        imageType: 'svg',
                        height: 24,
                      ))
                  : GestureDetector(
                      onTap: () {
                        UserDataManager().cardNumberShowSave("false");
                        Navigator.pushNamedAndRemoveUntil(
                            context, 'cardSettingsScreen', (route) => true);
                      },
                      child: CustomImageWidget(
                        imagePath: StaticAssets.setting,
                        imageType: 'svg',
                        height: 24,
                      )),
            ],
          )
        ],
      ),
    );
  }

  cardSection(BuildContext context, DashboardState state) {
    return Center(
      child: Image.network(
        state.userCardDetailsModel!.userCardDetails!.cardImage.toString(),
        // width: MediaQuery.of(context).size.width * 0.65,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            return child;
          } else {
            return const Center(child: MainLogoWidget());
          }
        },
        errorBuilder:
            (BuildContext context, Object error, StackTrace? stackTrace) {
          print('Error loading image: $error');
          return const Center(child: MainLogoWidget());
        },
      ),
    );
  }

  cardTemporarilyBlockedSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: CustomColor.warning,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Card Blocked',
              textAlign: TextAlign.start,
              style: GoogleFonts.inter(
                color: CustomColor.whiteColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'You’ve blocked your card, so it can’t be used by anyone for payments or withdrawal',
              textAlign: TextAlign.start,
              style: GoogleFonts.inter(
                color: CustomColor.whiteColor,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              UserDataManager().cardBlockUnblockStatusSave("unblock");
              _cardDetailsBloc.add(CardBlockUnblockEvent());
            },
            child: Container(
              height: 40,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1000),
                color: CustomColor.whiteColor,
              ),
              child: Text(
                'Reactivated Card',
                style: TextStyle(
                    color: CustomColor.warning,
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    height: 1),
              ),
            ),
          )
        ],
      ),
    );
  }

  cardActiveSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF2B65E0), // #2B65E0 color at 0%
            Color(0xFF4B81E6), // #4B81E6 color at 100%
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            // padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Have you received your card?',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: CustomColor.whiteColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            'Your card has been assigned and shipped, if you have received the card, activate withdrawals and payments',
            textAlign: TextAlign.start,
            style: GoogleFonts.inter(
              color: CustomColor.whiteColor,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),

          SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                elevation: 5,
                isScrollControlled: true,
                builder: (context) {
                  return const ActiveCardScreen();
                },
              );
            },
            child: Container(
              // width: 263,
              height: 40,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1000),
                color: CustomColor.whiteColor,
              ),
              child: Text(
                'Activate Card',
                style: GoogleFonts.inter(
                  color: CustomColor.primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          // Container(
          //   margin: const EdgeInsets.only(bottom: 10),
          //   // padding: const EdgeInsets.symmetric(horizontal: 20),
          //   child: const Text(
          //     'I didn\'t receive the card after 2 week',
          //     textAlign: TextAlign.center,
          //     style: TextStyle(
          //       color: Color(0xFF0A7BCD),
          //       fontFamily: 'Poppins',
          //       fontSize: 16,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  virtualCardStatusSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF2B65E0), // #2B65E0 color at 0%
            Color(0xFF4B81E6), // #4B81E6 color at 100%
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            // padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Have you received your card?',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: CustomColor.whiteColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            'Your card has been assigned and shipped, if you have received the card, activate withdrawals and payments',
            textAlign: TextAlign.start,
            style: GoogleFonts.inter(
              color: CustomColor.whiteColor,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),

          SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                elevation: 5,
                isScrollControlled: true,
                builder: (context) {
                  return const ActiveCardScreen();
                },
              );
            },
            child: Container(
              // width: 263,
              height: 40,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1000),
                color: CustomColor.whiteColor,
              ),
              child: Text(
                'Activate Card',
                style: GoogleFonts.inter(
                  color: CustomColor.primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          // Container(
          //   margin: const EdgeInsets.only(bottom: 10),
          //   // padding: const EdgeInsets.symmetric(horizontal: 20),
          //   child: const Text(
          //     'I didn\'t receive the card after 2 week',
          //     textAlign: TextAlign.center,
          //     style: TextStyle(
          //       color: Color(0xFF0A7BCD),
          //       fontFamily: 'Poppins',
          //       fontSize: 16,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  payFrom(BuildContext context) {
    return Container(
      height: 55,
      // margin: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: const Color(0xffEDEBEB),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("images/card/card_demo.png"),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 2.0, bottom: 7, right: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pay from',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  width: 200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Label (MAIN)',
                        // textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins',
                          fontSize: 9,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        'BE123456789012345',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins',
                          fontSize: 9,
                          fontWeight: FontWeight.normal,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  topUpWidget(BuildContext context, DashboardState state) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: CustomColor.kycContainerBgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                  state.userCardDetailsModel!.userCardDetails!.cardImage
                      .toString(),
                  height: 50,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return const Center(
                          child: MainLogoWidget(
                        width: 30,
                        height: 30,
                      ));
                    }
                  },
                  errorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) {
                    print('Error loading image: $error');
                    return const Center(
                        child: MainLogoWidget(
                      width: 30,
                      height: 30,
                    ) // Show a loading indicator in case of an error
                        );
                  },
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Balance',
                    textAlign: TextAlign.right,
                    style: GoogleFonts.inter(
                        color: CustomColor.black.withOpacity(0.7),
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.userCardDetailsModel!.userCardDetails!.symbol
                            .toString(),
                        style: GoogleFonts.inter(
                            color: CustomColor.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        width: 100,
                        child: Text(
                          state.userCardDetailsModel!.userCardDetails!.balance
                              .toString(),
                          style: GoogleFonts.inter(
                              color: CustomColor.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
          cardActive == 2
              ? Container()
              : Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1000),
                    color: CustomColor.primaryColor,
                  ),
                  child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          elevation: 5,
                          isScrollControlled: true,
                          builder: (context) {
                            return const PrepaidCardTopUpScreen();
                          },
                        );
                      },
                      child: Row(
                        children: [
                          CustomImageWidget(
                            imagePath: StaticAssets.addCircle,
                            imageType: 'svg',
                            height: 20,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Topup',
                            textAlign: TextAlign.left,
                            style: GoogleFonts.inter(
                              color: CustomColor.whiteColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      )),
                ),
        ],
      ),
    );
  }

  cardToCardTransferWidget(BuildContext context, DashboardState state) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamedAndRemoveUntil(
            context, 'prepaidCardBeneficiaryScreen', (route) => true);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: CustomColor.kycContainerBgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: CustomImageWidget(
                      imagePath: StaticAssets.cardToCard,
                      imageType: 'svg',
                      height: 40,
                    )),
                Text(
                  'Card To Card Transfer',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.inter(
                    color: CustomColor.primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Container(
                height: 40,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: CustomColor.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 10,
                  color: CustomColor.whiteColor,
                )),
          ],
        ),
      ),
    );
  }

  // cardDetailsSection(BuildContext context, DashboardState state) {
  //   return Center(
  //     child: Container(
  //       margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
  //       padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(10),
  //         color: const Color(0xffEDEBEB),
  //       ),
  //       child: Column(
  //         children: [
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               const Text(
  //                 'Card Number',
  //                 textAlign: TextAlign.left,
  //                 style: TextStyle(
  //                     color: Colors.black,
  //                     fontFamily: 'Poppins',
  //                     fontSize: 12,
  //                     fontWeight: FontWeight.normal,
  //                     height: 1),
  //               ),
  //               Row(
  //                 children: [
  //                   Padding(
  //                     padding: const EdgeInsets.only(right: 5),
  //                     child: showNumber == "true"
  //                         ? Text(
  //                             state.userCardDetailsModel!.userCardDetails!
  //                                 .fullcardnumber
  //                                 .toString(),
  //                             style: const TextStyle(
  //                               color: Colors.black,
  //                               fontFamily: 'Poppins',
  //                               fontSize: 10,
  //                               fontWeight: FontWeight.normal,
  //                               height: 1,
  //                             ),
  //                           )
  //                         : Text(
  //                             state.userCardDetailsModel!.userCardDetails!
  //                                 .cardnumber
  //                                 .toString(), // Masked number
  //                             style: const TextStyle(
  //                               color: Colors.black,
  //                               fontFamily: 'Poppins',
  //                               fontSize: 10,
  //                               fontWeight: FontWeight.normal,
  //                               height: 1,
  //                             ),
  //                           ),
  //                   ),
  //                   GestureDetector(
  //                     onTap: () async {
  //                       final result = await Navigator.pushNamedAndRemoveUntil(
  //                           context, 'cardVerifyGetPinScreen', (route) => true);
  //
  //                       if (result == true) {
  //                         Navigator.pushNamedAndRemoveUntil(
  //                             context, 'debitCardScreen', (route) => false);
  //                       }
  //                     },
  //                     child: Container(
  //                       alignment: Alignment.center,
  //                       width: 57,
  //                       height: 28,
  //                       decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(11),
  //                         color: const Color(0xff1C3C79),
  //                         border: Border.all(
  //                           color: const Color(0xffC4C4C4),
  //                           width: 1,
  //                         ),
  //                       ),
  //                       child: const Text(
  //                         'Show',
  //                         textAlign: TextAlign.center,
  //                         style: TextStyle(
  //                             color: Colors.white,
  //                             fontFamily: 'Poppins',
  //                             fontSize: 12,
  //                             fontWeight: FontWeight.normal,
  //                             height: 1),
  //                       ),
  //                     ),
  //                   )
  //                 ],
  //               )
  //             ],
  //           ),
  //           Container(
  //             margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 10),
  //             child: const Divider(
  //               color: Color(0xffB6B6B6),
  //               height: 1,
  //             ),
  //           ),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               const Text(
  //                 'Expiry',
  //                 textAlign: TextAlign.left,
  //                 style: TextStyle(
  //                     color: Colors.black,
  //                     fontFamily: 'Poppins',
  //                     fontSize: 12,
  //                     fontWeight: FontWeight.normal,
  //                     height: 1),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.only(right: 10),
  //                 child: Text(
  //                   state.userCardDetailsModel!.userCardDetails!.expiry
  //                       .toString(), //
  //                   style: const TextStyle(
  //                       color: Colors.black,
  //                       fontFamily: 'Poppins',
  //                       fontSize: 10,
  //                       fontWeight: FontWeight.normal,
  //                       height: 1),
  //                 ),
  //               ),
  //             ],
  //           ),
  //           Container(
  //             margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 10),
  //             child: const Divider(
  //               color: Color(0xffB6B6B6),
  //               height: 1,
  //             ),
  //           ),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               const Text(
  //                 'CVV',
  //                 textAlign: TextAlign.left,
  //                 style: TextStyle(
  //                     color: Colors.black,
  //                     fontFamily: 'Poppins',
  //                     fontSize: 12,
  //                     fontWeight: FontWeight.normal,
  //                     height: 1),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.only(right: 10),
  //                 child: Text(
  //                   state.userCardDetailsModel!.userCardDetails!.cvv.toString(),
  //                   style: const TextStyle(
  //                       color: Colors.black,
  //                       fontFamily: 'Poppins',
  //                       fontSize: 10,
  //                       fontWeight: FontWeight.normal,
  //                       height: 1),
  //                 ),
  //               ),
  //             ],
  //           ),
  //           Container(
  //             margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 10),
  //             child: const Divider(
  //               color: Color(0xffB6B6B6),
  //               height: 1,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  virtualCardDetailsSection(BuildContext context, DashboardState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              "Card Details",
              style: GoogleFonts.inter(
                  color: CustomColor.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            )),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0x0D000000),
                offset: Offset(0, 2),
                blurRadius: 12,
                spreadRadius: -2,
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Card Number',
                    textAlign: TextAlign.left,
                    style: GoogleFonts.inter(
                      color: CustomColor.black.withOpacity(0.7),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1,
                    ),
                  ),
                  Row(
                    children: [
                      // Text(
                      //   state.userCardDetailsModel!.userCardDetails!
                      //       .cardnumber
                      //       .toString(),
                      //   textAlign: TextAlign.right,
                      //   style: GoogleFonts.inter(
                      //     color: CustomColor.black,
                      //     fontSize: 9,
                      //     fontWeight: FontWeight.w500,
                      //     height: 1,
                      //   ),
                      // ),
                      GestureDetector(
                        onTap: () async {
                          final result =
                              await Navigator.pushNamedAndRemoveUntil(context,
                                  'cardVerifyGetPinScreen', (route) => true);
                          iframe = state
                              .userCardDetailsModel!.userCardDetails!.isiframe!;
                          iframeUrl = state.userCardDetailsModel!
                              .userCardDetails!.iframeurl!;

                          if (result == true) {
                            if (iframe == 0) {
                              showModalBottomSheet(
                                context: context,
                                elevation: 5,
                                isScrollControlled: true,
                                builder: (context) {
                                  return Material(
                                    color: CustomColor.scaffoldBg,
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(20)),
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.4,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 20),
                                      width: MediaQuery.of(context).size.width,
                                      child: Padding(
                                        padding: const EdgeInsets.all(14),
                                        child: ListView(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  alignment: Alignment.topLeft,
                                                  child: GestureDetector(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: CustomImageWidget(
                                                        imagePath:
                                                            StaticAssets.xClose,
                                                        imageType: 'svg',
                                                        height: 24,
                                                      )),
                                                ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                      "Card Details",
                                                      style: GoogleFonts.inter(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: CustomColor
                                                              .black),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: 24,
                                                ),
                                              ],
                                            ),
                                            Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 0,
                                                      vertical: 10),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 0,
                                                      vertical: 8),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 10.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Card Number',
                                                          textAlign:
                                                              TextAlign.left,
                                                          style:
                                                              GoogleFonts.inter(
                                                            color: CustomColor
                                                                .black
                                                                .withOpacity(
                                                                    0.7),
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            height: 1,
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(
                                                              state
                                                                  .userCardDetailsModel!
                                                                  .userCardDetails!
                                                                  .fullcardnumber
                                                                  .toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              style: GoogleFonts
                                                                  .inter(
                                                                color:
                                                                    CustomColor
                                                                        .black,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                height: 1,
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 3),
                                                              child: InkWell(
                                                                child: const Icon(
                                                                    Icons.copy,
                                                                    size: 16),
                                                                onTap: () {
                                                                  Clipboard.setData(
                                                                      ClipboardData(
                                                                    text: state
                                                                        .userCardDetailsModel!
                                                                        .userCardDetails!
                                                                        .fullcardnumber
                                                                        .toString(),
                                                                  ));
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                    const SnackBar(
                                                                        content:
                                                                            Text('Card number copied')),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 10.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Expiry',
                                                          textAlign:
                                                              TextAlign.left,
                                                          style:
                                                              GoogleFonts.inter(
                                                            color: CustomColor
                                                                .black
                                                                .withOpacity(
                                                                    0.7),
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            height: 1,
                                                          ),
                                                        ),
                                                        Text(
                                                          state
                                                              .userCardDetailsModel!
                                                              .userCardDetails!
                                                              .expiry
                                                              .toString(),
                                                          style:
                                                              GoogleFonts.inter(
                                                            color: CustomColor
                                                                .black,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            height: 1,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 10.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'CVV',
                                                          textAlign:
                                                              TextAlign.left,
                                                          style:
                                                              GoogleFonts.inter(
                                                            color: CustomColor
                                                                .black
                                                                .withOpacity(
                                                                    0.7),
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            height: 1,
                                                          ),
                                                        ),
                                                        Text(
                                                          state
                                                              .userCardDetailsModel!
                                                              .userCardDetails!
                                                              .cvv
                                                              .toString(),
                                                          style:
                                                              GoogleFonts.inter(
                                                            color: CustomColor
                                                                .black,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            height: 1,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                            /*  Container(
                                              alignment: Alignment.centerLeft,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    state.userCardDetailsModel!
                                                        .userCardDetails!.cvv
                                                        .toString(),
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(Icons.copy,
                                                        color: Colors.white),
                                                    onPressed: () {
                                                      Clipboard.setData(
                                                          ClipboardData(
                                                        text: state
                                                            .userCardDetailsModel!
                                                            .userCardDetails!
                                                            .cvv
                                                            .toString(),
                                                      ));
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                            content: Text(
                                                                'Copied to clipboard')),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 8),*/
                                            /*   Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  state
                                                      .userCardDetailsModel!
                                                      .userCardDetails!
                                                      .fullcardnumber
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.copy,
                                                      color: Colors.white),
                                                  onPressed: () {
                                                    Clipboard.setData(
                                                        ClipboardData(
                                                      text: state
                                                          .userCardDetailsModel!
                                                          .userCardDetails!
                                                          .fullcardnumber
                                                          .toString(),
                                                    ));
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                          content: Text(
                                                              'Copied to clipboard')),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),*/
                                            /*  Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  state.userCardDetailsModel!
                                                      .userCardDetails!.expiry
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.copy,
                                                      color: Colors.white),
                                                  onPressed: () {
                                                    Clipboard.setData(
                                                        ClipboardData(
                                                      text: state
                                                          .userCardDetailsModel!
                                                          .userCardDetails!
                                                          .expiry
                                                          .toString(),
                                                    ));
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                          content: Text(
                                                              'Copied to clipboard')),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                state
                                                            .userCardDetailsModel!
                                                            .userCardDetails!
                                                            .cardHolderName
                                                            .toString() ==
                                                        "null"
                                                    ? ""
                                                    : state
                                                        .userCardDetailsModel!
                                                        .userCardDetails!
                                                        .cardHolderName
                                                        .toString(),
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),*/
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else if (iframe == 1) {
                              print(iframeUrl);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      WebViewScreen(url: iframeUrl),
                                ),
                              );
                            }
                          }
                        },
                        child: Icon(
                          Icons.remove_red_eye,
                          color: CustomColor.black,
                        ),
                      )
                    ],
                  )
                ],
              ),
              /*  Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Expiry',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.inter(
                        color: CustomColor.black.withOpacity(0.7),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Text(
                        state.userCardDetailsModel!.userCardDetails!.expiry
                            .toString(),
                        style: GoogleFonts.inter(
                          color: CustomColor.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'CVV',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.inter(
                        color: CustomColor.black.withOpacity(0.7),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Text(
                        "***",
                        style: GoogleFonts.inter(
                          color: CustomColor.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),*/
            ],
          ),
        ),
      ],
    );
  }

  transaction(BuildContext context, DashboardState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 5,
        ),
        Text(
          'Transactions',
          textAlign: TextAlign.left,
          style: GoogleFonts.inter(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (_filteredTransactions.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                value = value.toLowerCase();
                setState(() {
                  _filteredTransactions = state
                      .userCardDetailsModel!.userCardDetails!.cardTrx!
                      .where((element) {
                    var name = element.merchNameDe43!.toLowerCase();
                    return name.contains(value);
                  }).toList();
                });
              },
              decoration: InputDecoration(
                errorStyle: TextStyle(color: CustomColor.errorColor),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                hintText: "Search",
                hintStyle: CustomStyle.loginInputTextHintStyle,
                filled: true,
                fillColor: CustomColor.primaryInputHintColor,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: CustomColor.primaryInputHintBorderColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12)),
                errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: CustomColor.errorColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12)),
                focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: CustomColor.errorColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: CustomColor.primaryColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12)),
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: CustomColor.primaryColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12)),
                disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: CustomColor.primaryColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12)),
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: CustomImageWidget(
                    imagePath: StaticAssets.searchMd,
                    imageType: 'svg',
                    height: 18,
                  ),
                ),
              ),
            ),
          ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
          child: Text(
            'Today',
            textAlign: TextAlign.left,
            style: GoogleFonts.inter(
              color: CustomColor.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(
          height: 300,
          child: ListView.builder(
            itemCount: _filteredTransactions.length,
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        isDismissible: true,
                        enableDrag: true,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        barrierColor: Colors.black.withOpacity(0.7),
                        useRootNavigator: true,
                        builder: (context) {
                          var data = _filteredTransactions;
                          return CardTransactionDetailsWidget(
                            Merch_Name_DE43: data[index].merchNameDe43!,
                            merchantName: data[index].merchantName!,
                            transactionId: data[index].transactionId!,
                            billingAmount: data[index].billingamount!,
                            billingCurrency: data[index].billingCurrency!,
                            txnDesc: data[index].txnDesc!,
                            totalPay: data[index].totalPay!,
                            status: data[index].status!,
                            type: data[index].type!,
                            currency: data[index].currency!,
                            symbol: data[index].symbol!,
                            created: data[index].created!,
                            image: data[index].image!,
                            isShowMerchant: data[index].isShowMerchant!,
                            onTap: () {},
                          );
                        });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: CustomColor.cryptoListContainerColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 65,
                                width: 65,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: CustomColor.whiteColor,
                                ),
                                child: _filteredTransactions[index]
                                            .image
                                            .toString() !=
                                        ""
                                    ? Image.network(
                                        _filteredTransactions[index]
                                            .image
                                            .toString(),
                                        height: 45,
                                        width: 45,
                                        loadingBuilder: (BuildContext context,
                                            Widget child,
                                            ImageChunkEvent? loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          } else {
                                            return const CircularProgressIndicator();
                                          }
                                        },
                                        errorBuilder: (BuildContext context,
                                            Object error,
                                            StackTrace? stackTrace) {
                                          // If network image fails to load, use local image instead
                                          return Image.asset(
                                            'images/master_card_logo.png',
                                            height: 45,
                                            width: 45,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (_filteredTransactions[index]
                                        .merchNameDe43!
                                        .isNotEmpty)
                                      Text(
                                        _filteredTransactions[index]
                                            .merchNameDe43!
                                            .toString(),
                                        style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: CustomColor.black),
                                      ),
                                    if (_filteredTransactions[index]
                                        .created!
                                        .isNotEmpty)
                                      Text(
                                        "Date: ${_filteredTransactions[index].created!.toString()}",
                                        style: GoogleFonts.inter(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                            color: CustomColor.black),
                                      ),
                                    Row(
                                      children: [
                                        Text(
                                          "Status: ",
                                          style: GoogleFonts.inter(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: CustomColor.black),
                                        ),
                                        if (_filteredTransactions[index]
                                            .status!
                                            .isNotEmpty)
                                          Text(
                                            _filteredTransactions[index]
                                                .status!
                                                .toString(),
                                            style: GoogleFonts.inter(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500,
                                                color:
                                                    _filteredTransactions[index]
                                                                .status!
                                                                .toString() ==
                                                            "completed"
                                                        ? CustomColor.green
                                                        : CustomColor
                                                            .errorColor),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              _filteredTransactions[index].symbol! +
                                  _filteredTransactions[index].totalPay!,
                              style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: CustomColor.errorColor),
                            ),
                            Text(
                              _filteredTransactions[index].type!,
                              style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: _filteredTransactions[index].type! ==
                                          "debit"
                                      ? CustomColor.errorColor
                                      : CustomColor.green),
                            )
                          ],
                        )
                      ],
                    ),
                  ));
            },
          ),
        )
      ],
    );
  }
}

class ActiveCardScreen extends StatefulWidget {
  const ActiveCardScreen({super.key});

  @override
  State<ActiveCardScreen> createState() => _ActiveCardScreenState();
}

class _ActiveCardScreenState extends State<ActiveCardScreen> {
  final DashboardBloc _activeCardScreenBloc = DashboardBloc();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _cardNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _activeCardScreenBloc,
      listener: (context, DashboardState state) {
        if (state.statusModel?.status == 0) {
          CustomToast.showError(context, "Sorry!", state.statusModel!.message!);
        }

        if (state.cardActiveModel?.status == 1) {
          Navigator.pushNamedAndRemoveUntil(
              context, 'debitCardScreen', (route) => false);
        }
      },
      child: BlocBuilder(
          bloc: _activeCardScreenBloc,
          builder: (context, DashboardState state) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.6,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                color: CustomColor.scaffoldBg,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
              ),
              child: ProgressHUD(
                inAsyncCall: state.isloading,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: CustomImageWidget(
                                    imagePath: StaticAssets.xClose,
                                    imageType: 'svg',
                                    height: 24,
                                  )),
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Active your card",
                                  style: GoogleFonts.inter(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: CustomColor.black),
                                ),
                              ),
                            ),
                            Container(
                              width: 20,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        InputTextCustom(
                            controller: _cardNumberController,
                            hint: 'Card Number',
                            label: 'Card Number',
                            keyboardType: TextInputType.number,
                            isEmail: false,
                            isPassword: false,
                            isSixteenDigits: true,
                            onChanged: () {}),
                        const SizedBox(
                          height: 10,
                        ),
                        PrimaryButtonWidget(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              UserDataManager().activeCardNumberSave(
                                  _cardNumberController.text);

                              _activeCardScreenBloc.add(CardActiveEvent());
                            }
                          },
                          // Disable button if fields are empty
                          buttonText: 'Continue',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}

class PrepaidCardTopUpScreen extends StatefulWidget {
  const PrepaidCardTopUpScreen({super.key});

  @override
  State<PrepaidCardTopUpScreen> createState() => _PrepaidCardTopUpScreenState();
}

class _PrepaidCardTopUpScreenState extends State<PrepaidCardTopUpScreen> {
  final DashboardBloc _prepaidCardTopUpBloc = DashboardBloc();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _ibanController = TextEditingController();

  SingleValueDropDownController _ibanAccountDropDownController =
      SingleValueDropDownController();

  bool bordershoww = false;
  String selectedIban = '';
  String? ibanId;

  @override
  void initState() {
    super.initState();
    _prepaidCardTopUpBloc.add(CardIbanListEvent());
    _prepaidCardTopUpBloc.add(CardTopUpIbanCallEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _prepaidCardTopUpBloc,
      listener: (context, DashboardState state) {
        if (state.statusModel?.status == 0) {
          CustomToast.showError(context, "Sorry!", state.statusModel!.message!);
        }

        if (state.cardTopUpFeeModel?.status == 1) {
          var ibanIdData = state.cardTopUpFeeModel?.ibanId!;
          showModalBottomSheet(
            context: context,
            elevation: 5,
            isScrollControlled: true,
            builder: (context) {
              return PrepaidCardTotalCostScreen(
                ibanId: ibanIdData!,
              );
            },
          );
        }
      },
      child: BlocBuilder(
          bloc: _prepaidCardTopUpBloc,
          builder: (context, DashboardState state) {
            return Material(
              color: CustomColor.scaffoldBg,
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20)), // Rounded top corners
              child: Container(
                height: MediaQuery.of(context).size.height * 0.7,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                width: MediaQuery.of(context).size.width,
                child: ProgressHUD(
                  inAsyncCall: state.isloading,
                  child: ListView(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: CustomImageWidget(
                                  imagePath: StaticAssets.xClose,
                                  imageType: 'svg',
                                  height: 24,
                                )),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Topup",
                                style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: CustomColor.black),
                              ),
                            ),
                          ),
                          Container(
                            width: 24,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            if (state.cardIbanGetCustomAccountsModel!.ibaninfo!
                                .isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 0),
                                child: DefaultDropDownFieldWithTitleWidget(
                                  controller: _ibanAccountDropDownController,
                                  title: "Select Iban",
                                  hint: "Select Iban",
                                  dropDownItemCount: state
                                          .cardIbanGetCustomAccountsModel!
                                          .ibaninfo!
                                          .length ??
                                      0,
                                  dropDownList: state
                                          .cardIbanGetCustomAccountsModel!
                                          .ibaninfo!
                                          .map<DropDownValueModel>(
                                              (Ibaninfo iban) {
                                        return DropDownValueModel(
                                          name:
                                              "${iban.label} (${iban.balance} ${iban.currency})",
                                          value: iban,
                                        );
                                      }).toList() ??
                                      [],
                                  onChanged: (val) {
                                    setState(() {
                                      selectedIban = (val as DropDownValueModel)
                                          .value
                                          ?.ibanId;
                                      ibanId = val.value.ibanId;

                                      bordershoww = true;
                                    });
                                  },
                                ),
                              ),
                            InputTextCustom(
                                controller: _amountController,
                                hint: 'Amount',
                                label: 'Topup Amount',
                                keyboardType: TextInputType.number,
                                isEmail: false,
                                isPassword: false,
                                onChanged: () {}),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      PrimaryButtonWidget(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            UserDataManager()
                                .prepaidCardAmountSave(_amountController.text);
                            _prepaidCardTopUpBloc
                                .add(CardTopupAmountEvent(ibanId: ibanId!));
                          }
                        },
                        buttonText: 'Continue',
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

// _selectIBANWidget(BuildContext context, List<Ibaninfo> ibanList,
//     TextEditingController controller) {
//   // final String? selectedLabel;
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text(
//         "Select IBAN",
//         style: GoogleFonts.inter(
//           fontSize: 12,
//           color: CustomColor.black.withOpacity(0.7),
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//       const SizedBox(
//         height: 10,
//       ),
//       DropdownButtonFormField<String>(
//         value: controller.text.isNotEmpty
//             ? controller.text
//             : ibanList.isNotEmpty
//                 ? ibanList.first.ibanId!
//                 : null,
//         iconEnabledColor: CustomColor.primaryColor,
//         icon: Icon(
//           Icons.keyboard_arrow_down_rounded,
//           size: 24,
//           color: CustomColor.black,
//         ),
//         decoration: InputDecoration(
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(11),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(11),
//             borderSide: BorderSide(
//               color: CustomColor.primaryColor,
//             ),
//           ),
//         ),
//         onChanged: (selectedValue) {
//           if (selectedValue != null) {
//             final selectedIban = ibanList.isNotEmpty
//                 ? ibanList.firstWhere((iban) => iban.ibanId == selectedValue)
//                 : null;
//             if (selectedIban != null) {
//               controller.text = selectedIban.ibanId!;
//               UserDataManager()
//                   .cardIbanSelectSave(selectedIban.ibanId.toString());
//             }
//           }
//         },
//         items: ibanList.map<DropdownMenuItem<String>>((Ibaninfo iban) {
//           return DropdownMenuItem<String>(
//             value: iban.ibanId!,
//             child: Text(
//               "${iban.label!} (${iban.balance})",
//               style: GoogleFonts.inter(
//                 fontSize: 12,
//                 color: CustomColor.black,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     ],
//   );
// }
}

class PrepaidCardTotalCostScreen extends StatefulWidget {
  PrepaidCardTotalCostScreen({super.key, required this.ibanId});

  String ibanId;

  @override
  State<PrepaidCardTotalCostScreen> createState() =>
      _PrepaidCardTotalCostScreenState();
}

class _PrepaidCardTotalCostScreenState
    extends State<PrepaidCardTotalCostScreen> {
  final DashboardBloc _prepaidCardCostBloc = DashboardBloc();

  @override
  void initState() {
    super.initState();
    _prepaidCardCostBloc.add(CardTopupAmountEvent(ibanId: widget.ibanId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _prepaidCardCostBloc,
      listener: (context, DashboardState state) {
        if (state.statusModel?.status == 0) {
          CustomToast.showError(context, "Sorry!", state.statusModel!.message!);
        }

        if (state.cardTopUpConfirmModel?.status == 1) {
          CustomToast.showSuccess(
              context, "Success!", state.cardTopUpConfirmModel!.message!);
          Navigator.pushNamedAndRemoveUntil(
              context, 'debitCardScreen', (route) => false);
        }
      },
      child: BlocBuilder(
          bloc: _prepaidCardCostBloc,
          builder: (context, DashboardState state) {
            String loadAmount = state.cardTopUpFeeModel!.loadAmount.toString();
            String totalFee = state.cardTopUpFeeModel!.totalFee.toString();
            String totalPay = state.cardTopUpFeeModel!.totalPay.toString();
            String symbol = state.cardTopUpFeeModel!.symbol.toString();
            String ibanIdData = state.cardTopUpFeeModel!.ibanId.toString();

            return Container(
              height: MediaQuery.of(context).size.height * 0.5,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                color: CustomColor.scaffoldBg,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
              ),
              child: ProgressHUD(
                inAsyncCall: state.isloading,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: CustomImageWidget(
                                  imagePath: StaticAssets.xClose,
                                  imageType: 'svg',
                                  height: 24,
                                )),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Confirm your Topup",
                                style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: CustomColor.black),
                              ),
                            ),
                          ),
                          Container(
                            width: 24,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            color: CustomColor.hubContainerBgColor,
                            borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Topup Amount',
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.inter(
                                      color: CustomColor.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "$symbol $loadAmount",
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.inter(
                                      color: CustomColor.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Total Fee',
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.inter(
                                      color: CustomColor.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "$symbol $totalFee",
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.inter(
                                      color: CustomColor.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Divider(
                              height: 1,
                              color: CustomColor.black.withOpacity(0.4),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Total Pay',
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.inter(
                                      color: CustomColor.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "$symbol $totalPay",
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.inter(
                                      color: CustomColor.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      PrimaryButtonWidget(
                        onPressed: () {
                          _prepaidCardCostBloc
                              .add(CardTopupConfirmEvent(ibanId: ibanIdData));
                        },
                        buttonText: 'Confirm',
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
