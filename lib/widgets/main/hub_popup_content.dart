import 'dart:convert';

import 'package:gptbanqbusiness/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../Screens/crypto_screen/Crypto_screen.dart';
import '../../Screens/investment/cdg_masternode/cdg_investment_dashboard_screen.dart';
import '../../Screens/investment/investment_screen.dart';
import '../../constant_string/User.dart';
import '../../utils/assets.dart';
import '../../utils/input_fields/custom_color.dart';
import '../../utils/strings.dart';
import '../buttons/primary_button_widget.dart';
import 'hub_container_widget.dart';

class HubPopupContent extends StatefulWidget {
  const HubPopupContent({super.key});

  @override
  _HubPopupContentState createState() => _HubPopupContentState();
}

class _HubPopupContentState extends State<HubPopupContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  Map<String, dynamic>? termsData;

  bool isAccepted = false;
  String? pageName;

  @override
  void initState() {
    super.initState();
    loadTermsData();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Delay the animation of the close button
    Future.delayed(const Duration(seconds: 1), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  Future<void> loadTermsData() async {
    try {
      final jsonString = await rootBundle.loadString('assets/json/terms.json');
      final jsonData = json.decode(jsonString);
      setState(() {
        termsData = jsonData;
      });
    } catch (e) {
      print("Error loading terms data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ModalRoute.of(context)!.animation!,
      builder: (context, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1), // Start from below the screen
            end: Offset.zero, // End at the original position
          ).animate(CurvedAnimation(
            parent: ModalRoute.of(context)!.animation!,
            curve: Curves.easeInOut,
          )),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            height: MediaQuery.of(context).size.height * 0.80,
            decoration: BoxDecoration(
              color: CustomColor.scaffoldBg,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Dashboard Menu",
                            style: GoogleFonts.inter(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: CustomColor.black,
                            ),
                          ),
                          Container(),
                        ],
                      ),
                    ),
                    Expanded(
                      child: GridView(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1,
                        ),
                        children: [
                          HubContainerWidget(
                            title: "Home",
                            imagePath: StaticAssets.home,
                            isHubContainerBorderColor: false,
                            onTap: () {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, 'dashboard', (route) => false);
                            },
                          ),
                          if (User.hidepage == 0)
                            HubContainerWidget(
                              title: "Currency",
                              imagePath: StaticAssets.currencyArrow,
                              isHubContainerBorderColor: false,
                              onTap: () {
                                if (User.tcCrypto == 0) {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.white,
                                    barrierColor: Colors.black.withOpacity(0.2),
                                    builder: (context) {
                                      return TermsContent(
                                        pdfLink: User.termsPdf,
                                        isAccepted: isAccepted,
                                        onAcceptedChanged: (value) {
                                          isAccepted = value;
                                        },
                                        onSubmit: () {
                                          pageName = "crypto";
                                          User.tcCrypto = 1;
                                          print("crypto");
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CryptoScreen(
                                                isCryptoCall: true,
                                              ), // Navigate to CryptoScreen
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  );
                                } else {
                                  Navigator.pushNamedAndRemoveUntil(context,
                                      'cryptoScreen', (route) => false);
                                }
                              },
                            ),
                          if (User.hideinvest == 0)
                            HubContainerWidget(
                              title: "Invest",
                              imagePath: StaticAssets.investment,
                              isHubContainerBorderColor: false,
                              onTap: () {
                                if (User.tcInvestment == 0) {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.white,
                                    barrierColor: Colors.black.withOpacity(0.2),
                                    builder: (context) {
                                      return TermsContent(
                                        pdfLink: User.termsPdf,
                                        isAccepted: isAccepted,
                                        onAcceptedChanged: (value) {
                                          isAccepted = value;
                                        },
                                        onSubmit: () {
                                          pageName = "investment";
                                          User.tcInvestment = 1;
                                          print("investment");

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  InvestmentScreen(
                                                isTcInvestmentCall: true,
                                              ), // Navigate to CryptoScreen
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  );
                                } else {
                                  Navigator.pushNamedAndRemoveUntil(context,
                                      'investmentScreen', (route) => false);
                                }
                              },
                            ),
                          if (User.hidecdg == 0)
                            HubContainerWidget(
                              title: Strings.coinName,
                              imagePath: StaticAssets.dataMining,
                              isHubContainerBorderColor: false,
                              onTap: () {
                                if (User.tcCdg == 0) {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.white,
                                    barrierColor: Colors.black.withOpacity(0.2),
                                    builder: (context) {
                                      return TermsContent(
                                        pdfLink: User.tccdgpdf,
                                        isAccepted: isAccepted,
                                        onAcceptedChanged: (value) {
                                          isAccepted = value;
                                        },
                                        onSubmit: () {
                                          pageName = "cdg";
                                          User.tcCdg = 1;
                                          debugPrint("CDG");

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CdgInvestmentDashboardScreen(
                                                isTcInvestmentCall: true,
                                              ), // Navigate to CryptoScreen
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  );
                                } else {
                                  Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      'cdgInvestmentDashboardScreen',
                                      (route) => false);
                                }
                              },
                            ),
                          HubContainerWidget(
                            title: "Pos",
                            imagePath: StaticAssets.posIcon,
                            isHubContainerBorderColor: false,
                            onTap: () {
                              Navigator.pushNamedAndRemoveUntil(context,
                                  'posDashboardScreen', (route) => false);
                            },
                          ),
                          HubContainerWidget(
                            title: "Send",
                            imagePath: StaticAssets.send,
                            isHubContainerBorderColor: false,
                            onTap: () {
                              Navigator.pushNamedAndRemoveUntil(context,
                                  'beneficiaryListScreen', (route) => false);
                            },
                          ),
                          if (User.isCardEu == 1)
                            HubContainerWidget(
                              title: "Cards",
                              imagePath: StaticAssets.cards,
                              isHubContainerBorderColor: false,
                              onTap: () {
                                Navigator.pushNamedAndRemoveUntil(
                                    context, 'cardScreen', (route) => false);
                              },
                            ),
                          if (User.showGc == 0)
                            HubContainerWidget(
                              title: "Gift Cards",
                              imagePath: StaticAssets.giftCards,
                              isHubContainerBorderColor: false,
                              onTap: () {
                                Navigator.pushNamedAndRemoveUntil(context,
                                    'buyGiftCardScreen', (route) => false);
                              },
                            ),
                          HubContainerWidget(
                            title: "Beneficiary",
                            imagePath: StaticAssets.addPeople,
                            isHubContainerBorderColor: false,
                            onTap: () {
                              Navigator.pushNamedAndRemoveUntil(context,
                                  'beneficiaryListScreen', (route) => false);
                            },
                          ),
                          HubContainerWidget(
                            title: "Profile",
                            imagePath: StaticAssets.profile,
                            isHubContainerBorderColor: false,
                            onTap: () {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, 'profileScreen', (route) => false);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: CustomColor.primaryColor,
                        ),
                        child: CustomImageWidget(
                          imagePath: StaticAssets.close,
                          imageType: 'svg',
                          height: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SectionWidget extends StatelessWidget {
  final Map<String, dynamic> section;

  const SectionWidget({Key? key, required this.section}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            section['title'],
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.0),
          // Section Content
          if (section.containsKey('content'))
            ...section['content'].map<Widget>((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  "● $item",
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              );
            }).toList(),
          // Subsections
          if (section.containsKey('subsections'))
            ...section['subsections'].map<Widget>((subsection) {
              return Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subsection['title'],
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.0),
                    ...subsection['content'].map<Widget>((subItem) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          "○ $subItem",
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              );
            }).toList(),
        ],
      ),
    );
  }
}

class TermsContent extends StatefulWidget {
  bool isAccepted;
  String pdfLink;
  final ValueChanged<bool> onAcceptedChanged;
  final VoidCallback onSubmit;

  TermsContent(
      {super.key,
      required this.isAccepted,
      required this.pdfLink,
      required this.onAcceptedChanged,
      required this.onSubmit});

  @override
  State<TermsContent> createState() => _TermsContentState();
}

class _TermsContentState extends State<TermsContent> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.74,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.52,
                  child: SfPdfViewer.network(
                    widget.pdfLink,
                    key: _pdfViewerKey,
                  ),
                ),
                // Accept Checkbox
                SizedBox(height: 20),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.isAccepted =
                              !widget.isAccepted; // Toggle the state
                          widget.onAcceptedChanged(widget.isAccepted);
                        });
                      },
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: widget.isAccepted
                              ? CustomColor.primaryColor
                              : Colors.transparent,
                          border: Border.all(
                            color: CustomColor.primaryColor,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: widget.isAccepted
                            ? Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 18,
                              )
                            : null, // Show checkmark only if accepted
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "I accept the Terms and Conditions",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Submit Button
                PrimaryButtonWidget(
                  onPressed: widget.isAccepted ? widget.onSubmit : null,
                  buttonText: 'Submit',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
