import 'package:gptbanqbusiness/Screens/Pos_Screen/Pos_mainScreen.dart';
import 'package:gptbanqbusiness/Screens/Pos_Screen/Pos_pending_screen.dart';
import 'package:gptbanqbusiness/Screens/Pos_Screen/Request_pos.dart';
import 'package:gptbanqbusiness/Screens/Pos_Screen/bloc/pos_bloc.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:gptbanqbusiness/utils/assets.dart';
import 'package:gptbanqbusiness/utils/input_fields/custom_color.dart';
import 'package:gptbanqbusiness/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

class CheckposScreen extends StatefulWidget {
  const CheckposScreen({super.key});

  @override
  State<CheckposScreen> createState() => _CheckposScreenState();
}

class _CheckposScreenState extends State<CheckposScreen> {
  PosBloc _posBloc = new PosBloc();

  @override
  void initState() {
    super.initState();
    _posBloc.add(checkposEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _posBloc,
      listener: (context, PosState state) {
        if (state.posstatusModel?.ispos == 0) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              type: PageTransitionType.scale,
              alignment: Alignment.center,
              isIos: true,
              duration: Duration(milliseconds: 200),
              child: RequestposScreen(),
            ),
          );
        } else if (state.posstatusModel?.ispos == 1) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              type: PageTransitionType.scale,
              alignment: Alignment.center,
              isIos: true,
              duration: Duration(milliseconds: 200),
              child: PosPendingScreen(),
            ),
          );
        } else if (state.posstatusModel?.ispos == 2) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              type: PageTransitionType.scale,
              alignment: Alignment.center,
              isIos: true,
              duration: Duration(milliseconds: 200),
              child: PosMainScreen(),
            ),
          );
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
                        height: 80,
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          'POS',
                          style: GoogleFonts.inter(
                              color: CustomColor.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 12),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: CustomImageWidget(
                            imagePath: StaticAssets.pos,
                            imageType: 'svg',
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
      ),
    );
  }
}
