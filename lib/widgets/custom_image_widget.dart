import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

@immutable
class CustomImageWidget extends StatelessWidget {
  final String imagePath; // The path of the image to display
  final double width;
  final double height;
  final String imageType; // 'svg' or 'png'

  const CustomImageWidget({
    super.key,
    required this.imagePath, // Path is now required to ensure reusability
    this.width = 150.0, // Default width
    this.height = 150.0, // Default height
    this.imageType = 'svg', // Default image type is 'svg'
  });

  @override
  Widget build(BuildContext context) {
    return imageType == 'svg'
        ? SvgPicture.asset(
            imagePath, // SVG image path
            width: width,
            height: height,
          )
        : Image.asset(
            imagePath, // PNG image path
            width: width,
            height: height,
          );
  }
}
