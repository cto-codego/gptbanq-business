import 'dart:io';

import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:gptbanqbusiness/utils/user_data_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../Config/bloc/app_bloc.dart';
import '../../../../Config/bloc/app_respotary.dart';
import '../../../../utils/input_fields/custom_color.dart';
import '../../../../widgets/buttons/default_back_button_widget.dart';
import '../../../../widgets/buttons/primary_button_widget.dart';
import '../../../../widgets/buttons/secondary_button_widget.dart';
import '../../../constant_string/User.dart';
import '../bloc/update_doc_bloc.dart';
import '../id_verify/update_capture_view_back_screen.dart';

class UpdateFrontPreviewScreen extends StatefulWidget {
  const UpdateFrontPreviewScreen(
      {super.key,
      this.idCapture,
      required this.isPassport,
      required this.title});

  final File? idCapture;
  final bool isPassport;
  final String title;

  @override
  State<UpdateFrontPreviewScreen> createState() => _UpdateFrontPreviewScreenState();
}

class _UpdateFrontPreviewScreenState extends State<UpdateFrontPreviewScreen> {
  final UpdateDocBloc _updateDocBloc = UpdateDocBloc();

  AppRespo appRespo = AppRespo();
  final AppBloc _appBloc = AppBloc();

  @override
  void initState() {
    super.initState();
    appRespo.getUserStatus();
    _appBloc.add(UserstatusEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _updateDocBloc,
      listener: (context, UpdateDocState state) async {
        if (state.kycIdVerifyModel?.status == 1) {
          Navigator.pushNamedAndRemoveUntil(
              context, 'updateFaceProofScreen', (route) => false);
        }
      },
      child: Scaffold(
        backgroundColor: CustomColor.scaffoldBg,
        body: SafeArea(
          child: BlocBuilder(
            bloc: _updateDocBloc,
            builder: (context, UpdateDocState state) {
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
                            margin: const EdgeInsets.all(5),
                            child: Text(widget.title,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                )),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.55,
                            margin: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    width: 3,
                                    color: CustomColor.primaryColor
                                        .withOpacity(0.4)),
                                image: DecorationImage(
                                  fit: BoxFit.contain,
                                  image: FileImage(widget.idCapture!),
                                )),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          SecondaryButtonWidget(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            buttonText: 'Retake',
                            apiBackgroundColor: CustomColor.whiteColor,
                          ),
                          widget.isPassport == true
                              ? PrimaryButtonWidget(
                                  onPressed: () async {
                                    // String imagePath = widget.idCapture!.path;

                                    // Save the image bytes to your data manager
                                    UserDataManager()
                                        .passportImageSave(widget.idCapture!.path);

                                    _updateDocBloc.add(KycIdVerifyEvent( uniqueId: User.updateUniqueId,
                                      docTypeStatus: User.updateDocTypeStatus,));
                                  },
                                  buttonText: "Submit",
                                )
                              : PrimaryButtonWidget(
                                  onPressed: () async {
                                    // String imagePath =
                                    //     await widget.idCapture!.path;


                                    // Save the base64 encoded image to your data manager
                                    UserDataManager()
                                        .idCardFrontImageSave(widget.idCapture!.path);

                                    debugPrint(UserDataManager()
                                        .getIdCardFrontImageCheck()
                                        .toString());
                                    await showDialog<File?>(
                                      context: context,
                                      builder: (context) =>
                                          UpdateCaptureViewBackScreen(
                                        fileCallback: (imagePath) {},
                                        title: "",
                                        info: "",
                                        hideIdWidget: false,
                                      ),
                                    );
                                  },
                                  buttonText: "Continue",
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
