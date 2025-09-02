import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';

class CameraScreen extends StatefulWidget {
  final CameraController controller;

  const CameraScreen({Key? key, required this.controller}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width * 0.8;
    double cardHeight = cardWidth * 0.63;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: CameraPreview(widget.controller),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: cardWidth,
                  height: cardHeight,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 5),
                  ),
                  child: _imageFile == null
                      ? ClipRect(
                    child: OverflowBox(
                      alignment: Alignment.center,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: SizedBox(
                          width: cardWidth,
                          height: cardHeight,
                          child: CameraPreview(widget.controller),
                        ),
                      ),
                    ),
                  )
                      : Image.file(
                    _imageFile!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_imageFile != null)
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _imageFile = null;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20),
                      ),
                      child: const Icon(
                        Icons.refresh,
                        size: 40,
                      ),
                    ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_imageFile == null) {
                        XFile image = await widget.controller.takePicture();
                        final appDir = await getApplicationDocumentsDirectory();
                        final fileName = '${DateTime.now()}.png';
                        final savedImage = File('${appDir.path}/$fileName');
                        await savedImage.writeAsBytes(await image.readAsBytes());
                        setState(() {
                          _imageFile = savedImage;
                        });
                      } else {
                        Navigator.pop(context, _imageFile!.path);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                    ),
                    child: Icon(
                      _imageFile == null ? Icons.camera : Icons.check,
                      size: 40,
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
