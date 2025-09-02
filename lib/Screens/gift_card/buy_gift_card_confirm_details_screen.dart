import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:gptbanqbusiness/Screens/Dashboard_screen/bloc/dashboard_bloc.dart';
import 'package:gptbanqbusiness/constant_string/User.dart';
import 'package:gptbanqbusiness/utils/input_fields/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../cutom_weidget/cutom_progress_bar.dart';
import '../../widgets/buttons/default_back_button_widget.dart';
import '../../widgets/buttons/primary_button_widget.dart';
import '../../widgets/toast/toast_util.dart';

class BuyGiftCardConfirmDetailsScreen extends StatefulWidget {
  BuyGiftCardConfirmDetailsScreen({super.key, required this.amount});

  String amount;

  @override
  State<BuyGiftCardConfirmDetailsScreen> createState() =>
      _BuyGiftCardConfirmDetailsScreenState();
}

class _BuyGiftCardConfirmDetailsScreenState
    extends State<BuyGiftCardConfirmDetailsScreen> {
  final DashboardBloc _buyGiftCardConfirmDetails = DashboardBloc();

  final FocusNode myFocusNode = FocusNode();
  bool active = true;

  @override
  void initState() {
    User.Screen = 'Buy gift card Confirm';

    super.initState();

    _buyGiftCardConfirmDetails
        .add(GiftCardGetFeeDataEvent(amount: widget.amount));
  }

  // final bool _detailsScreenPushed = false; // Track if details screen is pushed

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.scaffoldBg,
      body: BlocListener(
        bloc: _buyGiftCardConfirmDetails,
        listener: (context, DashboardState state) {
          if (state.buyGiftCardConfirmModel?.status == 1) {
            active = true;
            CustomToast.showSuccess(
                context, "Hey!!", state.buyGiftCardConfirmModel!.message!);
            Navigator.pushNamed(context, "buyGiftCardScreen");
          } else if (state.buyGiftCardConfirmModel?.status == 0) {
            active = true;
            CustomToast.showError(
                context, "Sorry!!", state.buyGiftCardConfirmModel!.message!);
          }
        },
        child: BlocBuilder(
            bloc: _buyGiftCardConfirmDetails,
            builder: (context, DashboardState state) {
              return SafeArea(
                child: ProgressHUD(
                  inAsyncCall: state.isloading,
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: Column(
                      // shrinkWrap: true,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30, top: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              DefaultBackButtonWidget(onTap: () {
                                Navigator.pushNamed(
                                    context, 'buyGiftCardDetailsScreen');
                              }),
                              Text(
                                'Buy Gift Card',
                                style: GoogleFonts.inter(
                                    color: CustomColor.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                              ),
                              Container(
                                width: 10,
                              )
                            ],
                          ),
                        ),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5,),
                            child: Image.network(
                              state.giftCardGetFeeDataModel!.image!.toString(),
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
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Fees Details",
                            textAlign: TextAlign.left,
                            style: GoogleFonts.inter(
                              color: CustomColor.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          state.giftCardGetFeeDataModel!.plan!.isEmpty
                              ? Container()
                              : Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: CustomColor.hubContainerBgColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        state.giftCardGetFeeDataModel!.plan!
                                            .first.title
                                            .toString() ??
                                            "",
                                        style: GoogleFonts.inter(
                                          color: CustomColor.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '€${state.giftCardGetFeeDataModel!.plan!.first.fee}' ??
                                              "",
                                          textAlign: TextAlign.right,
                                          style: GoogleFonts.inter(
                                            color: CustomColor.black
                                                .withOpacity(0.7),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        state.giftCardGetFeeDataModel!
                                            .plan![1].title
                                            .toString() ??
                                            "",
                                        style: GoogleFonts.inter(
                                          color: CustomColor.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        '€${state.giftCardGetFeeDataModel!.plan![1].fee ?? ""}',
                                        textAlign: TextAlign.right,
                                        style: GoogleFonts.inter(
                                          color: CustomColor.black
                                              .withOpacity(0.7),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        state.giftCardGetFeeDataModel!
                                            .plan![2].title
                                            .toString() ??
                                            "",
                                        style: GoogleFonts.inter(
                                          color: CustomColor.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        '€${state.giftCardGetFeeDataModel!.plan![2].fee ?? ""}',
                                        textAlign: TextAlign.right,
                                        style: GoogleFonts.inter(
                                          color: CustomColor.black
                                              .withOpacity(0.7),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        state.giftCardGetFeeDataModel!
                                            .plan![3].title
                                            .toString() ??
                                            "",
                                        style: GoogleFonts.inter(
                                          color: CustomColor.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        '€${state.giftCardGetFeeDataModel!.plan![3].fee ?? ""}',
                                        textAlign: TextAlign.right,
                                        style: GoogleFonts.inter(
                                          color: CustomColor.black
                                              .withOpacity(0.7),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                        PrimaryButtonWidget(
                          onPressed: active ? () {
                            active = false;
                            _buyGiftCardConfirmDetails
                                .add(GiftCardGetOrderConfirmEvent());
                          } : null,
                          buttonText: 'Order Confirm',
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

  _confirmButtonWidget(BuildContext context) {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      width: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(11)),
      child: ElevatedButton(
        onPressed: () {
          _buyGiftCardConfirmDetails.add(GiftCardGetOrderConfirmEvent());
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff10245C),
          elevation: 0,
          disabledBackgroundColor: const Color(0xffC4C4C4),
          shadowColor: Colors.transparent,
          minimumSize: const Size.fromHeight(40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11),
          ),
        ),
        child: const Text(
          'Order Confirm',
          style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontFamily: 'pop',
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
