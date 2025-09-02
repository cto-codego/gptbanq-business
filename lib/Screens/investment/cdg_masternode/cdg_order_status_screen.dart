import 'package:gptbanqbusiness/utils/assets.dart';
import 'package:gptbanqbusiness/utils/input_fields/custom_color.dart';
import 'package:gptbanqbusiness/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/custom_style.dart';
import '../../../widgets/buttons/default_back_button_widget.dart';
import '../../../widgets/buttons/primary_button_widget.dart';

// Renamed enum to avoid conflict
enum SuccessImageType {
  success,
  error,
  warning,
}

class CdgSuccessWidget extends StatefulWidget {
  const CdgSuccessWidget({
    super.key,
    required this.imageType, // Accepting image type as a parameter
    required this.title,
    required this.subTitle,
    required this.btnText,
    required this.onTap,
    required this.disableButton,
    required this.quantity,
    required this.price,
    required this.profit,
    required this.shipmentCost,
    required this.totalCost,
  });

  final SuccessImageType imageType; // Updated to the new enum name
  final String title;
  final String subTitle;
  final String btnText;
  final String quantity;
  final String price;
  final String profit;
  final String shipmentCost;
  final String totalCost;
  final VoidCallback onTap;
  final bool disableButton; // Marked as final since it’s now immutable

  @override
  State<CdgSuccessWidget> createState() => _CdgSuccessWidgetState();
}

class _CdgSuccessWidgetState extends State<CdgSuccessWidget> {
  @override
  void initState() {
    super.initState();
  }

  // Method to get the image path based on the image type
  String _getImagePath() {
    switch (widget.imageType) {
      case SuccessImageType.success:
        return StaticAssets.successDialog; // Assuming you have a success icon
      case SuccessImageType.error:
        return StaticAssets.errorDialog; // Assuming you have an error icon
      case SuccessImageType.warning:
        return StaticAssets.warningDialog; // Assuming you have a warning icon
      default:
        return StaticAssets.warningDialog; // Fallback icon if needed
    }
  }

  String _getImageData() {
    switch (widget.imageType) {
      case SuccessImageType.success:
        return ""; // Assuming you have a success icon
      case SuccessImageType.error:
        return 'svg'; // Assuming you have an error icon
      case SuccessImageType.warning:
        return 'svg'; // Assuming you have a warning icon
      default:
        return 'svg'; // Fallback icon if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.scaffoldBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  CustomImageWidget(
                    imagePath: _getImagePath(),
                    imageType: _getImageData(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: CustomStyle.loginTitleStyle,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 10),
                    child: Text(
                      widget.subTitle,
                      textAlign: TextAlign.center,
                      style: CustomStyle.loginSubTitleStyle,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: CustomColor.whiteColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey)),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Price',
                              textAlign: TextAlign.left,
                              style: GoogleFonts.inter(
                                color: CustomColor.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '200 EUR',
                              textAlign: TextAlign.left,
                              style: GoogleFonts.inter(
                                color: CustomColor.black.withOpacity(0.7),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Profit per day',
                              textAlign: TextAlign.left,
                              style: GoogleFonts.inter(
                                color: CustomColor.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '50 CDG',
                              textAlign: TextAlign.left,
                              style: GoogleFonts.inter(
                                color: CustomColor.black.withOpacity(0.7),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Shipment Cost',
                              textAlign: TextAlign.left,
                              style: GoogleFonts.inter(
                                color: CustomColor.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '20,00 EUR',
                              textAlign: TextAlign.left,
                              style: GoogleFonts.inter(
                                color: CustomColor.black.withOpacity(0.7),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Cost',
                              textAlign: TextAlign.left,
                              style: GoogleFonts.inter(
                                color: CustomColor.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '220,00 EUR',
                              textAlign: TextAlign.left,
                              style: GoogleFonts.inter(
                                color: CustomColor.black.withOpacity(0.7),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              PrimaryButtonWidget(
                onPressed: widget.onTap,
                buttonText: widget.btnText,
              ), // Space before buttons
            ],
          ),
        ),
      ),
      // bottomNavigationBar: CustomBottomBar(index: 0),
    );
  }

  Widget appBarSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DefaultBackButtonWidget(onTap: () {
            Navigator.pushNamedAndRemoveUntil(
                context, 'dashboard', (route) => false);
          }),
          Text(
            '',
            style: GoogleFonts.inter(
                color: CustomColor.black,
                fontSize: 18,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 20), // Changed from Container to SizedBox
        ],
      ),
    );
  }
}
