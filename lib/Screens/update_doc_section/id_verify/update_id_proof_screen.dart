// ignore_for_file: unused_field

import 'dart:ui';

import 'package:gptbanqbusiness/utils/assets.dart';
import 'package:gptbanqbusiness/utils/input_fields/custom_color.dart';
import 'package:gptbanqbusiness/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart'; // Import camera package
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';

import '../../../../Config/bloc/app_bloc.dart';
import '../../../../Config/bloc/app_respotary.dart';
import '../../../../Models/kyc/kyc_document_type_model.dart';
import '../../../../cutom_weidget/cutom_progress_bar.dart';
import '../../../../utils/strings.dart';
import '../../../../utils/user_data_manager.dart';
import '../../../../widgets/toast/toast_util.dart';
import '../bloc/update_doc_bloc.dart';
import 'update_capture_view_front_screen.dart';
import '../passport_verify/update_passport_view_screen.dart';

class UpdateIdProofScreen extends StatefulWidget {
  const UpdateIdProofScreen({super.key});

  @override
  State<UpdateIdProofScreen> createState() => _UpdateIdProofScreenState();
}

class _UpdateIdProofScreenState extends State<UpdateIdProofScreen> {
  final TextEditingController _selectCardController = TextEditingController();

  final UpdateDocBloc _updateDocBloc = UpdateDocBloc();

  AppRespo appRespo = AppRespo();
  final AppBloc _appBloc = AppBloc();

  String? _selectedCard;
  List<String> _cardTypes = [];

  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  String? _frontImagePath;
  String? _backImagePath;
  String? _passportImagePath;
  String? _selfiePhoto;
  File? idCapture; // Variable to store the captured ID image file

