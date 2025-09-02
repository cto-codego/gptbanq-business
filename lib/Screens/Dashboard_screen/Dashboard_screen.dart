import 'dart:async';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:gptbanqbusiness/Screens/currency_convert_screen/currency_exchange_dashboard_screen.dart';
import 'package:gptbanqbusiness/utils/assets.dart';
import 'package:gptbanqbusiness/widgets/custom_image_widget.dart';
import 'package:gptbanqbusiness/widgets/main_logo_widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constant_string/User.dart';
import '../../cutom_weidget/cutom_progress_bar.dart';
import '../../cutom_weidget/notification_pop.dart';
import '../../cutom_weidget/trx_biometric_confirmation_popup.dart';
import '../../utils/custom_scroll_behavior.dart';
import '../../utils/input_fields/custom_color.dart';
import '../../utils/location_serveci.dart';
import '../../utils/permissions/permission_manager.dart';
import '../../utils/user_data_manager.dart';
import '../../widgets/buttons/custom_circle_button_widget.dart';
import '../../widgets/buttons/custom_floating_action_button.dart';
import '../../widgets/buttons/primary_button_widget.dart';
import '../../widgets/main/hub_popup_content.dart';
import '../../widgets/main/iban_container_widget.dart';
import '../../widgets/main/swift_transaction_details_widget.dart';
import '../../widgets/main/transaction_card_widget.dart';
import '../../widgets/main/transaction_details_widget.dart';
import '../../widgets/toast/custom_dialog_widget.dart';
import '../../widgets/toast/toast_helper.dart';
import '../../widgets/toast/toast_util.dart';
import '../Profile_screen/Profile_screen.dart';
import '../Profile_screen/bloc/profile_bloc.dart';
import '../investment/cdg_masternode/cdg_investment_dashboard_screen.dart';
import '../no_network_connection/updateapp_screen.dart';
import 'bloc/dashboard_bloc.dart';
import 'deposit_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  final CarouselSliderController _controller = CarouselSliderController();

  // final ScrollController _scrollController = ScrollController();
  bool active = false;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // int _current = 0;
  int _currentIndex = 0;
  int the3dsconf = 0;

  String trx_uniquid = '';
  StreamController<Object> streamController =
      StreamController<Object>.broadcast();
  late TargetPlatform? platform;

  bool shownotification = true;
  final DashboardBloc _dashboardBloc = DashboardBloc();
  final ProfileBloc _profileBloc = ProfileBloc();

  List notificationList = [];
  String? label = "";
  int? sof = 0;

  bool isAccepted = false;
  String? pageName;

  Future<void> _onRefresh() async {
    debugPrint('_onRefresh');

    _dashboardBloc.add(DashboarddataEvent());
    _dashboardBloc.add(checkcardEvent());
  }

  @override
  void initState() {
    super.initState();
    // _dashboardBloc.add(checkupdate());

    User.Screen = 'Dashboard';

    if (Platform.isAndroid) {
      platform = TargetPlatform.android;
    } else {
      platform = TargetPlatform.iOS;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      PermissionManager.checkAndRequestPermissions(
        context,
        onDataCollected: (jsonData) {
          print('Collected JSON data in AnotherScreen: $jsonData');
          UserDataManager().userDeviceInfoSave(jsonData.toString());
        },
      );
    });

    firebaseCloudMessaging_Listeners(context);
    _dashboardBloc.add(DashboarddataEvent());

    _dashboardBloc.add(checkcardEvent());
    _dashboardBloc.add(TermsPdfEvent());
  }

  @override
  void dispose() {
    super.dispose();
    streamController.close();
  }

  @override
  Widget build(BuildContext context) {
    return User.isIban == 0
        ? Scaffold(
            backgroundColor: CustomColor.dashboardBgColor,
            body: BlocListener(
              bloc: _profileBloc,
              listener: (context, ProfileState state) {
                if (state.logoutModel?.status == 1) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/', (route) => false);
                }
              },
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MainLogoWidget(
                      width: double.maxFinite,
                    ),
                    const SizedBox(
                      height: 42,
                    ),
                    Container(
                        alignment: Alignment.center,
                        child: Image.asset('images/kyc_welcome.png')),
                    Text(
                      'Please wait while we verify your information, after while you will be redirected to your dashboard.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: CustomColor.black),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    PrimaryButtonWidget(
                      onPressed: () {
                        _profileBloc.add(LogoutEvent());
                      },
                      buttonText: 'Logout',
                    ),
                  ],
                ),
              ),
            ),
          )
        : Scaffold(
            backgroundColor: CustomColor.dashboardBgColor,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            body: BlocListener(
                bloc: _dashboardBloc,
                listener: (context, DashboardState state) async {
                  if (state.dashboardModel?.status == 1) {
                    User.profileimage = state.dashboardModel!.profileimage!;
                    User.currency = state.dashboardModel!.currency!;
                    User.ibanId = state.dashboardModel!.ibanId!;
                    User.isShowConversion =
                        state.dashboardModel!.isShowConversion!;

                    debugPrint(
                        "state.dashboardModel!.isShowConversion! ${state.dashboardModel!.isShowConversion!}");
                    debugPrint(
                        "state.dashboardModel!.isShowMoveBalance! ${state.dashboardModel!.isShowMoveBalance!}");

                    debugPrint(
                        "state.dashboardModel?.sof?.sourceOfWealth ${state.dashboardModel?.sof?.sourceOfWealth}");

                    debugPrint(state.dashboardModel?.ibanId.toString());
                    debugPrint(state.dashboardModel?.notifications.toString());

                    notificationList = state.dashboardModel!.notifications!;

                    UserDataManager().setUserIbanSave(
                        state.dashboardModel?.ibanId.toString());
                    UserDataManager().dashboardIbanSave(
                        state.dashboardModel!.ibanId!.toString());
                  }
                  if (state.termsPdfModel!.status == 1) {
                    User.termsPdf = state.termsPdfModel!.tcpdf!;
                    User.tccdgpdf = state.termsPdfModel!.tccdgpdf!;
                  }

                  if (state.updateModel?.status == 1) {
                    PackageInfo packageInfo = await PackageInfo.fromPlatform();

                    if (state.updateModel?.message != packageInfo.version) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => (UpdateAppScreen()),
                        ),
                      );
                    }
                  }

                  if (state.pdfmodel?.status == 1) {
                    final Uri pdfUrl = Uri.parse(state.pdfmodel!.url!);
                    if (await canLaunchUrl(pdfUrl)) {
                      await launchUrl(pdfUrl,
                          mode: LaunchMode.externalApplication);
                    } else {
                      throw 'Could not launch $pdfUrl';
                    }
                  }

                  if (state.dashboardModel?.sof?.sourceOfWealth == 1) {
                    label =
                        state.dashboardModel?.sof?.sourceOfWealthMsg.toString();
                    sof = 1;
                  }

                  if (state.transactiondetailsmodel?.status == 1) {
                    if (state.transactiondetailsmodel?.trxdata!.paymentMode ==
                        "sepa") {
                      showModalBottomSheet(
                          context: context,
                          isDismissible: true,
                          enableDrag: true,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          barrierColor: Colors.black.withOpacity(0.7),
                          useRootNavigator: true,
                          builder: (context) {
                            var data = state.transactiondetailsmodel!.trxdata!;
                            return TransactionDetailsWidget(
                              trxDataMode: data.mode!,
                              amount: data.amount!,
                              beneficiaryName: data.beneficiaryName ?? "",
                              transactionDate: data.transactionDate!,
                              fee: data.fee!,
                              accountHolder: data.accountHolder!,
                              afterBalance: data.afterBalance!,
                              beneficiaryCurrency: data.beneficiaryCurrency!,
                              beforeBalance: data.beforeBalance!,
                              currency: data.currency!,
                              label: data.label!,
                              receiverBic: data.receiverBic!,
                              receiverIban: data.receiverIban!,
                              reference: data.reference!,
                              status: data.status!,
                              transactionId: data.transactionId!,
                              paymentMode: data.paymentMode!,
                              transactionType: data.mode!,
                              onTap: () {
                                _dashboardBloc
                                    .add(DawnloadEvent(uniqueId: trx_uniquid));

                                Navigator.pop(context);
                              },
                            );
                          });
                    } else {
                      showModalBottomSheet(
                          context: context,
                          isDismissible: true,
                          enableDrag: true,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          barrierColor: Colors.black.withOpacity(0.7),
                          useRootNavigator: true,
                          builder: (context) {
                            var data = state.transactiondetailsmodel!.trxdata!;
                            return SwiftTransactionDetailsWidget(
                              recipientGets: data.receiptGet!,
                              note: data.note ?? "",
                              convertAmount: data.convertAmount!,
                              trxMode: data.trxMode!,
                              trxDataMode: data.mode!,
                              amount: data.amount!,
                              beneficiaryName: data.beneficiaryName!,
                              transactionDate: data.transactionDate!,
                              fee: data.fees!,
                              accountHolder: data.accountHolder!,
                              afterBalance: data.afterBalance!,
                              beneficiaryCurrency: data.beneficiaryCurrency!,
                              beforeBalance: data.beforeBalance!,
                              currency: data.currency!,
                              label: data.label!,
                              receiverBic: data.receiverBic!,
                              receiverIban: data.receiverIban!,
                              reference: data.reference!,
                              status: data.status!,
                              exchangeAmount: data.exchangeAmount!,
                              exchangeRate: data.exchangeRate!,
                              yourTotal: data.totalPay!,
                              exchangeFee: data.exchangeFee!,
                              internationFee: data.internationFee!,
                              transactionId: data.transactionId!,
                              transactionType: data.mode!,
                              paymentMode: data.paymentMode!,
                              receiverAccountHolder: data.beneficiaryName!,
                              onTap: () {
                                _dashboardBloc
                                    .add(DawnloadEvent(uniqueId: trx_uniquid));

                                Navigator.pop(context);
                              },
                            );
                          });
                    }
                  }

                  if (state.cardordermodel?.status == 1) {
                    User.cardexits = state.cardordermodel?.isCardOrder;
                  }

                  if (state.statusModel?.status == 0) {
                    CustomDialogWidget.showErrorDialog(
                        context: context,
                        title: "Sorry",
                        subTitle: state.statusModel!.message!,
                        btnOkText: 'Ok');
                  }

                  if (state.transactionApprovedModel?.status == 1) {
                    CustomDialogWidget.showSuccessDialog(
                        context: context,
                        title: "Hey!",
                        subTitle: state.transactionApprovedModel!.message!,
                        btnOkText: 'Ok');
                  }

                  //iban list
                  if (state.ibanlistModel?.status == 1) {
                    showModalBottomSheet(
                        context: context,
                        isDismissible: true,
                        enableDrag: true,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        barrierColor: Colors.black.withOpacity(0.7),
                        useRootNavigator: true,
                        builder: (context) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            height: MediaQuery.of(context).size.height * 0.85,
                            decoration: BoxDecoration(
                                color: CustomColor.whiteColor,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16))),
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                ListView(
                                  shrinkWrap: true,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: CustomImageWidget(
                                              imagePath:
                                                  StaticAssets.closeBlack,
                                              imageType: 'svg',
                                              height: 24,
                                            ),
                                          ),
                                          Text(
                                            User.isWallet == 0
                                                ? "IBAN Accounts"
                                                : "Your Accounts",
                                            style: GoogleFonts.inter(
                                              fontSize: 28,
                                              fontWeight: FontWeight.w500,
                                              color: CustomColor.black,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 24,
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    ListView.builder(
                                      itemCount:
                                          state.ibanlistModel!.ibaninfo!.length,
                                      shrinkWrap: true,
                                      physics: const ScrollPhysics(),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        var ibanInfo =
                                            state.ibanlistModel!.ibaninfo!;
                                        return IbanCardWidget(
                                          label: ibanInfo[index].label!,
                                          image: ibanInfo[index].currencyflag!,
                                          iban: ibanInfo[index].iban!,
                                          bic: ibanInfo[index].bic!,
                                          balance: ibanInfo[index].balance!,
                                          currency: ibanInfo[index].currency!,
                                          onTap: () {
                                            // Navigator.pop(context);

                                            UserDataManager().dashboardIbanSave(
                                                ibanInfo[index]
                                                    .ibanId
                                                    .toString());

                                            Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                'dashboard',
                                                (route) => false);
                                          },
                                          onTapIbanCopy: () async {
                                            await Clipboard.setData(
                                              ClipboardData(
                                                text: ibanInfo[index].iban!,
                                              ),
                                            );

                                            // Show SnackBar
                                            ToastHelper.showToast(
                                                context,
                                                "Success",
                                                User.isWallet == 0
                                                    ? "IBAN number copied"
                                                    : "Account number copied",
                                                ToastType.success);
                                          },
                                          onTapBicCopy: () async {
                                            await Clipboard.setData(
                                              ClipboardData(
                                                text: ibanInfo[index].bic!,
                                              ),
                                            );

                                            ToastHelper.showToast(
                                                context,
                                                "Success",
                                                "BIC number copied",
                                                ToastType.success);
                                          },
                                        );
                                      },
                                    ),
                                    const SizedBox(
                                      height: 50,
                                    ),
                                  ],
                                ),
                                Positioned(
                                  bottom: 0,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pushNamedAndRemoveUntil(context,
                                          'createIbanScreen', (route) => true);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: MediaQuery.of(context).size.width *
                                          0.85,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 16),
                                      decoration: BoxDecoration(
                                        color: CustomColor.primaryColor,
                                        borderRadius: BorderRadius.circular(48),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(right: 5),
                                            child: Icon(
                                              Icons.add,
                                              size: 20,
                                              color: CustomColor.whiteColor,
                                            ),
                                          ),
                                          Text(
                                            User.isWallet == 0
                                                ? "Create new IBAN account"
                                                : "Create new Account",
                                            style: GoogleFonts.inter(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                color: CustomColor.whiteColor),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                  }

                  if (state.convertCurrencyListModel?.status == 1) {
                    print("convertCurrencyListModel");
                    Navigator.pushReplacement(
                      context,
                      PageTransition(
                        type: PageTransitionType.scale,
                        alignment: Alignment.center,
                        isIos: true,
                        duration: const Duration(microseconds: 500),
                        child: CurrencyExchangeDashboardScreen(
                          buyCurrency:
                              state.convertCurrencyListModel!.buyCurrency!,
                        ),
                      ),
                    );
                  }

                  if (state.convertCurrencyListModel?.status == 0) {
                    CustomToast.showError(context, "Sorry!",
                        state.convertCurrencyListModel!.message!);
                  }

                  if (state.walletTransferIbanListModel?.status == 1) {
                    Navigator.pushNamedAndRemoveUntil(context,
                        'walletTransferDashboardScreen', (route) => false);
                  } else if (state.walletTransferIbanListModel?.status == 0) {
                    CustomToast.showError(context, "Sorry!",
                        state.walletTransferIbanListModel!.message!);
                  }
                },
                child: BlocBuilder(
                    bloc: _dashboardBloc,
                    builder: (context, DashboardState state) {
                      return StreamBuilder<Object>(
                          stream: streamController.stream.asBroadcastStream(
                        onListen: (subscription) async {
                          await Future.delayed(const Duration(minutes: 5), () {
                            // _dashboardBloc.add(checkupdate());
                          });
                        },
                      ), builder: (context, snapshot) {
                        return SafeArea(
                          child: ProgressHUD(
                            inAsyncCall: state.isloading,
                            child: RefreshIndicator(
                              onRefresh: _onRefresh,
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      // margin: EdgeInsets.only(bottom: 16),
                                      padding: EdgeInsets.only(
                                        left: 16,
                                        right: 16,
                                        top: 16,
                                      ),

                                      child: Column(
                                        children: [
                                          _appBarSectionWidget(
                                              state
                                                  .dashboardModel!.profileimage,
                                              state.dashboardModel!
                                                      .notifications!.isEmpty
                                                  ? false
                                                  : true),
                                          Container(
                                            // height: 139,
                                            padding: EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              color: CustomColor.whiteColor,
                                              borderRadius: BorderRadius.circular(
                                                  16.0), // Rounded corners (16.dp)
                                              boxShadow: [
                                                BoxShadow(
                                                  color:
                                                      const Color(0x1A000000),
                                                  blurRadius: 6.0,
                                                  offset: Offset(0, 2.5),
                                                ),
                                                BoxShadow(
                                                  color:
                                                      const Color(0x33000000),
                                                  blurRadius: 6.0,
                                                  offset: Offset(0, 2.5),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                bottom: 12),
                                                        child: Text(
                                                          'YOUR BALANCE',
                                                          style:
                                                              GoogleFonts.inter(
                                                            color: CustomColor
                                                                .inputFieldTitleTextColor,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                      ),
                                                      RichText(
                                                        text: TextSpan(
                                                          children: [
                                                            if (state
                                                                    .dashboardModel
                                                                    ?.symbol
                                                                    ?.isNotEmpty ??
                                                                false)
                                                              TextSpan(
                                                                text: state
                                                                        .dashboardModel
                                                                        ?.symbol ??
                                                                    '',
                                                                style:
                                                                    GoogleFonts
                                                                        .inter(
                                                                  color: CustomColor
                                                                      .inputFieldTitleTextColor,
                                                                  fontSize: 36,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            TextSpan(
                                                              text: state
                                                                      .dashboardModel
                                                                      ?.balance ??
                                                                  '0.00',
                                                              style: GoogleFonts
                                                                  .inter(
                                                                color:
                                                                    CustomColor
                                                                        .black,
                                                                fontSize: 36,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      if (state.dashboardModel!
                                                              .provider !=
                                                          'wallet')
                                                        Container(
                                                          // width: 180,
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 12),
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  "${state.dashboardModel?.accountLabel}: ${state.dashboardModel?.iban ?? 'N/A'}",
                                                                  style:
                                                                      GoogleFonts
                                                                          .inter(
                                                                    color: CustomColor
                                                                        .inputFieldTitleTextColor,
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                                if (state
                                                        .dashboardModel
                                                        ?.currencyFlag
                                                        ?.isNotEmpty ??
                                                    false)
                                                  Container(
                                                    height: 36,
                                                    width: 36,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                        image: NetworkImage(state
                                                                .dashboardModel
                                                                ?.currencyFlag ??
                                                            ""),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                CustomCircleButtonWidget(
                                                  icon:
                                                      StaticAssets.arrowUpRight,
                                                  onPressed: () {
                                                    Navigator
                                                        .pushNamedAndRemoveUntil(
                                                      context,
                                                      'beneficiaryListScreen',
                                                      (route) => false,
                                                    );
                                                  },
                                                ),
                                                if (state.dashboardModel
                                                        ?.showDeposit ==
                                                    1)
                                                  CustomCircleButtonWidget(
                                                    transferButton: false,
                                                    icon: StaticAssets
                                                        .arrowDownLeft,
                                                    onPressed: () {
                                                      var data =
                                                          state.dashboardModel!;
                                                      Navigator.push(
                                                        context,
                                                        PageTransition(
                                                          child:
                                                              DashboardDepositScreen(
                                                            ibanId:
                                                                data.ibanId!,
                                                          ),
                                                          type:
                                                              PageTransitionType
                                                                  .rightToLeft,
                                                          alignment:
                                                              Alignment.center,
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      300),
                                                          reverseDuration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      200),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                if (state.dashboardModel
                                                        ?.isShowConversion ==
                                                    1)
                                                  CustomCircleButtonWidget(
                                                    icon: StaticAssets
                                                        .exchangeIcon,
                                                    onPressed: () {
                                                      var data =
                                                          state.dashboardModel!;
                                                      _dashboardBloc.add(
                                                          ConvertCurrencyListEvent(
                                                              buyCurrency: data
                                                                  .currency));
                                                    },
                                                  ),
                                                if (state.dashboardModel
                                                        ?.isShowMoveBalance ==
                                                    1)
                                                  CustomCircleButtonWidget(
                                                    icon: StaticAssets
                                                        .walletTransferIcon,
                                                    onPressed: () {
                                                      _dashboardBloc.add(
                                                          WalletTransferIbanListEvent(
                                                              ibanId:
                                                                  User.ibanId));
                                                    },
                                                  ),
                                                CustomCircleButtonWidget(
                                                  icon: StaticAssets.bank,
                                                  onPressed: () {
                                                    _dashboardBloc.add(
                                                        getibanlistEvent());
                                                  },
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    if (User.hidecdg == 0)
                                      InkWell(
                                        onTap: () {
                                          if (User.tcCdg == 0) {
                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              backgroundColor: Colors.white,
                                              barrierColor:
                                                  Colors.black.withOpacity(0.2),
                                              builder: (context) {
                                                return TermsContent(
                                                  pdfLink: User.tccdgpdf,
                                                  isAccepted: isAccepted,
                                                  onAcceptedChanged: (value) {
                                                    isAccepted = value;
                                                  },
                                                  onSubmit: () {
                                                    pageName = "cdg";
                                                    User.tcCdg = 1;
                                                    debugPrint("CDG");

                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            CdgInvestmentDashboardScreen(
                                                          isTcInvestmentCall:
                                                              true,
                                                        ), // Navigate to CryptoScreen
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            );
                                          } else {
                                            Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                'cdgInvestmentDashboardScreen',
                                                (route) => false);
                                          }
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              left: 16, right: 16, top: 12),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(52.58),
                                              color: CustomColor.green
                                                  .withOpacity(0.2),
                                              border: Border.all(
                                                  color: CustomColor.whiteColor,
                                                  width: 2)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 5, vertical: 5),
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: CustomColor.green
                                                      .withValues(alpha: 0.2),
                                                ),
                                                child: CustomImageWidget(
                                                  imagePath:
                                                      StaticAssets.cdgDevice,
                                                  imageType: 'png',
                                                  height: 40,
                                                  width: 40,
                                                ),
                                              ),
                                              if (state.dashboardModel!.cdgText!
                                                  .isNotEmpty)
                                                Expanded(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 8),
                                                    child: Text(
                                                      state.dashboardModel!
                                                          .cdgText!,
                                                      textAlign: TextAlign.left,
                                                      style: GoogleFonts.inter(
                                                          color:
                                                              CustomColor.black,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10),
                                                child: Icon(
                                                  Icons.arrow_forward_ios_sharp,
                                                  color: Colors.black,
                                                  size: 18,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    if (sof == 1)
                                      InkWell(
                                        onTap: () {
                                          Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              'profileScreen',
                                              (route) => false);
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              left: 16, right: 16, top: 12),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(52.58),
                                              color: CustomColor.errorColor
                                                  .withOpacity(0.2),
                                              border: Border.all(
                                                  color: CustomColor.whiteColor,
                                                  width: 2)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 10),
                                                padding: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: CustomColor.errorColor,
                                                ),
                                                child: CustomImageWidget(
                                                  imagePath:
                                                      StaticAssets.warning,
                                                  imageType: 'svg',
                                                  height: 16,
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.only(right: 8),
                                                  child: Text(
                                                    label!,
                                                    textAlign: TextAlign.left,
                                                    style: GoogleFonts.inter(
                                                        color: CustomColor
                                                            .errorColor,
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    if (state.dashboardModel?.the3Dsconf!
                                            .status! ==
                                        1)
                                      InkWell(
                                        onTap: () {
                                          String? uniqueId = state
                                              .dashboardModel
                                              ?.the3Dsconf!
                                              .uniqueId
                                              .toString();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  TrxConfirmationScreen(
                                                      uniqueId: uniqueId!),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          margin: const EdgeInsets.only(
                                              left: 16, right: 16),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 5),
                                          decoration: BoxDecoration(
                                              color: const Color(0xffFFD058),
                                              borderRadius:
                                                  BorderRadius.circular(52.58),
                                              border: Border.all(
                                                  color: CustomColor.whiteColor,
                                                  width: 2)),
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Text(
                                              state.dashboardModel?.the3Dsconf!
                                                      .body
                                                      .toString() ??
                                                  "",
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                color: Color(0xFFFF6B00),
                                                fontFamily: 'Poppins',
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    if (state.dashboardModel?.the3Dsconf!
                                            .status! ==
                                        1)
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    Container(
                                        margin: const EdgeInsets.only(
                                            left: 16, right: 16, top: 10),
                                        padding: EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          border: Border.all(
                                              color: Color(0xFFE3E3E3)),
                                          color: Color(0xFFF6F9FC),
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Transactions",
                                                  style: GoogleFonts.inter(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: CustomColor.black,
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    Navigator
                                                        .pushNamedAndRemoveUntil(
                                                            context,
                                                            'transactionScreen',
                                                            (route) => true);
                                                  },
                                                  child: Text(
                                                    "Export PDF",
                                                    style: GoogleFonts.inter(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color(0xff5C5C5C),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (state
                                                    .dashboardModel!
                                                    .transaction!
                                                    .past!
                                                    .isEmpty &&
                                                state
                                                    .dashboardModel!
                                                    .transaction!
                                                    .yesterday!
                                                    .isEmpty &&
                                                state
                                                    .dashboardModel!
                                                    .transaction!
                                                    .today!
                                                    .isEmpty)
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 20),
                                                child: Column(
                                                  children: [
                                                    CustomImageWidget(
                                                      imagePath: StaticAssets
                                                          .noTransaction,
                                                      imageType: 'svg',
                                                      height: 130,
                                                    ),
                                                    Text(
                                                      "No Transaction",
                                                      style: GoogleFonts.inter(
                                                        color: CustomColor.black
                                                            .withOpacity(0.6),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            else
                                              Column(
                                                // shrinkWrap: true,
                                                // physics:
                                                //     NeverScrollableScrollPhysics(),
                                                // padding:
                                                //     const EdgeInsets.all(0),
                                                children: [
                                                  //today list
                                                  if (state
                                                      .dashboardModel!
                                                      .transaction!
                                                      .today!
                                                      .isNotEmpty)
                                                    ListView.builder(
                                                      itemCount: state
                                                          .dashboardModel!
                                                          .transaction!
                                                          .today!
                                                          .length,
                                                      shrinkWrap: true,
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        var today = state
                                                            .dashboardModel!
                                                            .transaction!
                                                            .today![index];
                                                        return TransactionCardWidget(
                                                          uniqueId:
                                                              today.unique_id!,
                                                          image: today.image,
                                                          beneficiaryName: today
                                                              .beneficiaryName!,
                                                          reasonPayment: today
                                                              .reasonPayment!,
                                                          created:
                                                              today.created!,
                                                          amount:
                                                              "${today.amount!} ${today.beneficiaryCurrency!}",
                                                          status: today.status!,
                                                          type: today.type!,
                                                          onTap: () {
                                                            trx_uniquid = today
                                                                .unique_id!;
                                                            _dashboardBloc.add(
                                                                transactiondetailsEvent(
                                                                    uniqueId:
                                                                        trx_uniquid));
                                                          },
                                                        );
                                                      },
                                                    )
                                                  else
                                                    Container(),

                                                  //yesterday list
                                                  if (state
                                                      .dashboardModel!
                                                      .transaction!
                                                      .yesterday!
                                                      .isNotEmpty)
                                                    ListView.builder(
                                                      itemCount: state
                                                          .dashboardModel!
                                                          .transaction!
                                                          .yesterday!
                                                          .length,
                                                      shrinkWrap: true,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        var yesterdayList = state
                                                            .dashboardModel!
                                                            .transaction!
                                                            .yesterday![index];
                                                        return TransactionCardWidget(
                                                          uniqueId:
                                                              yesterdayList
                                                                  .unique_id!,
                                                          image: yesterdayList
                                                              .image,
                                                          beneficiaryName:
                                                              yesterdayList
                                                                  .beneficiaryName!,
                                                          reasonPayment:
                                                              yesterdayList
                                                                  .reasonPayment!,
                                                          created: yesterdayList
                                                              .created!,
                                                          amount:
                                                              "${yesterdayList.amount!} ${yesterdayList.beneficiaryCurrency!}",
                                                          status: yesterdayList
                                                              .status!,
                                                          type: yesterdayList
                                                              .type!,
                                                          onTap: () {
                                                            trx_uniquid =
                                                                yesterdayList
                                                                    .unique_id!;
                                                            _dashboardBloc.add(
                                                                transactiondetailsEvent(
                                                                    uniqueId:
                                                                        trx_uniquid));
                                                          },
                                                        );
                                                      },
                                                    )
                                                  else
                                                    Container(),
                                                  ListView.builder(
                                                    itemCount: state
                                                        .dashboardModel!
                                                        .transaction!
                                                        .past!
                                                        .length,
                                                    shrinkWrap: true,
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      var pastList = state
                                                          .dashboardModel!
                                                          .transaction!
                                                          .past![index];
                                                      return TransactionCardWidget(
                                                        uniqueId:
                                                            pastList.uniqueId!,
                                                        image: pastList.image,
                                                        beneficiaryName: pastList
                                                            .beneficiaryName!,
                                                        reasonPayment: pastList
                                                            .reasonPayment!,
                                                        created:
                                                            pastList.created!,
                                                        amount:
                                                            "${pastList.amount!} ${pastList.beneficiaryCurrency!}",
                                                        status:
                                                            pastList.status!,
                                                        type: pastList.type!,
                                                        onTap: () {
                                                          trx_uniquid = pastList
                                                              .uniqueId!;
                                                          _dashboardBloc.add(
                                                              transactiondetailsEvent(
                                                                  uniqueId:
                                                                      trx_uniquid));
                                                        },
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                    })),
            floatingActionButton: CustomFloatingActionButton());
  }

  _appBarSectionWidget(String? profileImage, bool isNotificationEmpty) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              Navigator.pushReplacement(
                context,
                PageTransition(
                  type: PageTransitionType.scale,
                  alignment: Alignment.center,
                  isIos: true,
                  duration: const Duration(microseconds: 500),
                  child: const ProfileScreen(),
                ),
              );
            },
            child: Container(
              height: 48,
              width: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: CustomColor.whiteColor,
                  border: Border.all(
                    color: Color(0xffE3E3E3),
                    width: 2,
                  ),
                  image: DecorationImage(
                      image: NetworkImage(
                        profileImage!,
                      ),
                      fit: BoxFit.cover)),
            ),
          ),
          MainLogoWidget(
            height: 50,
          ),
          Stack(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, 'notificationScreen', (route) => true);
                },
                child: Container(
                  height: 48,
                  width: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      // Equivalent to `EllipticalGradient` in SwiftUI
                      center: const Alignment(0.5, -2.65),
                      // Center of the gradient
                      radius: 1.412,
                      // Approximation for radial size adjustment
                      colors: [
                        const Color.fromRGBO(224, 242, 255, 1),
                        // Color at location 0.0
                        Colors.white,
                        // Color at location 1.0
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        // Shadow color with 7% opacity
                        blurRadius: 6.0,
                        // Blur radius for the shadow
                        offset: const Offset(0, 2), // Offset (x: 0, y: 2)
                      ),
                    ],
                    border: Border.all(
                      color: const Color.fromRGBO(239, 243, 247, 1),
                      // Border color
                      width: 1.0, // Border width
                    ),
                  ),
                  child: CustomImageWidget(
                    imagePath: StaticAssets.bell,
                    imageType: 'svg',
                    height: 18,
                    width: 18,
                  ),
                ),
              ),
              isNotificationEmpty
                  ? Positioned(
                      top: 15,
                      right: 16,
                      child: Container(
                        height: 6,
                        width: 6,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: CustomColor.errorColor,
                        ),
                      ),
                    )
                  : SizedBox()
            ],
          )
        ],
      ),
    );
  }

  void iOS_Permission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true, badge: true, sound: true);

    print("123Settings registered: ${settings.authorizationStatus}");
  }

  void firebaseCloudMessaging_Listeners(BuildContext context) {
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then((message) async {
      if (message != null) {
        debugPrint('dashboard terminated');
        await _handleNotification(message);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint('Foreground message received: ${message.data}');
      await _handleNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      debugPrint('Message opened from background: ${message.data}');
      await _handleNotification(message);
    });

    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
  }

  Future<void> _handleNotification(RemoteMessage message) async {
    try {
      final category = message.data['category'];
      if (category == null) return;

      switch (category) {
        case 'deposit_iban':
          _dashboardBloc.add(DashboarddataEvent());
          break;
        case 'iban_confirm_transaction':
          approveMovefromwallets(message);
          break;
        case 'confirm_transaction':
          Approvecoinconvert(message);
          break;
        case 'move_cryptoeur_to_iban':
          ApprovetransferEurotoiban(message);
          break;
        case 'iban_confirm_transaction_crypto':
          ApproveEurotocrypto(message);
          break;
        case 'web_login_verified':
          approveBrowserLogin(message);
          break;
        case 'trx_biometric_confirmation':
          trxBiometricConfirmationWidget(message);
          break;
        case 'current-location':
          if (await Permission.location.isGranted) {
            Locationservece().getCurrentLocation();
          }
          break;
        case 'request_for_sessiondata':
          final uniqueId = message.data['unique_id'];
          if (uniqueId != null) {
            _dashboardBloc.add(RequestForSessionDataEvent(uniqueId: uniqueId));
          }
          break;
      }
    } catch (e) {
      debugPrint('Error handling notification: $e');
    }
  }

  approveMovefromwallets(RemoteMessage message) {
    try {
      showGeneralDialog(
        context: context,
        pageBuilder: (BuildContext buildContext, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Material(
                  color: Colors.transparent,
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
                                  message.notification!.title!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'pop',
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 40),
                                Image.asset(
                                  'images/bell.png',
                                  color: const Color(0xff090B78),
                                  width: 100,
                                  height: 100,
                                ),
                                const SizedBox(height: 40),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 20),
                                      Text(
                                        message.notification!.body!,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'pop',
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 100),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      gradient: const LinearGradient(colors: [
                                        Color(0xff090B78),
                                        Color(0xff090B78)
                                      ])),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _dashboardBloc
                                          .add(ApproveMoveWalletsEvent(
                                        uniqueId: message.data['unique_id'],
                                        completed: 'Completed',
                                      ));
                                      Navigator.popUntil(
                                          context, (route) => route.isFirst);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0)),
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                        shadowColor: Colors.transparent,
                                        minimumSize: const Size.fromHeight(50)),
                                    child: const Text(
                                      "Confirm",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'pop',
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 50),
                                InkWell(
                                  onTap: () {
                                    Navigator.popUntil(
                                        context, (route) => route.isFirst);
                                    _dashboardBloc.add(ApproveMoveWalletsEvent(
                                      uniqueId: message.data['unique_id'],
                                      completed: 'Canceled',
                                    ));
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: double.infinity,
                                    height: 40,
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.7),
                                        fontSize: 16,
                                        decoration: TextDecoration.underline,
                                        fontFamily: 'pop',
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black.withOpacity(0.1),
        transitionDuration: const Duration(milliseconds: 0),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
    ;
  }

  Approvecoinconvert(RemoteMessage message) {
    try {
      showGeneralDialog(
        context: context,
        pageBuilder: (BuildContext buildContext, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Material(
                  color: Colors.transparent,
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
                                  message.notification!.title!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'pop',
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 40),
                                Image.asset(
                                  'images/bell.png',
                                  color: const Color(0xff090B78),
                                  width: 100,
                                  height: 100,
                                ),
                                const SizedBox(height: 40),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 20),
                                      Text(
                                        message.notification!.body!,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'pop',
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 100),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      gradient: const LinearGradient(colors: [
                                        Color(0xff090B78),
                                        Color(0xff090B78)
                                      ])),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _dashboardBloc
                                          .add(ApproveTransactionEvent(
                                        uniqueId: message.data['unique_id'],
                                        completed: 'Completed',
                                      ));
                                      Navigator.popUntil(
                                          context, (route) => route.isFirst);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0)),
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                        shadowColor: Colors.transparent,
                                        minimumSize: const Size.fromHeight(50)),
                                    child: const Text(
                                      "Confirm",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'pop',
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 50),
                                InkWell(
                                  onTap: () {
                                    Navigator.popUntil(
                                        context, (route) => route.isFirst);
                                    _dashboardBloc.add(ApproveTransactionEvent(
                                      uniqueId: message.data['unique_id'],
                                      completed: 'Canceled',
                                    ));
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: double.infinity,
                                    height: 40,
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.7),
                                        fontSize: 16,
                                        decoration: TextDecoration.underline,
                                        fontFamily: 'pop',
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black.withOpacity(0.1),
        transitionDuration: const Duration(milliseconds: 0),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
    ;
  }

  ApprovetransferEurotoiban(RemoteMessage message) {
    try {
      showGeneralDialog(
        context: context,
        pageBuilder: (BuildContext buildContext, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Material(
                  color: Colors.transparent,
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
                                  message.notification!.title!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'pop',
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 40),
                                Image.asset(
                                  'images/bell.png',
                                  color: const Color(0xff090B78),
                                  width: 100,
                                  height: 100,
                                ),
                                const SizedBox(height: 40),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 20),
                                      Text(
                                        message.notification!.body!,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'pop',
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 100),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      gradient: const LinearGradient(colors: [
                                        Color(0xff090B78),
                                        Color(0xff090B78)
                                      ])),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _dashboardBloc.add(ApproveEurotoIbanEvent(
                                        uniqueId: message.data['unique_id'],
                                        completed: 'Completed',
                                      ));
                                      Navigator.popUntil(
                                          context, (route) => route.isFirst);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0)),
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                        shadowColor: Colors.transparent,
                                        minimumSize: const Size.fromHeight(50)),
                                    child: const Text(
                                      "Confirm",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'pop',
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 50),
                                InkWell(
                                  onTap: () {
                                    Navigator.popUntil(
                                        context, (route) => route.isFirst);
                                    _dashboardBloc.add(ApproveEurotoIbanEvent(
                                      uniqueId: message.data['unique_id'],
                                      completed: 'Canceled',
                                    ));
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: double.infinity,
                                    height: 40,
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.7),
                                        fontSize: 16,
                                        decoration: TextDecoration.underline,
                                        fontFamily: 'pop',
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black.withOpacity(0.1),
        transitionDuration: const Duration(milliseconds: 0),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
    ;
  }

  approveBrowserLogin(RemoteMessage message) {
    try {
      ApproveNotfications.approveTransaction(
          title: message.notification!.title!,
          body: message.notification!.body!,
          onConfirm: () {
            Navigator.popUntil(context, (route) => route.isFirst);
            _dashboardBloc.add(ApproveBrowserLoginEvent(
                uniqueId: message.data['unique_id'], loginStatus: 1));
          },
          onDecline: () {
            Navigator.popUntil(context, (route) => route.isFirst);
            _dashboardBloc.add(ApproveBrowserLoginEvent(
                uniqueId: message.data['unique_id'], loginStatus: 3));
          },
          context: context);
    } catch (e) {
      print(e);
    }
  }

  trxBiometricConfirmationWidget(RemoteMessage message) {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              TrxConfirmationScreen(uniqueId: message.data['unique_id']),
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  ApproveEurotocrypto(RemoteMessage message) {
    try {
      showGeneralDialog(
        context: context,
        pageBuilder: (BuildContext buildContext, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Material(
                  color: Colors.transparent,
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
                                  message.notification!.title!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'pop',
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 40),
                                Image.asset(
                                  'images/bell.png',
                                  color: const Color(0xff090B78),
                                  width: 100,
                                  height: 100,
                                ),
                                const SizedBox(height: 40),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 20),
                                      Text(
                                        message.notification!.body!,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'pop',
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 100),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      gradient: const LinearGradient(colors: [
                                        Color(0xff090B78),
                                        Color(0xff090B78)
                                      ])),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _dashboardBloc
                                          .add(ApproveEurotoCryptoEvent(
                                        uniqueId: message.data['unique_id'],
                                        completed: 'Completed',
                                      ));
                                      Navigator.popUntil(
                                          context, (route) => route.isFirst);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0)),
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                        shadowColor: Colors.transparent,
                                        minimumSize: const Size.fromHeight(50)),
                                    child: const Text(
                                      "Confirm",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'pop',
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 50),
                                InkWell(
                                  onTap: () {
                                    Navigator.popUntil(
                                        context, (route) => route.isFirst);
                                    _dashboardBloc.add(ApproveEurotoCryptoEvent(
                                      uniqueId: message.data['unique_id'],
                                      completed: 'Canceled',
                                    ));
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: double.infinity,
                                    height: 40,
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.7),
                                        fontSize: 16,
                                        decoration: TextDecoration.underline,
                                        fontFamily: 'pop',
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black.withOpacity(0.1),
        transitionDuration: const Duration(milliseconds: 0),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
    ;
  }

  paymentConfirmation(RemoteMessage message) {
    try {
      CustomDialogWidget.showWarningDialog(
          context: context,
          title: message.notification!.title!,
          subTitle: message.notification!.body!,
          btnOkText: 'Ok',
          btnOkOnPress: () {
            Navigator.pushNamedAndRemoveUntil(
                context, 'dashboard', (route) => false);
          });
    } catch (e) {
      debugPrint("confirmation message");
    }
  }

  void transpopup(
      {BuildContext? context,
      String? image,
      title,
      description,
      status,
      date,
      fee,
      amount}) {
    showModalBottomSheet(
        context: context!,
        isDismissible: true,
        enableDrag: true,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        barrierColor: Colors.black.withOpacity(0.7),
        useRootNavigator: true,
        builder: (context) {
          return Container(
              padding: const EdgeInsets.only(
                top: 10,
                right: 20,
                left: 20,
                bottom: 25,
              ),
              margin: const EdgeInsets.only(right: 0, left: 0, bottom: 0),
              decoration: const BoxDecoration(
                color: Color(0xffE4E3E3),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(11),
                    topRight: Radius.circular(11)),
              ),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: 100,
                      height: 100,
                      child: image == ''
                          ? const Icon(
                              Icons.swap_horiz_rounded,
                              color: Color(0xff10245C),
                              size: 50,
                            )
                          : Image.network(image!),
                    ),
                    Text(
                      date!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: const Color(0xff10245C).withOpacity(0.6),
                          fontSize: 14,
                          fontFamily: 'pop'),
                    ),
                    Text(
                      status!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.green,
                          fontSize: 14,
                          fontFamily: 'pop',
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      title!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Color(0xff10245C),
                          fontSize: 15,
                          fontFamily: 'pop',
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      description!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Color(0xff10245C),
                          fontSize: 14,
                          fontFamily: 'pop',
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Fees',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color(0xff10245C),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              fontFamily: 'pop'),
                        ),
                        Text(
                          fee!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: const Color(0xff10245C).withOpacity(0.8),
                              fontSize: 14,
                              fontFamily: 'pop'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Amount',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color(0xff10245C),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              fontFamily: 'pop'),
                        ),
                        Text(
                          amount!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: const Color(0xff10245C).withOpacity(0.8),
                              fontSize: 14,
                              fontFamily: 'pop'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                )
              ]));
        });
  }
}

Future myBackgroundMessageHandler(RemoteMessage message) async {
  final dynamic data = message.data;
  if (data != null) {
    debugPrint(
        'dashboard screen on myBackgroundMessageHandler dashboard $data');
  }

  if (message.notification != null) {
    debugPrint(
        'dashboard screen on myBackgroundMessageHandler dashboard $message');
    // final dynamic notification = message.notification;
  }
}
