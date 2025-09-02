import 'package:gptbanqbusiness/Screens/crypto_screen/bloc/crypto_bloc.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constant_string/User.dart';
import '../../utils/assets.dart';
import '../../utils/input_fields/custom_color.dart';
import '../../widgets/buttons/primary_button_widget.dart';
import '../../widgets/buttons/secondary_button_widget.dart';
import '../../widgets/custom_image_widget.dart';
import '../../widgets/success/success_widget.dart';

// ignore: must_be_immutable
class WithdrawConfirmationScreen extends StatefulWidget {
  String title, body, uniqueId;

  WithdrawConfirmationScreen(
      {super.key,
      required this.title,
      required this.body,
      required this.uniqueId});

  @override
  State<WithdrawConfirmationScreen> createState() =>
      _WithdrawConfirmationScreenState();
}

class _WithdrawConfirmationScreenState
    extends State<WithdrawConfirmationScreen> {
  final CryptoBloc _cryptoBloc = CryptoBloc();

  @override
  void initState() {
    _cryptoBloc.add(getibanlistEvent());
    super.initState();
    User.Screen = 'Move Euro';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.scaffoldBg,
      body: BlocListener(
          bloc: _cryptoBloc,
          listener: (context, CryptoState state) async {
            if (state.ibanDepositEurToCryptoCancelModel?.status == 1) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => SuccessWidget(
                    disableButton: false,
                    imageType: SuccessImageType.success,
                    title: 'Hey!',
                    subTitle: state.ibanDepositEurToCryptoCancelModel!.message!,
                    btnText: 'Go Back',
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, 'cryptoScreen', (route) => false);
                    },
                  ),
                ),
                (route) => false,
              );
            } else if (state.ibanDepositEurToCryptoCancelModel?.status == 0) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => SuccessWidget(
                    disableButton: false,
                    imageType: SuccessImageType.error,
                    title: 'Sorry!',
                    subTitle: state.ibanDepositEurToCryptoCancelModel!.message!,
                    btnText: 'Go Back',
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, 'cryptoScreen', (route) => false);
                    },
                  ),
                ),
                (route) => false,
              );
            }
          },
          child: BlocBuilder(
              bloc: _cryptoBloc,
              builder: (context, CryptoState state) {
                return SafeArea(
                  child: ProgressHUD(
                    inAsyncCall: state.isloading,
                    child: Container(
                      color: Colors.white,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.title,
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                margin: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: CustomColor.notificationBellBgColor,
                                ),
                                child: CustomImageWidget(
                                  imagePath: StaticAssets.notificationBell,
                                  imageType: 'svg',
                                  height: 100,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 20),
                                    Text(
                                      widget.body,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                              PrimaryButtonWidget(
                                onPressed: () {
                                  _cryptoBloc.add(ApproveEurotoIbanEvent(
                                    uniqueId: widget.uniqueId,
                                    completed: 'Completed',
                                  ));
                                },
                                buttonText: 'Confirm',
                              ),
                              SecondaryButtonWidget(
                                onPressed: () {
                                  _cryptoBloc.add(ApproveEurotoIbanEvent(
                                    uniqueId: widget.uniqueId,
                                    completed: 'Canceled',
                                  ));
                                },
                                buttonText: "Cancel",
                                apiBackgroundColor: CustomColor.whiteColor,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 50,
                          )
                        ],
                      ),
                    ),
                  ),
                );
              })),
    );
  }
}
