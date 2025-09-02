import 'dart:io';

import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/input_fields/custom_color.dart';
import '../../../../utils/user_data_manager.dart';
import '../../../../widgets/buttons/default_back_button_widget.dart';
import '../../../../widgets/buttons/primary_button_widget.dart';
import '../../../../widgets/buttons/secondary_button_widget.dart';
import '../../bloc/signup_bloc.dart';

class AddressPreviewScreen extends StatefulWidget {
  final File imageFile;

  AddressPreviewScreen({super.key, required this.imageFile});

  @override
  State<AddressPreviewScreen> createState() => _AddressPreviewScreenState();
}

class _AddressPreviewScreenState extends State<AddressPreviewScreen> {
  final SignupBloc _kycAddressVerifyBloc = SignupBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _kycAddressVerifyBloc,
      listener: (context, SignupState state) async {
        if (state.kycAddressVerifyModel?.status == 1) {
          Navigator.pushNamedAndRemoveUntil(
              context, 'kycStartScreen', (route) => false);
        }
      },
      child: Scaffold(
        backgroundColor: CustomColor.scaffoldBg,
        body: SafeArea(
          child: BlocBuilder(
            bloc: _kycAddressVerifyBloc,
            builder: (context, SignupState state) {
              debugPrint(widget.imageFile.toString());
              return ProgressHUD(
                inAsyncCall: state.isloading,
                child: Container(
                  width: double.maxFinite,
                  height: double.maxFinite,
                  margin: EdgeInsets.only(left: 16, right: 16, top: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DefaultBackButtonWidget(onTap: () {
                            Navigator.pop(context);
                          }),
                          Container()
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10),
                            child: Text("Address Proof",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  color: CustomColor.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                )),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.6,
                            margin: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    width: 3,
                                    color: CustomColor.primaryColor
                                        .withOpacity(0.4)),
                                image: DecorationImage(
                                    image: FileImage(widget.imageFile),
                                    fit: BoxFit.cover)),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          SecondaryButtonWidget(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            buttonText: "Retake",
                            apiBackgroundColor: CustomColor.whiteColor,
                          ),
                          PrimaryButtonWidget(
                            onPressed: () {
                              UserDataManager()
                                  .addressImageSave(widget.imageFile.path);

                              _kycAddressVerifyBloc
                                  .add(KycAddressVerifyEvent());
                            },
                            buttonText: "Submit",
                          ),
                        ],
                      ),
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
