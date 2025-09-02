import 'package:gptbanqbusiness/utils/input_fields/custom_color.dart';
import 'package:gptbanqbusiness/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomCircleButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String icon;
  bool? transferButton;

  CustomCircleButtonWidget({
    super.key,
    required this.icon,
    required this.onPressed,
    this.transferButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 9),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: CustomColor.whiteColor, width: 1),
          color: transferButton!
              ? CustomColor.transferButtonColor
              : CustomColor.depositButtonColor,
          boxShadow: [
            BoxShadow(
              color: transferButton!
                  ? CustomColor.transferButtonColor.withValues(alpha: 0.5 * 255)
                  : CustomColor.depositButtonColor.withValues(alpha: 0.5 * 255),
              offset: Offset(0, 0), // No offset
              spreadRadius: 2,
              blurRadius: 0,
            ),
          ],
        ),
        child: CustomImageWidget(
          imagePath: icon,
          imageType: 'svg',
          height: 21,
        ),
      ),
    );
  }
}
