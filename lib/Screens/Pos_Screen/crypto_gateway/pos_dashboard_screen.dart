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
import 'package:page_transition/page_transition.dart';

import '../../../utils/input_fields/custom_color.dart';
import '../../../widgets/buttons/custom_floating_action_button.dart';
import '../../../widgets/toast/toast_util.dart';
import '../checkpos_screen.dart';

class PosDashboardScreen extends StatefulWidget {
  const PosDashboardScreen({super.key});

  @override
  State<PosDashboardScreen> createState() => _PosDashboardScreenState();
}

class _PosDashboardScreenState extends State<PosDashboardScreen> {
  bool active = false;

  bool shownotification = true;
  final PosBloc _posBloc = PosBloc();

  Future<void> _onRefresh() async {
    debugPrint('_onRefresh');

    _posBloc.add(CheckPosModuleEvent());
  }

  @override
  void initState() {
    super.initState();
    User.Screen = 'pos dashboard screen';

    _posBloc.add(CheckPosModuleEvent());
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
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              child: ListView(
                                children: [
                                  appBarSection(context, state),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  if (state.checkPosModuleModel?.isPos == 1)
                                    PosPlanCardWidget(
                                      imagePath: StaticAssets.pos,
                                      planName:
                                          "${state.checkPosModuleModel?.posplan?.planName}",
                                      title:
                                          "Monthly Fee : ${state.checkPosModuleModel?.posplan?.monthlyFee}",
                                      subTitle:
                                          "Transaction Fee :${state.checkPosModuleModel?.posplan?.cardTrxFee}",
                                      onTap: () {
                                        Navigator.pushReplacement(
                                          context,
                                          PageTransition(
                                            type: PageTransitionType.fade,
                                            alignment: Alignment.center,
                                            isIos: true,
                                            duration: const Duration(
                                                milliseconds: 200),
                                            child: const CheckposScreen(),
                                          ),
                                        );
                                      },
                                    ),
                                  if (state.checkPosModuleModel?.isPos == 1)
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  if (User.cryptoGatewayHide == 0)
                                    PosPlanCardWidget(
                                      imagePath: StaticAssets.pos,
                                      planName: 'Crypto Gateway',
                                      title:
                                          "Transaction Fee : ${state.checkPosModuleModel?.cryptoTrxfee}",
                                      subTitle:
                                          "You will receive crypto to eur\nin your IBAN account.",
                                      onTap: () {
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            'merchantStoreScreen',
                                            (route) => false);
                                      },
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
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 20),
      child: Text(
        'Pos Dashboard',
        style: GoogleFonts.inter(
            color: CustomColor.black,
            fontSize: 20,
            fontWeight: FontWeight.w500),
      ),
    );
  }
}

class PosPlanCardWidget extends StatelessWidget {
  final String? imagePath;
  final String? planName;
  final String? title;
  final String? subTitle;
  final VoidCallback onTap;

  const PosPlanCardWidget({
    super.key,
    required this.imagePath,
    required this.planName,
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
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomImageWidget(
                    imagePath: imagePath!, // Use StaticAssets constant
                    imageType: 'svg',
                    height: 40,
                  ),
                  const SizedBox(width: 5),
                  Expanded(  // Use Expanded here instead of Flexible
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          planName ?? '',
                          style: GoogleFonts.inter(
                            color: CustomColor.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis, // Handle long text
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            '$title',
                            style: GoogleFonts.inter(
                              color: CustomColor.black.withOpacity(0.8),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              height: 1,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            '$subTitle',
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
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
            ),
            CustomImageWidget(
              imagePath: StaticAssets.arrowRight, // Use StaticAssets constant
              imageType: 'svg',
              height: 18,
            )
          ],
        ),
      ),
    );
  }
}
