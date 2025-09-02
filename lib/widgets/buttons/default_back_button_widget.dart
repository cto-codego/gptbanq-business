import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/assets.dart';
import '../../utils/input_fields/custom_color.dart';

class DefaultBackButtonWidget extends StatelessWidget {
  final VoidCallback onTap;
  final double iconSize;
  final String svgAssetPath;
  final Color? apiColor; // Optional API-provided color
  final Color defaultColor; // Default color

   DefaultBackButtonWidget({
    super.key,
    required this.onTap,
    this.iconSize = 24.0, // Default icon size
    this.svgAssetPath = StaticAssets.arrowNarrowLeft, // Default SVG asset path
    this.apiColor, // Accept color from API
    Color? defaultColor, // Set a default color
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
