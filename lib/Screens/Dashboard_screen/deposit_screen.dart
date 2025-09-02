import 'package:gptbanqbusiness/Screens/Dashboard_screen/bloc/dashboard_bloc.dart';
import 'package:gptbanqbusiness/constant_string/User.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:gptbanqbusiness/utils/input_fields/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/assets.dart';
import '../../widgets/buttons/default_back_button_widget.dart';
import '../../widgets/custom_image_widget.dart';
import '../../widgets/toast/toast_util.dart';

class DashboardDepositScreen extends StatefulWidget {
  const DashboardDepositScreen({
    super.key,
    required this.ibanId,
  });

  final String ibanId;

  @override
  State<DashboardDepositScreen> createState() => _DashboardDepositScreenState();
}

class _DashboardDepositScreenState extends State<DashboardDepositScreen>
    with SingleTickerProviderStateMixin {
  final DashboardBloc _dashboardBloc = DashboardBloc();
  bool local = true;
  int isSwift = 0;
  int isLocal = 0;

  @override
  void initState() {
    super.initState();
    // if (User.isEu == 1) {
    //   _dashboardBloc.add(SwiftDepositEvent());
    // }
    User.Screen = 'Notification Screen';
    _dashboardBloc.add(DepositAccountDetailsEvent(ibanId: widget.ibanId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.notificationBgColor,
      body: BlocListener(
          bloc: _dashboardBloc,
          listener: (context, DashboardState state) async {
            if (state.statusModel?.status == 0) {
              CustomToast.showError(
                  context, "Sorry!", state.statusModel!.message!);
            }

            if (state.depositDashboardModel?.status == 0) {
              CustomToast.showError(
                  context, "Sorry!", state.depositDashboardModel!.message!);
            }

            if (state.depositDashboardModel?.status == 1) {
              isLocal = state.depositDashboardModel!.isLocal!;
              isSwift = state.depositDashboardModel!.isSwift!;
              if (state.depositDashboardModel!.isLocal! == 1 &&
                  state.depositDashboardModel!.isSwift == 1) {
                setState(() {
                  local = true;
                });

                print(local.toString());
              } else if (state.depositDashboardModel!.isLocal! == 0 &&
                  state.depositDashboardModel!.isSwift == 1) {
                setState(() {
                  local = false;
                });

                print(local.toString());
              } else if (state.depositDashboardModel!.isLocal! == 1 &&
                  state.depositDashboardModel!.isSwift == 0) {
                setState(() {
                  local = true;
                });

                print(local.toString());
              }
            }
          },
          child: BlocBuilder(
              bloc: _dashboardBloc,
              builder: (context, DashboardState state) {
                return SafeArea(
                  child: ProgressHUD(
                    inAsyncCall: state.isloading,
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      child: ListView(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          appBarSection(context, state),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    if (state.depositDashboardModel!.currency!
                                        .isNotEmpty)
                                      TextSpan(
                                        text: state
                                            .depositDashboardModel!.currency!,
                                        style: GoogleFonts.inter(
                                          color: CustomColor
                                              .inputFieldTitleTextColor,
                                          fontSize: 36,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    if (state.depositDashboardModel!
                                        .accountBalance!.isNotEmpty)
                                      TextSpan(
                                        text: state.depositDashboardModel!
                                            .accountBalance!,
                                        style: GoogleFonts.inter(
                                          color: CustomColor.black,
                                          fontSize: 36,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              if (state.depositDashboardModel!.currencyflag!
                                  .isNotEmpty)
                                Container(
                                  height: 36,
                                  width: 36,
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: NetworkImage(state
                                          .depositDashboardModel!
                                          .currencyflag!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              else
                                Container(),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          if (isLocal == 1 && isSwift == 1)
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                color: CustomColor.currencyCustomSelectorColor,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          local = true;
                                        });
                                      },
                                      child: Container(
                                        height: 41,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(24),
                                          color: local
                                              ? CustomColor.whiteColor
                                              : CustomColor
                                                  .currencyCustomSelectorColor,
                                          boxShadow: local
                                              ? [
                                                  BoxShadow(
                                                    color: Color(0x0D000000),
                                                    // Shadow color
                                                    offset: Offset(0, 2),
                                                    // Offset of the shadow
                                                    blurRadius: 4,
                                                    // Blur radius
                                                    spreadRadius:
                                                        0, // Spread radius (0px)
                                                  ),
                                                ]
                                              : [],
                                        ),
                                        child: Text(
                                          'Local',
                                          style: GoogleFonts.inter(
                                              color: local
                                                  ? CustomColor.black
                                                  : CustomColor.black
                                                      .withOpacity(0.6),
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          local = false;
                                        });
                                      },
                                      child: Container(
                                        height: 41,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(24),
                                          color: local
                                              ? CustomColor
                                                  .currencyCustomSelectorColor
                                              : CustomColor.whiteColor,
                                          boxShadow: local
                                              ? []
                                              : [
                                                  BoxShadow(
                                                    color: Color(0x0D000000),
                                                    // Shadow color
                                                    offset: Offset(0, 2),
                                                    // Offset of the shadow
                                                    blurRadius: 4,
                                                    // Blur radius
                                                    spreadRadius:
                                                        0, // Spread radius (0px)
                                                  ),
                                                ],
                                        ),
                                        child: Text(
                                          'Swift',
                                          style: GoogleFonts.inter(
                                              color: local
                                                  ? CustomColor.black
                                                      .withOpacity(0.6)
                                                  : CustomColor.black,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          if (local && isLocal == 1)
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "For domestic transfers only",
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: CustomColor
                                              .transactionDetailsTextColor,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {},
                                        child: Text(
                                          "",
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 13,
                                            color: CustomColor.primaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                      color: CustomColor.whiteColor,
                                      borderRadius: BorderRadius.circular(16)),
                                  child: Column(
                                    children: [
                                      if (state.depositDashboardModel!.account!
                                          .local!.beneficiary!.isNotEmpty)
                                        BeneficiaryInfoWidget(
                                          label: "Beneficiary",
                                          title: state.depositDashboardModel!
                                              .account!.local!.beneficiary!,
                                          onCopy: () {
                                            copyToClipboard(
                                                context,
                                                state
                                                    .depositDashboardModel!
                                                    .account!
                                                    .local!
                                                    .beneficiary!);
                                          },
                                        ),
                                      if (state.depositDashboardModel!.account!
                                          .local!.iban!.isNotEmpty)
                                        BeneficiaryInfoWidget(
                                          label: state.depositDashboardModel!
                                              .account!.local!.accountLabel!,
                                          title: state.depositDashboardModel!
                                              .account!.local!.iban!,
                                          onCopy: () {
                                            copyToClipboard(
                                                context,
                                                state.depositDashboardModel!
                                                    .account!.local!.iban!);
                                          },
                                        ),
                                      if (state.depositDashboardModel!.account!
                                          .local!.bicSwift!.isNotEmpty)
                                        BeneficiaryInfoWidget(
                                          label: state.depositDashboardModel!
                                              .account!.local!.routeLabel!,
                                          title: state.depositDashboardModel!
                                              .account!.local!.bicSwift!,
                                          onCopy: () {
                                            copyToClipboard(
                                              context,
                                              state.depositDashboardModel!
                                                  .account!.local!.bicSwift!,
                                            );
                                          },
                                        ),
                                      if (state.depositDashboardModel!.account!
                                          .local!.bankName!.isNotEmpty)
                                        BeneficiaryInfoWidget(
                                          label: "Bank Name",
                                          title: state.depositDashboardModel!
                                              .account!.local!.bankName!,
                                          onCopy: () {
                                            copyToClipboard(
                                                context,
                                                state.depositDashboardModel!
                                                    .account!.local!.bankName!);
                                          },
                                        ),
                                      if (state.depositDashboardModel!.account!
                                          .local!.bankAddress!.isNotEmpty)
                                        BeneficiaryInfoWidget(
                                          label: "Bank Address",
                                          title: state.depositDashboardModel!
                                              .account!.local!.bankAddress!,
                                          onCopy: () {
                                            copyToClipboard(
                                              context,
                                              state.depositDashboardModel!
                                                  .account!.local!.bankAddress!,
                                            );
                                          },
                                        ),
                                      if (state.depositDashboardModel!.account!
                                          .local!.reference!.isNotEmpty)
                                        BeneficiaryInfoWidget(
                                          label: "Reference",
                                          title: state.depositDashboardModel!
                                              .account!.local!.reference!,
                                          onCopy: () {
                                            copyToClipboard(
                                              context,
                                              state.depositDashboardModel!
                                                  .account!.local!.reference!,
                                            );
                                          },
                                        ),
                                      if (state.depositDashboardModel!.account!
                                          .local!.note!.isNotEmpty)
                                        BeneficiaryInfoWidget(
                                          label: "Note",
                                          title: state.depositDashboardModel!
                                              .account!.local!.note!,
                                          titleColor: CustomColor.errorColor,
                                          showCopyButton: false,
                                          titleFontSize: 13,
                                          titleTextAlign: TextAlign.justify,
                                          onCopy: () {
                                            copyToClipboard(
                                              context,
                                              state.depositDashboardModel!
                                                  .account!.local!.note!,
                                            );
                                          },
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          if (!local && isSwift == 1)
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "For cross-border transfers only",
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: CustomColor
                                              .transactionDetailsTextColor,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {},
                                        child: Text(
                                          "",
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 13,
                                            color: CustomColor.primaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                      color: CustomColor.whiteColor,
                                      borderRadius: BorderRadius.circular(16)),
                                  child: Column(
                                    children: [
                                      if (state.depositDashboardModel!.account!
                                          .swift!.beneficiary!.isNotEmpty)
                                        BeneficiaryInfoWidget(
                                          label: "Beneficiary",
                                          title: state.depositDashboardModel!
                                              .account!.swift!.beneficiary!,
                                          onCopy: () {
                                            copyToClipboard(
                                              context,
                                              state.depositDashboardModel!
                                                  .account!.swift!.beneficiary!,
                                            );
                                          },
                                        ),
                                      if (state.depositDashboardModel!.account!
                                          .swift!.iban!.isNotEmpty)
                                        BeneficiaryInfoWidget(
                                          label: state.depositDashboardModel!
                                              .account!.swift!.accountLabel!,
                                          title: state.depositDashboardModel!
                                              .account!.swift!.iban,
                                          onCopy: () {
                                            copyToClipboard(
                                                context,
                                                state.depositDashboardModel!
                                                    .account!.swift!.iban!);
                                          },
                                        ),
                                      if (state.depositDashboardModel!.account!
                                          .swift!.bicSwift!.isNotEmpty)
                                        BeneficiaryInfoWidget(
                                          label: state.depositDashboardModel!
                                              .account!.swift!.routeLabel!,
                                          title: state.depositDashboardModel!
                                              .account!.swift!.bicSwift!,
                                          onCopy: () {
                                            copyToClipboard(
                                                context,
                                                state.depositDashboardModel!
                                                    .account!.swift!.bicSwift!);
                                          },
                                        ),
                                      if (state.depositDashboardModel!.account!
                                          .swift!.bankName!.isNotEmpty)
                                        BeneficiaryInfoWidget(
                                          label: "Bank Name",
                                          title: state.depositDashboardModel!
                                              .account!.swift!.bankName!,
                                          onCopy: () {
                                            copyToClipboard(
                                              context,
                                              state.depositDashboardModel!
                                                  .account!.swift!.bankName!,
                                            );
                                          },
                                        ),
                                      if (state.depositDashboardModel!.account!
                                          .swift!.bankAddress!.isNotEmpty)
                                        BeneficiaryInfoWidget(
                                          label: "Bank Address",
                                          title: state.depositDashboardModel!
                                              .account!.swift!.bankAddress!,
                                          onCopy: () {
                                            copyToClipboard(
                                              context,
                                              state.depositDashboardModel!
                                                  .account!.swift!.bankAddress!,
                                            );
                                          },
                                        ),
                                      if (state.depositDashboardModel!.account!
                                          .swift!.reference!.isNotEmpty)
                                        BeneficiaryInfoWidget(
                                          label: "Reference",
                                          title: state.depositDashboardModel!
                                              .account!.swift!.reference!,
                                          onCopy: () {
                                            copyToClipboard(
                                              context,
                                              state.depositDashboardModel!
                                                  .account!.swift!.reference!,
                                            );
                                          },
                                        ),
                                      if (state.depositDashboardModel!.account!
                                          .swift!.note!.isNotEmpty)
                                        BeneficiaryInfoWidget(
                                          label: "Note",
                                          title: state.depositDashboardModel!
                                              .account!.swift!.note!,
                                          titleColor: CustomColor.errorColor,
                                          showCopyButton: false,
                                          titleFontSize: 13,
                                          titleTextAlign: TextAlign.justify,
                                          onCopy: () {
                                            copyToClipboard(
                                              context,
                                              state.depositDashboardModel!
                                                  .account!.swift!.note!,
                                            );
                                          },
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          else
                            Container(),
                          Container(
                            padding: EdgeInsets.all(16),
                            margin: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                                color: CustomColor.whiteColor,
                                borderRadius: BorderRadius.circular(16)),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8),
                                  child: Row(
                                    children: [
                                      Container(
                                          margin: EdgeInsets.only(right: 10),
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            color: CustomColor.primaryColor,
                                          ),
                                          child: CustomImageWidget(
                                            imagePath:
                                                StaticAssets.shieldDollar,
                                            imageType: 'svg',
                                            height: 30,
                                          )),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Protected Deposit",
                                              style: GoogleFonts.inter(
                                                color: CustomColor.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              "Your money is protected by the Local Deposit Guarantee Scheme.",
                                              style: GoogleFonts.inter(
                                                color: CustomColor
                                                    .primaryTextHintColor,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  color:
                                      CustomColor.dashboardProfileBorderColor,
                                ),
                                Container(
                                  padding: EdgeInsets.all(8),
                                  child: Row(
                                    children: [
                                      Container(
                                          margin: EdgeInsets.only(right: 10),
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            color: CustomColor.primaryColor,
                                          ),
                                          child: CustomImageWidget(
                                            imagePath: StaticAssets.light,
                                            imageType: 'svg',
                                            height: 30,
                                          )),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Cross-platform transfer",
                                              style: GoogleFonts.inter(
                                                color: CustomColor.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              "Receive transfers from Euro bank into your Payment Account using these details.",
                                              style: GoogleFonts.inter(
                                                color: CustomColor
                                                    .primaryTextHintColor,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (local == true && isLocal == 1)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                "Documents",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  color: CustomColor.primaryTextHintColor,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          if (local == true && isLocal == 1)
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                  color: CustomColor.whiteColor,
                                  borderRadius: BorderRadius.circular(16)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamedAndRemoveUntil(context,
                                          'transactionScreen', (route) => true);
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Account Statement",
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w500,
                                            color: CustomColor
                                                .primaryTextHintColor,
                                            fontSize: 14,
                                          ),
                                        ),
                                        CustomImageWidget(
                                          imagePath: StaticAssets.arrowRight,
                                          imageType: 'svg',
                                          height: 24,
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              })),
    );
  }

  appBarSection(BuildContext context, state) {
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DefaultBackButtonWidget(
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Text(
            'Deposit',
            style: GoogleFonts.inter(
                color: CustomColor.black,
                fontSize: 18,
                fontWeight: FontWeight.w500),
          ),
          Container(
            width: 20,
          )
        ],
      ),
    );
  }
}

void copyToClipboard(BuildContext context, String textToCopy) {
  // Copy the text to the clipboard
  Clipboard.setData(ClipboardData(text: textToCopy)).then((_) {
    // Show a SnackBar to indicate that the text was copied
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied to clipboard!'),
        duration: Duration(seconds: 2), // Show for 2 seconds
      ),
    );
  });
}

class BeneficiaryInfoWidget extends StatelessWidget {
  final String label;
  final String? title;
  final VoidCallback onCopy;
  final Color titleColor; // Parameter for title color
  final bool showCopyButton; // Parameter to control copy button visibility
  final double titleFontSize; // Parameter for title font size
  final double labelFontSize; // Parameter for label font size
  final TextAlign titleTextAlign; // New parameter for title text alignment

  const BeneficiaryInfoWidget({
    super.key,
    required this.label,
    this.title = "",
    required this.onCopy,
    this.titleColor = CustomColor.transactionDetailsTextColor, // Default color
    this.showCopyButton = true, // Default to show the copy button
    this.titleFontSize = 18.0, // Default title font size
    this.labelFontSize = 14.0, // Default label font size
    this.titleTextAlign = TextAlign.start, // Default title text alignment
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: labelFontSize, // Use the customizable label font size
                color: CustomColor.touchIdSubtitleTextColor,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    title!,
                    textAlign: titleTextAlign,
                    // Use the customizable title text alignment
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: titleFontSize,
                      // Use the customizable title font size
                      color: titleColor, // Use the customizable title color
                    ),
                  ),
                ),
              ),
              if (showCopyButton) // Conditionally show the copy button
                InkWell(
                  onTap: onCopy,
                  child: CustomImageWidget(
                    imagePath: StaticAssets.copy,
                    imageType: 'svg',
                    height: 18,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
