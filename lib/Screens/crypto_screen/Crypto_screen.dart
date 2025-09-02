import 'dart:async';
import 'dart:io';

import 'package:gptbanqbusiness/Models/Crypto_coins_model.dart';
import 'package:gptbanqbusiness/Screens/crypto_screen/Euro_screen.dart';
import 'package:gptbanqbusiness/Screens/crypto_screen/bloc/crypto_bloc.dart';
import 'package:gptbanqbusiness/Screens/crypto_screen/coin_details.dart';
import 'package:gptbanqbusiness/constant_string/User.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:gptbanqbusiness/utils/custom_scroll_behavior.dart';
import 'package:gptbanqbusiness/utils/input_fields/custom_color.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:developer' as log;

import '../../utils/assets.dart';
import '../../widgets/buttons/custom_floating_action_button.dart';
import '../../widgets/buttons/primary_button_widget.dart';
import '../../widgets/buttons/secondary_button_widget.dart';
import '../../widgets/custom_image_widget.dart';
import '../../widgets/input_fields/crypto_search_input_field.dart';
import '../../widgets/toast/toast_util.dart';
import '../Dashboard_screen/bloc/dashboard_bloc.dart' as dashboard_bloc;

class CryptoScreen extends StatefulWidget {
  CryptoScreen({super.key, required this.isCryptoCall});

  bool? isCryptoCall;

  @override
  State<CryptoScreen> createState() => _CryptoScreenState();
}

class _CryptoScreenState extends State<CryptoScreen> {
  final CryptoBloc _cryptoBloc = CryptoBloc();
  final TextEditingController _search = TextEditingController();
  bool cashPortfolio = true;

  List<Coin>? Eurocoin = [
    Coin(image: '', currencyName: '', currencySymbol: '', fiatBalance: '')
  ];

