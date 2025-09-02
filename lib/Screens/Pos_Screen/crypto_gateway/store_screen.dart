import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:gptbanqbusiness/Screens/Pos_Screen/bloc/pos_bloc.dart';
import 'package:gptbanqbusiness/Screens/Pos_Screen/crypto_gateway/person_in_payment_dashboard_screen.dart';
import 'package:gptbanqbusiness/Screens/Pos_Screen/crypto_gateway/pos_dashboard_screen.dart';
import 'package:gptbanqbusiness/Screens/Pos_Screen/crypto_gateway/remote_payment_dashboard_screen.dart';
import 'package:gptbanqbusiness/Screens/Pos_Screen/crypto_gateway/stores_transaction_logs_screen.dart';
import 'package:gptbanqbusiness/utils/assets.dart';
import 'package:gptbanqbusiness/utils/input_fields/custom_color.dart';
import 'package:gptbanqbusiness/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gptbanqbusiness/constant_string/User.dart';
import 'package:gptbanqbusiness/cutom_weidget/custom_navigationBar.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:screenshot/screenshot.dart';

import '../../../widgets/buttons/custom_floating_action_button.dart';
import '../../../widgets/buttons/default_back_button_widget.dart';
import '../../../widgets/toast/toast_util.dart';

class StoreScreen extends StatefulWidget {
  StoreScreen({
    super.key,
    required this.storeName,
    required this.storeId,
    required this.storeCurrency,
    required this.storeCurrencyImage,
  });

  String storeName;
  String storeId;
  String storeCurrency;
  String storeCurrencyImage;

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  bool active = false;

  bool shownotification = true;
  final PosBloc _posBloc = PosBloc();

  Future<void> _onRefresh() async {
    debugPrint('_onRefresh');

    // _posBloc.add(CryptoPosListEvent());
  }

  @override
  void initState() {
    super.initState();
    User.Screen = 'crypto Store screen';
    // _posBloc.add(CryptoPosListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColor.scaffoldBg,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Stack(
          children: [
            BlocListener(
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
                              margin: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              child: ListView(
                                children: [
                                  Column(
                                    children: [
                                      appBarSection(context, state),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      StoreWidget(
                                        imagePath: StaticAssets.personInPayment,
                                        title: "Payment in person",
                                        subTitle:
                                            "Create a QR code for cryptocurrency\npayment,and you will get payment\nin your IBAN account.",
                                        onTap: () {
                                          Navigator.pushReplacement(
                                            context,
                                            PageTransition(
                                              type: PageTransitionType.fade,
                                              alignment: Alignment.center,
                                              isIos: true,
                                              duration: const Duration(
                                                  milliseconds: 200),
                                              child:
                                                  PersonInPaymentDashboardScreen(
                                                storeId: widget.storeId,
                                                storeName: widget.storeName,
                                                storeCurrency:
                                                    widget.storeCurrency,
                                                storeCurrencyImage:
                                                    widget.storeCurrencyImage,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      StoreWidget(
                                        imagePath: StaticAssets.remotePayment,
                                        title: "Remote Payment",
                                        subTitle:
                                            "Send a crypto payment link via email,\nwhich will be valid for 15 minutes\nafter being clicked by the consumer.",
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            PageTransition(
                                              type: PageTransitionType.scale,
                                              alignment: Alignment.center,
                                              isIos: true,
                                              duration: const Duration(
                                                  microseconds: 500),
                                              child:
                                                  RemotePaymentDashboardScreen(
                                                storeId: widget.storeId,
                                                storeName: widget.storeName,
                                                storeCurrency:
                                                    widget.storeCurrency,
                                                storeCurrencyImage:
                                                    widget.storeCurrencyImage,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        DefaultBackButtonWidget(onTap: () {
          Navigator.pushNamedAndRemoveUntil(
              context, 'merchantStoreScreen', (route) => false);
        }),
        Text(
          'Store ${widget.storeName}',
          style: GoogleFonts.inter(
              color: CustomColor.black,
              fontSize: 18,
              fontWeight: FontWeight.w500),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.scale,
                alignment: Alignment.center,
                isIos: true,
                duration: const Duration(microseconds: 500),
                child: StoresTransactionLogsScreen(
                  storeId: widget.storeId,
                  storeName: widget.storeName,
                ),
              ),
            );
          },
          child: CustomImageWidget(
            imagePath: StaticAssets.currencyArrow,
            imageType: 'svg',
            height: 24,
          ),
        ),
      ],
    );
  }
}

class StoreWidget extends StatelessWidget {
  final String? imagePath;
  final String? title;
  final String? subTitle;
  final VoidCallback onTap;

  const StoreWidget({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subTitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(12),
          ),
          color: CustomColor.kycContainerBgColor,
          border: Border.all(
            color: CustomColor.dashboardProfileBorderColor,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomImageWidget(
                  imagePath: imagePath!, // Use StaticAssets constant
                  imageType: 'svg',
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title ?? '',
                        style: GoogleFonts.inter(
                          color: CustomColor.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          '$subTitle',
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          // maxLines: 2,
                          style: GoogleFonts.inter(
                            color: CustomColor.subtitleTextColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            height: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            CustomImageWidget(
              imagePath: StaticAssets.arrowRight, // Use StaticAssets constant
              imageType: 'svg',
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
