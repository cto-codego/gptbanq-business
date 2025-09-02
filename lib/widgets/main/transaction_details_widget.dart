import 'package:gptbanqbusiness/utils/assets.dart';
import 'package:gptbanqbusiness/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/input_fields/custom_color.dart';

@immutable
class TransactionDetailsWidget extends StatelessWidget {
  TransactionDetailsWidget(
      {super.key,
      required this.trxDataMode,
      required this.amount,
      this.beneficiaryName = "",
      required this.transactionDate,
      required this.fee,
      required this.accountHolder,
      required this.afterBalance,
      required this.beforeBalance,
      required this.currency,
      required this.label,
      required this.receiverBic,
      required this.receiverIban,
      required this.beneficiaryCurrency,
      required this.reference,
      required this.transactionId,
      required this.paymentMode,
      required this.transactionType,
      required this.status,
      required this.onTap});

  String trxDataMode;
  String amount;
  String beneficiaryName;
  String beneficiaryCurrency;
  String transactionDate;
  String fee;
  String status;
  String accountHolder;
  String reference;
  String label;
  String currency;
  String beforeBalance;
  String afterBalance;
  String receiverIban;
  String receiverBic;
  String transactionType;
  String paymentMode;
  String transactionId;
  VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: CustomColor.whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: CustomImageWidget(
                    imagePath: StaticAssets.closeBlack,
                    imageType: 'svg',
                    height: 24,
                  ),
                ),
                Text(
                  "Details",
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: CustomColor.black,
                  ),
                ),
                SizedBox(
                  width: 20,
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 20),
            child: Text(
              (trxDataMode == 'debit' ? '-' : '+') +
                  amount +
                  beneficiaryCurrency,
              style: GoogleFonts.inter(
                  color: CustomColor.black,
                  fontSize: 36,
                  fontWeight: FontWeight.w600),
            ),
          ),
          if (fee.isNotEmpty)
            TransactionSmallContainerWidget(
              child: TransactionTextRowWidget(
                label: "Transaction Fees",
                value: "$fee ${currency.toUpperCase()}",
              ),
            ),
          if (reference.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: TransactionSmallContainerWidget(
                child: TransactionTextRowWidget(
                  label: "Reference",
                  value: reference,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TransactionSmallContainerWidget(
              child: Column(
                children: [
                  if (transactionId.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: TransactionTextRowWidget(
                        label: "Transaction Id",
                        value: transactionId,
                      ),
                    ),
                  if (paymentMode.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: TransactionTextRowWidget(
                        label: "Payment Mode",
                        value: paymentMode,
                      ),
                    ),
                  if (transactionType.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: TransactionTextRowWidget(
                        label: "Transaction Type",
                        value: transactionType,
                      ),
                    ),
                  if (status.isNotEmpty)
                    TransactionTextRowWidget(
                      label: "Status",
                      value: status,
                    ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: TransactionTextRowWidget(
                      label: "Statements",
                      value: "Download",
                      onTap: onTap,
                      valueColor: Color(0xff4D4DFF),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(top: 10, bottom: 6),
            child: Text(
              "From",
              style: GoogleFonts.inter(
                  fontSize: 14,
                  color: CustomColor.black,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: CustomColor.transactionFromContainerColor,
              border: Border.all(
                  color: CustomColor.dashboardProfileBorderColor, width: 1),
              borderRadius: BorderRadius.circular(10), // Border radius
            ),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: CustomColor.primaryColor,
                        ),
                        child: Text(
                          trxDataMode == 'credit'
                              ? beneficiaryName.substring(0, 2)
                              : accountHolder.substring(0, 2),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              trxDataMode == 'credit'
                                  ? beneficiaryName
                                  : accountHolder,
                              style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: CustomColor.black,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              reference,
                              style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: CustomColor.touchIdSubtitleTextColor,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                if (amount.isNotEmpty)
                  Text(
                    "$amount $beneficiaryCurrency",
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        color: CustomColor.black,
                        fontWeight: FontWeight.w500),
                  ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(top: 20, bottom: 6),
            child: Text(
              trxDataMode == 'credit' ? "Received" : "To",
              style: GoogleFonts.inter(
                  fontSize: 14,
                  color: CustomColor.black,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              // Padding
              decoration: BoxDecoration(
                color: CustomColor.whiteColor,
                borderRadius: BorderRadius.circular(10),
                border:
                    Border.all(color: CustomColor.dashboardProfileBorderColor),
              ),
              child: trxDataMode == 'credit'
                  ? Column(
                      children: [
                        if (label.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: TransactionTextRowWidget(
                              label: 'Destination account',
                              value: '$label . ${currency.toUpperCase()}',
                            ),
                          ),
                      ],
                    )
                  : Column(
                      children: [
                        if (beneficiaryName.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: TransactionTextRowWidget(
                              label: 'Beneficiary name',
                              value: ' $beneficiaryName',
                            ),
                          ),
                        if (receiverIban.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: TransactionTextRowWidget(
                              label: 'Receiver IBAN',
                              value: receiverIban,
                            ),
                          ),
                        if (receiverBic.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: TransactionTextRowWidget(
                              label: 'Receiver BIC',
                              value: receiverBic,
                            ),
                          ),
                      ],
                    )),
        ],
      ),
    );
  }
}

class TransactionSmallContainerWidget extends StatelessWidget {
  final Widget child;

  const TransactionSmallContainerWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: CustomColor.whiteColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: CustomColor.dashboardProfileBorderColor,
          ),
        ),
        child: child);
  }
}

class TransactionTextRowWidget extends StatelessWidget {
  final String label;
  final String value;
  VoidCallback? onTap;
  Color valueColor;

  TransactionTextRowWidget({
    super.key,
    required this.label,
    required this.value,
    this.onTap,
    this.valueColor = CustomColor.black,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: CustomColor.transactionDetailsTextColor,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: InkWell(
            onTap: onTap,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: GoogleFonts.inter(
                color: valueColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
