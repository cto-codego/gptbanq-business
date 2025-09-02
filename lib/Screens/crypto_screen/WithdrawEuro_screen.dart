import 'package:gptbanqbusiness/Screens/crypto_screen/bloc/crypto_bloc.dart';
import 'package:gptbanqbusiness/Screens/crypto_screen/deposit_confirmation_screen.dart';
import 'package:gptbanqbusiness/Screens/crypto_screen/withdraw_confirmation_screen.dart';
import 'package:gptbanqbusiness/cutom_weidget/custom_keyboard.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import '../../constant_string/User.dart';
import '../../utils/assets.dart';
import '../../utils/input_fields/custom_color.dart';
import '../../widgets/buttons/custom_icon_button_widget.dart';
import '../../widgets/buttons/default_back_button_widget.dart';
import '../../widgets/buttons/primary_button_widget.dart';
import '../../widgets/input_fields/amount_input_field_widget.dart';
import '../../widgets/toast/toast_util.dart';

// ignore: must_be_immutable
class WithdrawEuro extends StatefulWidget {
  String symbol, image;
  bool isBuy;

  WithdrawEuro(
      {super.key,
      required this.symbol,
      required this.isBuy,
      required this.image});

  @override
  State<WithdrawEuro> createState() => _WithdrawEuroState();
}

class _WithdrawEuroState extends State<WithdrawEuro> {
  final CryptoBloc _cryptoBloc = CryptoBloc();

  final TextEditingController _textEditingController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool active = false;

