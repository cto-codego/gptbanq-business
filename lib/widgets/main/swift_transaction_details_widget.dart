import 'package:gptbanqbusiness/utils/assets.dart';
import 'package:gptbanqbusiness/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/input_fields/custom_color.dart';

@immutable
class SwiftTransactionDetailsWidget extends StatelessWidget {
  SwiftTransactionDetailsWidget(
      {super.key,
        required this.trxDataMode,
        required this.amount,
        required this.beneficiaryName,
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
        required this.exchangeAmount,
        required this.exchangeRate,
        required this.yourTotal,
        required this.status,
        required this.recipientGets,
        required this.exchangeFee,
        required this.internationFee,
        required this.paymentMode,
        required this.receiverAccountHolder,
        required this.transactionType,
        required this.transactionId,
        required this.convertAmount,
        required this.trxMode,
        required this.note,
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
  String exchangeRate;
  String exchangeAmount;
  String yourTotal;
  String recipientGets;
  String exchangeFee;
  String internationFee;
  String receiverAccountHolder;
  String transactionType;
  String paymentMode;
  String transactionId;
  String convertAmount;
  String trxMode;
  String note;
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
          // const SizedBox(
          //   height: 10,
          // ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 10),
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
          // TransactionSmallContainerWidget(
          //   child: Column(
          //     children: [
          //       TransactionTextRowWidget(
          //         label: "Transaction Fees",
          //         value: "$fee ${currency.toUpperCase()}",
          //       ),
          //     ],
          //   ),
          // ),

          Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              // Padding
              decoration: BoxDecoration(
                color: CustomColor.whiteColor,
                borderRadius: BorderRadius.circular(10),
                border:
                Border.all(color: CustomColor.dashboardProfileBorderColor),
              ),
              child: Column(
                children: [
                  if(recipientGets.isNotEmpty && trxMode != "sell")
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: TransactionTextRowWidget(
                        label: 'Recipient Gets',
                        value: recipientGets,
                      ),
                    ),
                  if(convertAmount.isNotEmpty && trxMode == "sell")
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: TransactionTextRowWidget(
                        label: 'Convert Amount',
                        value: convertAmount,
                      ),
                    ),
                  if(exchangeRate.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: TransactionTextRowWidget(
                        label: 'Exchange Rate',
                        value: exchangeRate,
                      ),
                    ),
                  if(exchangeAmount.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: TransactionTextRowWidget(
                        label: 'Exchange Amount',
                        value: exchangeAmount,
                      ),
                    ),
                  if(fee.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: TransactionTextRowWidget(
                        label: 'Fees',
                        value: fee,
                        feeDataShow: true,
                        feeOnTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: CustomColor.scaffoldBg,
                                insetPadding: EdgeInsets.zero,
                                // Removes default inset margin
                                contentPadding: EdgeInsets.all(16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                content: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      padding:
                                      EdgeInsets.only(top: 40, bottom: 10),
                                      decoration: BoxDecoration(
                                        color: CustomColor.whiteColor,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        // Adjusts size to content
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          if(exchangeFee.isNotEmpty)
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 5),
                                              child: TransactionTextRowWidget(
                                                label: 'Exchange Fee',
                                                value: exchangeFee,
                                              ),
                                            ),
                                          if(internationFee.isNotEmpty)
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 5),
                                              child: TransactionTextRowWidget(
                                                label: 'Txs Fee',
                                                value: internationFee,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                        top: 0,
                                        child: Text(
                                          "Fees Details",
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            color: CustomColor.black,
                                          ),
                                        )),
                                    Positioned(
                                        top: 0,
                                        right: 1,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: CustomImageWidget(
                                            imagePath: StaticAssets.xClose,
                                            imageType: 'svg',
                                            height: 20,
                                          ),
                                        )),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  if(yourTotal.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: TransactionTextRowWidget(
                        label: 'Your Total',
                        value: yourTotal,
                      ),
                    ),
                ],
              )),

          if(reference.isNotEmpty)
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
                  if(transactionId.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: TransactionTextRowWidget(
                        label: "Transaction Id",
                        value: transactionId,
                      ),
                    ),
                  if(paymentMode.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: TransactionTextRowWidget(
                        label: "Payment Mode",
                        value: paymentMode,
                      ),
                    ),
                  if(transactionType.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: TransactionTextRowWidget(
                        label: "Transaction Type",
                        value: transactionType,
                      ),
                    ),
                  if(status.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: TransactionTextRowWidget(
                        label: "Status",
                        value: status,
                      ),
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


          if(note.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: TransactionSmallContainerWidget(
                child: TransactionTextRowWidget(
                  label: "Note",
                  value: note,
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
                            if(reference.isNotEmpty)
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
                if(amount.isNotEmpty)
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
                  if(label.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: TransactionTextRowWidget(
                        label: 'Destination account',
                        value: '$label . ${currency.toUpperCase()}',
                      ),
                    ),
                  // ),
                ],
              )
                  : Column(
                children: [
                  if(receiverAccountHolder.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: TransactionTextRowWidget(
                        label: 'Account Holder',
                        value: receiverAccountHolder,
                      ),
                    ),
                  if(receiverIban.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: TransactionTextRowWidget(
                        label: 'A/C',
                        value: receiverIban,
                      ),
                    ),
                  if(receiverBic.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: TransactionTextRowWidget(
                        label: 'Bic/Swift',
                        value: receiverBic,
                      ),
                    )
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
  bool feeDataShow;
  VoidCallback? feeOnTap;

  TransactionTextRowWidget({
    super.key,
    required this.label,
    required this.value,
    this.onTap,
    this.feeDataShow = false,
    this.feeOnTap,
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
        if (feeDataShow == true)
          Expanded(
            child: InkWell(
              onTap: onTap,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: feeOnTap,
                    child: Icon(
                      Icons.info_outline_rounded,
                      size: 24,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    value,
                    textAlign: TextAlign.end,
                    style: GoogleFonts.inter(
                      color: valueColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
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
