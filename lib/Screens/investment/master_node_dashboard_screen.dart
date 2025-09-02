import 'package:gptbanqbusiness/Screens/investment/bloc/investment_bloc.dart';
import 'package:gptbanqbusiness/Screens/investment/investment_screen.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gptbanqbusiness/constant_string/User.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Models/stake/iban_get_custom_account_model.dart';
import '../../utils/assets.dart';
import '../../utils/input_fields/custom_color.dart';
import '../../widgets/buttons/default_back_button_widget.dart';
import '../../widgets/buttons/primary_button_widget.dart';
import '../../widgets/custom_image_widget.dart';
import '../../widgets/main/default_dropdown_field_with_title_widget.dart';
import '../../widgets/toast/toast_util.dart';
import 'master_node_details_screen.dart';

class MasterNodeDashboardScreen extends StatefulWidget {
  const MasterNodeDashboardScreen({super.key});

  @override
  State<MasterNodeDashboardScreen> createState() =>
      _MasterNodeDashboardScreenState();
}

class _MasterNodeDashboardScreenState extends State<MasterNodeDashboardScreen> {
  bool active = false;

  bool shownotification = true;
  final InvestmentBloc _investmentBloc = InvestmentBloc();

  Future<void> _onRefresh() async {
    debugPrint('_onRefresh');

    _investmentBloc.add(NodeLogsEvent());
  }

