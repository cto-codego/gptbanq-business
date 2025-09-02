import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:gptbanqbusiness/Screens/Dashboard_screen/bloc/dashboard_bloc.dart';
import 'package:gptbanqbusiness/constant_string/User.dart';
import 'package:gptbanqbusiness/utils/assets.dart';
import 'package:gptbanqbusiness/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../cutom_weidget/cutom_progress_bar.dart';
import '../../cutom_weidget/flip_card_widget.dart';
import '../../utils/input_fields/custom_color.dart';
import '../../widgets/buttons/default_back_button_widget.dart';
import '../../widgets/input_fields/defult_input_field_with_title_widget.dart';
import '../../widgets/toast/toast_util.dart';

class ShowGiftCardScreen extends StatefulWidget {
  const ShowGiftCardScreen({super.key});

  @override
  State<ShowGiftCardScreen> createState() => _ShowGiftCardScreenState();
}

class _ShowGiftCardScreenState extends State<ShowGiftCardScreen> {
  late final List<CreditCardDetails> creditCards;

  final DashboardBloc _giftCardDetailsBloc = DashboardBloc();

  bool flap = false;

  bool showDetails = false;

  @override
  void initState() {
    User.Screen = 'show gift card';

    super.initState();
    _giftCardDetailsBloc.add(GiftCardGetDetailsEvent());
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
        bloc: _giftCardDetailsBloc,
        listener: (context, DashboardState state) {
          if (state.giftCardShareModel?.status == 0) {
            CustomToast.showError(
                context, "Sorry!", state.giftCardShareModel!.message!);
          } else if (state.giftCardShareModel?.status == 1) {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();

            CustomToast.showSuccess(
                context, "Hey!", state.giftCardShareModel!.message!);
          }
        },
        child: BlocBuilder(
            bloc: _giftCardDetailsBloc,
            builder: (context, DashboardState state) {
              return ProgressHUD(
                inAsyncCall: state.isloading,
                child: SafeArea(
                  child: Container(
                    margin: const EdgeInsets.only(right: 16, left: 16, top: 20),
                    child: Column(
                      // shrinkWrap: true,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              DefaultBackButtonWidget(onTap: () {
                                Navigator.pushNamedAndRemoveUntil(context,
                                    'buyGiftCardScreen', (route) => false);
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
                        Image.network(
                          state.giftCardDetailsModel!.image!.toString(),
                          height: 188,
                          width: MediaQuery.of(context).size.width,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                          errorBuilder: (BuildContext context, Object error,
                              StackTrace? stackTrace) {
                            // Error occurred while loading image, show the asset image as a fallback
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                        const SizedBox(height: 5),
                        Center(
                          child: Column(
                            children: [
                              Text(
                                "Current balance",
                                style: GoogleFonts.inter(
                                    color: CustomColor.black.withOpacity(0.7),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "€${state.giftCardDetailsModel!.card!.balance!.toString() ?? ''}",
                                style: GoogleFonts.inter(
                                    color: Colors.black,
                                    fontSize: 50,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        _detailsWidget(
                            context,
                            state.giftCardDetailsModel!.card!.cardNumber
                                    .toString() ??
                                "",
                            state.giftCardDetailsModel!.card!.expiryDate
                                    .toString() ??
                                "",
                            state.giftCardDetailsModel!.card!.cvv.toString() ??
                                ""),
                        const SizedBox(height: 10),
                        _transactionTitleWidget(context),
                        Expanded(
                          flex: 1,
                          child: state.giftCardDetailsModel!.card!.trx!.isEmpty
                              ? Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: Column(
                                    children: [
                                      CustomImageWidget(
                                        imagePath: StaticAssets.noTransaction,
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
                                )
                              : ListView.builder(
                                  itemCount: 5,
                                  shrinkWrap: true,
                                  physics: const ScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (index >=
                                        state.giftCardDetailsModel!.card!.trx!
                                            .length) {
                                      return Container(); // Return an empty container if index is out of bounds
                                    }
                                    return InkWell(
                                      onTap: () {
                                        AwesomeDialog(
                                                context: context,
                                                dialogType: DialogType.noHeader,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16),
                                                btnCancelColor: CustomColor
                                                    .primaryColor,
                                                dialogBackgroundColor: Colors
                                                    .white,
                                                animType: AnimType.scale,
                                                body: Column(
                                                  children: [
                                                    Center(
                                                      child: Text(
                                                        "€${state.giftCardDetailsModel!.card!.trx![index].amount.toString() ?? ''}",
                                                        style:
                                                            GoogleFonts.inter(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 50,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 10),
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'Transaction Type',
                                                              style: GoogleFonts
                                                                  .inter(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Color(
                                                                    0xff2C2C2C),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Container(
                                                                alignment: Alignment
                                                                    .centerRight,
                                                                child: Text(
                                                                  state
                                                                      .giftCardDetailsModel!
                                                                      .card!
                                                                      .trx![
                                                                          index]
                                                                      .type
                                                                      .toString(),
                                                                  style:
                                                                      GoogleFonts
                                                                          .inter(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: state.giftCardDetailsModel!.card!.trx![index].type.toString() ==
                                                                            "Debit"
                                                                        ? Colors
                                                                            .red
                                                                        : Colors
                                                                            .green,
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          ]),
                                                    ),
                                                    state
                                                                .giftCardDetailsModel!
                                                                .card!
                                                                .trx![index]
                                                                .trxid
                                                                .toString() ==
                                                            ""
                                                        ? Container()
                                                        : Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        10),
                                                            child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    'Transaction Id',
                                                                    style: GoogleFonts
                                                                        .inter(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: Color(
                                                                          0xff2C2C2C),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      child:
                                                                          Text(
                                                                        state
                                                                            .giftCardDetailsModel!
                                                                            .card!
                                                                            .trx![index]
                                                                            .trxid
                                                                            .toString(),
                                                                        maxLines:
                                                                            2,
                                                                        textAlign:
                                                                            TextAlign.right,
                                                                        style: GoogleFonts
                                                                            .inter(
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          color:
                                                                              Color(0xffC4C4C4),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ]),
                                                          ),
                                                    state
                                                                .giftCardDetailsModel!
                                                                .card!
                                                                .trx![index]
                                                                .transactionDate
                                                                .toString() ==
                                                            ""
                                                        ? Container()
                                                        : Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        10),
                                                            child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    'Transaction Date',
                                                                    style: GoogleFonts
                                                                        .inter(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: Color(
                                                                          0xff2C2C2C),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      child:
                                                                          Text(
                                                                        state
                                                                            .giftCardDetailsModel!
                                                                            .card!
                                                                            .trx![index]
                                                                            .transactionDate
                                                                            .toString(),
                                                                        maxLines:
                                                                            2,
                                                                        textAlign:
                                                                            TextAlign.right,
                                                                        style: GoogleFonts
                                                                            .inter(
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          color:
                                                                              Color(0xffC4C4C4),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ]),
                                                          ),
                                                    state
                                                                .giftCardDetailsModel!
                                                                .card!
                                                                .trx![index]
                                                                .merchant
                                                                .toString() ==
                                                            ""
                                                        ? Container()
                                                        : Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        10),
                                                            child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    'Merchant',
                                                                    style: GoogleFonts
                                                                        .inter(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: Color(
                                                                          0xff2C2C2C),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      child:
                                                                          Text(
                                                                        state
                                                                            .giftCardDetailsModel!
                                                                            .card!
                                                                            .trx![index]
                                                                            .merchant
                                                                            .toString(),
                                                                        maxLines:
                                                                            2,
                                                                        textAlign:
                                                                            TextAlign.right,
                                                                        style: GoogleFonts
                                                                            .inter(
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          color:
                                                                              Color(0xffC4C4C4),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ]),
                                                          ),
                                                    state
                                                                .giftCardDetailsModel!
                                                                .card!
                                                                .trx![index]
                                                                .merchantName
                                                                .toString() ==
                                                            ""
                                                        ? Container()
                                                        : Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        10),
                                                            child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    'Merchant Name',
                                                                    style: GoogleFonts
                                                                        .inter(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: Color(
                                                                          0xff2C2C2C),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      child:
                                                                          Text(
                                                                        state
                                                                            .giftCardDetailsModel!
                                                                            .card!
                                                                            .trx![index]
                                                                            .merchantName
                                                                            .toString(),
                                                                        maxLines:
                                                                            2,
                                                                        textAlign:
                                                                            TextAlign.right,
                                                                        style: GoogleFonts
                                                                            .inter(
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          color:
                                                                              Color(0xffC4C4C4),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ]),
                                                          ),
                                                    state
                                                                .giftCardDetailsModel!
                                                                .card!
                                                                .trx![index]
                                                                .merchantCity
                                                                .toString() ==
                                                            ""
                                                        ? Container()
                                                        : Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        10),
                                                            child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    'Merchant City',
                                                                    style: GoogleFonts
                                                                        .inter(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: Color(
                                                                          0xff2C2C2C),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      child:
                                                                          Text(
                                                                        state
                                                                            .giftCardDetailsModel!
                                                                            .card!
                                                                            .trx![index]
                                                                            .merchantCity
                                                                            .toString(),
                                                                        maxLines:
                                                                            2,
                                                                        textAlign:
                                                                            TextAlign.right,
                                                                        style: GoogleFonts
                                                                            .inter(
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          color:
                                                                              Color(0xffC4C4C4),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ]),
                                                          ),
                                                    state
                                                                .giftCardDetailsModel!
                                                                .card!
                                                                .trx![index]
                                                                .merchantCountry
                                                                .toString() ==
                                                            ""
                                                        ? Container()
                                                        : Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        10),
                                                            child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    'Merchant Country',
                                                                    style: GoogleFonts
                                                                        .inter(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: Color(
                                                                          0xff2C2C2C),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      child:
                                                                          Text(
                                                                        state
                                                                            .giftCardDetailsModel!
                                                                            .card!
                                                                            .trx![index]
                                                                            .merchantCountry
                                                                            .toString(),
                                                                        maxLines:
                                                                            2,
                                                                        textAlign:
                                                                            TextAlign.right,
                                                                        style: GoogleFonts
                                                                            .inter(
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          color:
                                                                              Color(0xffC4C4C4),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ]),
                                                          ),
                                                    state
                                                                .giftCardDetailsModel!
                                                                .card!
                                                                .trx![index]
                                                                .description
                                                                .toString() ==
                                                            ""
                                                        ? Container()
                                                        : Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        10),
                                                            child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    'Description',
                                                                    style: GoogleFonts
                                                                        .inter(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: Color(
                                                                          0xff2C2C2C),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      child:
                                                                          Text(
                                                                        state
                                                                            .giftCardDetailsModel!
                                                                            .card!
                                                                            .trx![index]
                                                                            .description
                                                                            .toString(),
                                                                        maxLines:
                                                                            2,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        textAlign:
                                                                            TextAlign.right,
                                                                        style: GoogleFonts
                                                                            .inter(
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          color:
                                                                              Color(0xffC4C4C4),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ]),
                                                          ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                  ],
                                                ),
                                                // btnCancelText: 'Cancel',
                                                btnOkText: 'Ok',
                                                btnOkColor: Colors.green,
                                                buttonsTextStyle:
                                                    GoogleFonts.inter(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white),
                                                btnCancelOnPress: () {},
                                                btnOkOnPress: () {})
                                            .show();
                                      },
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 6),
                                        // Spacing between each item
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                            color: CustomColor
                                                .cryptoListContainerColor,
                                            borderRadius:
                                                BorderRadius.circular(16)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                      height: 55,
                                                      width: 55,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                         shape: BoxShape.circle,
                                                        color: CustomColor.whiteColor,
                                                         ),
                                                      child: Image.network(
                                                        state
                                                            .giftCardDetailsModel!
                                                            .card!
                                                            .trx![index]
                                                            .image
                                                            .toString(),
                                                        height: 30,
                                                        width: 30,
                                                        loadingBuilder:
                                                            (BuildContext
                                                                    context,
                                                                Widget child,
                                                                ImageChunkEvent?
                                                                    loadingProgress) {
                                                          if (loadingProgress ==
                                                              null) {
                                                            return child;
                                                          } else {
                                                            return Image.asset(
                                                              'images/master_card_logo.png',
                                                              height: 30,
                                                              width: 30,
                                                            ); // Show loading indicator
                                                          }
                                                        },
                                                        errorBuilder:
                                                            (BuildContext
                                                                    context,
                                                                Object error,
                                                                StackTrace?
                                                                    stackTrace) {
                                                          return Image.asset(
                                                            'images/master_card_logo.png',
                                                            height: 30,
                                                            width: 30,
                                                          ); // Show error icon if image loading fails
                                                        },
                                                      )),
                                                  const SizedBox(
                                                    width: 8,
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
                                                          state
                                                              .giftCardDetailsModel!
                                                              .card!
                                                              .trx![index]
                                                              .merchantName
                                                              .toString(),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              GoogleFonts.inter(
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .black),
                                                        ),
                                                        Text(
                                                          "Date: ${state.giftCardDetailsModel!.card!.trx![index].transactionDate.toString() ?? ""}",
                                                          style: GoogleFonts.inter(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Color(
                                                                  0xffC4C4C4)),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Status: ",
                                                              style: GoogleFonts.inter(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Color(
                                                                      0xffC4C4C4)),
                                                            ),
                                                            Text(
                                                              state
                                                                  .giftCardDetailsModel!
                                                                  .card!
                                                                  .trx![index]
                                                                  .status
                                                                  .toString(),
                                                              style: GoogleFonts.inter(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: state
                                                                              .giftCardDetailsModel!
                                                                              .card!
                                                                              .trx![
                                                                                  index]
                                                                              .status
                                                                              .toString() ==
                                                                          "declined"
                                                                      ? Colors
                                                                          .red
                                                                      : Colors
                                                                          .green),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "${state.giftCardDetailsModel!.card!.trx![index].symbol.toString() ?? ""}${state.giftCardDetailsModel!.card!.trx![index].amount.toString() ?? ""}",
                                                  style: GoogleFonts.inter(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: state
                                                                  .giftCardDetailsModel!
                                                                  .card!
                                                                  .trx![index]
                                                                  .type
                                                                  .toString() ==
                                                              "Debit"
                                                          ? Colors.red
                                                          : Colors.green),
                                                ),
                                                Text(
                                                  state
                                                          .giftCardDetailsModel!
                                                          .card!
                                                          .trx![index]
                                                          .type
                                                          .toString() ??
                                                      "",
                                                  style: GoogleFonts.inter(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: state
                                                                  .giftCardDetailsModel!
                                                                  .card!
                                                                  .trx![index]
                                                                  .type
                                                                  .toString() ==
                                                              "Debit"
                                                          ? Colors.red
                                                          : Colors.green),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }

  _detailsWidget(
      BuildContext context, String cardNumber, String expiryDate, String cvv) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //show Details
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
              icon: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomImageWidget(
                    imagePath: StaticAssets.showDetails,
                    imageType: 'svg',
                    height: 24,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text("Show\n Details",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                            color: Color.fromRGBO(51, 51, 51, 1),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            height: 1)),
                  )
                ],
              ),
              onPressed: () {
                AwesomeDialog(
                    context: context,
                    dialogType: DialogType.noHeader,
                    btnCancelColor: CustomColor.primaryColor,
                    dialogBackgroundColor: Colors.white,
                    animType: AnimType.scale,
                    body: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Card Number',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xff2C2C2C),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        cardNumber,
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xffC4C4C4),
                                        ),
                                      ),
                                    ),
                                  )
                                ]),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Expiry Date',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xff2C2C2C),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        expiryDate,
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xffC4C4C4),
                                        ),
                                      ),
                                    ),
                                  )
                                ]),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'CVV',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xff2C2C2C),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        cvv,
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xffC4C4C4),
                                        ),
                                      ),
                                    ),
                                  )
                                ]),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                    btnCancelText: 'Cancel',
                    btnOkText: 'Copy',
                    btnOkColor: Colors.green,
                    buttonsTextStyle: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                    btnCancelOnPress: () {},
                    btnOkOnPress: () {
                      Clipboard.setData(ClipboardData(
                              text: "$cardNumber\n$expiryDate\n$cvv"))
                          .then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Copied to clipboard!',
                              style: GoogleFonts.inter(color: Colors.white),
                            ),
                          ),
                        );
                      });
                    }).show();
              },
            ),
          ),
          //share
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
              icon: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomImageWidget(
                    imagePath: StaticAssets.share,
                    imageType: 'svg',
                    height: 24,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text("Share",
                        style: GoogleFonts.inter(
                            color: Color.fromRGBO(51, 51, 51, 1),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            height: 1)),
                  )
                ],
              ),
              onPressed: () {
                final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
                final TextEditingController _emailController =
                    TextEditingController();
                final TextEditingController _nameController =
                    TextEditingController();

                AwesomeDialog(
                    context: context,
                    dialogType: DialogType.noHeader,
                    btnCancelColor: Colors.red,
                    dialogBackgroundColor: Colors.white,
                    animType: AnimType.scale,
                    body: Form(
                      key: _formKey,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Column(
                          children: [
                            Text(
                              "Share Your Gift Card ",
                              style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: CustomColor.black),
                            ),
                            DefaultInputFieldWithTitleWidget(
                              controller: _nameController,
                              title: 'Name',
                              hint: 'Enter Name',
                              isEmail: false,
                              keyboardType: TextInputType.name,
                              autofocus: true,
                              isPassword: false,
                            ),
                            DefaultInputFieldWithTitleWidget(
                              controller: _emailController,
                              title: 'Email',
                              hint: 'Enter Email',
                              isEmail: true,
                              keyboardType: TextInputType.name,
                              autofocus: true,
                              isPassword: false,
                            ),
                          ],
                        ),
                      ),
                    ),
                    btnCancelText: 'cancel',
                    btnOkText: 'Share',
                    btnOkColor: CustomColor.primaryColor,
                    buttonsTextStyle: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: CustomColor.whiteColor),
                    btnCancelOnPress: () {},
                    btnOkOnPress: () {
                      if (_formKey.currentState!.validate()) {
                        _giftCardDetailsBloc.add(GiftCardShareEvent());
                      } else {
                        // _giftCardDetailsBloc.add(GiftCardShareEvent());
                        print('cant do');
                      }
                    }).show();
              },
            ),
          ),

          //delete
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
              icon: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomImageWidget(
                    imagePath: StaticAssets.delete,
                    imageType: 'svg',
                    height: 24,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text("Delete",
                        style: GoogleFonts.inter(
                          color: CustomColor.errorColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        )),
                  )
                ],
              ),
              onPressed: () {
                AwesomeDialog(
                    context: context,
                    dialogType: DialogType.noHeader,
                    title: "Gift Card",
                    desc: "Are you Sure?",
                    titleTextStyle: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: CustomColor.black),
                    descTextStyle: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: CustomColor.black.withOpacity(0.7)),
                    btnCancelColor: CustomColor.green,
                    dialogBackgroundColor: Colors.white,
                    animType: AnimType.scale,
                    btnCancelText: 'cancel',
                    btnOkText: 'Delete',
                    btnOkColor: CustomColor.errorColor,
                    buttonsTextStyle: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                    btnCancelOnPress: () {},
                    btnOkOnPress: () {
                      _giftCardDetailsBloc.add((GiftCardDeleteEvent()));

                      Navigator.pushNamed(context, 'buyGiftCardScreen');
                    }).show();
              },
            ),
          )
        ],
      ),
    );
  }

  _transactionTitleWidget(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.only(top: 10, bottom: 5),
      child: Text("Transaction Logs",
          style: GoogleFonts.inter(
            color: CustomColor.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          )),
    );
  }
}
