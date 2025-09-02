import 'package:gptbanqbusiness/Screens/investment/bloc/investment_bloc.dart';
import 'package:gptbanqbusiness/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/input_fields/custom_color.dart';
import '../../../widgets/buttons/default_back_button_widget.dart';
import '../../../widgets/buttons/primary_button_widget.dart';
import '../../../widgets/toast/toast_util.dart';

class CdgMasternodeOrderScreen extends StatefulWidget {
  const CdgMasternodeOrderScreen({super.key});

  @override
  State<CdgMasternodeOrderScreen> createState() =>
      _CdgMasternodeOrderScreenState();
}

class _CdgMasternodeOrderScreenState extends State<CdgMasternodeOrderScreen> {
  final InvestmentBloc _investmentBloc = InvestmentBloc();

  TextEditingController storeController = TextEditingController();

  Future<void> _onRefresh() async {
    debugPrint('_onRefresh');
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.scaffoldBg,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
                    child: RefreshIndicator(
                      onRefresh: _onRefresh,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                appBarSection(context, state),
                                Image.asset(
                                  StaticAssets.masternodeMiningLogo,
                                  height: 150,
                                ),
                                Container(
                                  padding: EdgeInsets.all(12),
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
                                              'Cost',
                                              textAlign: TextAlign.left,
                                              style: GoogleFonts.inter(
                                                  color: CustomColor.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  height: 1),
                                            ),
                                            Text(
                                              "500.00 USDC",
                                              textAlign: TextAlign.left,
                                              style: GoogleFonts.inter(
                                                  color: CustomColor.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
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
                                              'Price',
                                              textAlign: TextAlign.left,
                                              style: GoogleFonts.inter(
                                                  color: CustomColor.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  height: 1),
                                            ),
                                            Text(
                                              "0.90 EUR",
                                              textAlign: TextAlign.left,
                                              style: GoogleFonts.inter(
                                                  color: CustomColor.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  height: 1),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20,),
                                PrimaryButtonWidget(
                                  onPressed: () {
                                    // Navigator.push(
                                    //   context,
                                    //   PageTransition(
                                    //     type: PageTransitionType.scale,
                                    //     alignment: Alignment.center,
                                    //     isIos: true,
                                    //     duration:
                                    //     const Duration(microseconds: 500),
                                    //     child: BuyCdgMasternodeInputAddressScreen(),
                                    //   ),
                                    // );
                                  },
                                  buttonText: 'Buy',
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
            'CDG Masternode',
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
