import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// The `CaptureController` class provides methods for capturing and saving images.
/// It includes a static method `saveImage` that takes a [File] representing an image,
/// and returns the saved image file path.
class CaptureController {
  /// Static method to save an image and return the saved image file path.
  ///
  /// The method takes a [File] `imageFile` representing the original image to be saved.
  /// The image is saved to a temporary file, and the [XFile] representing the path of the saved image is returned.
  ///
  /// Example:
  /// ```dart
  /// File imageFile = ...; // The original image file
  /// XFile? savedImage = await CaptureController.saveImage(imageFile);
  /// print('Saved image path: ${savedImage?.path}');
  /// ```
  static Future<File?> saveImage(File imageFile) async {
    // Generate a unique filename using the current timestamp
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    Directory tempDir = await getTemporaryDirectory();

    String tempPath = '${tempDir.path}/saved_image_$timestamp.png';

    // Copy the original image to the new temporary file
    await imageFile.copy(tempPath);

    // Return the saved image path as a [File]
    return File(tempPath);
  }
}
