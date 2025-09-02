import 'package:gptbanqbusiness/utils/assets.dart';
import 'package:gptbanqbusiness/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/input_fields/custom_color.dart';

@immutable
class CardTransactionDetailsWidget extends StatelessWidget {
  CardTransactionDetailsWidget({
    super.key,
    required this.Merch_Name_DE43,
    required this.merchantName,
    required this.transactionId,
    required this.billingAmount,
    required this.billingCurrency,
    required this.txnDesc,
    required this.totalPay,
    required this.status,
    required this.type,
    required this.currency,
    required this.symbol,
    required this.created,
    required this.image,
    required this.onTap,
    required this.isShowMerchant,
  });

  final String Merch_Name_DE43;
  final String merchantName;
  final String transactionId;
  final String billingAmount;
  final String billingCurrency;
  final String? txnDesc;
  final String totalPay;
  final String status;
  final String type;
  final String currency;
  final String symbol;
  final String created;
  final String image;
  final String isShowMerchant;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: CustomColor.whiteColor,
        borderRadius: const BorderRadius.only(
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
                const SizedBox(width: 20),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 20),
            child: Text(
              (type == 'debit' ? '-' : '+') + totalPay + currency.toUpperCase(),
              style: GoogleFonts.inter(
                  color: type == 'debit'
                      ? CustomColor.errorColor
                      : CustomColor.green,
                  fontSize: 36,
                  fontWeight: FontWeight.w600),
            ),
          ),
          if (type == 'debit')
            TransactionSmallContainerWidget(
              child: TransactionTextRowWidget(
                label: "Billing Amount",
                value: "$billingAmount ${billingCurrency.toUpperCase()}",
              ),
            ),
          const SizedBox(height: 10),
          if (type == 'debit')
            TransactionSmallContainerWidget(
              child: TransactionTextRowWidget(
                label: "Total Pay",
                value: "$totalPay ${currency.toUpperCase()}",
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: TransactionSmallContainerWidget(
              child: Column(
                children: [
                  if (type != null && type.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: TransactionTextRowWidget(
                        label: "Trx Type",
                        value: type,
                      ),
                    ),
                  if (transactionId.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: TransactionTextRowWidget(
                        label: "Transaction ID",
                        value: transactionId,
                      ),
                    ),
                  if (status != null && status.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: TransactionTextRowWidget(
                        label: "Status",
                        value: status,
                      ),
                    ),
                  if (isShowMerchant == "1")
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: TransactionTextRowWidget(
                        label: "Merchant Name",
                        value: merchantName,
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (txnDesc != null && txnDesc!.isNotEmpty)
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.only(top: 10, bottom: 6),
              child: Text(
                "Description",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: CustomColor.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          if (txnDesc != null && txnDesc!.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: CustomColor.transactionFromContainerColor,
                border: Border.all(
                  color: CustomColor.dashboardProfileBorderColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      txnDesc!,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: CustomColor.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: TransactionSmallContainerWidget(
              child: TransactionTextRowWidget(
                label: "Date",
                value: created,
              ),
            ),
          ),
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
