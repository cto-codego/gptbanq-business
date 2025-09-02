import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/assets.dart';
import '../../utils/input_fields/custom_color.dart';

class CustomIconButtonWidget extends StatelessWidget {
  final VoidCallback onTap;
  final double iconSize;
  final String svgAssetPath;
   Color? apiColor; // Optional API-provided color
  final Color defaultColor; // Default color

   CustomIconButtonWidget({
    super.key,
    required this.onTap,
    this.iconSize = 24.0, // Default icon size
    this.svgAssetPath = StaticAssets.helpCircle, // Default SVG asset path
    this.apiColor, // Accept color from API
     Color? defaultColor, // Accept color as optional
  }) : defaultColor = defaultColor ?? CustomColor.primaryColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SvgPicture.asset(
        svgAssetPath,
        width: iconSize,
        height: iconSize,
        colorFilter: ColorFilter.mode(
          apiColor ?? defaultColor, // Use API-provided color if available, otherwise use default
          BlendMode.srcIn,
        ),
      ),
      // No padding or constraints added
    );
  }
}
