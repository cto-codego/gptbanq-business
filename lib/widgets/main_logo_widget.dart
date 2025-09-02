import 'package:gptbanqbusiness/utils/assets.dart';
import 'package:flutter/material.dart';

@immutable
class MainLogoWidget extends StatelessWidget {
  final double width;
  final double height;

  const MainLogoWidget({
    super.key,
    this.width = 150.0, // Default width
    this.height = 150.0, // Default height
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      StaticAssets.mainLogo,
      width: width,
      height: height,
    );
  }
}