  @override
  void initState() {
    _cryptoBloc.add(getibanlistEvent());
    User.Screen = 'Move Euro';

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
            if (state.statusModel?.status == 0) {
              CustomToast.showError(
                  context, "Sorry!", state.statusModel!.message!);
            } else if (state.convertModel?.status == 1) {}

            if (state.ibanDepositEurToCryptoModel?.status == 1) {
              String body = state.ibanDepositEurToCryptoModel!.body!;
              String title = state.ibanDepositEurToCryptoModel!.title!;
              String uniqueId = state.ibanDepositEurToCryptoModel!.uniqueId!;

              debugPrint("check iban deposit check");

              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.scale,
                  alignment: Alignment.center,
                  isIos: true,
                  duration: const Duration(microseconds: 500),
                  child: DepositConfirmationScreen(
                    title: title,
                    body: body,
                    uniqueId: uniqueId,
                  ),
                ),
              );
            } else if (state.ibanDepositEurToCryptoModel?.status == 0) {
              CustomToast.showError(context, "Sorry!",
                  state.ibanDepositEurToCryptoModel!.message!);
            }

            if (state.eurWithdrawModel?.status == 1) {
              String body = state.eurWithdrawModel!.body!;
              String title = state.eurWithdrawModel!.title!;
              String uniqueId = state.eurWithdrawModel!.uniqueId!;

              debugPrint("check iban deposit check");

              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.scale,
                  alignment: Alignment.center,
                  isIos: true,
                  duration: const Duration(microseconds: 500),
                  child: WithdrawConfirmationScreen(
                    title: title,
                    body: body,
                    uniqueId: uniqueId,
                  ),
                ),
              );
            } else if (state.eurWithdrawModel?.status == 0) {
              CustomToast.showError(
                  context, "Sorry!", state.eurWithdrawModel!.message!);
            }
          },
          child: BlocBuilder(
              bloc: _cryptoBloc,
              builder: (context, CryptoState state) {
                return SafeArea(
                  child: ProgressHUD(
                    inAsyncCall: state.isloading,
                    child: Column(
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
                                  widget.isBuy ? 'Deposit' : 'Withdraw',
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
                        // const SizedBox(
                        //   height: 20,
                        // ),

                        Form(
                          key: _formKey,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            child: AmountInputField(
                                controller: _textEditingController,
                                label: widget.isBuy
                                    ? 'Deposit Amount'
                                    : 'Withdraw Amount',
                                currencySymbol: widget.symbol.toUpperCase(),
                                autofocus: false,
                                readOnly: true,
                                minAmount: 0,
                                onChanged: (value) {
                                  _updateButtonState();
                                }),
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),

                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Expanded(
                                  child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _textEditingController.text = '25';
                                  });
                                },
                                child: Container(
                                  height: 43,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: CustomColor.hubContainerBgColor),
                                  child: Text(
                                    '€25',
                                    style: GoogleFonts.inter(
                                        color: CustomColor
                                            .inputFieldTitleTextColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              )),
                              Expanded(
                                  child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _textEditingController.text = '50';
                                  });
                                },
                                child: Container(
                                  height: 43,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: CustomColor.hubContainerBgColor),
                                  child: Text(
                                    '€50',
                                    style: GoogleFonts.inter(
                                        color: CustomColor
                                            .inputFieldTitleTextColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              )),
                              Expanded(
                                  child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _textEditingController.text = '100';
                                  });
                                },
                                child: Container(
                                  height: 43,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: CustomColor.hubContainerBgColor),
                                  child: Text(
                                    '€100',
                                    style: GoogleFonts.inter(
                                        color: CustomColor
                                            .inputFieldTitleTextColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              )),
                              Expanded(
                                  child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _textEditingController.text = '250';
                                  });
                                },
                                child: Container(
                                  height: 43,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: CustomColor.hubContainerBgColor),
                                  child: Text(
                                    '€250',
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
                                      showModalBottomSheet(
                                          context: context,
                                          isDismissible: true,
                                          enableDrag: true,
                                          isScrollControlled: true,
                                          backgroundColor:
                                              CustomColor.whiteColor,
                                          barrierColor:
                                              Colors.black.withOpacity(0.7),
                                          useRootNavigator: true,
                                          builder: (context) {
                                            return StatefulBuilder(builder:
                                                (buildContext,
                                                    StateSetter
                                                        setStater /*You can rename this!*/) {
                                              return Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.5,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 10),
                                                  decoration:
                                                      const BoxDecoration(
                                                    color:
                                                        CustomColor.whiteColor,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(12),
                                                            topRight:
                                                                Radius.circular(
                                                                    12)),
                                                  ),
                                                  child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            CustomIconButtonWidget(
                                                              onTap: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              svgAssetPath:
                                                                  StaticAssets
                                                                      .closeBlack, // Replace with your asset path
                                                            ),
                                                            Text(
                                                              'Select Account',
                                                              style: GoogleFonts
                                                                  .inter(
                                                                color: CustomColor
                                                                    .primaryColor,
                                                                fontSize: 17,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 20),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                        Expanded(
                                                          child:
                                                              ListView.builder(
                                                            itemCount: state
                                                                .ibanlistModel!
                                                                .ibaninfo!
                                                                .length,
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    int index) {
                                                              return InkWell(
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                      context);

                                                                  widget.isBuy ==
                                                                          false
                                                                      ? _cryptoBloc.add(MovetoIbanEvent(
                                                                          ibanid: state
                                                                              .ibanlistModel!
                                                                              .ibaninfo![
                                                                                  index]
                                                                              .ibanId,
                                                                          amount: _textEditingController
                                                                              .text))
                                                                      : _cryptoBloc.add(MoveEurotocryptoEvent(
                                                                          ibanid: state
                                                                              .ibanlistModel!
                                                                              .ibaninfo![
                                                                                  index]
                                                                              .ibanId,
                                                                          amount:
                                                                              _textEditingController.text));
                                                                },
                                                                child:
                                                                    Container(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          20,
                                                                      vertical:
                                                                          20),
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    border:
                                                                        Border(
                                                                      bottom:
                                                                          BorderSide(
                                                                        color: CustomColor
                                                                            .primaryInputHintBorderColor,
                                                                        width:
                                                                            1,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  child: Text(
                                                                    state
                                                                        .ibanlistModel!
                                                                        .ibaninfo![
                                                                            index]
                                                                        .label!,
                                                                    style: GoogleFonts
                                                                        .inter(
                                                                      color: CustomColor
                                                                          .black,
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        )
                                                      ]));
                                            });
                                          });
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
