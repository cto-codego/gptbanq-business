import 'dart:io';
import 'package:gptbanqbusiness/Screens/update_doc_section/bloc/update_doc_bloc.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:gptbanqbusiness/utils/input_fields/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/user_data_manager.dart';
import '../../../../widgets/buttons/default_back_button_widget.dart';
import '../../../../widgets/buttons/primary_button_widget.dart';
import '../../../../widgets/buttons/secondary_button_widget.dart';
import '../../../../widgets/toast/toast_util.dart';
import '../../../constant_string/User.dart';

class UpdateBackPreviewScreen extends StatefulWidget {
  final File? idCapture;
  final String title;

  UpdateBackPreviewScreen({super.key, this.idCapture, required this.title});

  @override
  State<UpdateBackPreviewScreen> createState() =>
      _UpdateBackPreviewScreenState();
}

class _UpdateBackPreviewScreenState extends State<UpdateBackPreviewScreen> {
  final UpdateDocBloc _updateDocBloc = UpdateDocBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _updateDocBloc,
      listener: (context, UpdateDocState state) async {
        if (state.kycIdVerifyModel?.status == 1) {
          Navigator.pushNamedAndRemoveUntil(
              context, 'updateFaceProofScreen', (route) => false);
        } else if (state.kycIdVerifyModel?.status == 0) {
          CustomToast.showError(
              context, "Sorry!", state.kycIdVerifyModel!.message!);
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
                      _buildImagePreview(widget.title, widget.idCapture),
                      _buildActionButtons(context, widget.idCapture),
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

  Widget _buildImagePreview(String title, File? imageFile) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: CustomColor.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              height: 1,
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.55,
          margin: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 3,
              color: CustomColor.primaryColor.withOpacity(0.4),
            ),
            image: imageFile != null
                ? DecorationImage(
                    fit: BoxFit.contain,
                    image: FileImage(imageFile),
                  )
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, File? imageFile) {
    return Column(
      children: [
        SecondaryButtonWidget(
          onPressed: () {
            Navigator.pop(context);
          },
          buttonText: "Retake",
          apiBackgroundColor: CustomColor.whiteColor,
        ),
        PrimaryButtonWidget(
          onPressed: () async {
            if (imageFile != null) {
              // List<int> imageBytes = await imageFile.readAsBytes();

              UserDataManager().idCardBackImageSave(imageFile.path);

              _updateDocBloc.add(KycIdVerifyEvent(
                uniqueId: User.updateUniqueId,
                docTypeStatus: User.updateDocTypeStatus,
              ));
            }
          },
          buttonText: "Submit",
        ),
      ],
    );
  }
}
