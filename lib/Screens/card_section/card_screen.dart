import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:gptbanqbusiness/utils/assets.dart';
import 'package:gptbanqbusiness/utils/user_data_manager.dart';
import 'package:gptbanqbusiness/widgets/custom_image_widget.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:gptbanqbusiness/Screens/Dashboard_screen/bloc/dashboard_bloc.dart';
import 'package:gptbanqbusiness/constant_string/User.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';

import '../../Models/card/card_iban_get_custom_account_model.dart';
import '../../cutom_weidget/card_country_widget.dart';
import '../../cutom_weidget/input_textform.dart';
import '../../utils/custom_scroll_behavior.dart';
import '../../utils/input_fields/custom_color.dart';
import '../../widgets/buttons/custom_floating_action_button.dart';
import '../../widgets/buttons/primary_button_widget.dart';
import '../../widgets/main/default_dropdown_field_with_title_widget.dart';
import '../../widgets/main_logo_widget.dart';
import '../../widgets/toast/toast_util.dart';

class CardScreen extends StatefulWidget {
  const CardScreen({super.key});

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  bool active = false;
  bool isInstant = false;
  int iframe = 0;
  String iframeUrl = "";

  bool shownotification = true;
  final DashboardBloc _cardListBloc = DashboardBloc();

  Future<void> _onRefresh() async {
    debugPrint('_onRefresh');

    _cardListBloc.add(CardListEvent());
    _cardListBloc.add(DashboarddataEvent());
  }

  @override
  void initState() {
    super.initState();
    User.Screen = 'card screen';

    _cardListBloc.add(CardListEvent());
    _cardListBloc.add(DashboarddataEvent());
  }

