import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:gptbanqbusiness/utils/assets.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:gptbanqbusiness/widgets/toast/toast_util.dart';
import '../../../utils/input_fields/custom_color.dart';
import '../../../widgets/buttons/primary_button_widget.dart';
import '../../../widgets/buttons/default_back_button_widget.dart';
import '../bloc/investment_bloc.dart';

class CdgStakeDetailsScreen extends StatefulWidget {
  final List<String> cdgStakeSelectedCdgId;

  const CdgStakeDetailsScreen({
    super.key,
    required this.cdgStakeSelectedCdgId,
  });

  @override
  State<CdgStakeDetailsScreen> createState() => _CdgStakeDetailsScreenState();
}

class _CdgStakeDetailsScreenState extends State<CdgStakeDetailsScreen> {
  final InvestmentBloc _investmentBloc = InvestmentBloc();

  int? _boostPctSel; // selected percentage (e.g., 6 for 6%)
  bool _isBoostMenuActive = false; // NEW: track dropdown active state

  @override
  void initState() {
    super.initState();
    _investmentBloc.add(
      CdgStakeSelectedCdgIdEvent(
        cdgStakeSelectedCdgId: widget.cdgStakeSelectedCdgId,
      ),
    );
  }

  double _toDouble(String? s) {
    if (s == null) return 0.0;
    final cleaned =
        s.replaceAll(RegExp(r'[^\d\.\-]'), ''); // keep digits, dot, minus
    return double.tryParse(cleaned) ?? 0.0;
  }

  String _fmt(double v) => v.toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    final selectedCount = widget.cdgStakeSelectedCdgId.length;

