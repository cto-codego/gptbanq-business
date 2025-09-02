import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/input_fields/custom_color.dart';

class TransactionUserDataWidget extends StatelessWidget {
  final String name;
  final String iban;
  final String? accountType;
  final String image;

  const TransactionUserDataWidget({
    super.key,
    required this.name,
    this.accountType,
    required this.iban,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
          color: CustomColor.transactionFromContainerColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: CustomColor.dashboardProfileBorderColor)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: GoogleFonts.inter(
                  color: CustomColor.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              Text(
                iban,
                style: GoogleFonts.inter(
                  color: CustomColor.touchIdSubtitleTextColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
              Text(
                accountType ?? "",
                style: GoogleFonts.inter(
                  color: CustomColor.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          Container(
            width: 48,
            height: 48,
            margin: const EdgeInsets.only(right: 7),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
