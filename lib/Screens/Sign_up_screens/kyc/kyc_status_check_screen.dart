import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constant_string/User.dart';
import '../bloc/signup_bloc.dart';

class KycCheckStatusScreen extends StatefulWidget {
  const KycCheckStatusScreen({super.key});

  @override
  State<KycCheckStatusScreen> createState() => _KycCheckStatusScreenState();
}

class _KycCheckStatusScreenState extends State<KycCheckStatusScreen> {
  final SignupBloc _kycSubmitBloc = SignupBloc();

  bool completed = false;

  @override
  void initState() {
    super.initState();

    _kycSubmitBloc.add(KycStatusCheckEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _kycSubmitBloc,
      listener: (context, SignupState state) {
        if (state.kycStatusModel!.status == 1 ) {
          User.showAddressProof = state.kycStatusModel!.showAddressProof!;
        }

        if (state.kycStatusModel!.isIdproof == 3 ||
            state.kycStatusModel!.isIdproof == 0) {
          Navigator.pushNamedAndRemoveUntil(
              context, 'kycScreen', (route) => false);
        } else if (state.kycStatusModel!.isAddressproof == 3 ||
            state.kycStatusModel!.isAddressproof == 0) {
          Navigator.pushNamedAndRemoveUntil(
              context, 'addressProofScreen', (route) => false);
        } else if (state.kycStatusModel!.isSelfie == 3 ||
            state.kycStatusModel!.isSelfie == 0) {
          Navigator.pushNamedAndRemoveUntil(
              context, 'faceProofScreen', (route) => false);
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
                  padding: const EdgeInsets.only(left: 25, right: 25, top: 40),
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
                            Container(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 10),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [],
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