  Color _parseColor(String? hexColor, {Color fallback = Colors.white}) {
    if (hexColor == null || hexColor.isEmpty) return fallback;

    try {
      // Ensure the string starts with '0xff'
      return Color(
          int.parse(hexColor.startsWith('0xff') ? hexColor : '0xff$hexColor'));
    } catch (e) {
      return fallback; // In case of parsing error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColor.scaffoldBg,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Stack(
          children: [
            BlocListener(
                bloc: _cardListBloc,
                listener: (context, DashboardState state) {
                  if (state.statusModel?.status == 0) {
                    CustomToast.showError(
                        context, "Sorry!", state.statusModel!.message!);
                  }

                  if (state.userCardDetailsModel?.status == 1) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, 'debitCardScreen', (route) => false);

                    // iframe = state
                    //     .userCardDetailsModel!.userCardDetails!.isiframe!;
                    // iframeUrl = state
                    //     .userCardDetailsModel!.userCardDetails!.iframeurl!;
                    // if (iframe == 0) {
                    //
                    // } else if (iframe == 1) {
                    //   print(iframeUrl);
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => WebViewScreen(url: iframeUrl),
                    //     ),
                    //   );
                    //
                    // }
                  }
                },
                child: BlocBuilder(
                    bloc: _cardListBloc,
                    builder: (context, DashboardState state) {
                      return SafeArea(
                        child: ProgressHUD(
                          inAsyncCall: state.isloading,
                          child: RefreshIndicator(
                            onRefresh: _onRefresh,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  appBarSection(context, state),
                                  Expanded(
                                      child: GridView.builder(
                                    shrinkWrap: true,
                                    physics: const ScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 8.0,
                                      mainAxisSpacing: 8.0,
                                      childAspectRatio: 1.5,
                                    ),
                                    itemCount:
                                        state.cardListModel!.card!.length + 1,
                                    itemBuilder: (context, index) {
                                      if (index <
                                          state.cardListModel!.card!.length) {
                                        return GestureDetector(
                                            onTap: () {
                                              UserDataManager().cardIdSave(state
                                                  .cardListModel!
                                                  .card![index]
                                                  .cid
                                                  .toString());

                                              if (["0", "1"].contains(state.cardListModel!.card![index].status)) {
                                                // CustomToast.showError(context, "Sorry!",
                                                //     'Your card is currently in "Requested" status. We’ll notify you as soon as it’s approved and ready to use.');
                                                //
                                              } else {
                                                _cardListBloc
                                                    .add(CardDetailsEvent());
                                              }
                                            },
                                            child: Container(
                                              alignment: Alignment.bottomLeft,
                                              decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  image: DecorationImage(
                                                      image: NetworkImage(state
                                                          .cardListModel!
                                                          .card![index]
                                                          .cardImage
                                                          .toString()),
                                                      fit: BoxFit.cover)),
                                              child: Container(
                                                // alignment: Alignment.bottomLeft,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15,
                                                        vertical: 12),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          state.cardListModel!.card![index].balance.toString(),
                                                          textAlign: TextAlign.left,
                                                          style:  TextStyle(
                                                              fontSize: 16.0, color:_parseColor(
                                                              state.cardListModel!.card![index].textcolor)),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets.only(
                                                                  right: 5),
                                                          child: Text(
                                                            state.cardListModel!
                                                                .card![index].pan
                                                                .toString(),
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: TextStyle(
                                                              fontSize: 12.0,
                                                              color: _parseColor(
                                                                  state
                                                                      .cardListModel!
                                                                      .card![index]
                                                                      .textcolor),
                                                            ),
                                                          ),
                                                        ),
                                                        // Virtual card
                                                        state
                                                                    .cardListModel!
                                                                    .card![index]
                                                                    .cardType
                                                                    .toString() ==
                                                                "virtual card"
                                                            ? Text(
                                                                state
                                                                    .cardListModel!
                                                                    .card![index]
                                                                    .cardType
                                                                    .toString(),
                                                                textAlign:
                                                                    TextAlign.left,
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            12.0,
                                                                        color: Colors
                                                                            .white),
                                                              )
                                                            : const Text(""),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ));
                                      } else {
                                        return GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet(
                                              context: context,
                                              elevation: 5,
                                              builder: (context) {
                                                return const BottomSheetContent();
                                              },
                                            );
                                          },
                                          child: Container(
                                              alignment: Alignment.center,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 8),
                                              child: CustomPaint(
                                                  painter:
                                                      DottedBorderPainter(),
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: CustomImageWidget(
                                                      imagePath:
                                                          StaticAssets.cardAdd,
                                                      imageType: 'svg',
                                                      height: 20,
                                                    ),
                                                  ))),
                                        );
                                      }
                                    },
                                  ))
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    })),
          ],
        ),
        floatingActionButton: CustomFloatingActionButton());
  }

  appBarSection(BuildContext context, state) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(bottom: 30, top: 10),
      child: Text(
        'Card Dashboard',
        textAlign: TextAlign.center,
        style: GoogleFonts.inter(
            color: CustomColor.black,
            fontSize: 18,
            fontWeight: FontWeight.w500),
      ),
    );
  }

  cardSection(BuildContext context, DashboardState state) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 1.5,
      ),
      itemCount: state.cardListModel!.card!.length + 1,
      itemBuilder: (context, index) {
        if (index < state.cardListModel!.card!.length) {
          return GestureDetector(
              onTap: () {
                if (["0", "1"].contains(state.cardListModel!.card![index].status)) {
                  CustomToast.showError(context, "Sorry!",
                      'Your card is currently in "Requested" status. We’ll notify you as soon as it’s approved and ready to use.');
                } else {
                  Navigator.pushNamedAndRemoveUntil(
                      context, 'debitCardScreen', (route) => false);
                }
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: NetworkImage(state
                            .cardListModel!.card![index].cardImage
                            .toString()),
                        fit: BoxFit.cover)),
                child: Container(
                  // alignment: Alignment.bottomLeft,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                         Container(),
                          Text(
                            state.cardListModel!.card![index].balance.toString(),
                            textAlign: TextAlign.left,
                            style:  TextStyle(
                                fontSize: 12.0, color:_parseColor(
                                state.cardListModel!.card![index].textcolor)),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            state.cardListModel!.card![index].pan.toString(),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 12.0,
                              color: _parseColor(
                                  state.cardListModel!.card![index].textcolor),
                            ),
                          ),
                          Text(
                            state.cardListModel!.card![index].cardType.toString(),
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                fontSize: 12.0, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ));
        } else {
          return GestureDetector(
            onTap: () {
              _cardListBloc.add(CardOrderTypeEvent());
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE3E3E3)),
                  image: const DecorationImage(
                    image: AssetImage("images/add-square.png"),
                    scale: 1,
                  )),
            ),
          );
        }
      },
    );
  }
}

class DottedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = CustomColor.primaryInputHintBorderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Dotted border pattern
    const double dashWidth = 7;
    const double dashSpace = 7;

    final Path path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          const Radius.circular(8),
        ),
      );

    PathMetrics pathMetrics = path.computeMetrics();
    for (PathMetric pathMetric in pathMetrics) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        Path dashPath = pathMetric.extractPath(
          distance,
          distance + dashWidth,
        );
        canvas.drawPath(dashPath, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class BottomSheetContent extends StatefulWidget {
  const BottomSheetContent({super.key});

  @override
  _BottomSheetContentState createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  bool isInstant = false;

  // bool isPhysical = false;
  // bool isVirtual = true;
  bool? isPhysicalAvailable;
  bool? isVirtualAvailable;

  final DashboardBloc _cardOrderTypeBloc = DashboardBloc();

  @override
  void initState() {
    super.initState();
    _cardOrderTypeBloc.add(CardOrderTypeEvent());
    UserDataManager().cardTypeSave("virtual");
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _cardOrderTypeBloc,
      listener: (context, DashboardState state) {
        if (state.statusModel?.status == 0) {
          CustomToast.showError(context, "Sorry!", state.statusModel!.message!);
        }

        if (state.cardOrderTypeModel?.status == 1) {
          final cardTypeModel = state.cardOrderTypeModel?.cardtype;

          isPhysicalAvailable = cardTypeModel?.isPhysical == 1;
          isVirtualAvailable = cardTypeModel?.isVirtual == 1;
        }
      },
      child: BlocBuilder(
          bloc: _cardOrderTypeBloc,
          builder: (context, DashboardState state) {
            return Material(
              color: CustomColor.whiteColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                width: MediaQuery.of(context).size.width,
                child: ProgressHUD(
                  inAsyncCall: state.isloading,
                  child: ListView(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: CustomImageWidget(
                                imagePath: StaticAssets.closeBlack,
                                imageType: 'svg',
                                height: 20,
                              )),
                          Text(
                            'Choose Card',
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
                      Container(
                        height: 50,
                        margin: const EdgeInsets.only(top: 20),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: CustomColor.selectContainerColor,
                        ),
                        child: Row(
                          children: [
                            if (isPhysicalAvailable == true)
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      isInstant = !isInstant;
                                      UserDataManager().cardTypeSave("plastic");
                                    });
                                  },
                                  child: Container(
                                    height: 42,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: isInstant
                                          ? CustomColor.whiteColor
                                          : CustomColor.selectContainerColor,
                                    ),
                                    child: Text(
                                      "Physical",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.inter(
                                          color: isInstant
                                              ? CustomColor.black
                                              : CustomColor.black
                                                  .withOpacity(0.4),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ),
                            if (isVirtualAvailable == true)
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      isInstant = !isInstant;
                                      UserDataManager().cardTypeSave("virtual");
                                    });
                                  },
                                  child: Container(
                                    height: 42,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        color: isInstant
                                            ? CustomColor.selectContainerColor
                                            : CustomColor.whiteColor),
                                    child: Text(
                                      "Virtual",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.inter(
                                          color: isInstant
                                              ? CustomColor.black
                                                  .withOpacity(0.4)
                                              : CustomColor.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              )
                          ],
                        ),
                      ),
                      //debit card
                      state.cardOrderTypeModel!.debit!.isDebitcard.toString() ==
                              "0"
                          ? Container()
                          : GestureDetector(
                              onTap: () async {
                                UserDataManager().cardSave("debit");
                                UserDataManager().cardholderSave("0");
                                UserDataManager().userAddressSave("");
                                UserDataManager().userCitySave("");
                                UserDataManager().userPostalCodeSave("");
                                UserDataManager().userCountySave("");
                                String isVirtualCard =
                                    await UserDataManager().getCardType();

                                showModalBottomSheet(
                                  context: context,
                                  elevation: 5,
                                  builder: (context) {
                                    if (isVirtualCard == "virtual") {
                                      return const BottomSheetContentStep4(); // Show step 4 bottom sheet
                                    } else {
                                      return const BottomSheetContentStep2(); // Show step 2 bottom sheet
                                    }
                                  },
                                );
                              },
                              child: Container(
                                height: 96,
                                margin: const EdgeInsets.only(top: 30),
                                decoration: BoxDecoration(
                                  color: CustomColor.whiteColor,
                                  borderRadius: BorderRadius.circular(9),
                                  boxShadow: [
                                    BoxShadow(
                                      color: CustomColor.black.withOpacity(0.4),
                                      offset: Offset(0, 2),
                                      blurRadius: 4,
                                      spreadRadius: -2,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.network(
                                        state.cardOrderTypeModel!.debit!.image
                                            .toString(),
                                        loadingBuilder: (BuildContext context,
                                            Widget child,
                                            ImageChunkEvent? loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          } else {
                                            return const Center(
                                                child: MainLogoWidget(
                                              width: 40,
                                            ));
                                          }
                                        },
                                        errorBuilder: (BuildContext context,
                                            Object error,
                                            StackTrace? stackTrace) {
                                          debugPrint(
                                              'Error loading image: $error');
                                          return const Center(
                                              child: MainLogoWidget(
                                            width: 40,
                                          ) // Show a loading indicator in case of an error
                                              );
                                        },
                                        height: 40,
                                        width: 64,
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Debit Card',
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.inter(
                                              color: CustomColor.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          width: 230,
                                          child: Text(
                                            'You can assign your debit card to your IBAN and pay with your account funds.',
                                            textAlign: TextAlign.left,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
                                            style: GoogleFonts.inter(
                                                color: CustomColor.black,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),

                      //prepaid card
                      state.cardOrderTypeModel!.prepaid!.isPrepaid.toString() ==
                              "0"
                          ? Container()
                          : GestureDetector(
                              onTap: () async {
                                UserDataManager().cardSave("prepaid");
                                UserDataManager().cardholderSave("0");
                                UserDataManager().userAddressSave("");
                                UserDataManager().userCitySave("");
                                UserDataManager().userPostalCodeSave("");
                                UserDataManager().userCountySave("");
                                String isVirtualCard =
                                    await UserDataManager().getCardType();

                                showModalBottomSheet(
                                  context: context,
                                  elevation: 5,
                                  builder: (context) {
                                    if (isVirtualCard == "virtual") {
                                      return const BottomSheetContentStep4(); // Show step 4 bottom sheet
                                    } else {
                                      return const BottomSheetContentStep2(); // Show step 2 bottom sheet
                                    }
                                  },
                                );
                              },
                              child: Container(
                                height: 96,
                                margin: const EdgeInsets.only(top: 10),
                                decoration: BoxDecoration(
                                  color: CustomColor.whiteColor,
                                  borderRadius: BorderRadius.circular(9),
                                  boxShadow: [
                                    BoxShadow(
                                      color: CustomColor.black.withOpacity(0.4),
                                      // Equivalent to #0000000D (rgba(0, 0, 0, 0.05))
                                      offset: Offset(0, 2),
                                      // X: 0, Y: 2
                                      blurRadius: 4,
                                      // The blur effect of the shadow
                                      spreadRadius:
                                          -2, // The spread of the shadow
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.network(
                                        state.cardOrderTypeModel!.prepaid!.image
                                            .toString(),
                                        loadingBuilder: (BuildContext context,
                                            Widget child,
                                            ImageChunkEvent? loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          } else {
                                            return const Center(
                                                child: MainLogoWidget(
                                              width: 40,
                                            ));
                                          }
                                        },
                                        errorBuilder: (BuildContext context,
                                            Object error,
                                            StackTrace? stackTrace) {
                                          debugPrint(
                                              'Error loading image: $error');
                                          return const Center(
                                              child: MainLogoWidget(
                                            width: 40,
                                          ));
                                        },
                                        height: 40,
                                        width: 64,
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Prepaid Card',
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.inter(
                                              color: CustomColor.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          width: 220,
                                          child: Text(
                                            'You can top up your prepaid card using an IBAN account.',
                                            textAlign: TextAlign.left,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
                                            style: GoogleFonts.inter(
                                                color: CustomColor.black,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
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

/*----------------step 2----------------*/

class BottomSheetContentStep2 extends StatefulWidget {
  const BottomSheetContentStep2({super.key});

  @override
  State<BottomSheetContentStep2> createState() =>
      _BottomSheetContentStep2State();
}

class _BottomSheetContentStep2State extends State<BottomSheetContentStep2> {
  final DashboardBloc _cardOrderTypeBloc = DashboardBloc();

  @override
  void initState() {
    super.initState();
    _cardOrderTypeBloc.add(CardTypeEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _cardOrderTypeBloc,
      listener: (context, DashboardState state) {
        if (state.statusModel?.status == 0) {
          CustomToast.showError(
              context, "Sorry!", state.statusModel!.message!);
        }
      },
      child: BlocBuilder(
          bloc: _cardOrderTypeBloc,
          builder: (context, DashboardState state) {
            return Material(
              color: CustomColor.whiteColor,
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16)), // Rounded top corners
              child: Container(
                height: MediaQuery.of(context).size.height * 0.48,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                width: MediaQuery.of(context).size.width,
                child: ProgressHUD(
                  inAsyncCall: state.isloading,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: CustomImageWidget(
                                imagePath: StaticAssets.closeBlack,
                                imageType: 'svg',
                                height: 20,
                              )),
                          Text(
                            "Card Details",
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
                      SizedBox(
                        height: 10,
                      ),
                      if (state.cardTypeModel!.cardWithoutCardHolder
                              .toString() ==
                          "2")
                        GestureDetector(
                          onTap: () {
                            UserDataManager().cardholderSave("0");

                            showModalBottomSheet(
                              context: context,
                              elevation: 5,
                              isScrollControlled: true,
                              builder: (context) {
                                return const BottomSheetContentStep3();
                              },
                            );
                          },
                          child: Container(
                            height: 96,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: CustomColor.whiteColor,
                              borderRadius: BorderRadius.circular(9),
                              boxShadow: [
                                BoxShadow(
                                  color: CustomColor.black.withOpacity(0.4),
                                  // Equivalent to #0000000D (rgba(0, 0, 0, 0.05))
                                  offset: Offset(0, 2),
                                  // X: 0, Y: 2
                                  blurRadius: 4,
                                  // The blur effect of the shadow
                                  spreadRadius: -2, // The spread of the shadow
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.network(
                                    state.cardTypeModel!.cardImage.toString(),
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      } else {
                                        return Center(
                                            child: Image.asset(
                                          'images/card/card_demo.png',
                                        ));
                                      }
                                    },
                                    errorBuilder: (BuildContext context,
                                        Object error, StackTrace? stackTrace) {
                                      debugPrint('Error loading image: $error');
                                      return Image.asset(
                                        'images/card/card_demo.png',
                                      );
                                    },
                                    height: 40,
                                    width: 64,
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Without Card Holder name printed',
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.inter(
                                          color: CustomColor.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      width: 220,
                                      child: Text(
                                        'Fast shipping, cards already produced',
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        style: GoogleFonts.inter(
                                            color: CustomColor.black,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      if (state.cardTypeModel!.cardWithCardHolder.toString() ==
                          "1")
                        GestureDetector(
                          onTap: () {
                            UserDataManager().cardholderSave("1");
                            showModalBottomSheet(
                              context: context,
                              elevation: 5,
                              builder: (context) {
                                return const BottomSheetContentStep3();
                              },
                            );
                          },
                          child: Container(
                            height: 96,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: CustomColor.whiteColor,
                              borderRadius: BorderRadius.circular(9),
                              boxShadow: [
                                BoxShadow(
                                  color: CustomColor.black.withOpacity(0.4),
                                  // Equivalent to #0000000D (rgba(0, 0, 0, 0.05))
                                  offset: Offset(0, 2),
                                  // X: 0, Y: 2
                                  blurRadius: 4,
                                  // The blur effect of the shadow
                                  spreadRadius: -2, // The spread of the shadow
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.network(
                                    state.cardTypeModel!.cardImage.toString(),
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      } else {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    },
                                    errorBuilder: (BuildContext context,
                                        Object error, StackTrace? stackTrace) {
                                      debugPrint('Error loading image: $error');
                                      return Image.asset(
                                        'images/card/card_demo.png',
                                      );
                                    },
                                    height: 40,
                                    width: 64,
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Card Holder name printed',
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.inter(
                                          color: CustomColor.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      width: 220,
                                      child: Text(
                                        'The card will be produced by the manufacturer and shipped with your name.',
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        style: GoogleFonts.inter(
                                            color: CustomColor.black,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}

/*----------------step 3----------------*/

class BottomSheetContentStep3 extends StatefulWidget {
  const BottomSheetContentStep3({super.key});

  @override
  State<BottomSheetContentStep3> createState() =>
      _BottomSheetContentStep3State();
}

class _BottomSheetContentStep3State extends State<BottomSheetContentStep3> {
  final DashboardBloc _cardOrderTypeBloc = DashboardBloc();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _address = TextEditingController();
  final TextEditingController _postalCode = TextEditingController();
  final TextEditingController _city = TextEditingController();
  final TextEditingController _country = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cardOrderTypeBloc.add(CardTypeEvent());
    _address.text = "address";
    _city.text = 'city';
    _postalCode.text = '000';
    // _country.text = "Select Country";
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _cardOrderTypeBloc,
      listener: (context, DashboardState state) {
        if (state.statusModel?.status == 0) {
          CustomToast.showError(
              context, "Sorry!", state.statusModel!.message!);
        }

        if (state.cardOderDetailsModel?.status == 1) {
          showModalBottomSheet(
            context: context,
            elevation: 5,
            builder: (context) {
              return const BottomSheetContentStep4();
            },
          );
        }
      },
      child: BlocBuilder(
          bloc: _cardOrderTypeBloc,
          builder: (context, DashboardState state) {
            _address.text = state.cardTypeModel!.shipping!.address.toString();
            _city.text = state.cardTypeModel!.shipping!.city.toString();
            _postalCode.text =
                state.cardTypeModel!.shipping!.postalcode.toString();
            return Scaffold(
              backgroundColor: CustomColor.transparent,
              body: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                decoration: BoxDecoration(
                  color: CustomColor.whiteColor,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                // width: MediaQuery.of(context).size.width,
                child: ProgressHUD(
                  inAsyncCall: state.isloading,
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: CustomImageWidget(
                                  imagePath: StaticAssets.closeBlack,
                                  imageType: 'svg',
                                  height: 20,
                                )),
                            Text(
                              'Card Shipping Details',
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
                        const SizedBox(
                          height: 20,
                        ),
                        InputTextCustom(
                            controller: _address,
                            hint: 'address',
                            label: 'Address',
                            isEmail: false,
                            isPassword: false,
                            onChanged: () {}),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.30,
                              margin: const EdgeInsets.only(right: 5),
                              child: InputTextCustom(
                                  controller: _postalCode,
                                  hint: 'postal code',
                                  label: 'Postal Code',
                                  isEmail: false,
                                  isPassword: false,
                                  onChanged: () {}),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.57,
                              child: InputTextCustom(
                                  controller: _city,
                                  hint: 'city',
                                  label: 'City',
                                  isEmail: false,
                                  isPassword: false,
                                  onChanged: () {}),
                            ),
                          ],
                        ),
                        CardCountryWidget(
                          controller: _country,
                          hint: 'Select Country',
                          label: 'Country',
                          nationality: true,
                          listitems: state.cardTypeModel!.shipping!.country,
                          selectString: 'Select Country',
                        ),
                        PrimaryButtonWidget(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // All fields are valid, continue with the action
                              UserDataManager().userAddressSave(_address.text);
                              UserDataManager().userCitySave(_city.text);
                              UserDataManager()
                                  .userPostalCodeSave(_postalCode.text);
                              _cardOrderTypeBloc.add(CardFeeEvent());
                            }
                          },
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

class BottomSheetContentStep4 extends StatefulWidget {
  const BottomSheetContentStep4({super.key});

  @override
  State<BottomSheetContentStep4> createState() =>
      _BottomSheetContentStep4State();
}

class _BottomSheetContentStep4State extends State<BottomSheetContentStep4> {
  final DashboardBloc _cardOrderDetailsBloc = DashboardBloc();

  SingleValueDropDownController _ibanAccountDropDownController =
      SingleValueDropDownController();

  bool bordershoww = false;
  String selectedIban = '';
  String? ibanId;

  @override
  void initState() {
    super.initState();
    _cardOrderDetailsBloc.add(CardFeeEvent());
    _cardOrderDetailsBloc.add(CardIbanCallEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _cardOrderDetailsBloc,
      listener: (context, DashboardState state) {
        if (state.statusModel?.status == 0) {
          CustomToast.showError(
              context, "Sorry!", state.statusModel!.message!);
        }

        if (state.cardOrderConfirmModel?.status == 1) {
          Navigator.pushNamedAndRemoveUntil(
              context, 'cardScreen', (route) => false);
        }
      },
      child: BlocBuilder(
          bloc: _cardOrderDetailsBloc,
          builder: (context, DashboardState state) {
            String cardFee = state.cardOderDetailsModel!.card!.fee.toString();
            String shippingFee =
                state.cardOderDetailsModel!.card!.shippingCost.toString();
            String totalFee =
                state.cardOderDetailsModel!.card!.total.toString();

            return Material(
              color: CustomColor.whiteColor,
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16)), // Rounded top corners
              child: Container(
                height: MediaQuery.of(context).size.height * 0.48,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                width: MediaQuery.of(context).size.width,
                child: ProgressHUD(
                  inAsyncCall: state.isloading,
                  child: ListView(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: CustomImageWidget(
                                imagePath: StaticAssets.closeBlack,
                                imageType: 'svg',
                                height: 20,
                              )),
                          Text(
                            'Confirm Order',
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
                      const SizedBox(
                        height: 20,
                      ),
                      if (state
                          .cardIbanGetCustomAccountsModel!.ibaninfo!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: DefaultDropDownFieldWithTitleWidget(
                            controller: _ibanAccountDropDownController,
                            title: "Pay with",
                            hint: "Select Iban",
                            dropDownItemCount: state
                                    .cardIbanGetCustomAccountsModel!
                                    .ibaninfo!
                                    .length ??
                                0,
                            dropDownList: state
                                    .cardIbanGetCustomAccountsModel!.ibaninfo!
                                    .map<DropDownValueModel>((Ibaninfo iban) {
                                  return DropDownValueModel(
                                    name:
                                        "${iban.label} (${iban.balance} ${iban.currency})",
                                    value: iban,
                                  );
                                }).toList() ??
                                [],
                            onChanged: (val) {
                              setState(() {
                                selectedIban =
                                    (val as DropDownValueModel).value?.ibanId;
                                ibanId = val.value.ibanId;

                                bordershoww = true;
                              });
                            },
                          ),
                        ),
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            color: CustomColor.hubContainerBgColor,
                            borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Card Cost',
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.inter(
                                    color: CustomColor.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "${state.cardOderDetailsModel!.symbol} $cardFee",
                                  style: GoogleFonts.inter(
                                    color: CustomColor.black.withOpacity(0.7),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              ],
                            ),
                            if (shippingFee != "0.00" &&
                                shippingFee != "null" &&
                                shippingFee != "")
                              const SizedBox(
                                height: 10,
                              ),
                            if (shippingFee != "0.00" &&
                                shippingFee != "null" &&
                                shippingFee != "")
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Shipping Cost',
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.inter(
                                      color: CustomColor.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "${state.cardOderDetailsModel!.symbol} $shippingFee",
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.inter(
                                      color: CustomColor.black.withOpacity(0.7),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                ],
                              ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Total Cost',
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.inter(
                                    color: CustomColor.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (totalFee.isNotEmpty)
                                  Text(
                                    "${state.cardOderDetailsModel!.symbol} ${totalFee.toString()}",
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.inter(
                                      color: CustomColor.black.withOpacity(0.7),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      PrimaryButtonWidget(
                        onPressed: () {
                          UserDataManager().cardShippingCostSave(shippingFee);

                          _cardOrderDetailsBloc
                              .add(CardOrderConfirmEvent(ibanId: ibanId!));
                        },
                        buttonText: 'Next',
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

class TrxConfirmationSreen extends StatefulWidget {
  const TrxConfirmationSreen({super.key});

  @override
  State<TrxConfirmationSreen> createState() => _TrxConfirmationSreenState();
}

class _TrxConfirmationSreenState extends State<TrxConfirmationSreen> {
  final DashboardBloc _trxBloc = DashboardBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _trxBloc.add(TrxBiometricDetailsEvent(uniqueId: "123456789"));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _trxBloc,
      listener: (context, DashboardState state) {
        if (state.statusModel?.status == 0) {
          CustomToast.showError(
              context, "Sorry!", state.statusModel!.message!);
        }
      },
      child: BlocBuilder(
          bloc: _trxBloc,
          builder: (context, DashboardState state) {
            String body = state
                .trxBiometricConfirmationNotificationsModel!.data!.body
                .toString();
            String image = state
                .trxBiometricConfirmationNotificationsModel!.data!.image
                .toString();
            String title = state
                .trxBiometricConfirmationNotificationsModel!.data!.title
                .toString();
            return Material(
              color: Colors.white, // Set the background color to white
              child: Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: ProgressHUD(
                  inAsyncCall: state.isloading,
                  child: Column(
                    children: [
                      Expanded(
                        child: ScrollConfiguration(
                          behavior: CustomScrollBehavior(),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 18, right: 18),
                            child: ListView(
                              children: [
                                const SizedBox(height: 20),
                                Text(
                                  title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'pop',
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 150),
                                Column(
                                  children: [
                                    Image.network(
                                      image,
                                      height: 100,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        } else {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      },
                                      errorBuilder: (BuildContext context,
                                          Object error,
                                          StackTrace? stackTrace) {
                                        debugPrint(
                                            'Error loading image: $error');
                                        return Image.asset(
                                          'images/bell.png',
                                          height: 100,
                                        );
                                      },
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const SizedBox(height: 20),
                                          Text(
                                            body,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w800,
                                              fontFamily: 'pop',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const SizedBox(height: 100),
                                    Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(10),
                                      child: const Text(
                                        "Tap 'Approve' to verify the payment. if you do not recognize the purchase, decline.",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'pop',
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          gradient: const LinearGradient(
                                              colors: [
                                                Color(0xff090B78),
                                                Color(0xff090B78)
                                              ])),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.popUntil(context,
                                              (route) => route.isFirst);
                                          _trxBloc.add(
                                              TrxBiometricConfirmOrCancelEvent(
                                                  uniqueId: "123456789",
                                                  loginStatus: "APPROVED"));
                                        },
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        15.0)),
                                            backgroundColor: Colors.transparent,
                                            elevation: 0,
                                            shadowColor: Colors.transparent,
                                            minimumSize:
                                                const Size.fromHeight(50)),
                                        child: const Text(
                                          "Approve",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontFamily: 'pop',
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    InkWell(
                                      onTap: () {
                                        Navigator.popUntil(
                                            context, (route) => route.isFirst);
                                        _trxBloc.add(
                                            TrxBiometricConfirmOrCancelEvent(
                                                uniqueId: "123456789",
                                                loginStatus: "DECLINED"));
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: double.infinity,
                                        height: 40,
                                        child: Text(
                                          'Decline',
                                          style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.7),
                                            fontSize: 16,
                                            decoration:
                                                TextDecoration.underline,
                                            fontFamily: 'pop',
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
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
