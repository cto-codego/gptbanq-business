import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../../../utils/user_data_manager.dart';
import '../captuer/capture_controller.dart';
import '../image_preview/front_preview_screen.dart';

class PassportViewScreen extends StatefulWidget {
  const PassportViewScreen({
    super.key,
    required this.fileCallback,
    required this.title,
    this.info,
    this.hideIdWidget,
  });

  final Function(File imagePath) fileCallback;
  final String title;
  final String? info;
  final bool? hideIdWidget;

  @override
  State<PassportViewScreen> createState() => _PassportViewScreenState();
}

class _PassportViewScreenState extends State<PassportViewScreen> {
  late CameraController controller;
  late List<CameraDescription> cameras;
  bool _isCameraInitialized = false;
  bool _isCapturing = false;

  @override
  void initState() {
    super.initState();
    _initializeCameras();
  }

  Future<void> _initializeCameras() async {
    try {
      cameras = await availableCameras();
      if (cameras.isEmpty) {
        return;
      }

      controller = CameraController(
        cameras.first,
        ResolutionPreset.ultraHigh,
        imageFormatGroup: Platform.isIOS
            ? ImageFormatGroup.yuv420
            : ImageFormatGroup.bgra8888,
      );

      await controller.initialize();
      if (!mounted) return;
      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _captureAndSaveImage() async {
    if (_isCapturing) return;
    setState(() {
      _isCapturing = true;
    });

    try {
      XFile file = await controller.takePicture();

      // Save the image path to secure storage
      UserDataManager().passportImageSave(file.path);

      File? savedImage = await CaptureController.saveImage(File(file.path));

      widget.fileCallback(savedImage!);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => FrontPreviewScreen(
            idCapture: savedImage,
            isPassport: true,
            title: "Front page of your Passport",
          ),
        ),
      );
    } catch (e) {
      print('Error capturing image: $e');
    } finally {
      setState(() {
        _isCapturing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          fit: StackFit.expand,
          children: [
            CameraPreview(controller),
            _buildTopUI(),
            _buildCaptureButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopUI() {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                widget.title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700),
              ),
            ),
            if (widget.info != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(widget.info!,
                    style: const TextStyle(color: Colors.white)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCaptureButton() {
    return Positioned(
      bottom: 0,
      child: Column(
        children: [
          Container(
            height: 60,
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.95,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: const Text(
              "Take a photo of the front page of your Passport",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(0, 0, 0, 1),
                fontFamily: 'Poppins',
                fontSize: 15,
                letterSpacing: 0,
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
              onPressed: _captureAndSaveImage,
              icon: const Icon(Icons.camera),
              iconSize: 72,
            ),
          ),
        ],
      ),
    );
  }
}
