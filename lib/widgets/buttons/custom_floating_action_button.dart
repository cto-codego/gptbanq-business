import 'package:flutter/material.dart';

import '../../utils/assets.dart';
import '../../utils/input_fields/custom_color.dart';
import '../custom_image_widget.dart';
import '../main/hub_popup_content.dart';

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => HubPopupContent());
      },
      shape: CircleBorder(),
      backgroundColor: CustomColor.primaryColor,
      child: CustomImageWidget(
        imagePath: StaticAssets.menu,
        imageType: 'svg',
        height: 21,
      ),
    );
  }
}
