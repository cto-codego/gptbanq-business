import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:gptbanqbusiness/Screens/Pos_Screen/bloc/pos_bloc.dart';
import 'package:gptbanqbusiness/Screens/Pos_Screen/crypto_gateway/paymet_confirmation_screen.dart';
import 'package:gptbanqbusiness/utils/input_fields/custom_color.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gptbanqbusiness/constant_string/User.dart';
import 'package:gptbanqbusiness/cutom_weidget/custom_navigationBar.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:page_transition/page_transition.dart';

class RemoteMakePaymentScreen extends StatefulWidget {
  RemoteMakePaymentScreen({super.key, required this.uniqueId});

  String uniqueId;

  @override
  State<RemoteMakePaymentScreen> createState() =>
      _RemoteMakePaymentScreenState();
}

class _RemoteMakePaymentScreenState extends State<RemoteMakePaymentScreen> {
  bool active = false;

  bool shownotification = true;
  final PosBloc _posBloc = PosBloc();
  int selectedIndex = -1; // -1 means no container is selected initially
  StreamController<Object> streamController =
      StreamController<Object>.broadcast();

  Future<void> _onRefresh() async {
    debugPrint('_onRefresh');

    _posBloc.add(GetCryptoTransactionInfoEvent(uniqueId: widget.uniqueId));
  }

  @override
  void initState() {
    super.initState();
    User.Screen = 'person make payment screen';

    _posBloc.add(GetCryptoTransactionInfoEvent(uniqueId: widget.uniqueId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.scaffoldBg,
      body: BlocListener(
          bloc: _posBloc,
          listener: (context, PosState state) {
            if (state.statusModel?.status == 0) {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.error,
                animType: AnimType.rightSlide,
                desc: state.statusModel?.message,
                btnCancelText: 'OK',
                buttonsTextStyle: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'pop',
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
                btnCancelOnPress: () {},
              ).show();
            }

            if (state.getCryptoTransactionInfoModel?.status == 3) {
              Navigator.pushNamedAndRemoveUntil(
                  context, 'merchantStoreScreen', (route) => false);
            }

            if (state.getCryptoTransactionInfoModel?.status == 2) {
              Navigator.pushReplacement(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  alignment: Alignment.center,
                  isIos: true,
                  duration: const Duration(milliseconds: 200),
                  child: PaymentConfirmationScreen(
                    message:
                        "Thank you! Your Payment has been Successfully Received.",
                    trxId: state.getCryptoTransactionInfoModel!.order!
                        .transactionId!,
                  ),
                ),
              );
            }

            if (state.cryptoOrderCancelModel?.status == 1) {
              Navigator.pushNamedAndRemoveUntil(
                  context, 'merchantStoreScreen', (route) => false);
            }
          },
          child: BlocBuilder(
              bloc: _posBloc,
              builder: (context, PosState state) {
                return SafeArea(
                  child: ProgressHUD(
                    inAsyncCall: state.isloading,
                    child: RefreshIndicator(
                      onRefresh: _onRefresh,
                      child: StreamBuilder<Object>(
                          stream: streamController.stream.asBroadcastStream(
                        onListen: (subscription) async {
                          await Future.delayed(const Duration(seconds: 5),
                              () {
                            if (state.getCryptoTransactionInfoModel
                                    ?.status ==
                                1) {
                              _posBloc.add(GetCryptoTransactionInfoEvent(
                                  uniqueId: widget.uniqueId));
                            }
                          });
                        },
                      ), builder: (context, snapshot) {
                        return ListView(
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            appBarSection(context, state),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(
                                state.getCryptoTransactionInfoModel!.order!
                                    .image!,
                                height: 50,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child; // The image has finished loading, show the image.
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                (loadingProgress
                                                        .expectedTotalBytes ??
                                                    1)
                                            : null, // Show indeterminate progress if expectedTotalBytes is null.
                                      ),
                                    );
                                  }
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return const Text(
                                      'Failed to load image'); // Optional: Handle image loading error.
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              child: Image.network(
                                state.getCryptoTransactionInfoModel!.order!
                                    .qrcode!,
                                height: 180,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child; // The image has finished loading, show the image.
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                (loadingProgress
                                                        .expectedTotalBytes ??
                                                    1)
                                            : null, // If expectedTotalBytes is null, show indeterminate progress.
                                      ),
                                    );
                                  }
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return const Text(
                                      'Failed to load image'); // Optional: Handle image loading error.
                                },
                              ),
                            ),
                            Text(
                              "Payment accept only in ${state.getCryptoTransactionInfoModel!.order!.currencyName!}  ${state.getCryptoTransactionInfoModel!.order!.network!}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black.withOpacity(0.7),
                                  fontWeight: FontWeight.w900),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Scan the QR code or copy the ${state.getCryptoTransactionInfoModel!.order!.symbol!.toUpperCase()} address to make payment",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black.withOpacity(0.7),
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "payment address: ",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color:
                                            Colors.black.withOpacity(0.7),
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 270,
                                      height: 25,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 7),
                                      child: DottedBorder(
                                        color: Colors.grey,
                                        strokeWidth: 1,
                                        child: Text(
                                          state
                                              .getCryptoTransactionInfoModel!
                                              .order!
                                              .address!,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black
                                                  .withOpacity(0.7),
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                        onTap: () {
                                          String textToCopy = state
                                              .getCryptoTransactionInfoModel!
                                              .order!
                                              .address!;
                                          copyToClipboard(
                                              textToCopy, context);
                                        },
                                        child: const Icon(Icons.copy))
                                  ],
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 30),
                              child: Text(
                                "send ${state.getCryptoTransactionInfoModel!.order!.cryptoAmount} (In ONE payment) don't include transaction fee in this amount",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black.withOpacity(0.7),
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Text(
                              "1 ${state.getCryptoTransactionInfoModel!.order!.symbol!.toUpperCase()} = ${state.getCryptoTransactionInfoModel!.order!.price}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black.withOpacity(0.7),
                                  fontWeight: FontWeight.w500),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Expire in: ${state.getCryptoTransactionInfoModel!.order!.time!}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black.withOpacity(0.7),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "if you send any other ${state.getCryptoTransactionInfoModel!.order!.currencyName!} amount, payment system will not accept",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Container(
                              height: 60,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 30),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: const Color(0xff10245C),
                                  borderRadius: BorderRadius.circular(11)),
                              child: ElevatedButton(
                                  onPressed: () {
                                    _posBloc.add(CryptoOrderCancelEvent(
                                        uniqueId: widget.uniqueId));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                      shadowColor: Colors.transparent,
                                      minimumSize:
                                          const Size.fromHeight(40),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(11))),
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontFamily: 'pop',
                                        fontWeight: FontWeight.w500),
                                  )),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                );
              })),
      bottomNavigationBar: CustomBottomBar(index: 1),
    );
  }

  appBarSection(BuildContext context, state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Make Payment',
            style: TextStyle(
                color: Color(0xff000000),
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.w500,
                height: 1),
          ),
          // const SizedBox(
          //   width: 20,
          // ),
        ],
      ),
    );
  }

  void copyToClipboard(String text, BuildContext context) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
