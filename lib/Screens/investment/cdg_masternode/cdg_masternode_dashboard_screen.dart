import 'package:gptbanqbusiness/Screens/investment/bloc/investment_bloc.dart';
import 'package:gptbanqbusiness/Screens/investment/cdg_masternode/cdg_masternode_log_details_screen.dart';
import 'package:gptbanqbusiness/utils/assets.dart';
import 'package:gptbanqbusiness/widgets/custom_image_widget.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Models/cdg/cdg_accounts_model.dart';
import '../../../constant_string/User.dart';
import '../../../cutom_weidget/input_textform.dart';
import '../../../utils/input_fields/custom_color.dart';
import '../../../widgets/buttons/custom_floating_action_button.dart';
import '../../../widgets/buttons/primary_button_widget.dart';
import '../../../widgets/main/default_dropdown_field_with_title_widget.dart';
import '../../../widgets/success/success_widget.dart';
import '../../../widgets/toast/custom_dialog_widget.dart';
import '../../../widgets/toast/toast_util.dart';
import 'active_cdg_device_screen.dart';
import 'buy_cdg_masternode_input_address_screen.dart';

class CdgMasternodeDashboardScreen extends StatefulWidget {
  const CdgMasternodeDashboardScreen({super.key});

  @override
  State<CdgMasternodeDashboardScreen> createState() =>
      _CdgMasternodeDashboardScreenState();
}

