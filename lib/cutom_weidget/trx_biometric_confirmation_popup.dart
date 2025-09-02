import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:gptbanqbusiness/utils/custom_scroll_behavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Screens/Dashboard_screen/bloc/dashboard_bloc.dart';
import 'cutom_progress_bar.dart';

// class TrxBiometricConfirmationNotifications {
//   static trxBiometricConfirmationNotifications({
//     String title = '',
//     String body = '',
//     String uniqueId = '',
//     BuildContext? context,
//     final onConfirm,
//     final onDecline,
//   }) {
//     showGeneralDialog(
//       context: context!,
//       pageBuilder: (BuildContext buildContext, Animation<double> animation,
//           Animation<double> secondaryAnimation) {
//         return TrxConfirmationScreen(
//           uniqueId: uniqueId,
//           confirm: onConfirm,
//           cancel: onDecline,
//         );
//       },
//       barrierDismissible: true,
//       barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
//       barrierColor: Colors.black.withOpacity(0.1),
//       transitionDuration: const Duration(milliseconds: 0),
//     );
//   }
// }

class TrxConfirmationScreen extends StatefulWidget {
  TrxConfirmationScreen({
    super.key,
    required this.uniqueId,
    // required this.confirm,
    // required this.cancel
  });

  String uniqueId;

  // Function()? confirm;
  // Function()? cancel;

  @override
  State<TrxConfirmationScreen> createState() => _TrxConfirmationScreenState();
}

class _TrxConfirmationScreenState extends State<TrxConfirmationScreen> {
  final DashboardBloc _trxBloc = DashboardBloc();

  @override
  void initState() {
    super.initState();
    _trxBloc.add(TrxBiometricDetailsEvent(uniqueId: widget.uniqueId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener(
        bloc: _trxBloc,
        listener: (context, DashboardState state) {
          if (state.statusModel?.status == 0) {
            AwesomeDialog(
              context: context,
              dismissOnTouchOutside: false,
              dialogType: DialogType.error,
              animType: AnimType.rightSlide,
              desc: state.statusModel?.message,
              btnCancelText: 'OK',
              buttonsTextStyle: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'pop',
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
              btnCancelOnPress: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, 'dashboard', (route) => false);
              },
            ).show();
          }

          if (state.transactionApprovedModel?.status == 1) {
            AwesomeDialog(
              context: context,
              dismissOnTouchOutside: false,
              dialogType: DialogType.success,
              animType: AnimType.rightSlide,
              desc: state.transactionApprovedModel?.message,
              btnCancelText: 'OK',
              btnCancelColor: Colors.green,
              buttonsTextStyle: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'pop',
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
              btnCancelOnPress: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, 'dashboard', (route) => false);
              },
            ).show();
          }
        },
        child: BlocBuilder(
            bloc: _trxBloc,
            builder: (context, DashboardState state) {
              String body = state
                  .trxBiometricConfirmationNotificationsModel!.data!.body
                  .toString();

              String image = state
                  .trxBiometricConfirmationNotificationsModel!.data!.image
                  .toString();
              String title = state
                  .trxBiometricConfirmationNotificationsModel!.data!.title
                  .toString();
              return ProgressHUD(
                inAsyncCall: state.isloading,
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
                                title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'pop',
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 150),
                              Column(
                                children: [
                                  Image.network(
                                    image,
                                    height: 100,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      } else {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    },
                                    errorBuilder: (BuildContext context,
                                        Object error, StackTrace? stackTrace) {
                                      debugPrint('Error loading image: $error');
                                      return Image.asset('images/bell.png',
                                          height: 100);
                                    },
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(height: 20),
                                        Text(
                                          body,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w800,
                                            fontFamily: 'pop',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  const SizedBox(height: 100),
                                  Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.all(10),
                                    child: const Text(
                                      "Tap 'Approve' to verify the payment. if you do not recognize the purchase, decline.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'pop',
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        gradient: const LinearGradient(colors: [
                                          Color(0xff090B78),
                                          Color(0xff090B78)
                                        ])),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        _trxBloc.add(
                                            TrxBiometricConfirmOrCancelEvent(
                                          uniqueId: widget.uniqueId,
                                          loginStatus: "APPROVED",
                                        ));
                                      },
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0)),
                                          backgroundColor: Colors.transparent,
                                          elevation: 0,
                                          shadowColor: Colors.transparent,
                                          minimumSize:
                                              const Size.fromHeight(50)),
                                      child: const Text(
                                        "Approve",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontFamily: 'pop',
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  InkWell(
                                    onTap: () {
                                      _trxBloc
                                          .add(TrxBiometricConfirmOrCancelEvent(
                                        uniqueId: widget.uniqueId,
                                        loginStatus: "DECLINED",
                                      ));
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: double.infinity,
                                      height: 40,
                                      child: Text(
                                        'Decline',
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
