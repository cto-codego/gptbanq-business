import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../Sign_up_screens/kyc/captuer/capture_controller.dart';
import '../image_preview/update_back_preview_screen.dart';

class UpdateCaptureViewBackScreen extends StatefulWidget {
  const UpdateCaptureViewBackScreen({
    super.key,
    required this.fileCallback,
    required this.title,
    this.info,
    this.hideIdWidget,
  });

  /// Callback function that receives the captured and cropped image as a [File].
  final Function(File imagePath) fileCallback;

  /// The title displayed at the top of the capture screen.
  final String title;

  /// Additional information or instructions displayed on the capture screen.
  final String? info;

  final bool? hideIdWidget;

  @override
  State<UpdateCaptureViewBackScreen> createState() => _UpdateCaptureViewBackScreenState();
}

class _UpdateCaptureViewBackScreenState extends State<UpdateCaptureViewBackScreen> {
  late CameraController controller;
  late List<CameraDescription> cameras;

  @override
  void initState() {
    super.initState();
    initializeCameras().then((value) {
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

      controller.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    });
  }

  Future<void> initializeCameras() async {
    cameras = await availableCameras();
    setState(() {});
  }

  CameraDescription getDefaultCameraDescription() {
    return const CameraDescription(
      name: "default",
      lensDirection: CameraLensDirection.back,
      sensorOrientation: 180,
    );
  }

  @override
  void dispose() {
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
            CameraPreview(controller),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
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
                    if (widget.info != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          widget.info!,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                  ],
                ),
              ),
            ),
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
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Take a photo of the back page of your\nID card/driving license & & Please ensure that all four corners of your ID document are clearly visible in the photo.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 1),
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        height: 1,
                      ),
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
                        XFile file = await controller.takePicture();

                        File? savedImage =
                        await CaptureController.saveImage(File(file.path));

                        widget.fileCallback(savedImage!);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateBackPreviewScreen(
                              idCapture: savedImage,
                              title: "Back page of your\nID card/driving license",
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.camera),
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
