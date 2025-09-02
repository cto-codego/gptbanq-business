import 'dart:io';

import 'package:gptbanqbusiness/Models/Crypto_coins_model.dart';
import 'package:gptbanqbusiness/Screens/crypto_screen/bloc/crypto_bloc.dart';
import 'package:gptbanqbusiness/constant_string/User.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:gptbanqbusiness/utils/input_fields/custom_color.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../widgets/buttons/default_back_button_widget.dart';
import '../../widgets/buttons/primary_button_widget.dart';
import '../../widgets/input_fields/defult_input_field_with_title_widget.dart';
import '../../widgets/toast/toast_util.dart';

// ignore: must_be_immutable
class SendCoinScreen extends StatefulWidget {
  String symbol, coinname, coinimage, balance, isMemoShow;

  bool isCoin;

  SendCoinScreen(
      {super.key,
      required this.symbol,
      required this.coinname,
      required this.coinimage,
      required this.isCoin,
      required this.isMemoShow,
      required this.balance});

  @override
  State<SendCoinScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<SendCoinScreen> {
  final CryptoBloc _cryptoBloc = CryptoBloc();
  final _formKey = GlobalKey<FormState>();
  bool active = false;

  final TextEditingController _amount = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _memoController = TextEditingController();

  int network = 0;

  List<Coin>? Eurocoin = [
    Coin(image: '', currencyName: '', currencySymbol: '', fiatBalance: '')
  ];

  Future saveandshare(Uint8List beyts) async {
    final directory = await getApplicationSupportDirectory();
    final image = File('${directory.path}/address.png');
    image.writeAsBytes(beyts);

    final xFile = XFile(image.path);

    // await Share.shareXFiles([image.path]);

    // Sharing the file with optional subject and text
    return await Share.shareXFiles(
      [xFile],
      subject: '',
      text: '',
    );
  }

  @override
  void initState() {
    super.initState();
    User.Screen = 'send coin';

    _cryptoBloc.add(GetnetworkEvent(symbol: widget.symbol));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.scaffoldBg,
      body: BlocListener(
          bloc: _cryptoBloc,
          listener: (context, CryptoState state) async {
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
                    child: Container(
                      alignment: Alignment.topCenter,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 30, top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                DefaultBackButtonWidget(onTap: () {
                                  Navigator.pop(context);
                                }),
                                Text(
                                  'Withdraw',
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                      ),
                                      Expanded(
                                        child: Text(
                                          widget.balance.toUpperCase(),
                                          textAlign: TextAlign.right,
                                          style: GoogleFonts.inter(
                                            color: CustomColor.black,
                                            fontSize: 24,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                ]),
                          ),
                          Text(
                            'Select Network',
                            style: GoogleFonts.inter(
                                color: CustomColor.inputFieldTitleTextColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          Container(
                              alignment: Alignment.centerLeft,
                              width: MediaQuery.of(context).size.width,
                              // margin:
                              //     const EdgeInsets.symmetric(horizontal: 20),
                              child: Wrap(
                                direction: Axis.horizontal,
                                children: [
                                  for (int i = 0;
                                      i < state.sendNetwork!.network!.length;
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
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 7, vertical: 10),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: network == i
                                                  ? CustomColor.blue
                                                  : CustomColor.whiteColor,
                                              border: Border.all(
                                                color: network == i
                                                    ? CustomColor.blueBorder
                                                    : CustomColor.whiteColor,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color(0x0D000000),
                                                  offset: Offset(0, 2),
                                                  blurRadius: 4,
                                                ),
                                              ]),
                                          child: Text(
                                            '${state.sendNetwork!.network![i].network}',
                                            style: GoogleFonts.inter(
                                                color: network == i
                                                    ? CustomColor.whiteColor
                                                    : CustomColor.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400),
                                          )),
                                    ),
                                ],
                              )),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                DefaultInputFieldWithTitleWidget(
                                  controller: _amount,
                                  title: 'Amount',
                                  hint: 'Amount',
                                  isEmail: false,
                                  keyboardType: TextInputType.number,
                                  autofocus: false,
                                  isPassword: false,
                                  onChanged: (value) {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        active = true;
                                      });
                                    }
                                  },
                                  suffixIcon: Container(
                                    width: 20,
                                    alignment: Alignment.center,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _amount.text = widget.balance;
                                        });
                                      },
                                      child: Text(
                                        'Max',
                                        style: GoogleFonts.inter(
                                            color: CustomColor.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  prefixIcon: Container(
                                    width: 20,
                                    alignment: Alignment.center,
                                    child: Text(
                                      widget.symbol.toUpperCase(),
                                      style: GoogleFonts.inter(
                                          color: CustomColor.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                DefaultInputFieldWithTitleWidget(
                                  controller: _address,
                                  title: 'Address',
                                  hint: 'Enter Address',
                                  isEmail: false,
                                  keyboardType: TextInputType.text,
                                  autofocus: false,
                                  isPassword: false,
                                  onChanged: (value) {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        active = true;
                                      });
                                    }
                                  },
                                  suffixIcon: Container(
                                    width: 20,
                                    alignment: Alignment.center,
                                    child: InkWell(
                                      onTap: () async {
                                        var result =
                                            await BarcodeScanner.scan();

                                        setState(() {
                                          _address.text = result.rawContent;
                                        });
                                      },
                                      child: Text(
                                        'QR',
                                        style: GoogleFonts.inter(
                                            color: CustomColor.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ),
                                if (widget.isMemoShow == "1")
                                  DefaultInputFieldWithTitleWidget(
                                    controller: _memoController,
                                    title: 'Memo',
                                    hint: 'memo',
                                    isEmail: false,
                                    keyboardType: TextInputType.text,
                                    autofocus: false,
                                    isPassword: false,
                                    validator: (value) => null,
                                    onChanged: (value) {
                                      if (_formKey.currentState!.validate()) {
                                        setState(() {
                                          active = true;
                                        });
                                      }
                                    },
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          PrimaryButtonWidget(
                            onPressed: active
                                ? () {
                                    if (_formKey.currentState!.validate()) {
                                      active = false;
                                      _cryptoBloc.add(SendCoinEvent(
                                          address: _address.text,
                                          amount: _amount.text,
                                          memo: _memoController.text ?? "",
                                          currencyId: widget.symbol,
                                          network: state.sendNetwork!.network!
                                                  .isNotEmpty
                                              ? state.sendNetwork!
                                                  .network![network].network
                                              : ""));
                                    }
                                  }
                                : null,
                            buttonText: 'Send',
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              })),
    );
  }
}