  Future<void> _onRefresh() async {
    debugPrint('_onRefresh');

    _cryptoBloc.add(GetcoinsEvent());
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;


  @override
  void initState() {
    super.initState();

    User.Screen = 'Crypto';

    if (widget.isCryptoCall == true) {
      _cryptoBloc.add(SwiftTermsEvent(
          type: "crypto", deviceType: Platform.isAndroid ? "android" : "ios"));
    }

    firebaseCloudMessaging_Listeners(context);
    _cryptoBloc.add(GetcoinsEvent());
  }

  @override
  void dispose() {
    _cryptoBloc.close(); // Close the bloc
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
        backgroundColor: CustomColor.notificationBgColor,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: BlocListener(
            bloc: _cryptoBloc,
            listener: (context, CryptoState state) async {
              if (state.coins!.status == 1) {
                Eurocoin = state.coins!.curruncylist!.where((element) {
                  final title = element.currencyName!.toLowerCase();

                  const searc = 'euro';

                  return title.contains(searc);
                }).toList();
              }

              if (state.statusModel?.status == 0) {
                CustomToast.showError(
                    context, "Sorry!", state.statusModel!.message!);
              }
            },
            child: BlocBuilder(
                bloc: _cryptoBloc,
                builder: (context, CryptoState state) {
                  return SafeArea(
                      child: ProgressHUD(
                        inAsyncCall: state.isloading,
                        child: RefreshIndicator(
                          onRefresh: _onRefresh,
                          child: Container(
                            margin: EdgeInsets.only(top: 30, left: 16, right: 16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(bottom: 10),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Currency',
                                    style: GoogleFonts.inter(
                                        color: CustomColor.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),

                                Container(
                                  margin: EdgeInsets.only(top: 10, bottom: 10),
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: CustomColor.whiteColor,
                                    borderRadius: BorderRadius.circular(
                                        16.0), // Rounded corners (16.dp)
                                    boxShadow: [
                                      BoxShadow(
                                        color: CustomColor.black.withOpacity(0.1),
                                        // var(--sds-color-black-100) equivalent
                                        offset: const Offset(0, 0.25),
                                        // var(--sds-size-depth-0) and var(--sds-size-depth-025)
                                        blurRadius: 10, // var(--sds-size-depth-100)
                                      ),
                                      // Second shadow definition
                                      BoxShadow(
                                        color: CustomColor.black.withOpacity(0.2),
                                        // var(--sds-color-black-200) equivalent
                                        offset: const Offset(0, 0.25),
                                        // var(--sds-size-depth-0) and var(--sds-size-depth-025)
                                        blurRadius: 10, // var(--sds-size-depth-100)
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                              const EdgeInsets.only(bottom: 5),
                                              child: Text(
                                                'YOUR PORTFOLIO CRYPTO',
                                                style: GoogleFonts.inter(
                                                  color: CustomColor
                                                      .inputFieldTitleTextColor,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  if (state
                                                      .coins!.portfolio!.isNotEmpty)
                                                    TextSpan(
                                                      text: state.coins!.portfolio!,
                                                      style: GoogleFonts.inter(
                                                        color: CustomColor.black,
                                                        fontSize: 36,
                                                        fontWeight: FontWeight.w500,
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
                                              cashPortfolio = true;
                                            });
                                          },
                                          child: Container(
                                            height: 41,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(24),
                                              color: cashPortfolio
                                                  ? CustomColor.whiteColor
                                                  : CustomColor
                                                  .currencyCustomSelectorColor,
                                              boxShadow: cashPortfolio
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
                                              'Cash Portfolio',
                                              style: GoogleFonts.inter(
                                                  color: cashPortfolio
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
                                              cashPortfolio = false;
                                            });
                                          },
                                          child: Container(
                                            height: 41,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(24),
                                              color: cashPortfolio
                                                  ? CustomColor
                                                  .currencyCustomSelectorColor
                                                  : CustomColor.whiteColor,
                                              boxShadow: cashPortfolio
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
                                              'Crypto Portfolio',
                                              style: GoogleFonts.inter(
                                                  color: cashPortfolio
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
                                //list section

                                //cash portfolio section
                                cashPortfolio
                                    ? _cashPortfolioWidget(context, state)
                                    :

                                //crypto section
                                Flexible(
                                  child: Container(
                                    padding: EdgeInsets.all(16), // Padding
                                    decoration: BoxDecoration(
                                      color: CustomColor.whiteColor,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        width: 1, // Border width
                                        color: CustomColor.black
                                            .withOpacity(0.1),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 5),
                                          child: CryptoSearchInputWidget(
                                            controller: _search,
                                            onChanged: (String v) {
                                              if (v.isEmpty ||
                                                  _search.text == '') {
                                                setState(() {
                                                  state.coins!.coin = state
                                                      .coins!.curruncylist;
                                                });
                                              } else {
                                                final list2 = state
                                                    .coins!.curruncylist!
                                                    .where((element) {
                                                  final title = element
                                                      .currencyName!
                                                      .toLowerCase();
                                                  final symbol = element
                                                      .currencySymbol!
                                                      .toLowerCase();

                                                  final searc =
                                                  v.toLowerCase();
                                                  return title
                                                      .contains(searc) ||
                                                      symbol.contains(searc);
                                                }).toList();

                                                setState(() {
                                                  state.coins!.coin = list2;
                                                });
                                              }
                                            },
                                          ),
                                        ),
                                        Expanded(
                                            child: CoinListView(
                                              coins: state.coins!.coin!,
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ));
                })),
        floatingActionButton:
        isKeyboardOpen ? null : CustomFloatingActionButton()

      // bottomNavigationBar: CustomBottomBar(index: 1),
    );
  }

  _cashPortfolioWidget(BuildContext context, CryptoState state) {
    return Container(
      padding: EdgeInsets.all(16), // Padding
      decoration: BoxDecoration(
        color: CustomColor.whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          width: 1, // Border width
          color: CustomColor.black.withOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: CryptoSearchInputWidget(
              controller: _search,
              onChanged: (String v) {
                if (v.isEmpty || _search.text == '') {
                  setState(() {
                    state.coins!.coin = state.coins!.curruncylist;
                  });
                } else {
                  final list2 = state.coins!.curruncylist!.where((element) {
                    final title = element.currencyName!.toLowerCase();
                    final symbol = element.currencySymbol!.toLowerCase();

                    final searc = v.toLowerCase();
                    return title.contains(searc) || symbol.contains(searc);
                  }).toList();

                  setState(() {
                    state.coins!.coin = list2;
                  });
                }
              },
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.scale,
                  alignment: Alignment.center,
                  isIos: true,
                  duration: const Duration(microseconds: 500),
                  child: EuroScreen(symbol: Eurocoin![0].currencySymbol!),
                ),
              ).then((value) {
                _cryptoBloc.add(GetcoinsEvent());
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              margin: EdgeInsets.only(top: 10), // Optional margin
              decoration: BoxDecoration(
                color: CustomColor.whiteColor,
                borderRadius: BorderRadius.circular(10), // Border radius
                border: Border.all(
                  color: CustomColor.black.withOpacity(0.1),
                  width: 1, // Border width
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Eurocoin![0].image!.isEmpty
                          ? Container()
                          : Container(
                        width: 48,
                        height: 48,
                        margin: const EdgeInsets.only(right: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(Eurocoin![0].image!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Eurocoin![0].currencyName!,
                            style: GoogleFonts.inter(
                              color: CustomColor.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            Eurocoin![0].currencySymbol!.toUpperCase(),
                            style: GoogleFonts.inter(
                              color: CustomColor.black.withOpacity(0.8),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  Text(
                    Eurocoin![0].fiatBalance!,
                    style: GoogleFonts.inter(
                      color: CustomColor.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void iOS_Permission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true, badge: true, sound: true);

    print("123Settings registered: ${settings.authorizationStatus}");
  }

  void firebaseCloudMessaging_Listeners(BuildContext context) {
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        debugPrint(' dashboard terminated');
        try {
          if (message.notification != null) {
            if (message.data['category'] == 'iban_confirm_transaction') {
              approveMovefromwallets(message);
            } else if (message.data['category'] == 'confirm_transaction') {
              Approvecoinconvert(message);
            }
            // else if (message.data['category'] == 'move_cryptoeur_to_iban') {
            //   ApprovetransferEurotoiban(message);
            // }
            // else if (message.data['category'] ==
            //     'iban_confirm_transaction_crypto') {
            //   ApproveEurotocrypto(message);
            // }
          }
        } catch (e) {
          debugPrint(e.toString());
        }
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('A new onmessage event was published!');

      debugPrint('message *** ${message.data}');

      try {
        if (message.notification != null) {
          debugPrint(message.data['category']);

          if (message.data['category'] == 'iban_confirm_transaction') {
            approveMovefromwallets(message);
          } else if (message.data['category'] == 'confirm_transaction') {
            log.log(' Message data: ${message.toMap()}', name: "onMessage");

            Approvecoinconvert(message);
          }
          // else if (message.data['category'] == 'move_cryptoeur_to_iban') {
          //   ApprovetransferEurotoiban(message);
          // }
          // else if (message.data['category'] ==
          //     'iban_confirm_transaction_crypto') {
          //   ApproveEurotocrypto(message);
          // }
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    });

    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('A new onMessageOpenedApp event was published!');

      try {
        if (message.notification != null) {
          if (message.data['category'] == 'iban_confirm_transaction') {
            approveMovefromwallets(message);
          } else if (message.data['category'] == 'confirm_transaction') {
            Approvecoinconvert(message);
          }
          // else if (message.data['category'] == 'move_cryptoeur_to_iban') {
          //   ApprovetransferEurotoiban(message);
          // }
          // else if (message.data['category'] ==
          //     'iban_confirm_transaction_crypto') {
          //   ApproveEurotocrypto(message);
          // }
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    });
  }

  // ApprovetransferEurotoiban(RemoteMessage message) {
  //   try {
  //     showGeneralDialog(
  //       context: context,
  //       pageBuilder: (BuildContext buildContext, Animation<double> animation,
  //           Animation<double> secondaryAnimation) {
  //         return Container(
  //           color: Colors.white,
  //           height: MediaQuery.of(context).size.height,
  //           width: MediaQuery.of(context).size.width,
  //           child: Center(
  //             child: SizedBox(
  //               width: MediaQuery.of(context).size.width,
  //               child: Material(
  //                 color: Colors.transparent,
  //                 child: Column(
  //                   children: [
  //                     Expanded(
  //                       child: ScrollConfiguration(
  //                         behavior: CustomScrollBehavior(),
  //                         child: Padding(
  //                           padding: const EdgeInsets.only(left: 18, right: 18),
  //                           child: ListView(
  //                             // crossAxisAlignment: CrossAxisAlignment.center,
  //                             children: [
  //                               const SizedBox(height: 20),
  //                               Text(
  //                                 message.notification!.title!,
  //                                 style: const TextStyle(
  //                                   fontSize: 18,
  //                                   color: Colors.black,
  //                                   fontWeight: FontWeight.w600,
  //                                   fontFamily: 'pop',
  //                                 ),
  //                                 textAlign: TextAlign.center,
  //                               ),
  //                               const SizedBox(height: 40),
  //                               Image.asset(
  //                                 'images/bell.png',
  //                                 color: const Color(0xff090B78),
  //                                 width: 100,
  //                                 height: 100,
  //                               ),
  //                               const SizedBox(height: 40),
  //                               Container(
  //                                 padding: const EdgeInsets.all(10),
  //                                 decoration: BoxDecoration(
  //                                     color: Colors.white,
  //                                     borderRadius: BorderRadius.circular(10)),
  //                                 child: Column(
  //                                   crossAxisAlignment:
  //                                       CrossAxisAlignment.center,
  //                                   mainAxisAlignment: MainAxisAlignment.center,
  //                                   children: [
  //                                     const SizedBox(height: 20),
  //                                     Text(
  //                                       message.notification!.body!,
  //                                       textAlign: TextAlign.center,
  //                                       style: const TextStyle(
  //                                         fontSize: 14,
  //                                         color: Colors.black,
  //                                         fontWeight: FontWeight.w500,
  //                                         fontFamily: 'pop',
  //                                       ),
  //                                     ),
  //                                     const SizedBox(
  //                                       height: 20,
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                               const SizedBox(height: 100),
  //                               Container(
  //                                 margin: const EdgeInsets.symmetric(
  //                                     horizontal: 10),
  //                                 alignment: Alignment.center,
  //                                 decoration: BoxDecoration(
  //                                     borderRadius: BorderRadius.circular(100),
  //                                     gradient: const LinearGradient(colors: [
  //                                       Color(0xff090B78),
  //                                       Color(0xff090B78)
  //                                     ])),
  //                                 child: ElevatedButton(
  //                                   onPressed: () {
  //                                     _cryptoBloc.add(ApproveEurotoIbanEvent(
  //                                       uniqueId: message.data['unique_id'],
  //                                       completed: 'Completed',
  //                                     ));
  //                                     Navigator.popUntil(
  //                                         context, (route) => route.isFirst);
  //                                   },
  //                                   style: ElevatedButton.styleFrom(
  //                                       shape: RoundedRectangleBorder(
  //                                           borderRadius:
  //                                               BorderRadius.circular(15.0)),
  //                                       elevation: 0,
  //                                       shadowColor: Colors.transparent,
  //                                       // : Colorprimarys.transparent,
  //                                       backgroundColor:
  //                                           const Color(0xff191C32),
  //                                       minimumSize: const Size.fromHeight(50)),
  //                                   child: const Text(
  //                                     "Confirm",
  //                                     style: TextStyle(
  //                                         color: Colors.white,
  //                                         fontSize: 16,
  //                                         fontFamily: 'pop',
  //                                         fontWeight: FontWeight.w600),
  //                                   ),
  //                                 ),
  //                               ),
  //                               const SizedBox(height: 50),
  //                               InkWell(
  //                                 onTap: () {
  //                                   Navigator.popUntil(
  //                                       context, (route) => route.isFirst);
  //                                   _cryptoBloc.add(ApproveEurotoIbanEvent(
  //                                     uniqueId: message.data['unique_id'],
  //                                     completed: 'Canceled',
  //                                   ));
  //                                 },
  //                                 child: Container(
  //                                   alignment: Alignment.center,
  //                                   width: double.infinity,
  //                                   height: 40,
  //                                   child: Text(
  //                                     'Cancel',
  //                                     style: TextStyle(
  //                                       color: Colors.black.withOpacity(0.7),
  //                                       fontSize: 16,
  //                                       decoration: TextDecoration.underline,
  //                                       fontFamily: 'pop',
  //                                     ),
  //                                   ),
  //                                 ),
  //                               )
  //                             ],
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //         );
  //       },
  //       barrierDismissible: true,
  //       barrierLabel:
  //           MaterialLocalizations.of(context).modalBarrierDismissLabel,
  //       barrierColor: Colors.black.withOpacity(0.1),
  //       transitionDuration: const Duration(milliseconds: 0),
  //     );
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   }
  //   ;
  // }

  // ApproveEurotocrypto(
  //     {required String title, required String body, required String uniqueId}) {
  //   try {
  //     showGeneralDialog(
  //       context: context,
  //       pageBuilder: (BuildContext buildContext, Animation<double> animation,
  //           Animation<double> secondaryAnimation) {
  //         return Container(
  //           color: Colors.white,
  //           height: MediaQuery.of(context).size.height,
  //           width: MediaQuery.of(context).size.width,
  //           child: Center(
  //             child: SizedBox(
  //               width: MediaQuery.of(context).size.width,
  //               child: Material(
  //                 color: Colors.transparent,
  //                 child: Column(
  //                   children: [
  //                     Expanded(
  //                       child: ScrollConfiguration(
  //                         behavior: CustomScrollBehavior(),
  //                         child: Padding(
  //                           padding: const EdgeInsets.only(left: 18, right: 18),
  //                           child: ListView(
  //                             // crossAxisAlignment: CrossAxisAlignment.center,
  //                             children: [
  //                               const SizedBox(height: 20),
  //                               Text(
  //                                 title,
  //                                 style: const TextStyle(
  //                                   fontSize: 18,
  //                                   color: Colors.black,
  //                                   fontWeight: FontWeight.w600,
  //                                   fontFamily: 'pop',
  //                                 ),
  //                                 textAlign: TextAlign.center,
  //                               ),
  //                               const SizedBox(height: 40),
  //                               Image.asset(
  //                                 'images/bell.png',
  //                                 color: const Color(0xff090B78),
  //                                 width: 100,
  //                                 height: 100,
  //                               ),
  //                               const SizedBox(height: 40),
  //                               Container(
  //                                 padding: const EdgeInsets.all(10),
  //                                 decoration: BoxDecoration(
  //                                     color: Colors.white,
  //                                     borderRadius: BorderRadius.circular(10)),
  //                                 child: Column(
  //                                   crossAxisAlignment:
  //                                       CrossAxisAlignment.center,
  //                                   mainAxisAlignment: MainAxisAlignment.center,
  //                                   children: [
  //                                     const SizedBox(height: 20),
  //                                     Text(
  //                                       body,
  //                                       textAlign: TextAlign.center,
  //                                       style: const TextStyle(
  //                                         fontSize: 14,
  //                                         color: Colors.black,
  //                                         fontWeight: FontWeight.w500,
  //                                         fontFamily: 'pop',
  //                                       ),
  //                                     ),
  //                                     const SizedBox(
  //                                       height: 20,
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                               const SizedBox(height: 100),
  //                               Container(
  //                                 margin: const EdgeInsets.symmetric(
  //                                     horizontal: 10),
  //                                 alignment: Alignment.center,
  //                                 decoration: BoxDecoration(
  //                                     borderRadius: BorderRadius.circular(100),
  //                                     gradient: const LinearGradient(colors: [
  //                                       Color(0xff090B78),
  //                                       Color(0xff090B78)
  //                                     ])),
  //                                 child: ElevatedButton(
  //                                   onPressed: () {
  //                                     _cryptoBloc.add(ApproveEurotoCryptoEvent(
  //                                       uniqueId: uniqueId,
  //                                       completed: 'Completed',
  //                                     ));
  //                                     Navigator.popUntil(
  //                                         context, (route) => route.isFirst);
  //                                   },
  //                                   style: ElevatedButton.styleFrom(
  //                                       shape: RoundedRectangleBorder(
  //                                           borderRadius:
  //                                               BorderRadius.circular(15.0)),
  //                                       backgroundColor: Colors.transparent,
  //                                       elevation: 0,
  //                                       shadowColor: Colors.transparent,
  //                                       minimumSize: const Size.fromHeight(50)),
  //                                   child: const Text(
  //                                     "Confirm",
  //                                     style: TextStyle(
  //                                         color: Colors.white,
  //                                         fontSize: 16,
  //                                         fontFamily: 'pop',
  //                                         fontWeight: FontWeight.w600),
  //                                   ),
  //                                 ),
  //                               ),
  //                               const SizedBox(height: 50),
  //                               InkWell(
  //                                 onTap: () {
  //                                   // Navigator.pop(context);
  //                                   _cryptoBloc.add(ApproveEurotoCryptoEvent(
  //                                     uniqueId: uniqueId,
  //                                     completed: 'Canceled',
  //                                   ));
  //
  //                                   Navigator.popUntil(
  //                                       context, (route) => route.isFirst);
  //                                 },
  //                                 child: Container(
  //                                   alignment: Alignment.center,
  //                                   width: double.infinity,
  //                                   height: 40,
  //                                   child: Text(
  //                                     'Cancel',
  //                                     style: TextStyle(
  //                                       color: Colors.black.withOpacity(0.7),
  //                                       fontSize: 16,
  //                                       decoration: TextDecoration.underline,
  //                                       fontFamily: 'pop',
  //                                     ),
  //                                   ),
  //                                 ),
  //                               )
  //                             ],
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //         );
  //       },
  //       barrierDismissible: true,
  //       barrierLabel:
  //           MaterialLocalizations.of(context).modalBarrierDismissLabel,
  //       barrierColor: Colors.black.withOpacity(0.1),
  //       transitionDuration: const Duration(milliseconds: 0),
  //     );
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   }
  // }

  approveMovefromwallets(RemoteMessage message) {
    try {
      showGeneralDialog(
        context: context,
        pageBuilder: (BuildContext buildContext, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return Container(
            color: CustomColor.scaffoldBg,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      Expanded(
                        child: ScrollConfiguration(
                          behavior: CustomScrollBehavior(),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: ListView(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 20),
                                Text(
                                  message.notification!.title!,
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 40),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: CustomColor.notificationBellBgColor,
                                  ),
                                  child: CustomImageWidget(
                                    imagePath: StaticAssets.notificationBell,
                                    imageType: 'svg',
                                    height: 100,
                                  ),
                                ),
                                const SizedBox(height: 40),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 20),
                                      Text(
                                        message.notification!.body!,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 100),
                                PrimaryButtonWidget(
                                  onPressed: () {
                                    _cryptoBloc.add(ApproveMoveWalletsEvent(
                                      uniqueId: message.data['unique_id'],
                                      completed: 'Completed',
                                    ));
                                    CustomToast.showSuccess(
                                        context,
                                        "Thank You!",
                                        "Transaction has been confirmed");
                                    Navigator.popUntil(
                                        context, (route) => route.isFirst);
                                  },
                                  buttonText: 'Confirm',
                                ),
                                SecondaryButtonWidget(
                                  onPressed: () {
                                    CustomToast.showError(context, "Sorry!!",
                                        "Transaction has been cancelled");
                                    Navigator.popUntil(
                                        context, (route) => route.isFirst);
                                    _cryptoBloc.add(ApproveMoveWalletsEvent(
                                      uniqueId: message.data['unique_id'],
                                      completed: 'Canceled',
                                    ));
                                  },
                                  buttonText: "Cancel",
                                  apiBackgroundColor: CustomColor.whiteColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        barrierDismissible: true,
        barrierLabel:
        MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black.withOpacity(0.1),
        transitionDuration: const Duration(milliseconds: 0),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
    ;
  }

  Approvecoinconvert(RemoteMessage message) {
    try {
      showGeneralDialog(
        context: context,
        pageBuilder: (BuildContext buildContext, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return Container(
            color: CustomColor.scaffoldBg,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      Expanded(
                        child: ScrollConfiguration(
                          behavior: CustomScrollBehavior(),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: ListView(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 20),
                                Text(
                                  message.notification!.title!,
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 40),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: CustomColor.notificationBellBgColor,
                                  ),
                                  child: CustomImageWidget(
                                    imagePath: StaticAssets.notificationBell,
                                    imageType: 'svg',
                                    height: 100,
                                  ),
                                ),
                                const SizedBox(height: 40),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 20),
                                      Text(
                                        message.notification!.body!,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 100),
                                PrimaryButtonWidget(
                                  onPressed: () {
                                    _cryptoBloc.add(ApproveTransactionEvent(
                                      uniqueId: message.data['unique_id'],
                                      completed: 'Completed',
                                    ));
                                    CustomToast.showSuccess(
                                        context,
                                        "Thank You!",
                                        "Transaction has been confirmed");
                                    Navigator.popUntil(
                                        context, (route) => route.isFirst);
                                  },
                                  buttonText: 'Confirm',
                                ),
                                SecondaryButtonWidget(
                                  onPressed: () {
                                    CustomToast.showError(context, "Sorry!!",
                                        "Transaction has been cancelled");
                                    Navigator.popUntil(
                                        context, (route) => route.isFirst);
                                    _cryptoBloc.add(ApproveTransactionEvent(
                                      uniqueId: message.data['unique_id'],
                                      completed: 'Canceled',
                                    ));
                                  },
                                  buttonText: "Cancel",
                                  apiBackgroundColor: CustomColor.whiteColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        barrierDismissible: true,
        barrierLabel:
        MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black.withOpacity(0.1),
        transitionDuration: const Duration(milliseconds: 0),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
    ;
  }
}

class CoinListView extends StatelessWidget {
  final List<Coin> coins; // Replace 'Coin' with your actual model class

  const CoinListView({Key? key, required this.coins}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: coins.length,
      itemBuilder: (BuildContext context, int index) {
        if (coins[index].currencyName == 'EURO') {
          return Container(); // Skip EURO coins
        } else {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.scale,
                  alignment: Alignment.center,
                  isIos: true,
                  duration: const Duration(milliseconds: 500),
                  child: CoinDetails(
                    symbol: coins[index].currencySymbol!,
                  ),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              margin: EdgeInsets.only(top: 10), // Optional margin
              decoration: BoxDecoration(
                color: CustomColor.whiteColor,
                borderRadius: BorderRadius.circular(10), // Border radius
                border: Border.all(
                  color: CustomColor.black.withOpacity(0.1),
                  width: 1, // Border width
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        coins[index].image!.isEmpty
                            ? Container()
                            : Container(
                          width: 48,
                          height: 48,
                          margin: const EdgeInsets.only(right: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(coins[index].image!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                coins[index].currencyName!,
                                style: GoogleFonts.inter(
                                  color: CustomColor.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                coins[index].currencySymbol!.toUpperCase(),
                                style: GoogleFonts.inter(
                                  color: CustomColor.black.withOpacity(0.8),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        coins[index].cryptoBalance!,
                        style: GoogleFonts.inter(
                          color: CustomColor.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        coins[index].fiatBalance!,
                        style: GoogleFonts.inter(
                          color: CustomColor.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

Future myBackgroundMessageHandler(RemoteMessage message) async {
  if (message.data.isNotEmpty) {
    // Handle data message
    debugPrint(
        'dashboard screen on myBackgroundMessageHandler dashboed $message');
    // final dynamic data = message.data;
  }

  if (message.notification != null) {
    // Handle notification message
    debugPrint(
        'dashboard screen on myBackgroundMessageHandler dashbord $message');
    // final dynamic notification = message.notification;
  }

  // Or do other work.
}
