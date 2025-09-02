import 'dart:io';

import 'package:gptbanqbusiness/Models/Crypto_coins_model.dart';
import 'package:gptbanqbusiness/Screens/crypto_screen/bloc/crypto_bloc.dart';
import 'package:gptbanqbusiness/constant_string/User.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:gptbanqbusiness/utils/assets.dart';
import 'package:gptbanqbusiness/widgets/custom_image_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../utils/input_fields/custom_color.dart';
import '../../widgets/buttons/default_back_button_widget.dart';
import '../../widgets/buttons/primary_button_widget.dart';

// ignore: must_be_immutable
class DepositScreen extends StatefulWidget {
  String symbol, coinname, coinimage;

  bool isCoin;

  DepositScreen(
      {super.key,
      required this.symbol,
      required this.coinname,
      required this.coinimage,
      required this.isCoin});

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  CryptoBloc _cryptoBloc = new CryptoBloc();
  final _screenshotcontrolar = new ScreenshotController();

  int network = 0;

  List<Coin>? Eurocoin = [
    Coin(image: '', currencyName: '', currencySymbol: '', fiatBalance: '')
  ];

  Future<void> _onRefresh() async {
    widget.isCoin
        ? _cryptoBloc.add(GenerateaddressEvent(symbol: widget.symbol))
        : _cryptoBloc.add(GenerateQrcodeNetworksEvent(symbol: widget.symbol));
  }

  void takeScreenshot() async {
    final imagefile = await _screenshotcontrolar.capture();
    saveandshare(imagefile!);
  }