  @override
  void initState() {
    super.initState();
    appRespo.getUserStatus();
    _appBloc.add(UserstatusEvent());
    _selectedCard ??= 'Identity Type';
    _updateDocBloc.add(KycDocumentTypeEvent());
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _takePicture(String side) async {
    try {
      await _initializeControllerFuture;
      final XFile image = await _controller.takePicture();

      if (side == 'front') {
        setState(() {
          _frontImagePath = image.path;
        });
      } else if (side == 'back') {
        setState(() {
          _backImagePath = image.path;
        });
      } else if (side == 'passport') {
        setState(() {
          _passportImagePath = image.path;
        });
      }
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _updateDocBloc,
      listener: (context, UpdateDocState state) {
        if (state.kycDocumentTypeModel?.status == 0) {
          CustomToast.showError(context, "Sorry!", state.statusModel!.message!);
        } else if (state.kycDocumentTypeModel?.status == 1) {
          setState(() {
            // Populate _cardTypes with the document types received from the API response
            _cardTypes = state.kycDocumentTypeModel?.doc
                    ?.map((doc) => doc.type ?? '')
                    .toList() ??
                [];
            _selectedCard = _cardTypes.isNotEmpty
                ? _cardTypes[0]
                : "select type"; // Set the selected value to the first item in _cardTypes
            // _selectCardController.text = _selectedCard.toString();
            _selectCardController.text =
                state.kycDocumentTypeModel!.doc![0].type!.toString();

            print("checking again");
            print(state.kycDocumentTypeModel!.doc![0].type!);
            print("checking again");
          });
        }

        // _selectCardController.text = _selectedCard.toString();
        // print("$_selectedCard");
        // print(_selectCardController.text);
      },
      child: Scaffold(
        backgroundColor: CustomColor.scaffoldBg,
        resizeToAvoidBottomInset: true,
 body: SafeArea(
          child: BlocBuilder(
            bloc: _updateDocBloc,
            builder: (context, UpdateDocState state) {
              return ProgressHUD(
                inAsyncCall: state.isloading,
                child: Container(
                  width: double.maxFinite,
                  height: double.maxFinite,
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        Strings.idDocTitle,
                        style: GoogleFonts.inter(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: CustomColor.black),
                      ),
                      Text(
                        Strings.idDocSubTitle,
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: CustomColor.subtitleTextColor),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            _selectTypeWidget(
                                context,
                                state.kycDocumentTypeModel?.doc,
                                _selectCardController),
                            const SizedBox(
                              height: 40,
                            ),
                            InkWell(
                              onTap: () {
                                _selectCardController.text == "passport"
                                    ? showDialog<File?>(
                                        context: context,
                                        builder: (context) =>
                                            UpdatePassportViewScreen(
                                          fileCallback: (imagePath) {},
                                          title: "",
                                          info: "",
                                          hideIdWidget: false,
                                        ),
                                      )
                                    : showDialog<File?>(
                                        context: context,
                                        builder: (context) =>
                                            UpdateCaptureViewFrontScreen(
                                          fileCallback: (imagePath) {},
                                          title: "",
                                          info: "",
                                          hideIdWidget: false,
                                        ),
                                      );
                                setState(() {});
                              },
                              child: Center(
                                  child: Container(
                                      padding: const EdgeInsets.all(20.0),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          border: Border.all(
                                            color: CustomColor.black
                                                .withOpacity(0.4),
                                          )),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              CustomImageWidget(
                                                imagePath: StaticAssets.icDoc,
                                                imageType: "svg",
                                                height: 24,
                                              ),
                                              Text(
                                                Strings.identityDocuments,
                                                style: GoogleFonts.inter(
                                                  fontSize: 16,
                                                  color: CustomColor.black,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                Strings
                                                    .identityDocumentsSubTitle,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.inter(
                                                  fontSize: 13,
                                                  color: CustomColor
                                                      .subtitleTextColor,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ))),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
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

  Widget _selectTypeWidget(BuildContext context, List<Doc>? cardTypes,
      TextEditingController controller) {
    if (cardTypes == null || cardTypes.isEmpty) {
      // If document types are not available, display a loading indicator or placeholder
      return Container(); // Placeholder loading indicator
    } else {
      // Document types are available, render the dropdown
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Strings.chooseYourIdentityType,
            style: GoogleFonts.inter(
              fontSize: 18,
              color: CustomColor.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          DocumentTypeSelector(
            cardTypes: cardTypes,
            onSelected: (selectedType) {
              debugPrint("Selected: $selectedType");
              controller.text = selectedType;
              debugPrint("controller: $selectedType");
              UserDataManager().kycDocTypeSave(selectedType);
            },
          ),
        ],
      );
    }
  }
}

class DottedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = CustomColor.primaryInputHintBorderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Dotted border pattern
    const double dashWidth = 5;
    const double dashSpace = 5;

    final Path path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          const Radius.circular(12),
        ),
      );

    PathMetrics pathMetrics = path.computeMetrics();
    for (PathMetric pathMetric in pathMetrics) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        Path dashPath = pathMetric.extractPath(
          distance,
          distance + dashWidth,
        );
        canvas.drawPath(dashPath, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class DottedBorder extends StatelessWidget {
  final Widget child;

  const DottedBorder({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DottedBorderPainter(),
      child: child,
    );
  }
}

class DocumentTypeSelector extends StatefulWidget {
  final List<Doc> cardTypes;
  final Function(String) onSelected;

  const DocumentTypeSelector(
      {required this.cardTypes, required this.onSelected, super.key});

  @override
  _DocumentTypeSelectorState createState() => _DocumentTypeSelectorState();
}

class _DocumentTypeSelectorState extends State<DocumentTypeSelector> {
  String? _selectedCardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.cardTypes.map((type) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedCardType = type.type;
              widget.onSelected(type.type!);
            });
          },
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            margin: const EdgeInsets.symmetric(vertical: 5.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: CustomColor.primaryInputHintBorderColor,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                CustomImageWidget(
                  imagePath: StaticAssets.icDoc,
                  imageType: "svg",
                  height: 24,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    type.type!,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: CustomColor.black,
                    ),
                  ),
                ),
                CustomRadioButton(
                  isSelected: _selectedCardType == type.type,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class CustomRadioButton extends StatelessWidget {
  final bool isSelected;

  const CustomRadioButton({required this.isSelected, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 16,
      width: 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: CustomColor.primaryInputHintBorderColor,
          width: 2.0,
        ),
      ),
      child: isSelected
          ? Center(
              child: Container(
                height: 14,
                width: 14,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: CustomColor.black),
              ),
            )
          : null,
    );
  }
}
