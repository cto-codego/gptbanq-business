import 'dart:async';

import 'package:gptbanqbusiness/Screens/Pos_Screen/bloc/pos_bloc.dart';
import 'package:gptbanqbusiness/Screens/Pos_Screen/crypto_gateway/paymet_confirmation_screen.dart';
import 'package:gptbanqbusiness/utils/assets.dart';
import 'package:gptbanqbusiness/widgets/custom_image_widget.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gptbanqbusiness/constant_string/User.dart';
import 'package:gptbanqbusiness/cutom_weidget/custom_navigationBar.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import '../../../utils/input_fields/custom_color.dart';
import '../../../widgets/buttons/primary_button_widget.dart';
import '../../../widgets/toast/toast_util.dart';

class PersonMakePaymentScreen extends StatefulWidget {
  PersonMakePaymentScreen({super.key, required this.uniqueId});

  String uniqueId;

  @override
  State<PersonMakePaymentScreen> createState() =>
      _PersonMakePaymentScreenState();
}

class _PersonMakePaymentScreenState extends State<PersonMakePaymentScreen> {
  bool active = false;

  bool shownotification = true;
  final PosBloc _posBloc = PosBloc();
  int selectedIndex = -1; // -1 means no container is selected initially
  StreamController<Object> streamController =
      StreamController<Object>.broadcast();

  Timer? _timer; // Declare the Timer

  Future<void> _onRefresh() async {
    debugPrint('_onRefresh');

    _fetchCryptoTransactionInfo();
  }

