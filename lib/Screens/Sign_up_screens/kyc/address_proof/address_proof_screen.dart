import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import 'dart:io';

import '../../../../cutom_weidget/cutom_progress_bar.dart';
import '../../../../utils/assets.dart';
import '../../../../utils/input_fields/custom_color.dart';
import '../../../../utils/strings.dart';
import '../../../../utils/user_data_manager.dart';
import '../../../../widgets/buttons/default_back_button_widget.dart';
import '../../../../widgets/buttons/primary_button_widget.dart';
import '../../../../widgets/custom_image_widget.dart';
import '../../bloc/signup_bloc.dart';

class AddressProofScreen extends StatefulWidget {
  const AddressProofScreen({super.key});

  @override
  State<AddressProofScreen> createState() => _AddressProofScreenState();
}

class _AddressProofScreenState extends State<AddressProofScreen> {
  final SignupBloc _kycAddressVerifyBloc = SignupBloc();

  final String _selectedCard = 'ID Card'; // Default selection
  late CameraController _controller;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  bool _isButtonEnabled = false; // To track button state

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
      bloc: _kycAddressVerifyBloc,
      listener: (context, SignupState state) {
        if (state.kycAddressVerifyModel?.status == 1) {
          Navigator.pushNamedAndRemoveUntil(
              context, 'kycStartScreen', (route) => false);
        }
      },
      child: Scaffold(
        backgroundColor: CustomColor.scaffoldBg,
        resizeToAvoidBottomInset: true,
        body: BlocBuilder(
          bloc: _kycAddressVerifyBloc,
          builder: (context,SignupState state) {
            return Stack(
              children: [
                SafeArea(
                  child: ProgressHUD(
                    inAsyncCall: state.isloading,
                    child: Container(
                      width: double.maxFinite,
                      height: double.maxFinite,
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, top: 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              DefaultBackButtonWidget(onTap: () {
                                Navigator.pushNamedAndRemoveUntil(
                                    context, 'kycStartScreen', (route) => false);
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
                              _kycAddressVerifyBloc
                                  .add(KycAddressVerifyEvent());
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: CustomColor.black.withOpacity(0.4),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomImageWidget(
                    imagePath: StaticAssets.addressProof,
                    imageType: "svg",
                    height: 24,
                  ),
                  Text(
                    Strings.uploadAddressProof,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: CustomColor.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),


                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

  Future<void> _uploadPicture(BuildContext context) async {
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

          UserDataManager()
              .addressImageSave(savedImage.path);

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
