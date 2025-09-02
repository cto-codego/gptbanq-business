import 'dart:ui';

import 'package:gptbanqbusiness/Screens/update_doc_section/bloc/update_doc_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import 'dart:io';

import '../../../../../cutom_weidget/cutom_progress_bar.dart';
import '../../../../../utils/assets.dart';
import '../../../../../utils/input_fields/custom_color.dart';
import '../../../../../utils/strings.dart';
import '../../../../../utils/user_data_manager.dart';
import '../../../../../widgets/buttons/default_back_button_widget.dart';
import '../../../../../widgets/buttons/primary_button_widget.dart';
import '../../../../../widgets/custom_image_widget.dart';
import '../../../constant_string/User.dart';

class UpdateAddressProofScreen extends StatefulWidget {
  const UpdateAddressProofScreen({super.key});

  @override
  State<UpdateAddressProofScreen> createState() =>
      _UpdateAddressProofScreenState();
}

class _UpdateAddressProofScreenState extends State<UpdateAddressProofScreen> {
  final UpdateDocBloc _updateDocBloc = UpdateDocBloc();

  final String _selectedCard = 'ID Card'; // Default selection
  late CameraController _controller;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  bool _isButtonEnabled = false; // To track button state
  bool _isFileUploaded =
      false; // New state to track if a file has been successfully uploaded

  // ignore: unused_field
  late Future<void> _initializeControllerFuture;

  File? idCapture; // Variable to store the captured ID image file

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _updateDocBloc,
      listener: (context, UpdateDocState state) {
        if (state.kycAddressVerifyModel?.status == 1) {
          Navigator.pushNamedAndRemoveUntil(
              context, 'updateDocScreen', (route) => false);
        }
      },
      child: Scaffold(
        backgroundColor: CustomColor.scaffoldBg,
        resizeToAvoidBottomInset: true,
        body: BlocBuilder(
          bloc: _updateDocBloc,
          builder: (context, UpdateDocState state) {
            return SafeArea(
              child: Stack(
                children: [
                  SafeArea(
                    bottom: false,
                    child: ProgressHUD(
                      inAsyncCall: state.isloading,
                      child: Container(
                        width: double.maxFinite,
                        height: double.maxFinite,
                        padding:
                            const EdgeInsets.only(left: 16, right: 16, top: 40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                DefaultBackButtonWidget(onTap: () {
                                  Navigator.pushNamedAndRemoveUntil(context,
                                      'kycStartScreen', (route) => false);
                                }),
                                Container()
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Text(
                              Strings.addressProofTitle,
                              style: GoogleFonts.inter(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w600,
                                  color: CustomColor.black),
                            ),
                            Text(
                              Strings.addressProofSubTitle1,
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
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  _uploadProofIdentity(context, _selectedCard),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Proof of Address",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      color: CustomColor.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    Strings.uploadAddressProofSubTitle,
                                    maxLines: 8,
                                    overflow: TextOverflow.ellipsis,
                                    // textAlign: TextAlign.left,
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: CustomColor.subtitleTextColor,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                ],
                              ),
                            ),
                            PrimaryButtonWidget(
                              onPressed: _isButtonEnabled
                                  ? () {
                                      _updateDocBloc.add(KycAddressVerifyEvent(
                                        uniqueId: User.updateUniqueId,
                                        docTypeStatus: User.updateDocTypeStatus,
                                      ));
                                    }
                                  : null,
                              // Disable button if _isButtonEnabled is false
                              buttonText: 'Continue',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (_isLoading)
                    Container(
                      color: Colors.black45,
                      child: Center(
                        child: Text(
                          "Processing...",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: CustomColor.subtitleTextColor),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  _uploadProofIdentity(BuildContext context, String isPassport) {
    return InkWell(
      onTap: () {
        _uploadPicture(context);
      },
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: CustomColor.black.withOpacity(0.4),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomImageWidget(
                    imagePath: StaticAssets.addressProof,
                    imageType: "svg",
                    height: 24,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      Strings.uploadAddressProof,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: CustomColor.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              if (_isLoading)
                SizedBox(
                  height: 20, // Adjust size as needed
                  width: 20, // Adjust size as needed
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        CustomColor.primaryColor), // Use your primary color
                  ),
                )
              else if (_isFileUploaded)
                Icon(
                  Icons.check_circle, // Success icon
                  color: Colors.green, // Green color for success
                  size: 20,
                )
              else
                Icon(
                  Icons.upload_file, // Default upload icon
                  color: CustomColor.black,
                  size: 30,
                )
            ],
          ),
        ),
      ),
    );
  }

  /*Future<void> _uploadPicture(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery, // Gallery selection
      );

      if (image != null) {
        File imageFile = File(image.path);
        final bytes = await imageFile.readAsBytes();

        final decodedImage = img.decodeImage(bytes);
        if (decodedImage != null) {
          final pngBytes = img.encodePng(decodedImage);
          final appDir = await getApplicationDocumentsDirectory();
          final fileName = '${DateTime.now().toIso8601String()}_image.png';
          final savedImage = File('${appDir.path}/$fileName');
          await savedImage.writeAsBytes(Uint8List.fromList(pngBytes));

          setState(() {
            _isButtonEnabled = true; // Enable button when image is uploaded
          });

          UserDataManager().addressImageSave(savedImage.path);

          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (context) => AddressPreviewScreen(imageFile: savedImage),
          //   ),
          // );
        }
      } else {
        setState(() {
          _isButtonEnabled = false; // Disable button when no image is selected
        });
      }
    } catch (e) {
      print('Error selecting image: $e');
      setState(() {
        _isButtonEnabled = false;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }*/

  Future<void> _uploadPicture(BuildContext context) async {
    setState(() {
      _isLoading = true;
      _isFileUploaded = false;
    });

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final fileExtension = file.path.split('.').last.toLowerCase();

        if (['jpg', 'jpeg', 'png'].contains(fileExtension)) {
          // Process image
          final bytes = await file.readAsBytes();
          final decodedImage = img.decodeImage(bytes);
          if (decodedImage != null) {
            final pngBytes = img.encodePng(decodedImage);
            final appDir = await getApplicationDocumentsDirectory();
            final fileName = '${DateTime.now().toIso8601String()}_image.png';
            final savedImage = File('${appDir.path}/$fileName');
            await savedImage.writeAsBytes(Uint8List.fromList(pngBytes));
            UserDataManager().addressImageSave(savedImage.path);
          }
        } else if (fileExtension == 'pdf') {
          // Save PDF path
          UserDataManager().addressImageSave(file.path);
        }

        setState(() {
          _isButtonEnabled = true;
          _isFileUploaded = true;
        });
      } else {
        setState(() {
          _isButtonEnabled = false;
          _isFileUploaded = true;
        });
      }
    } catch (e) {
      print('Error picking file: $e');
      setState(() {
        _isButtonEnabled = false;
        _isFileUploaded = true;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

class DottedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = CustomColor.primaryInputHintBorderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

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
