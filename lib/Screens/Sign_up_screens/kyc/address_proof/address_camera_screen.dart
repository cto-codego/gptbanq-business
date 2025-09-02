import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../image_preview/address_preview_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final ImagePicker _picker = ImagePicker();

  // bool _isFlashOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            _buildOverlayWidgets(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverlayWidgets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: Container()),
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Take a photo of your address proof',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _takePicture,
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(20),
                ),
                child: const Icon(
                  Icons.camera,
                  size: 40,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _takePicture() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (image != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = '${DateTime.now()}_front.png';
      final savedImage = File('${appDir.path}/$fileName');
      await savedImage.writeAsBytes(await image.readAsBytes());

      // Perform navigation only after all async operations are done.
      if (!mounted) return;
      _navigateToPreviewScreen(savedImage);
    }
  }

  // Separate the navigation logic into its own function.
  void _navigateToPreviewScreen(File imageFile) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddressPreviewScreen(imageFile: imageFile),
      ),
    );
  }
}
