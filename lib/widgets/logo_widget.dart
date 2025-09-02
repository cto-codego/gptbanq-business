import 'package:gptbanqbusiness/utils/assets.dart';
import 'package:flutter/material.dart';

@immutable
class LogoWidget extends StatelessWidget {
  final double width;
  final double height;

  const LogoWidget({
    super.key,
    this.width = 150.0, // Default width
    this.height = 150.0, // Default height
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      StaticAssets.whiteLogo,
      width: width,
      height: height,
    );
  }
}