class _CdgMasternodeDashboardScreenState
    extends State<CdgMasternodeDashboardScreen> {
  bool active = false;
  bool shownotification = true;
  final InvestmentBloc _investmentBloc = InvestmentBloc();
  TextEditingController storeController = TextEditingController();

  Future<void> _onRefresh() async {
    _investmentBloc.add(CdgDashboardEvent());
    debugPrint('_onRefresh');
  }

  @override
  void initState() {
    super.initState();
    _investmentBloc.add(CdgDashboardEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.scaffoldBg,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: BlocListener(
        bloc: _investmentBloc,
        listener: (context, InvestmentState state) {
          if (state.cdgDashboardModel?.status == 0) {
            CustomToast.showError(context, "Sorry!",
                state.cdgDashboardModel?.message ?? "Failed");
          }

          if (state.unStakeModel?.status == 1) {
            CustomToast.showSuccess(
                context, "Hey!", state.unStakeModel!.message!);
            Navigator.pushNamedAndRemoveUntil(
                context, 'cdgMasternodeDashboardScreen', (route) => false);
          } else if (state.unStakeModel?.status == 0) {
            CustomToast.showSuccess(
                context, "Hey!", state.unStakeModel!.message!);
            Navigator.pushNamedAndRemoveUntil(
                context, 'cdgMasternodeDashboardScreen', (route) => false);
          }
        },
        child: BlocBuilder(
          bloc: _investmentBloc,
          builder: (context, InvestmentState state) {
            // 0 HIDE NO BUTTON, 1 SHOW UNSTAKE , 2 STAKE BUTTON
            final dashboard = state.cdgDashboardModel;
            final priceText = dashboard?.price ?? "--";
            final balanceText = dashboard?.balance ?? "--";
            final usdBalanceText = dashboard?.usdBalance ?? "--";
            final logo = dashboard?.logo ?? "";
            final totalWorking = dashboard?.totalWorking ?? "0";
            final totalDevice = dashboard?.totalDevice ?? "0";
            final totalOffline = dashboard?.totalOffline ?? "0";
            final workingList = dashboard?.working ?? const [];
            final deviceList = dashboard?.device ?? const [];
            final offlineList = dashboard?.offline ?? const [];
            final popupText = dashboard?.popupText ?? "";

            return SafeArea(
              child: ProgressHUD(
                inAsyncCall: state.isloading,
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Image.asset(
                        StaticAssets.cdgBg1,
                        height: 300,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Image.asset(
                        StaticAssets.cdgBg2,
                        width: 150,
                        height: 150,
                      ),
                    ),
                    RefreshIndicator(
                      onRefresh: _onRefresh,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        children: [
                          // Header / App bar
                          Column(
                            children: [
                              appBarSection(context, state),
                              const Divider(),
                              // Balance block
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        priceText,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.inter(
                                            color: CustomColor.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        "Available Balance",
                                        style: GoogleFonts.inter(
                                            color: Colors.grey,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: InkWell(
                                          onTap: () {
                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              elevation: 5,
                                              builder: (context) {
                                                return Padding(
                                                  // keep sheet above keyboard
                                                  padding: EdgeInsets.only(
                                                    bottom:
                                                        MediaQuery.of(context)
                                                            .viewInsets
                                                            .bottom,
                                                  ),
                                                  child: SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.8,
                                                    child: ShareMasternodeSheet(
                                                      description: popupText,
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 8),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: CustomColor.black
                                                    .withAlpha(10)),
                                            child: Icon(
                                              Icons.share,
                                              color: CustomColor.black,
                                              size: 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        if (logo.isNotEmpty)
                                          Image.network(
                                            logo,
                                            height: 50,
                                            width: 50,
                                          )
                                        else
                                          const SizedBox(width: 50, height: 50),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              balanceText,
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.inter(
                                                  color: CustomColor.black,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              usdBalanceText,
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.inter(
                                                  color: Colors.grey,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                        InkWell(
                                          onTap: () {
                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              elevation: 5,
                                              builder: (context) {
                                                return Padding(
                                                  padding: EdgeInsets.only(
                                                    bottom:
                                                        MediaQuery.of(context)
                                                            .viewInsets
                                                            .bottom,
                                                  ),
                                                  child: SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.85,
                                                    child:
                                                        CdgCurrencyExchangeScreen(
                                                      balance: balanceText,
                                                      price: priceText,
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          child: CustomImageWidget(
                                            height: 24,
                                            width: 24,
                                            imagePath: StaticAssets.cdgExchange,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Action buttons
                          Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          elevation: 5,
                                          builder: (context) {
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom,
                                              ),
                                              child: SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.85,
                                                child:
                                                    const OrderCdgMasternodeSheet(),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            CustomColor.primaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 12),
                                      ),
                                      child: Text(
                                        "Order Masternode",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.inter(
                                          color: CustomColor.whiteColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            type: PageTransitionType.scale,
                                            alignment: Alignment.center,
                                            isIos: true,
                                            duration: const Duration(
                                                microseconds: 500),
                                            child:
                                                const ActiveCdgDeviceScreen(),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            CustomColor.primaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 12),
                                      ),
                                      child: Text(
                                        "Active",
                                        style: GoogleFonts.inter(
                                          color: CustomColor.whiteColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              // 0 HIDE NO BUTTON, 1 SHOW UNSTAKE , 2 STAKE BUTTON
                              Row(
                                children: [
                                  if (state.cdgDashboardModel
                                          ?.stakeUnStakeButton ==
                                      2)
                                    Expanded(
                                      child: InkWell(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        onTap: () {
                                          Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              "cdgStakeScreen",
                                              (route) => true);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 12),
                                          decoration: BoxDecoration(
                                            color: Colors.orange,
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            state.cdgDashboardModel?.stakeBtn ??
                                                "Stake",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.inter(
                                              color: CustomColor.whiteColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (state.cdgDashboardModel
                                          ?.stakeUnStakeButton ==
                                      1)
                                    Expanded(
                                      child: InkWell(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        onTap: () async {
                                          CustomDialogWidget.showWarningDialog(
                                            context: context,
                                            title: "Confirm",
                                            subTitle: state.cdgDashboardModel
                                                    ?.unStakeAlert ??
                                                "Are you sure you want to ${state.cdgDashboardModel?.unStakeBtn ?? "Unstake"}",
                                            btnOkText: "Yes",
                                            btnCancelText: "No",
                                            btnOkOnPress: () {
                                              _investmentBloc
                                                  .add(CdgUnStakeEvent());
                                            },
                                            btnCancelOnPress: () {},
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 12),
                                          decoration: BoxDecoration(
                                            color: CustomColor.green,
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            state.cdgDashboardModel
                                                    ?.unStakeBtn ??
                                                "Unstake",
                                            style: GoogleFonts.inter(
                                              color: CustomColor.whiteColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Tabs + lists
                          DefaultTabController(
                            length: 3,
                            child: Column(
                              children: [
                                TabBar(
                                  labelColor: CustomColor.black,
                                  unselectedLabelColor: Colors.grey,
                                  indicatorColor: CustomColor.primaryColor,
                                  dividerColor: CustomColor.transparent,
                                  indicatorWeight: 0.2,
                                  indicatorPadding:
                                      const EdgeInsets.only(top: 5),
                                  padding: EdgeInsets.zero,
                                  labelPadding: const EdgeInsets.all(8),
                                  tabs: [
                                    Tab(
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: CustomColor
                                              .dashboardProfileBorderColor,
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          border: Border.all(
                                              color: const Color(0xff37E01A)),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Text(
                                          "Working : $totalWorking",
                                          style: GoogleFonts.inter(
                                            color: CustomColor.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Tab(
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: CustomColor
                                              .dashboardProfileBorderColor,
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          border:
                                              Border.all(color: Colors.grey),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Text(
                                          "Devices : $totalDevice",
                                          style: GoogleFonts.inter(
                                            color: CustomColor.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Tab(
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: CustomColor
                                              .dashboardProfileBorderColor,
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          border: Border.all(
                                              color: CustomColor.errorColor),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Text(
                                          "Offline : $totalOffline",
                                          style: GoogleFonts.inter(
                                            color: CustomColor.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                // Fix a sensible height that fits on most screens;
                                // since the parent is a ListView, this area can be tall safely.
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  child: TabBarView(
                                    children: [
                                      // Working list
                                      ListView.builder(
                                        itemCount: workingList.length,
                                        itemBuilder: (context, index) {
                                          final item = workingList[index];
                                          return CdgDeviceListItem(
                                            deviceColor:
                                                item.status == "working"
                                                    ? CustomColor.green
                                                    : item.status == "offline"
                                                        ? CustomColor.errorColor
                                                        : Colors.grey,
                                            image: item.image,
                                            serialNumber: item.serialNumber,
                                            orderId: item.orderId,
                                            status: item.status,
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                PageTransition(
                                                  type:
                                                      PageTransitionType.scale,
                                                  alignment: Alignment.center,
                                                  isIos: true,
                                                  duration: const Duration(
                                                      microseconds: 500),
                                                  child:
                                                      CdgMasternodeLogDetailsScreen(
                                                    orderId: item.orderId,
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                      // Devices list
                                      ListView.builder(
                                        itemCount: deviceList.length,
                                        itemBuilder: (context, index) {
                                          final item = deviceList[index];
                                          return CdgDeviceListItem(
                                            deviceColor:
                                                item.status == "working"
                                                    ? CustomColor.green
                                                    : item.status == "offline"
                                                        ? CustomColor.errorColor
                                                        : Colors.grey,
                                            image: item.image,
                                            serialNumber: item.serialNumber,
                                            orderId: item.orderId,
                                            status: item.status,
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                PageTransition(
                                                  type:
                                                      PageTransitionType.scale,
                                                  alignment: Alignment.center,
                                                  isIos: true,
                                                  duration: const Duration(
                                                      microseconds: 500),
                                                  child:
                                                      CdgMasternodeLogDetailsScreen(
                                                    orderId: item.orderId,
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                      // Offline list
                                      ListView.builder(
                                        itemCount: offlineList.length,
                                        itemBuilder: (context, index) {
                                          final item = offlineList[index];
                                          return CdgDeviceListItem(
                                            deviceColor:
                                                item.status == "working"
                                                    ? CustomColor.green
                                                    : item.status == "offline"
                                                        ? CustomColor.errorColor
                                                        : Colors.grey,
                                            image: item.image,
                                            serialNumber: item.serialNumber,
                                            orderId: item.orderId,
                                            status: item.status,
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                PageTransition(
                                                  type:
                                                      PageTransitionType.scale,
                                                  alignment: Alignment.center,
                                                  isIos: true,
                                                  duration: const Duration(
                                                      microseconds: 500),
                                                  child:
                                                      CdgMasternodeLogDetailsScreen(
                                                    orderId: item.orderId,
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: const CustomFloatingActionButton(),
    );
  }

  appBarSection(BuildContext context, state) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      child: Text(
        'CDG Masternode',
        style: GoogleFonts.inter(
            color: CustomColor.black,
            fontSize: 18,
            fontWeight: FontWeight.w500),
      ),
    );
  }
}

class CdgDeviceListItem extends StatelessWidget {
  final String? image;
  final String? serialNumber;
  final String? orderId;
  final String? status;
  final Color deviceColor;
  final VoidCallback onTap;

  const CdgDeviceListItem({
    super.key,
    this.image,
    this.serialNumber,
    this.orderId,
    this.status,
    required this.deviceColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final showSerial = (serialNumber ?? '').isNotEmpty;
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: CustomColor.dashboardProfileBorderColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: (image != null && image!.isNotEmpty)
                      ? Image.network(
                          image!,
                          height: 53,
                          width: 40,
                          errorBuilder: (context, error, stack) => Container(
                            height: 53,
                            width: 40,
                            color: Colors.grey[300],
                            child: Icon(Icons.broken_image,
                                size: 20, color: Colors.grey[600]),
                          ),
                        )
                      : Container(
                          height: 53,
                          width: 40,
                          color: Colors.grey[300],
                          child: Icon(Icons.image_not_supported_outlined,
                              size: 20, color: Colors.grey[600]),
                        ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      showSerial ? "Serial Number" : "Order Id",
                      style: GoogleFonts.inter(
                        color: CustomColor.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(
                        showSerial ? (serialNumber ?? "--") : (orderId ?? "--"),
                        maxLines: 3,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          color: CustomColor.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: deviceColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                status ?? "--",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: CustomColor.whiteColor,
                  fontSize: 8,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderCdgMasternodeSheet extends StatefulWidget {
  const OrderCdgMasternodeSheet({super.key});

  @override
  State<OrderCdgMasternodeSheet> createState() =>
      _OrderCdgMasternodeSheetState();
}

class _OrderCdgMasternodeSheetState extends State<OrderCdgMasternodeSheet> {
  final InvestmentBloc _investmentBloc = InvestmentBloc();
  List<int> dropdownList = [];
  int? _selectedValue;
  bool _acceptTerms = false;
  String? _selectedType;
  String? _deviceId;

  double baseMasternodePrice = 00.00;
  double basePerDayProfit = 00.00;
  double baseShippingCost = 00.00;
  int baseTotalPaymentDays = 00;
  String baseCurrency = "";
  String cdgImage = "";
  String masternodeCurrency = "";
  List<String>? cdgType;

  double masternodePrice = 00.00;
  double perDayProfit = 00.00;
  int totalPaymentDays = 0;
  double totalCostMasternode = 00.00;
  double userAvailableBalance = 00.00;

  SingleValueDropDownController _ibanAccountDropDownController =
      SingleValueDropDownController();

  String selectedIban = '';
  String selectedIbanCurrency = '';
  dynamic ratePrince;
  double payableAmount = 0.00;
  String? ibanId;

  TextEditingController payableAmountController = TextEditingController();
  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _investmentBloc.add(CdgDeviceListEvent());
    _investmentBloc.add(CdgAccountsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _investmentBloc,
      listener: (context, InvestmentState state) {
        if (state.cdgDeviceListModel?.status == 0) {
          CustomToast.showError(
              context, "Sorry!", state.cdgDeviceListModel?.message ?? "Failed");
        }

        if (state.cdgDeviceListModel?.status == 1) {
          User.isCdgShow = state.cdgDeviceListModel!.isCdg ?? 0;

          setState(() {
            _deviceId =
                state.cdgDeviceListModel!.data?.first.id?.toString() ?? "";
            baseCurrency =
                (state.cdgDeviceListModel!.data?.first.labelDeviceCost ?? "")
                    .replaceAll(RegExp(r'[0-9.]'), '')
                    .trim();
            masternodeCurrency =
                (state.cdgDeviceListModel!.data?.first.labelProfit ?? "")
                    .replaceAll(RegExp(r'[0-9.]'), '')
                    .trim();
            _selectedValue = 1;
            dropdownList = state.cdgDeviceListModel!.quantity ?? [];
            baseMasternodePrice = double.tryParse(
                    state.cdgDeviceListModel!.data?.first.deviceCost ?? "0") ??
                0.0;
            baseShippingCost = double.tryParse(
                    state.cdgDeviceListModel!.data?.first.shippingCost ??
                        "0") ??
                0.0;

            basePerDayProfit = double.tryParse(
                (state.cdgDeviceListModel!.data?.first.labelProfit ?? "")
                    .replaceAll(RegExp(r'[^0-9.]'), ''))!;
            masternodePrice = baseMasternodePrice;
            perDayProfit = basePerDayProfit * (_selectedValue ?? 1);
            totalPaymentDays = baseTotalPaymentDays;
            totalCostMasternode =
                (baseMasternodePrice * (_selectedValue ?? 1)) +
                    baseShippingCost;
            _selectedType = state.cdgDeviceListModel!.data?.first.type ?? "";
            cdgImage = state.cdgDeviceListModel!.data?.first.image ?? "";
          });
        }
      },
      child: BlocBuilder(
          bloc: _investmentBloc,
          builder: (context, InvestmentState state) {
            return Material(
              color: CustomColor.whiteColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16),
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
                            if (_selectedType != null &&
                                _selectedType!.isNotEmpty)
                              Text(
                                'Buy $_selectedType',
                                style: GoogleFonts.inter(
                                    color: CustomColor.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                            Container(width: 10),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: (state.cdgDeviceListModel?.data ?? [])
                                  .map<Widget>((device) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedType = device.type;

                                      var selectedDevice =
                                          (state.cdgDeviceListModel?.data ?? [])
                                              .firstWhere(
                                                  (d) => d.type == device.type);
                                      _deviceId =
                                          selectedDevice.id?.toString() ?? "";
                                      cdgImage = selectedDevice.image ?? "";
                                      baseCurrency =
                                          (selectedDevice.labelDeviceCost ?? "")
                                              .replaceAll(RegExp(r'[0-9.]'), '')
                                              .trim();
                                      masternodeCurrency =
                                          (selectedDevice.labelProfit ?? "")
                                              .replaceAll(RegExp(r'[0-9.]'), '')
                                              .trim();
                                      baseMasternodePrice = double.tryParse(
                                              selectedDevice.deviceCost ??
                                                  "0") ??
                                          0.0;
                                      baseShippingCost = double.tryParse(
                                              selectedDevice.shippingCost ??
                                                  "0") ??
                                          0.0;
                                      basePerDayProfit = double.tryParse(
                                              (selectedDevice.labelProfit ?? "")
                                                  .replaceAll(
                                                      RegExp(r'[^0-9.]'),
                                                      '')) ??
                                          0.0;
                                      masternodePrice = baseMasternodePrice;
                                      perDayProfit = basePerDayProfit *
                                          (_selectedValue ?? 1);
                                      totalCostMasternode =
                                          (baseMasternodePrice *
                                                  (_selectedValue ?? 1)) +
                                              baseShippingCost;

                                      if (ibanId != null &&
                                          ratePrince != null) {
                                        payableAmount = totalCostMasternode *
                                            double.parse(ratePrince);
                                        payableAmountController.text =
                                            payableAmount.toString();
                                      }
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: _selectedType == device.type
                                            ? CustomColor.primaryColor
                                            : CustomColor
                                                .primaryInputHintBorderColor,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Image.network(
                                      device.image2 ?? "",
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          height: 100,
                                          width: 100,
                                          color: Colors.grey[300],
                                          child: Icon(
                                            Icons.broken_image,
                                            color: Colors.grey[600],
                                            size: 50,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
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
                                    'Quantity?',
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
                                      ),
                                      onChanged: (int? newValue) {
                                        setState(() {
                                          _selectedValue = newValue ?? 1;
                                          perDayProfit = basePerDayProfit *
                                              _selectedValue!;
                                          totalPaymentDays =
                                              baseTotalPaymentDays;
                                          totalCostMasternode =
                                              baseMasternodePrice *
                                                      _selectedValue! +
                                                  baseShippingCost;

                                          if (ratePrince != null) {
                                            payableAmount =
                                                totalCostMasternode *
                                                    double.parse(ratePrince);
                                            payableAmountController.text =
                                                payableAmount.toString();
                                          }
                                        });
                                      },
                                      items: (dropdownList.isNotEmpty
                                              ? dropdownList
                                              : [1, 2, 3, 4, 5])
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
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Price',
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.inter(
                                      color: CustomColor.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "${baseMasternodePrice.toString()} $baseCurrency",
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.inter(
                                      color: CustomColor.black.withOpacity(0.7),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),
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
                                    "${perDayProfit.toString()} $masternodeCurrency",
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.inter(
                                      color: CustomColor.black.withOpacity(0.7),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Shipment Cost',
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.inter(
                                      color: CustomColor.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "${baseShippingCost.toString()} $baseCurrency",
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.inter(
                                      color: CustomColor.black.withOpacity(0.7),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                  Text(
                                    "${totalCostMasternode.toString()} $baseCurrency",
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
                        if ((state.cdgAccountsModel?.cdgIbanInfo?.isNotEmpty ??
                                false) ==
                            true)
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 0),
                                  child: DefaultDropDownFieldWithTitleWidget(
                                    controller: _ibanAccountDropDownController,
                                    title: "Pay with",
                                    hint: "Select Iban",
                                    dropDownItemCount: state.cdgAccountsModel
                                            ?.cdgIbanInfo?.length ??
                                        0,
                                    dropDownList:
                                        (state.cdgAccountsModel?.cdgIbanInfo ??
                                                [])
                                            .map<DropDownValueModel>(
                                                (CdgIbaninfo iban) {
                                      return DropDownValueModel(
                                        name: "${iban.showlabel}",
                                        value: iban,
                                      );
                                    }).toList(),
                                    onChanged: (val) {
                                      setState(() {
                                        selectedIban =
                                            (val as DropDownValueModel)
                                                .value
                                                ?.ibanId;
                                        ibanId = val.value.ibanId;
                                        selectedIbanCurrency =
                                            val.value.currency ?? '';
                                        if (val.value.coinPrice != null) {
                                          ratePrince =
                                              val.value.coinPrice.toString();
                                        } else {
                                          ratePrince = "1";
                                        }

                                        payableAmount = totalCostMasternode *
                                            double.parse(ratePrince);
                                        userAvailableBalance = double.tryParse(
                                                (val.value.availableBalance ??
                                                        "0")
                                                    .toString()) ??
                                            0.0;

                                        payableAmountController.text =
                                            payableAmount.toString();
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(bottom: 10, top: 8),
                          child: Text(
                            "Your Have to Pay: $payableAmount $baseCurrency",
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
                                  _acceptTerms = !_acceptTerms;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _acceptTerms
                                      ? CustomColor.primaryColor
                                      : CustomColor.whiteColor,
                                  border: Border.all(
                                    color: _acceptTerms
                                        ? CustomColor.primaryColor
                                        : const Color(0xFF798187),
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                width: 18,
                                height: 18,
                                child: _acceptTerms
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 14,
                                      )
                                    : null,
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
                                          final url = state.buyMasterNodeModel
                                                  ?.termsCondition ??
                                              "";
                                          if (url.isEmpty) return;
                                          if (await canLaunchUrl(
                                              Uri.parse(url))) {
                                            await launchUrl(Uri.parse(url));
                                          } else {
                                            CustomToast.showError(context,
                                                "Sorry!", "Could not launch");
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
                          padding: const EdgeInsets.only(top: 20, bottom: 8),
                          child: PrimaryButtonWidget(
                            onPressed: _acceptTerms &&
                                    (_formKey.currentState?.validate() ??
                                        false) &&
                                    ibanId != null
                                ? () {
                                    if (_formKey.currentState!.validate()) {
                                      if (kDebugMode) {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            type: PageTransitionType.scale,
                                            alignment: Alignment.center,
                                            isIos: true,
                                            duration: const Duration(
                                                microseconds: 500),
                                            child:
                                                BuyCdgMasternodeInputAddressScreen(
                                              deviceId: _deviceId ?? "",
                                              numberOfNode:
                                                  (_selectedValue ?? 1)
                                                      .toString(),
                                              ibanId: ibanId!,
                                            ),
                                          ),
                                        );
                                      } else {
                                        // Release mode: Check balance before navigation
                                        if (userAvailableBalance <
                                            payableAmount) {
                                          CustomToast.showError(context,
                                              "Sorry!", "Insufficient balance");
                                        } else {
                                          Navigator.push(
                                            context,
                                            PageTransition(
                                              type: PageTransitionType.scale,
                                              alignment: Alignment.center,
                                              isIos: true,
                                              duration: const Duration(
                                                  microseconds: 500),
                                              child:
                                                  BuyCdgMasternodeInputAddressScreen(
                                                deviceId: _deviceId ?? "",
                                                numberOfNode:
                                                    (_selectedValue ?? 1)
                                                        .toString(),
                                                ibanId: ibanId!,
                                              ),
                                            ),
                                          );
                                        }
                                      }
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

class ShareMasternodeSheet extends StatefulWidget {
  ShareMasternodeSheet({super.key, required this.description});

  String description;

  @override
  State<ShareMasternodeSheet> createState() => _ShareMasternodeSheetState();
}

class _ShareMasternodeSheetState extends State<ShareMasternodeSheet> {
  final InvestmentBloc _investmentBloc = InvestmentBloc();
  final _activeNFormKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _shareEmailController = TextEditingController();
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();

    _shareEmailController.addListener(_checkFormValidity);
    _nameController.addListener(_checkFormValidity);
  }

  void _checkFormValidity() {
    setState(() {
      isButtonEnabled = _shareEmailController.text.isNotEmpty &&
          _nameController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _investmentBloc,
      listener: (context, InvestmentState state) {
        if (state.statusModel?.status == 1) {
          CustomToast.showSuccess(
              context, "Hey!", state.statusModel?.message ?? "Success");
          Navigator.pop(context);
        } else if (state.statusModel?.status == 0) {
          CustomToast.showError(
              context, "Sorry!", state.statusModel?.message ?? "Failed");
        }
      },
      child: BlocBuilder(
          bloc: _investmentBloc,
          builder: (context, InvestmentState state) {
            return Container(
              height: 260,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: CustomColor.whiteColor,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                border: Border(
                  top: BorderSide(
                    color: Color(0xff797777),
                    width: 1,
                  ),
                ),
              ),
              child: ProgressHUD(
                inAsyncCall: state.isloading,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: CustomImageWidget(
                              imagePath: StaticAssets.xClose,
                              imageType: 'svg',
                              height: 26,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Text(
                            'Refer to your friend',
                            textAlign: TextAlign.left,
                            style: GoogleFonts.inter(
                                color: CustomColor.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                height: 1),
                          ),
                        ),
                        const SizedBox(width: 20),
                      ],
                    ),
                    Form(
                      key: _activeNFormKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.description,
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.inter(
                              color: CustomColor.errorColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          InputTextCustom(
                            controller: _nameController,
                            hint: 'Write Name',
                            label: 'Name',
                            isEmail: false,
                            isPassword: false,
                            autofocus: true,
                            onChanged: _checkFormValidity,
                          ),
                          InputTextCustom(
                            controller: _shareEmailController,
                            hint: 'Write Email Address',
                            label: 'Email',
                            isEmail: false,
                            isPassword: false,
                            onChanged: _checkFormValidity,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Submit Button
                    PrimaryButtonWidget(
                      onPressed: isButtonEnabled
                          ? () {
                              if (_activeNFormKey.currentState?.validate() ??
                                  false) {
                                _investmentBloc.add(CdgInviteEvent(
                                    name: _nameController.text,
                                    email: _shareEmailController.text));
                              }
                            }
                          : null,
                      buttonText: 'send',
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

class CdgCurrencyExchangeScreen extends StatefulWidget {
  CdgCurrencyExchangeScreen(
      {super.key, required this.balance, required this.price});

  String balance, price;

  @override
  State<CdgCurrencyExchangeScreen> createState() =>
      _CdgCurrencyExchangeScreenState();
}

class _CdgCurrencyExchangeScreenState extends State<CdgCurrencyExchangeScreen> {
  final InvestmentBloc _investmentBloc = InvestmentBloc();
  bool isButtonEnabled = false;

  String masternodeCurrency = "";
  String convertCurrency = "USDC";
  double priceValue = 0.00;
  double balanceValue = 0.00;

  double convertValue = 0.00;

  final TextEditingController _amountController = TextEditingController();

  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    masternodeCurrency =
        widget.balance.replaceAll(RegExp(r'[0-9.]'), '').trim();

    priceValue =
        double.tryParse(widget.price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;

    balanceValue =
        double.tryParse(widget.balance.replaceAll(RegExp(r'[^0-9.]'), '')) ??
            0.0;

    _amountController.addListener(_checkFormValidity);
  }

  void _checkFormValidity() {
    setState(() {
      isButtonEnabled = _amountController.text.isNotEmpty;

      if (_amountController.text.isNotEmpty) {
        final parsedValue = double.tryParse(_amountController.text) ?? 0.0;
        final amountValue = double.parse(parsedValue.toStringAsFixed(6));
        convertValue = amountValue * priceValue;
      } else {
        convertValue = 0.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _investmentBloc,
      listener: (context, InvestmentState state) {
        if (state.statusModel?.status == 1) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => SuccessWidget(
                imageType: SuccessImageType.success,
                title: 'Conversion Success',
                subTitle: state.statusModel?.message ?? 'Success',
                btnText: 'Home',
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, "dashboard", (route) => false);
                },
                disableButton: false,
              ),
            ),
            (route) => false,
          );
        } else if (state.statusModel?.status == 0) {
          CustomToast.showError(
              context, "Sorry!", state.statusModel?.message ?? "Failed");
        }
      },
      child: BlocBuilder(
          bloc: _investmentBloc,
          builder: (context, InvestmentState state) {
            return Material(
              color: CustomColor.whiteColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16),
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
                              'Convert $masternodeCurrency To $convertCurrency',
                              style: GoogleFonts.inter(
                                  color: CustomColor.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                            Container(width: 10),
                          ],
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              InputTextCustom(
                                controller: _amountController,
                                hint: 'White Your Amount',
                                label: 'Sell CDG',
                                isEmail: false,
                                isPassword: false,
                                autofocus: true,
                                keyboardType: TextInputType.number,
                                onChanged: _checkFormValidity,
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 16),
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: CustomColor.hubContainerBgColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Current Balance',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.inter(
                                              color: CustomColor.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              widget.balance,
                                              textAlign: TextAlign.right,
                                              style: GoogleFonts.inter(
                                                color: CustomColor.black
                                                    .withOpacity(0.6),
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Price',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.inter(
                                              color: CustomColor.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              widget.price,
                                              textAlign: TextAlign.right,
                                              style: GoogleFonts.inter(
                                                color: CustomColor.black
                                                    .withOpacity(0.6),
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'You will get',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.inter(
                                              color: CustomColor.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              "${convertValue.toStringAsFixed(6)} $convertCurrency",
                                              textAlign: TextAlign.right,
                                              style: GoogleFonts.inter(
                                                color: CustomColor.black
                                                    .withOpacity(0.6),
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: PrimaryButtonWidget(
                            onPressed: isButtonEnabled &&
                                    0.00 < balanceValue &&
                                    balanceValue >=
                                        (double.tryParse(
                                                _amountController.text) ??
                                            double.infinity)
                                ? () {
                                    if (_formKey.currentState?.validate() ??
                                        false) {
                                      _investmentBloc.add(CdgConvertEvent(
                                          amount: _amountController.text));
                                    }
                                  }
                                : null,
                            buttonText: 'Convert',
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
