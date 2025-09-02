import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/input_fields/custom_color.dart';
import '../../Sign_up_screens/kyc/captuer/capture_controller.dart';
import '../image_preview/update_front_preview_screen.dart';

class UpdateCaptureViewFrontScreen extends StatefulWidget {
  const UpdateCaptureViewFrontScreen(
      {super.key,
      required this.fileCallback,
      required this.title,
      this.info,
      this.hideIdWidget});

  /// Callback function that receives the captured and cropped image as an [XFile].
  final Function(File imagePath) fileCallback;

  /// The title displayed at the top of the capture screen.
  final String title;

  /// Additional information or instructions displayed on the capture screen.
  final String? info;

  final bool? hideIdWidget;

  @override
  State<UpdateCaptureViewFrontScreen> createState() =>
      _UpdateCaptureViewFrontScreenState();
}

class _UpdateCaptureViewFrontScreenState
    extends State<UpdateCaptureViewFrontScreen> {
  late CameraController controller;
  late List<CameraDescription> cameras;

  @override
  void initState() {
    super.initState();
    initializeCameras().then((value) {
      // Initialize the camera controller with a default camera description.
      if (cameras.isEmpty) {
        controller = CameraController(
          getDefaultCameraDescription(),
          ResolutionPreset.ultraHigh,
          imageFormatGroup: Platform.isIOS
              ? ImageFormatGroup.yuv420
              : ImageFormatGroup.bgra8888, // Specify the format group
        );
      } else {
        controller = CameraController(
          cameras.first,
          ResolutionPreset.ultraHigh,
          imageFormatGroup: Platform.isIOS
              ? ImageFormatGroup.yuv420
              : ImageFormatGroup.bgra8888, // Specify the format group
        );
      }

      // Initialize the camera controller and update the UI after initialization.
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    });
  }

  Future<void> initializeCameras() async {
    // await Permission.camera.request();
    cameras = await availableCameras();
    setState(() {}); // Refresh the widget tree after obtaining cameras
  }

  /// Retrieves the default camera description with placeholder values.
  CameraDescription getDefaultCameraDescription() {
    return const CameraDescription(
      name: "default",
      lensDirection: CameraLensDirection.back,
      sensorOrientation: 180,
    );
  }

  @override
  void dispose() {
    // Dispose of the camera controller to release resources.
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          fit: StackFit.expand,
          children: [
            // Live camera preview.
            CameraPreview(controller),
            // UI at the top of the capture screen.
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: const EdgeInsets.only(
                  top: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Back button.
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                    // Title at the top of the screen.
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    // Additional information or instructions.
                    if (widget.info != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Text(
                          widget.info!,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Capture button at the bottom center.
            Positioned(
              bottom: 0,
              child: Column(
                children: [
                  Container(
                    height: 60,
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.95,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      "Take a photo of the front page of your\nID card/driving license & Please ensure that all four corners of your ID document are clearly visible in the photo.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                          color: CustomColor.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.black12,
                      shape: BoxShape.circle,
                    ),
                    margin: const EdgeInsets.all(25),
                    child: IconButton(
                      enableFeedback: true,
                      color: Colors.white,
                      onPressed: () async {
                        // Capture an image.
                        XFile file = await controller.takePicture();

                        // Crop the captured image.
                        File? savedImage =
                            await CaptureController.saveImage(File(file.path));

                        // Callback to handle the cropped image.
                        widget.fileCallback(savedImage!);

                        print(savedImage);
                        // Close the capture screen and callback to handle the cropped image..
                        // Navigator.pop(context, croppedImage);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UpdateFrontPreviewScreen(
                                    idCapture: savedImage,
                                    isPassport: false,
                                    title:
                                        "Front page of your\nID card/driving license",
                                  )),
                        );
                      },
                      icon: const Icon(
                        Icons.camera,
                      ),
                      iconSize: 72,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
