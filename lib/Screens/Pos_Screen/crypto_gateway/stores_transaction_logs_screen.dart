import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:gptbanqbusiness/Screens/Pos_Screen/bloc/pos_bloc.dart';
import 'package:gptbanqbusiness/utils/assets.dart';
import 'package:gptbanqbusiness/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gptbanqbusiness/constant_string/User.dart';
import 'package:gptbanqbusiness/cutom_weidget/custom_navigationBar.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screenshot/screenshot.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Models/pos/store_transaction_log_model.dart';
import '../../../utils/input_fields/custom_color.dart';
import '../../../widgets/buttons/custom_floating_action_button.dart';
import '../../../widgets/buttons/default_back_button_widget.dart';
import '../../../widgets/toast/toast_util.dart';

class StoresTransactionLogsScreen extends StatefulWidget {
  StoresTransactionLogsScreen({
    super.key,
    required this.storeId,
    required this.storeName,
  });

  String storeId, storeName;

  @override
  State<StoresTransactionLogsScreen> createState() =>
      _StoresTransactionLogsScreenState();
}

class _StoresTransactionLogsScreenState
    extends State<StoresTransactionLogsScreen> {
  bool active = false;

  bool shownotification = true;
  final PosBloc _posBloc = PosBloc();

  TextEditingController storeController = TextEditingController();

  Future<void> _onRefresh() async {
    debugPrint('_onRefresh');

    _posBloc.add(StoreTransactionLogEvent(storeId: widget.storeId));
  }

  @override
  void initState() {
    super.initState();
    User.Screen = 'Stores Transaction Log screen';
    _posBloc.add(StoreTransactionLogEvent(storeId: widget.storeId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.scaffoldBg,
        floatingActionButtonLocation:
        FloatingActionButtonLocation.centerFloat,
      body: BlocListener(
          bloc: _posBloc,
          listener: (context, PosState state) {
            if (state.statusModel?.status == 0) {
              CustomToast.showError(
                  context, "Sorry!", state.statusModel!.message!);
            }
          },
          child: BlocBuilder(
              bloc: _posBloc,
              builder: (context, PosState state) {
                return SafeArea(
                  child: ProgressHUD(
                    inAsyncCall: state.isloading,
                    child: RefreshIndicator(
                      onRefresh: _onRefresh,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        child: Column(
                          // mainAxisAlignment:
                          //     MainAxisAlignment.start,
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
                                            height: 80,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                              color: CustomColor
                                                  .kycContainerBgColor, // Using hex color with opacity
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    CustomImageWidget(
                                                      imagePath:
                                                          StaticAssets.paid,
                                                      imageType: 'svg',
                                                      height: 26,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 5),
                                                      child: Text(
                                                        "Paid Amount",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: GoogleFonts.inter(
                                                            color: CustomColor
                                                                .black
                                                                .withOpacity(
                                                                    0.4),
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  "${state.storeTransactionLogModel!.totalPaid}",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.inter(
                                                      color: CustomColor.black,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Container(
                                            height: 80,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                              color: CustomColor
                                                  .kycContainerBgColor, // Using hex color with opacity
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    CustomImageWidget(
                                                      imagePath:
                                                          StaticAssets.unpaid,
                                                      imageType: 'svg',
                                                      height: 26,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 5),
                                                      child: Text(
                                                        "Unpaid Amount",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: GoogleFonts.inter(
                                                            color: CustomColor
                                                                .black
                                                                .withOpacity(
                                                                    0.4),
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  "${state.storeTransactionLogModel!.totalUnpaid}",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.inter(
                                                      color: CustomColor.black,
                                                      fontSize: 18,
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
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Transaction Logs',
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.inter(
                                      color: CustomColor.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  // Icon(Icons.search, ),
                                  SizedBox(),
                                ],
                              ),
                            ),

                            state.storeTransactionLogModel!.log!.isEmpty
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
                                : Expanded(
                                    child: ListView.builder(
                                        itemCount: state
                                            .storeTransactionLogModel!
                                            .log!
                                            .length,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              showBottomSheet(
                                                context: context,
                                                elevation: 5,
                                                builder: (context) {
                                                  return BottomSheetContentStep1(
                                                    status: state
                                                        .storeTransactionLogModel!
                                                        .log![index]
                                                        .status!,
                                                    date: state
                                                        .storeTransactionLogModel!
                                                        .log![index]
                                                        .date
                                                        .toString(),
                                                    transactionId: state
                                                        .storeTransactionLogModel!
                                                        .log![index]
                                                        .transactionId!,
                                                    amount: state
                                                        .storeTransactionLogModel!
                                                        .log![index]
                                                        .amount!,
                                                    paidAmount: state
                                                        .storeTransactionLogModel!
                                                        .log![index]
                                                        .paidAmount!,
                                                    network: state
                                                        .storeTransactionLogModel!
                                                        .log![index]
                                                        .network!,
                                                    coin: state
                                                        .storeTransactionLogModel!
                                                        .log![index]
                                                        .coin!,
                                                    cryptoAmount: state
                                                        .storeTransactionLogModel!
                                                        .log![index]
                                                        .cryptoAmount!,
                                                    link: state
                                                        .storeTransactionLogModel!
                                                        .log![index]
                                                        .link!,
                                                    fees: state
                                                        .storeTransactionLogModel!
                                                        .log![index]
                                                        .fee!,
                                                  );
                                                },
                                              );
                                            },
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 0, vertical: 5),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 12, vertical: 8),
                                              decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                  color: CustomColor
                                                      .cryptoListContainerColor),
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
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                              state
                                                                  .storeTransactionLogModel!
                                                                  .log![index]
                                                                  .amount!,
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: GoogleFonts.inter(
                                                                  color: Color(
                                                                      0xff000000),
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  height: 1),
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 120,
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        10,
                                                                    vertical:
                                                                        8),
                                                            child: Text(
                                                              'Trx id: ${state.storeTransactionLogModel!.log![index].transactionId!}',
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: GoogleFonts.inter(
                                                                  color: Color(
                                                                      0xff000000),
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  height: 1),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          '${state.storeTransactionLogModel!.log![index].date!}',
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: GoogleFonts.inter(
                                                              color: Color(
                                                                  0xff000000),
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              height: 1),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          state
                                                              .storeTransactionLogModel!
                                                              .log![index]
                                                              .status!,
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: GoogleFonts.inter(
                                                              color: state
                                                                          .storeTransactionLogModel!
                                                                          .log![
                                                                              index]
                                                                          .status! ==
                                                                      "Paid"
                                                                  ? Colors.green
                                                                  : Colors
                                                                      .orangeAccent,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              height: 1),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                            // Container(
                            //   alignment: Alignment.bottomCenter,
                            //   padding:
                            //       const EdgeInsets.symmetric(vertical: 5),
                            //   child:  Text(
                            //     '***${widget.profit} Profit in ${widget.time}\n***Daily profit payment',
                            //     textAlign: TextAlign.left,
                            //     style: const TextStyle(
                            //         color: Color.fromRGBO(0, 0, 0, 1),
                            //         fontFamily: 'Poppins',
                            //         fontSize: 10,
                            //         fontWeight: FontWeight.normal,
                            //         height: 1),
                            //   ),
                            // )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              })),

        floatingActionButton: CustomFloatingActionButton()
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
            'Merchant Transaction',
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

  _selectStoreNameWidget(BuildContext context, List<Storename> storeName,
      TextEditingController controller) {
    String? selectedLabel;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: DropdownButtonFormField<String>(
        value: controller.text.isNotEmpty
            ? controller.text
            : storeName.isNotEmpty
                ? storeName.first.storeId!
                : null,
        iconEnabledColor: const Color(0xff10245C),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11),
            borderSide: const BorderSide(color: Color(0xff10245C)),
          ),
        ),
        onChanged: (selectedValue) {
          if (selectedValue != null) {
            final selectedIban = storeName.isNotEmpty
                ? storeName.firstWhere(
                    (storeName) => storeName.storeId == selectedValue)
                : null;
            if (selectedIban != null) {
              controller.text = selectedIban.storeId!;
              // UserDataManager()
              //     .giftCardIbanSave(selectedIban.ibanId.toString());
            }
          }
        },
        items: storeName.map<DropdownMenuItem<String>>((Storename storeName) {
          return DropdownMenuItem<String>(
            value: storeName.storeId!,
            child: Text(
              storeName.label!,
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'pop',
                color: Color(0xff10245C),
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/*----------------transaction details----------------*/

class BottomSheetContentStep1 extends StatefulWidget {
  BottomSheetContentStep1(
      {super.key,
      required this.status,
      required this.date,
      required this.transactionId,
      required this.amount,
      required this.paidAmount,
      required this.network,
      required this.cryptoAmount,
      required this.link,
      required this.fees,
      required this.coin});

  String transactionId,
      coin,
      network,
      amount,
      paidAmount,
      status,
      date,
      cryptoAmount,
      link,
      fees;

  @override
  State<BottomSheetContentStep1> createState() =>
      _BottomSheetContentStep1State();
}

class _BottomSheetContentStep1State extends State<BottomSheetContentStep1> {
  final PosBloc _posBloc = PosBloc();

  @override
  void initState() {
    super.initState();
    // _cardOrderDetailsBloc.add(CardFeeEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _posBloc,
      listener: (context, PosState state) {
        if (state.statusModel?.status == 0) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            desc: state.statusModel?.message,
            btnCancelText: 'OK',
            buttonsTextStyle: const TextStyle(
                fontSize: 14,
                fontFamily: 'pop',
                fontWeight: FontWeight.w600,
                color: Colors.white),
            btnCancelOnPress: () {},
          ).show();
        }

        // if (state.cardOrderConfirmModel?.status == 1) {
        //   Navigator.pushNamedAndRemoveUntil(
        //       context, 'cardScreen', (route) => false);
        // }
      },
      child: BlocBuilder(
          bloc: _posBloc,
          builder: (context, PosState state) {
            return Material(
              color: CustomColor.whiteColor,

              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16)), // Rounded top corners
              child: Container(
                height: 360,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(
                        20), // Match the border radius of Material
                  ),
                  border: Border(
                    top: BorderSide(
                      color: Color(0xff797777),
                      width: 1, // Set the thickness of the top border
                    ),
                  ),
                ),
                child: ProgressHUD(
                  inAsyncCall: state.isloading,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: CustomImageWidget(
                              imagePath: StaticAssets.xClose,
                              imageType: 'svg',
                              height: 26,
                            ),
                          ),
                        ),
                        Container(
                          // width: 315
                          // height: 293,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                            color: CustomColor.hubContainerBgColor,
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                     Text(
                                      'Amount',
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.inter(
                                          color: CustomColor.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          height: 1),
                                    ),
                                    Text(
                                      widget.amount.toUpperCase(),
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.inter(
                                          color: CustomColor.black.withOpacity(0.7),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          height: 1),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                     Text(
                                      'Fees',
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.inter(
                                          color: CustomColor.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          height: 1),
                                    ),
                                    Text(
                                      widget.fees.toUpperCase(),
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.inter(
                                          color: CustomColor.black.withOpacity(0.7),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          height: 1),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                     Text(
                                      'Paid Amount',
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.inter(
                                          color: CustomColor.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          height: 1),
                                    ),
                                    Text(
                                      widget.paidAmount.toUpperCase(),
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.inter(
                                          color: CustomColor.black.withOpacity(0.7),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          height: 1),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                     Text(
                                      'Crypto Amount',
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.inter(
                                          color: CustomColor.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          height: 1),
                                    ),
                                    Text(
                                      widget.cryptoAmount.toUpperCase(),
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.inter(
                                          color: CustomColor.black.withOpacity(0.7),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          height: 1),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                     Text(
                                      'Coin',
                                      textAlign: TextAlign.left,
                                       style: GoogleFonts.inter(
                                           color: CustomColor.black,
                                           fontSize: 15,
                                           fontWeight: FontWeight.w500,
                                           height: 1),
                                    ),
                                    Text(
                                      widget.coin.toUpperCase(),
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.inter(
                                          color: CustomColor.black.withOpacity(0.7),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          height: 1),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                     Text(
                                      'Transaction Id',
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.inter(
                                          color: CustomColor.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          height: 1),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: InkWell(
                                          onTap: () async {
                                            await launchUrl(Uri.parse(widget.link));
                                          },
                                          child: Text(
                                            widget.transactionId,
                                            maxLines: 1,
                                            textAlign: TextAlign.right,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.inter(
                                                color: CustomColor.primaryColor,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                height: 1),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                     Text(
                                      'Status',
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.inter(
                                          color: CustomColor.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          height: 1),
                                    ),
                                    Text(
                                      widget.status.toUpperCase(),
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.inter(
                                          color: widget.status == "Paid"
                                              ? Colors.green
                                              : Colors.orangeAccent,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          height: 1),
                                    )
                                  ],
                                ),
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
          }),
    );
  }
}