  @override
  void initState() {
    super.initState();
    User.Screen = 'investment dashboard screen';
    _investmentBloc.add(NodeLogsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.scaffoldBg,
      body: BlocListener(
          bloc: _investmentBloc,
          listener: (context, InvestmentState state) {
            if (state.statusModel?.status == 0) {
              CustomToast.showError(
                  context, "Sorry!", state.statusModel!.message!);
            }
          },
          child: BlocBuilder(
              bloc: _investmentBloc,
              builder: (context, InvestmentState state) {
                return SafeArea(
                  child: ProgressHUD(
                    inAsyncCall: state.isloading,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: RefreshIndicator(
                        onRefresh: _onRefresh,
                        child: Column(
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 30, top: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      DefaultBackButtonWidget(onTap: () {
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            'investmentScreen',
                                            (route) => false);
                                      }),
                                      Text(
                                        'MasterNode Dashboard',
                                        style: GoogleFonts.inter(
                                            color: CustomColor.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Container(
                                        width: 15,
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                  decoration: BoxDecoration(
                                    color: CustomColor.whiteColor,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            CustomColor.black.withOpacity(0.4),
                                        offset: Offset(0, 1), // 0px 1px
                                        blurRadius: 8, // 8px
                                        spreadRadius: -2, // -2px
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 8),
                                            child: Image.asset(
                                              "images/investment/t_icon.png",
                                              height: 40,
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 3),
                                                child: Text("Available balance",
                                                    style: GoogleFonts.inter(
                                                      color: CustomColor
                                                          .primaryTextHintColor,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    )),
                                              ),
                                              Text(
                                                  "${state.nodeLogsModel?.availableBalance}",
                                                  style: GoogleFonts.inter(
                                                    color: CustomColor.black,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                  )),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Container(
                                        alignment: Alignment.centerRight,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 8),
                                        decoration: BoxDecoration(
                                            color: Color(0xff8F8F8F),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        // padding:
                                        //     const EdgeInsets.only(right: 10),
                                        child: Image.asset(
                                          "images/investment/masternode.png",
                                          height: 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                  margin: EdgeInsets.symmetric(vertical: 20),
                                  decoration: BoxDecoration(
                                    color: CustomColor.whiteColor,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            CustomColor.black.withOpacity(0.4),
                                        offset: Offset(0, 1), // 0px 1px
                                        blurRadius: 8, // 8px
                                        spreadRadius: -2, // -2px
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Total MasterNode :',
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.inter(
                                            color: CustomColor.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        '${state.nodeLogsModel?.numberNode}',
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.inter(
                                            color: CustomColor.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                                PrimaryButtonWidget(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      elevation: 5,
                                      builder: (context) {
                                        return SizedBox(
                                          height: MediaQuery.of(context).size.height * 0.7, // 50% of screen height
                                          child: const BottomSheetContentStep1(),
                                        );
                                      },
                                    );
                                  },
                                  buttonText: 'Buy Virtual MasterNode',
                                ),
                              ],
                            ),
                            if (state.nodeLogsModel!.order!.isNotEmpty)
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Transactions',
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.inter(
                                      color: CustomColor.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            Expanded(
                              child: ListView.builder(
                                  itemCount: state.nodeLogsModel?.order!.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            type: PageTransitionType.scale,
                                            alignment: Alignment.center,
                                            isIos: true,
                                            duration: const Duration(
                                                microseconds: 500),
                                            child: MasterNodeDetailsScreen(
                                              orderId: state.nodeLogsModel!
                                                  .order![index].orderId!,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 5,
                                          ),
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                            color:
                                                CustomColor.hubContainerBgColor,
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      'ID ${state.nodeLogsModel?.order![index].orderId}',
                                                      textAlign: TextAlign.left,
                                                      style: GoogleFonts.inter(
                                                        color:
                                                            Color(0xff000000),
                                                        fontSize: 8,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      '${state.nodeLogsModel?.order![index].start} / ${state.nodeLogsModel?.order![index].end}',
                                                      textAlign: TextAlign.left,
                                                      style: GoogleFonts.inter(
                                                        color:
                                                            Color(0xff000000),
                                                        fontSize: 8,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.75,
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 5),
                                                      child: Column(
                                                        children: [
                                                          SfLinearGauge(
                                                            axisTrackExtent: 0,
                                                            showTicks: false,
                                                            showLabels: false,
                                                            barPointers: [
                                                              LinearBarPointer(
                                                                value: double.parse(state
                                                                    .nodeLogsModel!
                                                                    .order![
                                                                        index]
                                                                    .profitPercentage!
                                                                    .toString()),
                                                                color: const Color(
                                                                    0xff3F56D1),
                                                              ),
                                                            ],
                                                            markerPointers: [
                                                              LinearWidgetPointer(
                                                                value: double.parse(state
                                                                    .nodeLogsModel!
                                                                    .order![
                                                                        index]
                                                                    .profitPercentage!
                                                                    .toString()),
                                                                child:
                                                                    Image.asset(
                                                                  "images/investment/t_icon.png",
                                                                  height: 14,
                                                                  width: 14,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Container(
                                                            width: 260,
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        10),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Flexible(
                                                                  child: Text(
                                                                    'Profit Generated ',
                                                                    style: GoogleFonts
                                                                        .inter(
                                                                      color: Color(
                                                                          0xff000000),
                                                                      fontSize:
                                                                          6,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Flexible(
                                                                  child: Text(
                                                                    '${state.nodeLogsModel?.order![index].paidProfit}',
                                                                    style: GoogleFonts
                                                                        .inter(
                                                                      color: Color(
                                                                          0xff000000),
                                                                      fontSize:
                                                                          8,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    // width: MediaQuery.of(context).size.width * 0.6,
                                                    // alignment:
                                                    //     Alignment.centerRight,
                                                    // padding:
                                                    //     const EdgeInsets.all(
                                                    //         8.0),
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          '${state.nodeLogsModel?.order![index].profitPercentage}%',
                                                          maxLines: 4,
                                                          textAlign:
                                                              TextAlign.center,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              GoogleFonts.inter(
                                                            color: CustomColor
                                                                .green,
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 20.h,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                            // Container(
                            //   alignment: Alignment.bottomCenter,
                            //   padding:
                            //       const EdgeInsets.symmetric(vertical: 5),
                            //   child: Text(
                            //     '***${widget.profit} Profit in ${widget.time}\n***Daily profit payment',
                            //     textAlign: TextAlign.left,
                            //     style: const TextStyle(
                            //         color: Color.fromRGBO(0, 0, 0, 1),
                            //         fontFamily: 'Poppins',
                            //         fontSize: 10,
                            //         letterSpacing:
                            //             0 /*percentages not used in flutter. defaulting to zero*/,
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
    );
  }

  appBarSection(BuildContext context, state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.scale,
                  alignment: Alignment.center,
                  isIos: true,
                  duration: const Duration(microseconds: 500),
                  child: InvestmentScreen(
                    isTcInvestmentCall: false,
                  ),
                ),
              );
            },
            child: Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              child: Image.asset(
                'images/backarrow.png',
                width: 24,
                height: 24,
              ),
            ),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Investment',
                  style: TextStyle(
                      color: Color(0xff2C2C2C),
                      fontFamily: 'pop',
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                'Dashboard',
                style: TextStyle(
                    color: Color(0xff009456),
                    fontFamily: 'pop',
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }
}

/*----------------step 1----------------*/

class BottomSheetContentStep1 extends StatefulWidget {
  const BottomSheetContentStep1({super.key});

  @override
  State<BottomSheetContentStep1> createState() =>
      _BottomSheetContentStep1State();
}

class _BottomSheetContentStep1State extends State<BottomSheetContentStep1> {
  final InvestmentBloc _investmentBloc = InvestmentBloc();
  List<int> dropdownList = [];
  int? _selectedValue;
  bool _acceptTerms = false;

  // Define base values
  double baseMasternodePrice = 00.00;
  double basePerDayProfit = 00.00;
  int baseTotalPaymentDays = 00;

  // Variables to hold updated values
  double masternodePrice = 00.00;
  double perDayProfit = 00.00;
  int totalPaymentDays = 0;
  double totalCostMasternode = 00.00;

  SingleValueDropDownController _ibanAccountDropDownController =
      SingleValueDropDownController();

  String selectedIban = '';
  String selectedIbanCurrency = '';
  dynamic ratePrince;
  double payableAmount = 0.00;
  String? ibanId;

  TextEditingController payableAmountController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _investmentBloc.add(BuyMasterNodeInfoEvent());
    _investmentBloc
        .add(IbanGetCustomAccountEvent(type: "invest", symbol: "usdc"));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _investmentBloc,
      listener: (context, InvestmentState state) {
        if (state.statusModel?.status == 0) {
          CustomToast.showError(context, "Sorry!", state.statusModel!.message!);
        }

        if (state.buyMasterNodeModel?.status == 1) {
          setState(() {
            _selectedValue = 1;
            dropdownList = state.buyMasterNodeModel!.dropList!;
            baseMasternodePrice =
                double.parse(state.buyMasterNodeModel!.masternodePrice!);
            basePerDayProfit =
                double.parse(state.buyMasterNodeModel!.perDayProfit!);
            baseTotalPaymentDays =
                int.parse(state.buyMasterNodeModel!.totalPaymentDay!);

            masternodePrice = baseMasternodePrice;
            perDayProfit = basePerDayProfit * _selectedValue!;
            totalPaymentDays = baseTotalPaymentDays;
            totalCostMasternode = baseMasternodePrice * _selectedValue!;
          });
        }

        if (state.statusModel?.status == 1) {
          CustomToast.showSuccess(
              context, "Hey!!", state.statusModel!.message!);
          Navigator.pushNamedAndRemoveUntil(
              context, 'masterNodeScreen', (route) => false);
        }

        if (state.ibanGetCustomAccountsModel?.status == 0) {
          CustomToast.showError(
              context, "Sorry!", state.ibanGetCustomAccountsModel!.message!);
        }
      },
      child: BlocBuilder(
          bloc: _investmentBloc,
          builder: (context, InvestmentState state) {
            return Material(
              color: CustomColor.whiteColor,
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16)), // Rounded top corners
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(
                        16), // Match the border radius of Material
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
                              'Buy Virtual Master',
                              style: GoogleFonts.inter(
                                  color: CustomColor.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                            Container(
                              width: 20,
                            )
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'how many masternodes\ndo you want to purchase?',
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.inter(
                                      color: CustomColor.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 70,
                                    child: DropdownButtonFormField<int>(
                                      value: _selectedValue ?? 1,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 10.0,
                                                vertical: 5.0),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          borderSide: const BorderSide(
                                              color: Colors.black, width: 1.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          borderSide: const BorderSide(
                                              color: Colors.black, width: 1.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          borderSide: const BorderSide(
                                              color: Colors.black, width: 1.5),
                                        ),
                                        // hintText: '0',
                                      ),
                                      onChanged: (int? newValue) {
                                        setState(() {
                                          _selectedValue = newValue;
                                          if (newValue != null) {
                                            // masternodePrice =
                                            //     baseMasternodePrice *
                                            //         newValue;
                                            perDayProfit =
                                                basePerDayProfit * newValue;
                                            totalPaymentDays =
                                                baseTotalPaymentDays;
                                            totalCostMasternode =
                                                baseMasternodePrice * newValue;
                                            // Already updated

                                            if (ratePrince != null) {
                                              payableAmount =
                                                  totalCostMasternode *
                                                      double.parse(ratePrince);

                                              setState(() {
                                                payableAmountController.text =
                                                    payableAmount.toString();
                                              });
                                            }
                                          }
                                        });
                                      },
                                      items: dropdownList
                                          .map<DropdownMenuItem<int>>(
                                              (int value) {
                                        return DropdownMenuItem<int>(
                                          value: value,
                                          child: Text(value.toString()),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'MasterNode Price',
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.inter(
                                      color: CustomColor.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '${masternodePrice.toStringAsFixed(2)} ${state.buyMasterNodeModel!.coin!.toUpperCase()}',
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.inter(
                                      color: CustomColor.black.withOpacity(0.7),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Profit per day',
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.inter(
                                      color: CustomColor.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '${perDayProfit.toStringAsFixed(2)} ${state.buyMasterNodeModel!.coin!.toUpperCase()}',
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.inter(
                                      color: CustomColor.black.withOpacity(0.7),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total payment days',
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.inter(
                                      color: CustomColor.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '${totalPaymentDays.toStringAsFixed(2)} Days',
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.inter(
                                      color: CustomColor.black.withOpacity(0.7),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total Cost Masternode',
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.inter(
                                      color: CustomColor.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '${totalCostMasternode.toStringAsFixed(2)} ${state.buyMasterNodeModel!.coin!.toUpperCase()}',
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.inter(
                                      color: CustomColor.black.withOpacity(0.7),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),

                        if (state
                            .ibanGetCustomAccountsModel!.ibaninfo!.isNotEmpty)
                          Form(
                            key: _formKey,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 0),
                              child: DefaultDropDownFieldWithTitleWidget(
                                controller: _ibanAccountDropDownController,
                                title: "Pay with",
                                hint: "Select Iban",
                                dropDownItemCount: state
                                        .ibanGetCustomAccountsModel!
                                        .ibaninfo!
                                        .length ??
                                    0,
                                dropDownList: state
                                        .ibanGetCustomAccountsModel!.ibaninfo!
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
                                    selectedIbanCurrency = val.value.currency;

                                    ratePrince = val.value.coinPrice.toString();

                                    payableAmount = totalCostMasternode *
                                        double.parse(ratePrince);

                                    setState(() {
                                      payableAmountController.text =
                                          payableAmount.toString();
                                    });
                                  });
                                },
                              ),
                            ),
                          ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            "Your Have to Pay: ${payableAmountController.text} $selectedIbanCurrency",
                            style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: CustomColor.black.withOpacity(0.4)),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _acceptTerms =
                                      !_acceptTerms; // Toggle the checkbox state
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _acceptTerms
                                      ? CustomColor.primaryColor
                                      : CustomColor.whiteColor,
                                  // Background color when checked
                                  border: Border.all(
                                    color: _acceptTerms
                                        ? CustomColor.primaryColor
                                        : Color(0xFF798187),
                                    width: 1.5, // Border width
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                width: 18,
                                height: 18,
                                child: _acceptTerms
                                    ? Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        // Check color when checked
                                        size: 14, // Size of the check icon
                                      )
                                    : null, // Empty when unchecked
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: RichText(
                                text: TextSpan(
                                  text: 'I have read the ',
                                  style: GoogleFonts.inter(
                                    color: CustomColor.black.withOpacity(0.6),
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    height: 1,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'terms and agreement',
                                      style: GoogleFonts.inter(
                                        color:
                                            CustomColor.black.withOpacity(0.6),
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        height: 1,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          var url = state.buyMasterNodeModel!
                                              .termsCondition!;
                                          if (await canLaunchUrl(
                                              Uri.parse(url))) {
                                            await launchUrl(Uri.parse(url));
                                          } else {
                                            throw 'Could not launch $url';
                                          }
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: PrimaryButtonWidget(
                            onPressed: _acceptTerms
                                ? () {
                                    if (_formKey.currentState!.validate()) {
                                      _investmentBloc.add(NodeOrderEvent(
                                          numberOfNode: _selectedValue!,
                                          ibanId: ibanId!));
                                    }
                                  }
                                : null,
                            buttonText: 'Pay',
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
