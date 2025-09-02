import 'package:gptbanqbusiness/Screens/Dashboard_screen/Dashboard_screen.dart';
import 'package:gptbanqbusiness/Screens/transfer_screen/binficiary_screen.dart';
import 'package:gptbanqbusiness/Screens/transfer_screen/bloc/transfer_bloc.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import '../../widgets/buttons/primary_button_widget.dart';
import '../../widgets/toast/toast_util.dart';

class DoneScreen extends StatefulWidget {
  const DoneScreen({super.key});

  @override
  State<DoneScreen> createState() => _DoneScreenState();
}

class _DoneScreenState extends State<DoneScreen> {
  final TransferBloc _transferBloc = TransferBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _transferBloc,
      listener: (context, TransferState state) {
        if (state.statusModel?.status == 0) {
          CustomToast.showError(
              context, "Sorry!", state.statusModel!.message!);
          Navigator.pushReplacement(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              alignment: Alignment.center,
              isIos: true,
              duration: const Duration(milliseconds: 200),
              child: const BeneficiaryListScreen(),
            ),
          );

        } else if (state.statusModel?.status == 1) {

          CustomToast.showSuccess(
              context, "Thank You!", state.statusModel!.message!);
          Navigator.pushReplacement(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              alignment: Alignment.center,
              isIos: true,
              duration: const Duration(milliseconds: 200),
              child: const DashboardScreen(),
            ),
          );

        }
      },
      child: BlocBuilder(
        bloc: _transferBloc,
        builder: (context, TransferState state) {
          return ProgressHUD(
            inAsyncCall: state.isloading,
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              body: SafeArea(
                child: Container(
                  width: double.maxFinite,
                  height: double.maxFinite,
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, top: 70),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                       Text(
                        'To complete your payment open your email and proceed with biometric recognition',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff2C2C2C),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Image.asset(
                          'images/Vector.png',
                          width: 198,
                          height: 198,
                        ),
                      ),

                      PrimaryButtonWidget(
                        onPressed: () {
                          _transferBloc.add(
                              ApproveibanTransactionEvent(
                                  uniqueId: "",
                                  completed: 'Completed',
                                  lat: '',
                                  long: ''));
                        },
                        buttonText: 'Submit',
                      ),
                      const SizedBox(
                        height: 1,
                      )
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
