import 'package:gptbanqbusiness/utils/input_fields/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrimaryButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed; // Make onPressed nullable
  final String buttonText;
  final double height;
  final double width;
  final EdgeInsets margin;
  final Color? apiBackgroundColor; // API-provided color
  final Color defaultBackgroundColor; // Default color
  final Color disabledColor;
  final double elevation;
  final BorderRadiusGeometry borderRadius;
  final TextStyle? textStyle; // Optional text style property
  final Color defaultTextColor; // New property for default text color

  // Set default border color and default text color
  PrimaryButtonWidget(
      {super.key,
      required this.onPressed, // Nullable function
      required this.buttonText,
      this.height = 48,
      this.width = double.infinity,
      this.margin = const EdgeInsets.only(bottom: 20),
      this.apiBackgroundColor, // Accepts color from API
      Color? defaultBackgroundColor, // Default local color
      Color? disabledColor,
      this.elevation = 0,
      this.borderRadius = const BorderRadius.all(Radius.circular(1000)),
      this.textStyle, // Optional text style parameter
      this.defaultTextColor = CustomColor.primaryTextColor // Default text color
      })
      : disabledColor = disabledColor ?? CustomColor.disableColor,
        defaultBackgroundColor = disabledColor ?? CustomColor.primaryColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: margin,
      width: width,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
      ),
      child: ElevatedButton(
        onPressed: onPressed, // Nullable onPressed is accepted here
        style: ElevatedButton.styleFrom(
          backgroundColor: onPressed != null
              ? apiBackgroundColor ?? defaultBackgroundColor
              : disabledColor,
          // Use disabled color if onPressed is null
          elevation: elevation,
          disabledBackgroundColor: disabledColor,
          shadowColor: Colors.transparent,
          minimumSize: const Size.fromHeight(40),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
          ),
        ),
        child: Text(
          buttonText,
          style: textStyle?.copyWith(
                  color: textStyle?.color ?? defaultTextColor) ??
              GoogleFonts.inter(
                color: defaultTextColor,
                // Use defaultTextColor if no textStyle is provided
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
        ),
      ),
    );
  }
}
