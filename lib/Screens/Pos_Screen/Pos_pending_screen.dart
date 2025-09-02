import 'package:gptbanqbusiness/Screens/Pos_Screen/bloc/pos_bloc.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:gptbanqbusiness/utils/input_fields/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/assets.dart';
import '../../widgets/buttons/custom_floating_action_button.dart';
import '../../widgets/custom_image_widget.dart';


class PosPendingScreen extends StatefulWidget {
  const PosPendingScreen({super.key});

  @override
  State<PosPendingScreen> createState() => _PosPendingScreenState();
}

class _PosPendingScreenState extends State<PosPendingScreen> {
  PosBloc _posBloc = new PosBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _posBloc,
      listener: (context, PosState state) {},
      child: BlocBuilder(
        bloc: _posBloc,
        builder: (context, PosState state) {
          return ProgressHUD(
            inAsyncCall: state.isloading,
            child: Scaffold(
              backgroundColor: CustomColor.scaffoldBg,
                floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                body: SafeArea(
                  child: Container(
                  padding:
                  const EdgeInsets.only(left: 16, right: 16, top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 70,
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: CustomImageWidget(
                                  imagePath: StaticAssets.pos,
                                  imageType: 'svg',
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  'You have already sent request.',
                                  style: GoogleFonts.inter(
                                      color: CustomColor.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                                ),
                ),
                floatingActionButton: CustomFloatingActionButton()),

          );
        },
      ),
    );
  }
}
