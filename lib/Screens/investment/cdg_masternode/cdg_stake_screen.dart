import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:gptbanqbusiness/Screens/investment/bloc/investment_bloc.dart';
import 'package:gptbanqbusiness/utils/assets.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:gptbanqbusiness/widgets/toast/toast_util.dart';
import '../../../utils/input_fields/custom_color.dart';
import '../../../utils/strings.dart';
import '../../../widgets/buttons/primary_button_widget.dart';
import '../../../widgets/buttons/default_back_button_widget.dart';
import '../models/cdg_stake_list_model.dart';
import 'cdg_stake_overview_screen.dart';

class CdgStakeScreen extends StatefulWidget {
  const CdgStakeScreen({super.key});

  @override
  State<CdgStakeScreen> createState() => _CdgStakeScreenState();
}

class _CdgStakeScreenState extends State<CdgStakeScreen> {
  final InvestmentBloc _investmentBloc = InvestmentBloc();

  // ✅ Track selection by cdgId
  final Set<String> _selectedCdgIds = {};

  Future<void> _onRefresh() async => _investmentBloc.add(CdgStakeListEvent());

  @override
  void initState() {
    super.initState();
    _investmentBloc.add(CdgStakeListEvent());
  }

  void _toggleOne(String cdgId) {
    setState(() {
      _selectedCdgIds.contains(cdgId)
          ? _selectedCdgIds.remove(cdgId)
          : _selectedCdgIds.add(cdgId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.scaffoldBg,
      body: BlocListener<InvestmentBloc, InvestmentState>(
        bloc: _investmentBloc,
        listener: (context, state) {
          if (state.cdgStakeListModel?.status == 0) {
            CustomToast.showError(
              context,
              "Sorry!",
              state.cdgStakeListModel?.message ?? "Failed",
            );
            Navigator.pop(context);
          }
        },
        child: BlocBuilder<InvestmentBloc, InvestmentState>(
          bloc: _investmentBloc,
          builder: (context, state) {
            final List<Cdg> devices =
                state.cdgStakeListModel?.cdg ?? const <Cdg>[];

            final bool isButtonEnabled =
                devices.isNotEmpty && _selectedCdgIds.isNotEmpty;

            return SafeArea(
              child: ProgressHUD(
                inAsyncCall: state.isloading,
                child: Stack(
                  children: [
                    Positioned(
                        top: 0,
                        right: 0,
                        child: Image.asset(StaticAssets.cdgBg1, height: 300)),
                    Positioned(
                        bottom: 0,
                        left: 0,
                        child: Image.asset(StaticAssets.cdgBg2,
                            width: 150, height: 150)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: RefreshIndicator(
                        onRefresh: _onRefresh,
                        child: Column(
                          children: [
                            appBarSection(context),
                            const Divider(),
                            // Header
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 6),
                              child: Row(
                                children: [
                                  Text("Stakeable Devices",
                                      style: GoogleFonts.inter(
                                        color: CustomColor.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      )),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: CustomColor
                                          .dashboardProfileBorderColor,
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Text(
                                      "${devices.length}",
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color:
                                            CustomColor.black.withOpacity(0.6),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    "Selected: ${_selectedCdgIds.length}",
                                    style: GoogleFonts.inter(
                                      color: CustomColor.black.withOpacity(0.7),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Expanded(
                              child: ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                itemCount: devices.length,
                                itemBuilder: (context, index) {
                                  final device = devices[index];
                                  final cdgId = device.cdgId?.toString() ?? '';
                                  final isSelected =
                                      _selectedCdgIds.contains(cdgId);

                                  return CdgDeviceListItem(
                                    image: device.image,
                                    serialNumber: device.serialNumber,
                                    cdgId: cdgId,
                                    status: device.status,
                                    isSelected: isSelected,
                                    onSelectedChanged: (_) => _toggleOne(cdgId),
                                    onTap: () => _toggleOne(cdgId),
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 16),

                            PrimaryButtonWidget(
                              onPressed: isButtonEnabled
                                  ? () {
                                      final selectedIds =
                                          _selectedCdgIds.toList();

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => CdgStakeDetailsScreen(
                                            cdgStakeSelectedCdgId: selectedIds,
                                          ),
                                        ),
                                      );

                                      // _investmentBloc.add(
                                      //   CdgStakeSelectedCdgIdEvent(
                                      //     cdgStakeSelectedCdgId: selectedIds,
                                      //   ),
                                      // );
                                    }
                                  : null,
                              buttonText: 'Next',
                            ),

                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Padding appBarSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DefaultBackButtonWidget(onTap: () => Navigator.pop(context)),
          Text('${Strings.coinName} Stake',
              style: GoogleFonts.inter(
                color: CustomColor.black,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              )),
          const SizedBox(width: 20),
        ],
      ),
    );
  }
}

class CdgDeviceListItem extends StatelessWidget {
  final String? image;
  final String? serialNumber;
  final String? cdgId;
  final String? status;
  final bool isSelected;
  final ValueChanged<bool> onSelectedChanged;
  final VoidCallback onTap;

  const CdgDeviceListItem({
    super.key,
    this.image,
    this.serialNumber,
    this.cdgId,
    this.status,
    required this.isSelected,
    required this.onSelectedChanged,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // tap anywhere to toggle selection
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          color: CustomColor.dashboardProfileBorderColor,
          // border: Border.all(
          //   color: isSelected ? CustomColor.primaryColor : Colors.transparent,
          //   width: 2,
          // ),
        ),
        child: Row(
          children: [
            // Checkbox
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: isSelected,
                  onChanged: (v) => onSelectedChanged(v ?? false),
                  activeColor: CustomColor.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),

            // Image (network → fallback to app logo)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: (image != null && image!.isNotEmpty)
                  ? Image.network(
                      image!,
                      height: 53,
                      width: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) => Image.asset(
                        "images/icon/logo.png",
                        height: 53,
                        width: 40,
                        fit: BoxFit.contain,
                      ),
                    )
                  : Image.asset(
                      "images/icon/logo.png",
                      height: 53,
                      width: 40,
                      fit: BoxFit.contain,
                    ),
            ),

            // Labels
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Serial Number",
                    style: GoogleFonts.inter(
                      color: CustomColor.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    serialNumber ?? "--",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: Colors.grey,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Status pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.orange),
              ),
              child: Text(
                status ?? "--",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: CustomColor.whiteColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
