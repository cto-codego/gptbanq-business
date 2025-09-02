import 'package:gptbanqbusiness/Screens/crypto_screen/bloc/crypto_bloc.dart';
import 'package:gptbanqbusiness/Screens/crypto_screen/confirm_screen.dart';
import 'package:gptbanqbusiness/constant_string/User.dart';
import 'package:gptbanqbusiness/cutom_weidget/custom_keyboard.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/input_fields/custom_color.dart';
import '../../widgets/buttons/default_back_button_widget.dart';
import '../../widgets/buttons/primary_button_widget.dart';
import '../../widgets/input_fields/amount_input_field_widget.dart';
import '../../widgets/toast/toast_util.dart';

// ignore: must_be_immutable
class BuyScreen extends StatefulWidget {
  String symbol, image, paircurrency;
  bool isBuy;

  BuyScreen(
      {super.key,
        required this.symbol,
        required this.isBuy,
        required this.paircurrency,
        required this.image});

  @override
  State<BuyScreen> createState() => _BuyScreenState();
}

class _BuyScreenState extends State<BuyScreen> {
  final CryptoBloc _cryptoBloc = CryptoBloc();

  final TextEditingController _textEditingController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool active = false;

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _textEditingController.removeListener(_updateButtonState);
    _textEditingController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        active = _textEditingController.text.isNotEmpty;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.scaffoldBg,
      body: BlocListener(
          bloc: _cryptoBloc,
          listener: (context, CryptoState state) async {
            if (state.convertModel?.status == 0) {
              CustomToast.showError(
                  context, "Sorry!", state.convertModel!.message!);
            } else if (state.convertModel?.status == 1) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ConfirmScreen(
                        convertModel: state.convertModel!,
                        isBuy: widget.isBuy,
                        symbol: widget.symbol,
                        image: widget.image,
                      )));
            }
          },
          child: BlocBuilder(
              bloc: _cryptoBloc,
              builder: (context, CryptoState state) {
                return SafeArea(
                  child: ProgressHUD(
                    inAsyncCall: state.isloading,
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                  widget.isBuy
                                      ? 'Buy ${widget.symbol.toUpperCase()}'
                                      : 'Sell ${widget.symbol.toUpperCase()}',
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
                        Form(
                          key: _formKey,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            child: AmountInputField(
                                controller: _textEditingController,
                                label:
                                widget.isBuy ? 'Buy Amount' : 'Sell Amount',
                                currencySymbol: widget.isBuy
                                    ? widget.paircurrency
                                    : widget.symbol.toUpperCase(),
                                autofocus: false,
                                readOnly: true,
                                minAmount: 0,
                                onChanged: (value) {
                                  _updateButtonState();
                                }),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        if (widget.isBuy == false)
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _textEditingController.text =
                                              User.cryptoBalance;
                                        });
                                      },
                                      child: Container(
                                        height: 43,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: CustomColor.hubContainerBgColor),
                                        child: Text(
                                          'Max',
                                          style: GoogleFonts.inter(
                                              color: CustomColor
                                                  .inputFieldTitleTextColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          child: PrimaryButtonWidget(
                            onPressed: active
                                ? () {
                              active = false;
                              if (_formKey.currentState!.validate()) {
                                widget.isBuy
                                    ? _cryptoBloc.add(ConvercoinEvent(
                                  amount:
                                  _textEditingController.text,
                                  basesymbol: widget.symbol,
                                  from: widget.paircurrency,
                                  to: widget.symbol,
                                ))
                                    : _cryptoBloc.add(ConvercoinEvent(
                                  amount:
                                  _textEditingController.text,
                                  basesymbol: widget.symbol,
                                  from: widget.symbol,
                                  to: widget.paircurrency,
                                ));
                              }
                            }
                                : null,
                            buttonText: 'Next',
                          ),
                        ),
                        Expanded(
                            child: Container(
                              color: const Color(0xffF7F9FD),
                              child: KeyPad2(
                                pinController: _textEditingController,
                                onChange: (String pin) {
                                  _textEditingController.text = pin;

                                  setState(() {});
                                },
                              ),
                            ))
                      ],
                    ),
                  ),
                );
              })),
    );
  }
}
