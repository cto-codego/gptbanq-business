import 'package:gptbanqbusiness/Screens/Pos_Screen/checkpos_screen.dart';
import 'package:gptbanqbusiness/Screens/Pos_Screen/bloc/pos_bloc.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:gptbanqbusiness/utils/assets.dart';
import 'package:gptbanqbusiness/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import '../../utils/input_fields/custom_color.dart';
import '../../widgets/buttons/default_back_button_widget.dart';
import '../../widgets/buttons/primary_button_widget.dart';
import '../../widgets/toast/toast_util.dart';

class RequestposScreen extends StatefulWidget {
  const RequestposScreen({super.key});

  @override
  State<RequestposScreen> createState() => _RequestposScreenState();
}

class _RequestposScreenState extends State<RequestposScreen> {
  PosBloc _posBloc = PosBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _posBloc.add(posplanEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _posBloc,
      listener: (context, PosState state) {
        if (state.statusModel?.status == 1) {
          CustomToast.showSuccess(context, "Hey!", state.statusModel!.message!);

          Navigator.push(
            context,
            PageTransition(
              child: CheckposScreen(),
              type: PageTransitionType.fade,
              alignment: Alignment.center,
              duration: Duration(milliseconds: 300),
              reverseDuration: Duration(milliseconds: 200),
            ),
          );
        } else if (state.statusModel?.status == 0) {
          CustomToast.showError(context, "Sorry!", state.statusModel!.message!);
        }
      },
      child: BlocBuilder(
        bloc: _posBloc,
        builder: (context, PosState state) {
          return ProgressHUD(
            inAsyncCall: state.isloading,
            child: Scaffold(
              backgroundColor: CustomColor.scaffoldBg,
              body: SafeArea(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DefaultBackButtonWidget(onTap: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, 'dashboard', (route) => false);
                          }),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              'POS request',
                              style: GoogleFonts.inter(
                                  color: CustomColor.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18),
                            ),
                          ),
                          Container(width: 20,)
                        ],
                      ),

                      Expanded(
                        child: Column(
                          children: [

                            Container(
                              height: 250,
                              alignment: Alignment.center,
                              child: CustomImageWidget(
                                imagePath: StaticAssets.pos,
                                imageType: 'svg',
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Container(
                                  alignment: Alignment.center,
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Monthly Plan Cost',
                                          style: GoogleFonts.inter(
                                              color: CustomColor.black
                                                  .withOpacity(0.7),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          '${state.posFeesModel!.plan!.monthlyFee!} €',
                                          style: GoogleFonts.inter(
                                              color: CustomColor.black
                                                  .withOpacity(0.7),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 30),
                                        ),
                                      ]),
                                )),
                                Expanded(
                                    child: Container(
                                  alignment: Alignment.center,
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Transactions Cost',
                                          style: GoogleFonts.inter(
                                              color: CustomColor.black
                                                  .withOpacity(0.7),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          '${state.posFeesModel!.plan!.cardTrxFee!} %',
                                          style: GoogleFonts.inter(
                                              color: CustomColor.black
                                                  .withOpacity(0.7),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 30),
                                        ),
                                      ]),
                                ))
                              ],
                            ),
                          ],
                        ),
                      ),
                      PrimaryButtonWidget(
                        onPressed: () {
                          _posBloc.add(RequestposEvent());
                        },
                        buttonText: 'Request Terminal',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
