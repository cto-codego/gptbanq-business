import 'package:gptbanqbusiness/utils/assets.dart';
import 'package:gptbanqbusiness/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/input_fields/custom_color.dart';

class TransactionCardWidget extends StatelessWidget {
  final String uniqueId;
  final String? image;
  final String beneficiaryName;
  final String reasonPayment;
  final String created;
  final String amount;
  final String status;
  final String type;
  final VoidCallback onTap;

  const TransactionCardWidget({
    super.key,
    required this.uniqueId,
    this.image,
    required this.beneficiaryName,
    required this.reasonPayment,
    required this.created,
    required this.amount,
    required this.status,
    required this.type,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: CustomColor.whiteColor),
          color: CustomColor.whiteColor,
          boxShadow: [
            BoxShadow(
              color: const Color(0x1F000000),
              offset: const Offset(0, 2),
              blurRadius: 8,
              spreadRadius: -4,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 49,
                    width: 49,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0x1A10245D),
                      shape: BoxShape.circle,
                    ),
                    child:
                    image == ''
                        ?
                    CustomImageWidget(
                            imagePath: StaticAssets.transactionIcon,
                            imageType: 'svg',
                      height: 24,
                          )
                        : CircleAvatar(
                            backgroundImage: NetworkImage(image!),
                          ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (beneficiaryName.isNotEmpty)
                          Text(
                            beneficiaryName,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: CustomColor.black,
                            ),
                          ),
                        if (reasonPayment.isNotEmpty)
                          Text(
                            reasonPayment,
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              color: CustomColor.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        Text(
                          created,
                          style:  GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff7F7373)
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  amount,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: type == 'debit'
                        ? CustomColor.errorColor
                        : CustomColor.primaryColor,
                  ),
                ),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 10,
                    fontFamily: 'pop',
                    color: status == 'Completed'
                        ? CustomColor.green
                        : CustomColor.warning
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
