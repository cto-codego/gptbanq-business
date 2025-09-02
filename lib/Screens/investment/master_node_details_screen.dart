import 'package:gptbanqbusiness/Screens/investment/bloc/investment_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gptbanqbusiness/Screens/Dashboard_screen/bloc/dashboard_bloc.dart';
import 'package:gptbanqbusiness/constant_string/User.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/assets.dart';
import '../../utils/input_fields/custom_color.dart';
import '../../widgets/custom_image_widget.dart';
import '../../widgets/toast/toast_util.dart';

class MasterNodeDetailsScreen extends StatefulWidget {
  MasterNodeDetailsScreen({
    super.key,
    required this.orderId,
  });

  String orderId;

  @override
  State<MasterNodeDetailsScreen> createState() =>
      _MasterNodeDetailsScreenState();
}

class _MasterNodeDetailsScreenState extends State<MasterNodeDetailsScreen> {
  bool active = false;

  bool shownotification = true;
  final InvestmentBloc _investmentBloc = InvestmentBloc();

  Future<void> _onRefresh() async {
    debugPrint('_onRefresh');

    _investmentBloc.add(NodeProfitLogsEvent(orderId: widget.orderId));
  }

  @override
  void initState() {
    super.initState();
    User.Screen = 'node profit screen';
    _investmentBloc.add(NodeProfitLogsEvent(orderId: widget.orderId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      body: Stack(
        children: [
          BlocListener(
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
                        child: RefreshIndicator(
                          onRefresh: _onRefresh,
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, top: 30),
                            child: Column(
                              // mainAxisAlignment:
                              //     MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    appBarSection(context, state),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                             Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 3),
                                              child: Text("Masternode Id",
                                                  style: GoogleFonts.inter(
                                                    color: CustomColor.black,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w500,
                                                  )),
                                            ),
                                            Text(
                                                state.nodeProfitLogModel!
                                                    .orderId!,
                                                style: GoogleFonts.inter(
                                                  color: CustomColor.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                             Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 3),
                                              child: Text("Paid Profit",
                                                  style: GoogleFonts.inter(
                                                    color: CustomColor.black,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w500,
                                                  )),
                                            ),
                                            Text(
                                                state.nodeProfitLogModel!
                                                    .totalPaid!
                                                    .toUpperCase(),
                                                style: GoogleFonts.inter(
                                                  color: CustomColor.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: ListView.builder(
                                      itemCount: state
                                          .nodeProfitLogModel?.logs!.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                            border: Border.all(
                                              color: CustomColor
                                                  .dashboardProfileBorderColor,
                                            ),
                                            color:
                                                CustomColor.hubContainerBgColor,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  '${state.nodeProfitLogModel?.logs![index].id}',
                                                  textAlign: TextAlign.left,
                                                  style: GoogleFonts.inter(
                                                    color: CustomColor.black,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  '${state.nodeProfitLogModel?.logs![index].profit!.toUpperCase()}',
                                                  textAlign: TextAlign.left,
                                                  style: GoogleFonts.inter(
                                                    color: CustomColor.black,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: SizedBox(
                                                  width: 80,
                                                  child: Text(
                                                    '${state.nodeProfitLogModel?.logs![index].status!.toUpperCase()}',
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.inter(
                                                        color: state
                                                                    .nodeProfitLogModel
                                                                    ?.logs![
                                                                        index]
                                                                    .status ==
                                                                "processing"
                                                            ? CustomColor.warning
                                                            : state
                                                                        .nodeProfitLogModel
                                                                        ?.logs![
                                                                            index]
                                                                        .status ==
                                                                    "unpaid"
                                                                ? CustomColor.errorColor
                                                                : CustomColor.green,
                                                        fontSize: 9,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                     ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  '${state.nodeProfitLogModel?.logs![index].date}',
                                                  textAlign: TextAlign.left,
                                                  style: GoogleFonts.inter(
                                                      color: CustomColor.black,
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                  ),
                                                ),
                                              )
                                            ],
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
        ],
      ),
    );
  }

  appBarSection(BuildContext context, state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: CustomImageWidget(
              imagePath: StaticAssets.arrowNarrowLeft,
              imageType: 'svg',
              height: 20,
            )),
        Text(
          'MasterNode',
          style: GoogleFonts.inter(
              color: CustomColor.black,
              fontSize: 18,
              fontWeight: FontWeight.w500),
        ),
        Container(
          width: 20,
        )
      ],
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
  final DashboardBloc _cardOrderDetailsBloc = DashboardBloc();

  @override
  void initState() {
    super.initState();
    _cardOrderDetailsBloc.add(CardFeeEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _cardOrderDetailsBloc,
      listener: (context, DashboardState state) {
        if (state.statusModel?.status == 0) {
          CustomToast.showError(context, "Sorry!", state.statusModel!.message!);
        }

        if (state.cardOrderConfirmModel?.status == 1) {
          CustomToast.showSuccess(
              context, "Thank You!", state.cardOrderConfirmModel!.message!);

          Navigator.pushNamedAndRemoveUntil(
              context, 'masterNodeScreen', (route) => false);
        }
      },
      child: BlocBuilder(
          bloc: _cardOrderDetailsBloc,
          builder: (context, DashboardState state) {
            String cardFee = "00.00";
            String shippingFee = "00.00";
            String totalFee = "00.00";

            return Material(
              color: Colors.white,

              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20)), // Rounded top corners
              child: Container(
                height: 375,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(
                        20), // Match the border radius of Material
                  ),
                  border: Border(
                    top: BorderSide(
                      color: Color(0xff797777),
                      width: 2, // Set the thickness of the top border
                    ),
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
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Cancel',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Color(0xff000000),
                                    fontFamily: 'Inter',
                                    fontSize: 10,
                                    fontWeight: FontWeight.normal,
                                    height: 1),
                              ),
                            ),
                            Container(
                              height: 2,
                              width: 141,
                              alignment: Alignment.center,
                              decoration:
                                  const BoxDecoration(color: Color(0xff6F6E6E)),
                            ),
                            InkWell(
                              onTap: () {},
                              child: const Text(
                                'Cancel',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Colors.transparent,
                                    fontFamily: 'Inter',
                                    fontSize: 10,
                                    fontWeight: FontWeight.normal,
                                    height: 1),
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Buy Virtual Master',
                                style: TextStyle(
                                    color: Color(0xff000000),
                                    fontFamily: 'Poppins',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    height: 1),
                              ),
                              Text(
                                'Node',
                                style: TextStyle(
                                    color: Color(0xff3C14AE),
                                    fontFamily: 'Poppins',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    height: 1),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 315,
                          // height: 293,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                            color: Color.fromRGBO(241, 238, 238, 1),
                          ),
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'how many masternodes\ndo you want to purchase?',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Color(0xff000000),
                                          fontFamily: 'Inter',
                                          fontSize: 10,
                                          fontWeight: FontWeight.normal,
                                          height: 1),
                                    ),
                                    Text(
                                      'dropwdown',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Color(0xff000000),
                                          fontFamily: 'Inter',
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          height: 1),
                                    )
                                  ],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'MasterNode Price',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Color(0xff000000),
                                          fontFamily: 'Inter',
                                          fontSize: 10,
                                          fontWeight: FontWeight.normal,
                                          height: 1),
                                    ),
                                    Text(
                                      '5000 USDT',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Color(0xff000000),
                                          fontFamily: 'Inter',
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          height: 1),
                                    )
                                  ],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Profit per day',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Color(0xff000000),
                                          fontFamily: 'Inter',
                                          fontSize: 10,
                                          fontWeight: FontWeight.normal,
                                          height: 1),
                                    ),
                                    Text(
                                      '13,69 USDT',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Color(0xff000000),
                                          fontFamily: 'Inter',
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          height: 1),
                                    )
                                  ],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total payment days',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Color(0xff000000),
                                          fontFamily: 'Inter',
                                          fontSize: 10,
                                          fontWeight: FontWeight.normal,
                                          height: 1),
                                    ),
                                    Text(
                                      '1095 Days',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Color(0xff000000),
                                          fontFamily: 'Inter',
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          height: 1),
                                    )
                                  ],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total Cost Masternode',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Color(0xff000000),
                                          fontFamily: 'Inter',
                                          fontSize: 10,
                                          fontWeight: FontWeight.normal,
                                          height: 1),
                                    ),
                                    Text(
                                      '5000,00 USDT',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Color(0xff000000),
                                          fontFamily: 'Inter',
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          height: 1),
                                    )
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Checkbox(
                                      value: true,
                                      onChanged: (value) {
                                        value != true;
                                      }),
                                  RichText(
                                    text: const TextSpan(
                                      text: 'Accept',
                                      style: TextStyle(
                                          color: Color(0xff000000),
                                          fontFamily: 'Inter',
                                          fontSize: 10,
                                          fontWeight: FontWeight.normal,
                                          height: 1),
                                      children: [
                                        TextSpan(
                                          text: ' terms and conditions',
                                          style: TextStyle(
                                              color: Color(0xff5349CA),
                                              fontFamily: 'Inter',
                                              fontSize: 10,
                                              fontWeight: FontWeight.normal,
                                              height: 1),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                height: 35,
                                width: double.infinity,
                                margin: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15)),
                                child: ElevatedButton(
                                    onPressed: () {
                                      // UserDataManager()
                                      //     .cardShippingCostSave(shippingFee);
                                      //
                                      // _cardOrderDetailsBloc
                                      //     .add(CardOrderConfirmEvent());
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xff3C14AE),
                                        elevation: 0,
                                        disabledBackgroundColor:
                                            const Color(0xffC4C4C4),
                                        shadowColor: Colors.transparent,
                                        minimumSize: const Size.fromHeight(40),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(11))),
                                    child: const Text(
                                      'pay',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontFamily: 'pop',
                                          fontWeight: FontWeight.w500),
                                    )),
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