  @override
  void initState() {
    super.initState();
    User.Screen = 'person make payment screen';

    // Call the method immediately
    _fetchCryptoTransactionInfo();

    // Set up a timer to call the method every 5 seconds
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _fetchCryptoTransactionInfo();
    });
  }

  Future<void> _fetchCryptoTransactionInfo() async {
    debugPrint('_fetchCryptoTransactionInfo called');
    _posBloc.add(GetCryptoTransactionInfoEvent(uniqueId: widget.uniqueId));
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the Timer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.scaffoldBg,
      body: BlocListener(
          bloc: _posBloc,
          listener: (context, PosState state) {
            if (state.statusModel?.status == 0) {
              CustomToast.showError(
                  context, "Sorry!", state.statusModel!.message!);
            }

            if (state.getCryptoTransactionInfoModel?.status == 3) {
              _timer?.cancel(); // Cancel the Timer

              Navigator.pushNamedAndRemoveUntil(
                  context, 'merchantStoreScreen', (route) => false);
            }

            if (state.getCryptoTransactionInfoModel?.status == 2) {
              _timer?.cancel(); // Cancel the Timer

              Navigator.pushAndRemoveUntil(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    alignment: Alignment.center,
                    isIos: true,
                    duration: const Duration(milliseconds: 200),
                    child: PaymentConfirmationScreen(
                      message:
                          "Thank you! Your Payment has been Successfully Received.",
                      trxId: state
                          .getCryptoTransactionInfoModel!.order!.transactionId!,
                    ),
                  ),
                  (route) => false);
            }

            if (state.cryptoOrderCancelModel?.status == 1) {
              Navigator.pushNamedAndRemoveUntil(
                  context, 'merchantStoreScreen', (route) => false);
            }
          },
          child: BlocBuilder(
              bloc: _posBloc,
              builder: (context, PosState state) {
                if (state == null) {
                  return const CircularProgressIndicator(); // or some other loading state
                }

                return state.cryptoOrderCancelModel?.status == 2
                    ? const Center(child: CircularProgressIndicator())
                    : state.cryptoOrderCancelModel?.status == 3
                        ? const Center(child: CircularProgressIndicator())
                        : SafeArea(
                            child: ProgressHUD(
                              inAsyncCall: state.isloading,
                              child: RefreshIndicator(
                                onRefresh: _onRefresh,
                                child: ListView(
                                  children: [
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    appBarSection(context, state),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    // Padding(
                                    //   padding: const EdgeInsets.all(8.0),
                                    //   child: Image.network(
                                    //     state.getCryptoTransactionInfoModel!
                                    //             .order!.image! ??
                                    //         "",
                                    //     height: 50,
                                    //     loadingBuilder: (BuildContext context,
                                    //         Widget child,
                                    //         ImageChunkEvent? loadingProgress) {
                                    //       if (loadingProgress == null) {
                                    //         return child; // The image has finished loading, show the image.
                                    //       } else {
                                    //         return Center(
                                    //           child: CircularProgressIndicator(
                                    //             value: loadingProgress
                                    //                         .expectedTotalBytes !=
                                    //                     null
                                    //                 ? loadingProgress
                                    //                         .cumulativeBytesLoaded /
                                    //                     (loadingProgress
                                    //                             .expectedTotalBytes ??
                                    //                         1)
                                    //                 : null, // Show indeterminate progress if expectedTotalBytes is null.
                                    //           ),
                                    //         );
                                    //       }
                                    //     },
                                    //     errorBuilder:
                                    //         (context, error, stackTrace) {
                                    //       return const Text(
                                    //           'Failed to load image'); // Optional: Handle image loading error.
                                    //     },
                                    //   ),
                                    // ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 10),
                                      child: Image.network(
                                        state.getCryptoTransactionInfoModel!
                                            .order!.qrcode!,
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
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Text(
                                              'Failed to load image'); // Optional: Handle image loading error.
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Payment accept only in ${state.getCryptoTransactionInfoModel!.order!.currencyName!}  ${state.getCryptoTransactionInfoModel!.order!.network!}",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.inter(
                                            fontSize: 16,
                                            color: CustomColor.black
                                                .withOpacity(0.7),
                                            fontWeight: FontWeight.w900),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Scan the QR code or copy the ${state.getCryptoTransactionInfoModel!.order!.symbol!.toUpperCase()} address to make payment",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.inter(
                                            fontSize: 14,
                                            color: CustomColor.black
                                                .withOpacity(0.7),
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
                                            style: GoogleFonts.inter(
                                                fontSize: 14,
                                                color: CustomColor.black
                                                    .withOpacity(0.7),
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        Container(
                                          width: 270,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 7),
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                  color: CustomColor
                                                      .primaryColor
                                                      .withOpacity(0.3))),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  state
                                                      .getCryptoTransactionInfoModel!
                                                      .order!
                                                      .address!,
                                                  textAlign: TextAlign.center,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black
                                                          .withOpacity(0.7),
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
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
                                                  child: CustomImageWidget(
                                                    imagePath:
                                                        StaticAssets.copy,
                                                    imageType: "svg",
                                                    height: 24,
                                                  ))
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 30),
                                      child: RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            color: CustomColor.black.withOpacity(0.7),
                                            fontWeight: FontWeight.w500,
                                          ),
                                          children: [
                                            TextSpan(text: "send "),
                                            TextSpan(
                                              text: "${state.getCryptoTransactionInfoModel!.order!.cryptoAmount}",
                                              style: GoogleFonts.inter(
                                                fontWeight: FontWeight.bold, // Bold the amount
                                              ),
                                            ),
                                            WidgetSpan(
                                              alignment: PlaceholderAlignment.middle,
                                              child: GestureDetector(
                                                onTap: () {
                                                  Clipboard.setData(ClipboardData(
                                                    text: "${state.getCryptoTransactionInfoModel!.order!.copyCryptoAmount}",
                                                  ));
                                                  // Optional: Show a snackbar message
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text('Copied to clipboard')),
                                                  );
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                                  child: CustomImageWidget(
                                                    imagePath:
                                                    StaticAssets.copy,
                                                    imageType: "svg",
                                                    height: 16,
                                                  )
                                                ),
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                              " (In ONE payment) don't include transaction fee in this amount",
                                            ),
                                          ],
                                        ),
                                      ),

                                    ),
                                    Text(
                                      "1 ${state.getCryptoTransactionInfoModel!.order!.symbol!.toUpperCase()} = ${state.getCryptoTransactionInfoModel!.order!.price}",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.inter(
                                          fontSize: 16,
                                          color: CustomColor.black
                                              .withOpacity(0.7),
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Expire in: ${state.getCryptoTransactionInfoModel!.order!.time!}",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          color: CustomColor.black
                                              .withOpacity(0.7),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "if you send any other ${state.getCryptoTransactionInfoModel!.order!.currencyName!} amount, payment system will not accept",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.inter(
                                            fontSize: 14,
                                            color: CustomColor.errorColor,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 16),
                                      child: PrimaryButtonWidget(
                                        onPressed: () {
                                          _posBloc.add(CryptoOrderCancelEvent(
                                              uniqueId: widget.uniqueId));

                                          Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              'merchantStoreScreen',
                                              (route) => false);
                                        },
                                        buttonText: 'Cancel',
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
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Make Payment',
            style: GoogleFonts.inter(
                color: CustomColor.black,
                fontSize: 25,
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
