import 'package:gptbanqbusiness/Screens/transfer_screen/bloc/transfer_bloc.dart';
import 'package:gptbanqbusiness/constant_string/User.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:gptbanqbusiness/utils/input_fields/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/buttons/default_back_button_widget.dart';
import '../../widgets/main/transaction_card_widget.dart';
import '../../widgets/toast/toast_util.dart';

class BeneficiaryUserDetailsScreen extends StatefulWidget {
  BeneficiaryUserDetailsScreen({
    super.key,
    required this.userId,
  });

  String userId;

  @override
  State<BeneficiaryUserDetailsScreen> createState() =>
      _BeneficiaryUserDetailsScreenState();
}

class _BeneficiaryUserDetailsScreenState
    extends State<BeneficiaryUserDetailsScreen>
    with SingleTickerProviderStateMixin {
  final TransferBloc _transferBloc = TransferBloc();
  bool details = true;

  @override
  void initState() {
    super.initState();
    // _dashboardBloc.add(DashboarddataEvent());
    User.Screen = 'Notification Screen';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.notificationBgColor,
      body: BlocListener(
          bloc: _transferBloc,
          listener: (context, TransferState state) async {
            if (state.statusModel?.status == 0) {
              CustomToast.showError(
                  context, "Sorry!", state.statusModel!.message!);
            }
          },
          child: BlocBuilder(
              bloc: _transferBloc,
              builder: (context, TransferState state) {
                return SafeArea(
                  child: ProgressHUD(
                    inAsyncCall: state.isloading,
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Column(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              appBarSection(context, state),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Ranjit Sing",
                                        style: GoogleFonts.inter(
                                          color: CustomColor.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20,
                                        )),
                                    Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  "https://icons.veryicon.com/png/o/miscellaneous/icon-icon-of-ai-intelligent-dispensing/login-user-name-1.png"))),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  color:
                                      CustomColor.currencyCustomSelectorColor,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            details = true;
                                          });
                                        },
                                        child: Container(
                                          height: 41,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(24),
                                            color: details
                                                ? CustomColor.whiteColor
                                                : CustomColor
                                                    .currencyCustomSelectorColor,
                                            boxShadow: details
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
                                            'Details',
                                            style: GoogleFonts.inter(
                                                color: details
                                                    ? CustomColor.black
                                                    : CustomColor.black
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
                                            details = false;
                                          });
                                        },
                                        child: Container(
                                          height: 41,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(24),
                                            color: details
                                                ? CustomColor
                                                    .currencyCustomSelectorColor
                                                : CustomColor.whiteColor,
                                            boxShadow: details
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
                                            'Transactions',
                                            style: GoogleFonts.inter(
                                                color: details
                                                    ? CustomColor.black
                                                        .withOpacity(0.6)
                                                    : CustomColor.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              details
                                  ? Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(16),
                                          margin: EdgeInsets.symmetric(
                                              vertical: 10),
                                          decoration: BoxDecoration(
                                              color: CustomColor.whiteColor,
                                              borderRadius:
                                                  BorderRadius.circular(16)),
                                          child: Column(
                                            children: [
                                              BeneficiaryInfoWidget(
                                                label: "Total sent",
                                                title: "00" ?? "",
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                              color: CustomColor.whiteColor,
                                              borderRadius:
                                                  BorderRadius.circular(16)),
                                          child: Column(
                                            children: [
                                              BeneficiaryInfoWidget(
                                                label: "IBAN",
                                                title: "asdfaskjdfjhh" ?? "",
                                              ),
                                              BeneficiaryInfoWidget(
                                                label: "BIC/Swift",
                                                title: "asdfaskjdfjhh" ?? "",
                                              ),
                                              BeneficiaryInfoWidget(
                                                label: "Country/region",
                                                title: "asdfaskjdfjhh" ?? "",
                                              ),
                                              BeneficiaryInfoWidget(
                                                label: "Currency",
                                                title: "asdfaskjdfjhh" ?? "",
                                              ),
                                            ],
                                          ),
                                        ),

                                        Container(
                                          padding: EdgeInsets.all(16),
                                          margin: EdgeInsets.symmetric(
                                              vertical: 10),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              color: CustomColor.whiteColor,
                                              borderRadius:
                                                  BorderRadius.circular(16)),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Address",
                                                style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14,
                                                  color: CustomColor
                                                      .touchIdSubtitleTextColor,
                                                ),
                                              ),
                                              Text(
                                                "asdlkjfahskdf\nsdfhhsldjhf\nasjdhfdjhs\ajhdvfjahdf",
                                                style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15,
                                                  color: CustomColor
                                                      .transactionDetailsTextColor
                                                      .withOpacity(0.7),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Container(
                                        //   padding: EdgeInsets.all(16),
                                        //   margin:
                                        //       EdgeInsets.symmetric(vertical: 10),
                                        //   decoration: BoxDecoration(
                                        //       color: CustomColor.whiteColor,
                                        //       borderRadius:
                                        //           BorderRadius.circular(16)),
                                        //   child: Column(
                                        //     children: [
                                        //       Container(
                                        //         padding: EdgeInsets.all(8),
                                        //         child: Row(
                                        //           children: [
                                        //             Container(
                                        //                 margin: EdgeInsets.only(
                                        //                     right: 10),
                                        //                 padding: EdgeInsets.all(10),
                                        //                 decoration: BoxDecoration(
                                        //                   borderRadius:
                                        //                       BorderRadius.circular(
                                        //                           12.0),
                                        //                   color: CustomColor
                                        //                       .primaryColor,
                                        //                 ),
                                        //                 child: CustomImageWidget(
                                        //                   imagePath: StaticAssets
                                        //                       .shieldDollar,
                                        //                   imageType: 'svg',
                                        //                   height: 30,
                                        //                 )),
                                        //             Expanded(
                                        //               child: Column(
                                        //                 mainAxisAlignment:
                                        //                     MainAxisAlignment.start,
                                        //                 crossAxisAlignment:
                                        //                     CrossAxisAlignment
                                        //                         .start,
                                        //                 children: [
                                        //                   Text(
                                        //                     "Protected Deposit",
                                        //                     style:
                                        //                         GoogleFonts.inter(
                                        //                       color:
                                        //                           CustomColor.black,
                                        //                       fontSize: 14,
                                        //                       fontWeight:
                                        //                           FontWeight.w500,
                                        //                     ),
                                        //                   ),
                                        //                   Text(
                                        //                     "Your money is protected by the Lithuanian Deposit Guarantee Scheme.",
                                        //                     style:
                                        //                         GoogleFonts.inter(
                                        //                       color: CustomColor
                                        //                           .primaryTextHintColor,
                                        //                       fontSize: 12,
                                        //                       fontWeight:
                                        //                           FontWeight.w400,
                                        //                     ),
                                        //                   ),
                                        //                 ],
                                        //               ),
                                        //             ),
                                        //           ],
                                        //         ),
                                        //       ),
                                        //       Divider(
                                        //         color: CustomColor
                                        //             .dashboardProfileBorderColor,
                                        //       ),
                                        //       Container(
                                        //         padding: EdgeInsets.all(8),
                                        //         child: Row(
                                        //           children: [
                                        //             Container(
                                        //                 margin: EdgeInsets.only(
                                        //                     right: 10),
                                        //                 padding: EdgeInsets.all(10),
                                        //                 decoration: BoxDecoration(
                                        //                   borderRadius:
                                        //                       BorderRadius.circular(
                                        //                           12.0),
                                        //                   color: CustomColor
                                        //                       .primaryColor,
                                        //                 ),
                                        //                 child: CustomImageWidget(
                                        //                   imagePath:
                                        //                       StaticAssets.light,
                                        //                   imageType: 'svg',
                                        //                   height: 30,
                                        //                 )),
                                        //             Expanded(
                                        //               child: Column(
                                        //                 mainAxisAlignment:
                                        //                     MainAxisAlignment.start,
                                        //                 crossAxisAlignment:
                                        //                     CrossAxisAlignment
                                        //                         .start,
                                        //                 children: [
                                        //                   Text(
                                        //                     "Cross-platform transfer",
                                        //                     style:
                                        //                         GoogleFonts.inter(
                                        //                       color:
                                        //                           CustomColor.black,
                                        //                       fontSize: 14,
                                        //                       fontWeight:
                                        //                           FontWeight.w500,
                                        //                     ),
                                        //                   ),
                                        //                   Text(
                                        //                     "Receive transfers from Euro bank into your Revolut Payments Account using these details.",
                                        //                     style:
                                        //                         GoogleFonts.inter(
                                        //                       color: CustomColor
                                        //                           .primaryTextHintColor,
                                        //                       fontSize: 12,
                                        //                       fontWeight:
                                        //                           FontWeight.w400,
                                        //                     ),
                                        //                   ),
                                        //                 ],
                                        //               ),
                                        //             ),
                                        //           ],
                                        //         ),
                                        //       ),
                                        //     ],
                                        //   ),
                                        // )
                                      ],
                                    )
                                  : Expanded(
                                      child: ListView.builder(
                                        itemCount: 10,
                                        shrinkWrap: true,
                                        physics:
                                            AlwaysScrollableScrollPhysics(),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          // var today = state
                                          //     .dashboardModel!
                                          //     .transaction!
                                          //     .today![index];
                                          return TransactionCardWidget(
                                            uniqueId: "user id",
                                            image: "laskdjfjl",
                                            beneficiaryName: "Azad Hossain",
                                            reasonPayment:
                                                "exchange transaction",
                                            created: "20/12/2024",
                                            amount: "200",
                                            status: "sent",
                                            type: "Credit",
                                            onTap: () {
                                              // trx_uniquid = today
                                              //     .unique_id!;
                                              // _dashboardBloc.add(
                                              //     transactiondetailsEvent(
                                              //         uniqueId:
                                              //         trx_uniquid));
                                            },
                                          );
                                        },
                                      ),
                                    )
                            ],
                          ),
                          if (details == false)
                            Positioned(
                              bottom: 0,
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushNamedAndRemoveUntil(context,
                                      'addBeneficiaryScreen', (route) => false);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                  margin: EdgeInsets.symmetric(vertical: 20),
                                  decoration: BoxDecoration(
                                    color: CustomColor.primaryColor,
                                    borderRadius: BorderRadius.circular(48),
                                  ),
                                  child: Text(
                                    "Send",
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: CustomColor.whiteColor),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              })),
    );
  }

  appBarSection(BuildContext context, state) {
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DefaultBackButtonWidget(
            onTap: () {
              Navigator.pop(context);
            },
          ),
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
    );
  }
}

void copyToClipboard(BuildContext context, String textToCopy) {
  // Copy the text to the clipboard
  Clipboard.setData(ClipboardData(text: textToCopy)).then((_) {
    // Show a SnackBar to indicate that the text was copied
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied to clipboard!'),
        duration: Duration(seconds: 2), // Show for 2 seconds
      ),
    );
  });
}

class BeneficiaryInfoWidget extends StatelessWidget {
  final String label;
  String? title;

  BeneficiaryInfoWidget({
    super.key,
    required this.label,
    this.title = "",
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: CustomColor.touchIdSubtitleTextColor,
            ),
          ),
          Text(
            title!,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: CustomColor.transactionDetailsTextColor.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
