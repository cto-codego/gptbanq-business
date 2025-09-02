import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/input_fields/custom_color.dart';
import '../custom_image_widget.dart';

class HubContainerWidget extends StatelessWidget {
  final String title;
  final String imagePath;
  final bool isHubContainerBorderColor;
  final VoidCallback onTap;

  const HubContainerWidget({
    super.key,
    required this.title,
    required this.imagePath,
    this.isHubContainerBorderColor = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 5),
        decoration: BoxDecoration(
          color: CustomColor.hubContainerBgColor, // Background color
          border: Border.all(
            color: isHubContainerBorderColor
                ? CustomColor.primaryColor
                : CustomColor.hubContainerBgColor, // Dynamic border color
          ),
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomImageWidget(
              imagePath: imagePath,
              imageType: 'svg',
              height: 24,
            ),
            SizedBox(height: 5),
            Text(
              title,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: CustomColor.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