    return Scaffold(
      backgroundColor: CustomColor.scaffoldBg,
      body: SafeArea(
        child: BlocListener<InvestmentBloc, InvestmentState>(
          bloc: _investmentBloc,
          listener: (context, state) {
            if (state.cdgStakeOverviewModel?.status == 0) {
              CustomToast.showError(
                context,
                "Sorry!",
                state.cdgStakeOverviewModel?.message ?? "Failed",
              );
              Navigator.pop(context);
            }

            if (state.statusModel?.status == 1) {
              CustomToast.showSuccess(
                context,
                "Hey!",
                state.statusModel?.message ?? "Success",
              );
              Navigator.pushNamedAndRemoveUntil(
                  context, 'cdgMasternodeDashboardScreen', (route) => false);
            } else if (state.statusModel?.status == 0) {
              CustomToast.showError(
                context,
                "Sorry!",
                state.statusModel?.message ?? "Failed",
              );
              Navigator.pop(context);
            }
          },
          child: BlocBuilder<InvestmentBloc, InvestmentState>(
            bloc: _investmentBloc,
            builder: (context, state) {
              final m = state.cdgStakeOverviewModel;
              final list = m?.list;

              // base from API
              final defaultBaseAmount =
                  _toDouble(state.cdgStakeOverviewModel?.defaultPay);
              final bootBase =
                  _toDouble(state.cdgStakeOverviewModel?.pay1PercentageBoot);
              final boostOptions = list?.boostPercentage ?? const <int>[];

              // ensure default selection
              if (_boostPctSel == null) {
                if (boostOptions.isNotEmpty) {
                  _boostPctSel = boostOptions.first;
                } else {
                  _boostPctSel = 0;
                }
              }
              final boostPct = (_boostPctSel ?? 0);
              final boostPay = bootBase * boostPct;

              final total = defaultBaseAmount + boostPay;

              // NEW: balance guard
              final cdgBal = _toDouble(state.cdgStakeOverviewModel?.cdgBalance);
              final hasEnoughBalance = cdgBal >= total;

              // button title with ##AMT## replacement
              final rawBtnTitle = m?.btnTitle ?? 'Submit';
              final btnTitle = rawBtnTitle.contains('##AMT##')
                  ? rawBtnTitle.replaceAll('##AMT##',
                      "${_fmt(total)} ${state.cdgStakeOverviewModel?.coin ?? ""}")
                  : rawBtnTitle;

              // NEW: gate the button
              // Fix: don’t gate on dropdown focus
              final canSubmit = selectedCount > 0 &&
                  m?.status == 1 &&
                  _boostPctSel != null &&
                  hasEnoughBalance; // removed !_isBoostMenuActive

              return ProgressHUD(
                inAsyncCall: state.isloading,
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Image.asset(StaticAssets.cdgBg1, height: 300),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Image.asset(
                        StaticAssets.cdgBg2,
                        width: 150,
                        height: 150,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          // header
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10, top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                DefaultBackButtonWidget(
                                  onTap: () => Navigator.pop(context),
                                ),
                                Text(
                                  'Stake Overview',
                                  style: GoogleFonts.inter(
                                    color: CustomColor.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 20),
                              ],
                            ),
                          ),
                          const Divider(),

                          // selected count card
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(top: 12, bottom: 14),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: CustomColor.hubContainerBgColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  list?.deviceSelectedText ?? "Selected Device",
                                  style: GoogleFonts.inter(
                                    color: CustomColor.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        CustomColor.dashboardProfileBorderColor,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    (list?.deviceSelectedValue?.isNotEmpty ??
                                            false)
                                        ? list!.deviceSelectedValue!
                                        : '$selectedCount',
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: CustomColor.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // summary with boost% dropdown
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: CustomColor.hubContainerBgColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                _SummaryRow(
                                  label: list?.basePrice ?? "Base",
                                  value: list?.baseValue ?? "0.00",
                                ),
                                const SizedBox(height: 8),

                                // Boost % selector
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${list?.boostPayout}',
                                        style: GoogleFonts.inter(
                                          color: CustomColor.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    // NEW: Focus wrapper to toggle _isBoostMenuActive
                                    Focus(
                                      onFocusChange: (hasFocus) {
                                        setState(() {
                                          _isBoostMenuActive = hasFocus;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: CustomColor
                                              .dashboardProfileBorderColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: DropdownButton<int>(
                                          value: _boostPctSel,
                                          underline: const SizedBox.shrink(),
                                          onTap: () => setState(
                                              () => _isBoostMenuActive = true),
                                          items: boostOptions.isNotEmpty
                                              ? [
                                                  for (final p in boostOptions)
                                                    DropdownMenuItem<int>(
                                                      value: p,
                                                      child: Text('$p%'),
                                                    ),
                                                ]
                                              : [
                                                  const DropdownMenuItem<int>(
                                                    value: 0,
                                                    child: Text('0%'),
                                                  ),
                                                ],
                                          onChanged: (v) {
                                            setState(() {
                                              _boostPctSel = v;
                                              _isBoostMenuActive = false;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 8),
                                _SummaryRow(
                                  label: 'Boost pay (${_boostPctSel ?? 0}%)',
                                  value:
                                      "${_fmt(boostPay)} ${state.cdgStakeOverviewModel?.coin ?? ""}",
                                ),
                                const Divider(height: 24),
                                _SummaryRow(
                                  label: 'Total Amount',
                                  value:
                                      "${_fmt(total)} ${state.cdgStakeOverviewModel?.coin ?? ""}",
                                  isBold: true,
                                ),
                              ],
                            ),
                          ),

                          if ((m?.boostNote?.isNotEmpty ?? false)) ...[
                            const SizedBox(height: 10),
                            Text(
                              m!.boostNote!,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: CustomColor.black.withOpacity(0.7),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],

                          const SizedBox(height: 18),
                          PrimaryButtonWidget(
                            onPressed: canSubmit
                                ? () {
                                    _investmentBloc.add(CdgStakePayNowEvent(
                                      cdgStakeSelectedCdgId:
                                          widget.cdgStakeSelectedCdgId,
                                      boostPercentage: _boostPctSel!,
                                    ));
                                  }
                                : null,
                            buttonText: btnTitle,
                          ),
                          RichText(
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                                TextSpan(
                                  text:
                                      '${state.cdgStakeOverviewModel?.cdgTitle} ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      '${state.cdgStakeOverviewModel?.cdgBalance}',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    final txtStyle = GoogleFonts.inter(
      color: CustomColor.black.withOpacity(isBold ? 1 : 0.88),
      fontSize: isBold ? 16 : 14,
      fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label, style: txtStyle)),
          const SizedBox(width: 10),
          Text(value, style: txtStyle),
        ],
      ),
    );
  }
}
