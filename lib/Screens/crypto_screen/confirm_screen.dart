import 'package:gptbanqbusiness/Models/convert_preview_model.dart';
import 'package:gptbanqbusiness/Screens/crypto_screen/bloc/crypto_bloc.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slidable_button/slidable_button.dart';

import '../../utils/input_fields/custom_color.dart';
import '../../widgets/buttons/default_back_button_widget.dart';
import '../../widgets/toast/toast_util.dart';

// ignore: must_be_immutable
class ConfirmScreen extends StatefulWidget {
  String symbol, image;
  bool isBuy;
  ConvertModel convertModel;

  ConfirmScreen(
      {super.key,
      required this.symbol,
      required this.image,
      required this.isBuy,
      required this.convertModel});

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  CryptoBloc _cryptoBloc = CryptoBloc();

  bool value = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.whiteColor,
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                DefaultBackButtonWidget(onTap: () {
                                  Navigator.pop(context);
                                }),
                                Text(
                                  widget.isBuy ? 'Buy' : 'Sell',
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
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                height: 120,
                                width: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: CustomColor.black.withOpacity(0.1),
                                ),
                                child: Container(
                                  height: 96,
                                  width: 96,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: NetworkImage(widget.image),
                                          fit: BoxFit.cover)),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 16),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                                decoration: BoxDecoration(
                                  color: CustomColor.whiteColor,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: CustomColor.black.withOpacity(0.1),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Detail Transaction',
                                      style: GoogleFonts.inter(
                                          color: CustomColor.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${widget.symbol.toUpperCase()} price',
                                            style: GoogleFonts.inter(
                                                color: CustomColor.black
                                                    .withOpacity(0.5),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Expanded(
                                            child: Text(
                                              widget.convertModel.price!,
                                              textAlign: TextAlign.end,
                                              style: GoogleFonts.inter(
                                                  color: CustomColor.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Amount',
                                            style: GoogleFonts.inter(
                                                color: CustomColor.black
                                                    .withOpacity(0.5),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Expanded(
                                            child: Text(
                                              widget.convertModel.payAmount!,
                                              textAlign: TextAlign.end,
                                              style: GoogleFonts.inter(
                                                  color: CustomColor.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Fees',
                                            style: GoogleFonts.inter(
                                                color: CustomColor.black
                                                    .withOpacity(0.5),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Expanded(
                                            child: Text(
                                              widget.convertModel.fee!,
                                              textAlign: TextAlign.end,
                                              style: GoogleFonts.inter(
                                                  color: CustomColor.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Order type',
                                            style: GoogleFonts.inter(
                                                color: CustomColor.black
                                                    .withOpacity(0.5),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Expanded(
                                            child: Text(
                                              widget.isBuy ? 'Buy' : "Sell",
                                              textAlign: TextAlign.end,
                                              style: GoogleFonts.inter(
                                                  color: CustomColor.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      color: CustomColor.black.withOpacity(0.5),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Total',
                                            style: GoogleFonts.inter(
                                                color: CustomColor.black
                                                    .withOpacity(0.3),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Expanded(
                                            child: Text(
                                              widget.convertModel.getAmount!,
                                              textAlign: TextAlign.end,
                                              style: GoogleFonts.inter(
                                                  color: CustomColor.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          alignment: Alignment.bottomCenter,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                      value: value,
                                      onChanged: (v) {
                                        setState(() {
                                          value = v!;
                                        });
                                      }),
                                  Expanded(
                                    child: Text(
                                      "Select this choice to perform the conversion",
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.inter(
                                          color: Color(0xff7A7A7A),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: double.infinity,
                                child: HorizontalSlidableButton(
                                  width: MediaQuery.of(context).size.width / 3,
                                  height: 56.0,
                                  buttonWidth: 56.0,
                                  isRestart: true,
                                  color: value == true
                                      ? CustomColor.primaryColor
                                      : CustomColor.primaryColor
                                          .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(100),
                                  buttonColor: CustomColor.whiteColor,
                                  initialPosition: SlidableButtonPosition.start,
                                  tristate: true,
                                  label: Container(
                                      alignment: Alignment.center,
                                      width: 56.0,
                                      height: 56.0,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          // border: Border.all(
                                          //   color:
                                          // ),
                                          color: value == true
                                              ? CustomColor.whiteColor
                                              : CustomColor.whiteColor),
                                      child:  Icon(
                                        Icons.keyboard_double_arrow_right,
                                        color: CustomColor.primaryColor,
                                      )),
                                  onChanged: value == true
                                      ? (position) {
                                          setState(() {
                                            if (position ==
                                                SlidableButtonPosition.end) {
                                              _cryptoBloc.add(
                                                  ConfirmConvertevent(
                                                      amount: widget
                                                          .convertModel.amount,
                                                      base_coin_symbol:
                                                          widget.symbol,
                                                      from_coin: widget
                                                          .convertModel
                                                          .fromSymbol,
                                                      to_coin: widget
                                                          .convertModel
                                                          .toSymbol,
                                                      type: widget
                                                          .convertModel.type));
                                            } else {}
                                          });
                                        }
                                      : null,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Swipe to confirm',
                                          style: GoogleFonts.inter(
                                              color: value == true
                                                  ? CustomColor.whiteColor
                                                  : CustomColor.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              })),
    );
  }
}