  Future<void> saveandshare(Uint8List beyts) async {
    final directory = await getApplicationSupportDirectory();
    final image = File('${directory.path}/address.png');
    await image.writeAsBytes(beyts);

    final xFile = XFile(image.path);

    await Share.shareXFiles([xFile]);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    User.Screen = 'Deposit coin';

    widget.isCoin
        ? _cryptoBloc.add(GenerateaddressEvent(symbol: widget.symbol))
        : _cryptoBloc.add(GenerateQrcodeNetworksEvent(symbol: widget.symbol));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.scaffoldBg,
      body: BlocListener(
          bloc: _cryptoBloc,
          listener: (context, CryptoState state) async {},
          child: BlocBuilder(
              bloc: _cryptoBloc,
              builder: (context, CryptoState state) {
                return SafeArea(
                  child: ProgressHUD(
                    inAsyncCall: state.isloading,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: RefreshIndicator(
                        onRefresh: _onRefresh,
                        child: Screenshot(
                          controller: _screenshotcontrolar,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 30, top: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    DefaultBackButtonWidget(onTap: () {
                                      Navigator.pop(context);
                                    }),
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
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 10),
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: CustomColor.whiteColor,
                                  borderRadius: BorderRadius.circular(
                                      16.0), // Rounded corners (16.dp)
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0x14000000),
                                      offset: Offset(0, 1),
                                      blurRadius: 8,
                                      spreadRadius: -2,
                                    ),
                                  ],
                                ),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          widget.coinimage.isEmpty
                                              ? Container()
                                              : Container(
                                                  width: 48,
                                                  height: 48,
                                                  margin: const EdgeInsets.only(
                                                      right: 10),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                          widget.coinimage),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                widget.coinname,
                                                style: GoogleFonts.inter(
                                                  color: CustomColor.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                widget.symbol.toUpperCase(),
                                                style: GoogleFonts.inter(
                                                  color: CustomColor
                                                      .inputFieldTitleTextColor,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                    ]),
                              ),
                              widget.isCoin
                                  ? Container()
                                  : Text(
                                      'Select Network',
                                      style: GoogleFonts.inter(
                                          color: CustomColor
                                              .inputFieldTitleTextColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                              widget.isCoin
                                  ? Container()
                                  : SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      // margin:
                                      //     EdgeInsets.symmetric(horizontal: 20),
                                      child: Wrap(
                                        direction: Axis.horizontal,
                                        children: [
                                          for (int i = 0;
                                              i <
                                                  state.tokennetworks!
                                                      .userAddresses!.length;
                                              i++)
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  network = i;
                                                });
                                              },
                                              child: Container(
                                                  width: 100,
                                                  height: 45,
                                                  alignment: Alignment.center,
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 7,
                                                      vertical: 10),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: network == i
                                                        ? CustomColor.blue
                                                        : CustomColor
                                                            .whiteColor,
                                                    border: Border.all(
                                                      color: network == i
                                                          ? CustomColor
                                                              .blueBorder
                                                          : CustomColor
                                                              .whiteColor,
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color:
                                                            Color(0x0D000000),
                                                        offset: Offset(0, 2),
                                                        blurRadius: 4,
                                                      ),
                                                    ],
                                                  ),
                                                  child: Text(
                                                    '${state.tokennetworks!.userAddresses![i].network}',
                                                    style: GoogleFonts.inter(
                                                        color: network == i
                                                            ? CustomColor
                                                                .whiteColor
                                                            : CustomColor.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  )),
                                            ),
                                        ],
                                      )),
                              Expanded(
                                  child: ListView(
                                children: [
                                  Text(
                                    'Copy Address',
                                    style: GoogleFonts.inter(
                                        color: CustomColor
                                            .inputFieldTitleTextColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  widget.isCoin
                                      ? Container(
                                          margin: EdgeInsets.only(bottom: 10),
                                          padding: EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: CustomColor.whiteColor,
                                            borderRadius: BorderRadius.circular(
                                                16.0), // Rounded corners (16.dp)
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color(0x14000000),
                                                offset: Offset(0, 1),
                                                blurRadius: 8,
                                                spreadRadius: -2,
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  state.coinQrcode!.address!,
                                                  style: GoogleFonts.inter(
                                                    color: CustomColor
                                                        .transactionDetailsTextColor,
                                                    fontSize: 14,
                                                    fontWeight:
                                                    FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                  onPressed: () async {
                                                    await Clipboard.setData(
                                                        ClipboardData(
                                                            text: state
                                                                .coinQrcode!
                                                                .address!));
                                                  },
                                                  icon: CustomImageWidget(
                                                    imagePath:
                                                    StaticAssets.copy,
                                                    imageType: 'svg',
                                                    height: 24,
                                                  ))
                                            ],
                                          ),
                                        )
                                      : Container(
                                          margin: EdgeInsets.only(bottom: 10),
                                          padding: EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: CustomColor.whiteColor,
                                            borderRadius: BorderRadius.circular(
                                                16.0), // Rounded corners (16.dp)
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color(0x14000000),
                                                offset: Offset(0, 1),
                                                blurRadius: 8,
                                                spreadRadius: -2,
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 10),
                                                  child: Text(
                                                    state
                                                        .tokennetworks!
                                                        .userAddresses![network]
                                                        .address!,
                                                    style: GoogleFonts.inter(
                                                      color: CustomColor
                                                          .transactionDetailsTextColor,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                  onPressed: () async {
                                                    await Clipboard.setData(
                                                        ClipboardData(
                                                            text: state
                                                                .tokennetworks!
                                                                .userAddresses![
                                                                    network]
                                                                .address!));
                                                  },
                                                  icon: CustomImageWidget(
                                                    imagePath:
                                                        StaticAssets.copy,
                                                    imageType: 'svg',
                                                    height: 24,
                                                  ))
                                            ],
                                          ),
                                        ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  widget.isCoin
                                      ? Container(
                                          alignment: Alignment.center,
                                          width: 180,
                                          height: 180,
                                          child: state.coinQrcode!.qrcode == ''
                                              ? Container()
                                              : Image.network(
                                                  state.coinQrcode!.qrcode!),
                                        )
                                      : Container(
                                          alignment: Alignment.center,
                                          width: 180,
                                          height: 180,
                                          child: state
                                                      .tokennetworks!
                                                      .userAddresses![network]
                                                      .qrcode ==
                                                  ''
                                              ? Container()
                                              : Image.network(state
                                                  .tokennetworks!
                                                  .userAddresses![network]
                                                  .qrcode!),
                                        ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      state.coinQrcode!.networkType!,
                                      style: GoogleFonts.inter(
                                        color: CustomColor
                                            .transactionDetailsTextColor,
                                        fontSize: 14,
                                        fontWeight:
                                        FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),

                                  PrimaryButtonWidget(
                                    onPressed: takeScreenshot,
                                    buttonText: 'Share Address',
                                  ),
                                ],
                              ))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              })),
    );
  }
}
