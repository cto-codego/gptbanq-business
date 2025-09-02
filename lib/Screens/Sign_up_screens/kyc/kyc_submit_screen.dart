import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widgets/toast/toast_util.dart';
import '../bloc/signup_bloc.dart';

class KycSubmitScreen extends StatefulWidget {
  const KycSubmitScreen({super.key});

  @override
  State<KycSubmitScreen> createState() => _KycSubmitScreenState();
}

class _KycSubmitScreenState extends State<KycSubmitScreen> {
  final SignupBloc _kycSubmitBloc = SignupBloc();

  bool completed = false;

  @override
  void initState() {
    super.initState();

    _kycSubmitBloc.add(KycSubmitEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _kycSubmitBloc,
      listener: (context, SignupState state) {
        if (state.kycSubmitModel?.status == 0) {
          CustomToast.showError(
              context, "Sorry!", state.kycSubmitModel!.message!);
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        } else if (state.kycSubmitModel?.status == 1) {
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: BlocBuilder(
            bloc: _kycSubmitBloc,
            builder: (context, SignupState state) {
              return ProgressHUD(
                inAsyncCall: state.isloading,
                child: Container(
                  width: double.maxFinite,
                  height: double.maxFinite,
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 40),
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 300,
                              alignment: Alignment.center,
                              child: Image.asset(
                                'images/applogo.png',
                              ),
                            ),
                            const SizedBox(
                              height: 42,
                            ),

                            // Container(
                            //   width: 100,
                            //   alignment: Alignment.center,
                            //   child: Image.asset(
                            //     'images/proof-address.png',
                            //   ),
                            // ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Expanded(
                                  //   child: Text(
                                  //     User.kycmessage,
                                  //     textAlign: TextAlign.center,
                                  //     style: const TextStyle(
                                  //         color: Colors.black,
                                  //         fontFamily: 'pop',
                                  //         fontSize: 18,
                                  //         fontWeight: FontWeight.w500),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // Container(
                      //   height: 60,
                      //   width: double.infinity,
                      //   decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(11)),
                      //   child: ElevatedButton(
                      //       onPressed: () {
                      //         Navigator.pushNamedAndRemoveUntil(
                      //             context, '/', (route) => false);
                      //       },
                      //       style: ElevatedButton.styleFrom(
                      //           backgroundColor: const Color(0xff10245C),
                      //           elevation: 0,
                      //           shadowColor: Colors.transparent,
                      //           minimumSize: const Size.fromHeight(40),
                      //           shape: RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.circular(11))),
                      //       child: const Text(
                      //         'Proceed',
                      //         style: TextStyle(
                      //             color: Colors.white,
                      //             fontSize: 15,
                      //             fontFamily: 'pop',
                      //             fontWeight: FontWeight.w500),
                      //       )),
                      // ),
                      const SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
