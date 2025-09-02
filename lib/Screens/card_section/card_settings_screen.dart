import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:gptbanqbusiness/Models/card/card_replace_model.dart';
import 'package:gptbanqbusiness/utils/user_data_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constant_string/User.dart';
import '../../cutom_weidget/cutom_progress_bar.dart';
import '../../cutom_weidget/input_textform.dart';
import '../../utils/assets.dart';
import '../../utils/input_fields/custom_color.dart';
import '../../widgets/buttons/default_back_button_widget.dart';
import '../../widgets/buttons/primary_button_widget.dart';
import '../../widgets/custom_image_widget.dart';
import '../../widgets/main_logo_widget.dart';
import '../../widgets/toast/custom_dialog_widget.dart';
import '../../widgets/toast/toast_util.dart';
import '../Dashboard_screen/bloc/dashboard_bloc.dart';

class CardSettingsScreen extends StatefulWidget {
  const CardSettingsScreen({super.key});

  @override
  State<CardSettingsScreen> createState() => _CardSettingsScreenState();
}

class _CardSettingsScreenState extends State<CardSettingsScreen> {
  bool active = false;
  int? _onlinePayment; // Use nullable int to represent initial loading state
  int? _recurringPayments;
  int? _contactless;
  int? _pinBlockUnblock;
  String? _blockCardMessage;
  String symbol = "";

  String? _isVirtual;

  final DashboardBloc _cardSettingBloc = DashboardBloc();

  Future<void> _onRefresh() async {
    debugPrint('_onRefresh');

    _cardSettingBloc.add(DashboarddataEvent());
    _cardSettingBloc.add(CardDetailsEvent());
  }

  @override
  void initState() {
    super.initState();
    User.Screen = 'card Settings Screen';

    _cardSettingBloc.add(DashboarddataEvent());
    _cardSettingBloc.add(CardDetailsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.scaffoldBg,
      body: BlocListener(
          bloc: _cardSettingBloc,
          listener: (context, DashboardState state) {
            if (state.statusModel?.status == 0) {
              CustomToast.showError(
                  context, "Sorry!", state.statusModel!.message!);
            }
            if (state.userCardDetailsModel?.status == 1) {
              _onlinePayment = int.parse(state
                  .userCardDetailsModel!.userCardDetails!.cardSetting!.online
                  .toString());
              _pinBlockUnblock = int.parse(state
                  .userCardDetailsModel!.userCardDetails!.cardSetting!.atmlBlock
                  .toString());
              _recurringPayments = int.parse(state
                  .userCardDetailsModel!.userCardDetails!.cardSetting!.recurring
                  .toString());
              _contactless = int.parse(state.userCardDetailsModel!
                  .userCardDetails!.cardSetting!.contactless
                  .toString());

              _blockCardMessage = state.userCardDetailsModel!
                  .userCardDetails!.cardSetting!.blockCardMessage
                  .toString();

              _isVirtual = state
                  .userCardDetailsModel!.userCardDetails!.cardMaterial
                  .toString();

              print("----------check-----------");
              print(_onlinePayment.toString());
              print(_recurringPayments.toString());
              print(_contactless.toString());
              print(_pinBlockUnblock.toString());
              print("----------check-----------");
              symbol = state.userCardDetailsModel!.userCardDetails!.symbol
                  .toString();
            }

            if (state.cardBlockUnblockModel?.status == 1) {
              CustomToast.showSuccess(
                  context, "Success!", state.cardBlockUnblockModel!.message!);
              Navigator.pushNamedAndRemoveUntil(
                  context, 'cardScreen', (route) => false);
            }

            if (state.cardReplaceModel?.status == 1) {
              CustomToast.showSuccess(
                  context, "Success!", state.cardReplaceModel!.message!);
            }
          },
          child: BlocBuilder(
              bloc: _cardSettingBloc,
              builder: (context, DashboardState state) {
                return SafeArea(
                  child: ProgressHUD(
                    inAsyncCall: state.isloading,
                    child: RefreshIndicator(
                      onRefresh: _onRefresh,
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: ListView(
                          children: [
                            appBarSection(context, state),
                            cardSection(context, state),
                            settingSection(context, state),
                            settingsOptions(context, state),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              })),
    );
  }

  appBarSection(BuildContext context, DashboardState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DefaultBackButtonWidget(onTap: () {
            Navigator.pop(context);
          }),
          Text(
            'Card Setting',
            style: GoogleFonts.inter(
                color: CustomColor.black,
                fontSize: 18,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(
            width: 20,
          )
        ],
      ),
    );
  }

  cardSection(BuildContext context, DashboardState state) {
    return Center(
      child: Image.network(
        state.userCardDetailsModel!.userCardDetails!.cardImage.toString(),
        width: MediaQuery.of(context).size.width,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            return child;
          } else {
            return const Center(
                child: MainLogoWidget(
              height: 200,
            ));
          }
        },
        errorBuilder:
            (BuildContext context, Object error, StackTrace? stackTrace) {
          print('Error loading image: $error');
          return MainLogoWidget(
            height: 200,
          );
        },
      ),
    );
  }

  settingSection(BuildContext context, DashboardState state) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
         /* _isVirtual == "virtual"
              ? Container()
              : GestureDetector(
                  onTap: () {
                    CustomDialogWidget.showWarningDialog(
                        context: context,
                        title: "Replace Card",
                        subTitle: "Do you want to replace card?",
                        btnOkText: "Yes",
                        btnCancelText: "No",
                        btnOkOnPress: () {
                          _cardSettingBloc.add(CardReplaceEvent());
                        },
                        btnCancelOnPress: () {});
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 44,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1000),
                      color: CustomColor.primaryColor,
                    ),
                    child: Row(
                      children: [
                        CustomImageWidget(
                          imagePath: StaticAssets.replaceCard,
                          imageType: 'svg',
                          height: 14,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Replace Card',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: CustomColor.whiteColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),*/
          Expanded(
            child: GestureDetector(
              onTap: () {
                CustomDialogWidget.showWarningDialog(
                  context: context,
                  title: "Block Card",
                  subTitle:  state.userCardDetailsModel!.userCardDetails!.cardSetting!.blockCardMessage!.toString(),
                  btnOkText: "Block",
                  btnCancelText: "Cancel",
                  btnOkOnPress: () {
                    UserDataManager().cardBlockUnblockStatusSave("block");
                    _cardSettingBloc.add(CardBlockUnblockEvent());
                  },
                  btnCancelOnPress: () {
                    // UserDataManager().cardBlockUnblockStatusSave("pblock");
                    // UserDataManager().cardBlockUnblockStatusSave("block");
                    // _cardSettingBloc.add(CardBlockUnblockEvent());
                  },
                );
              },
              child: Container(
                alignment: Alignment.center,
                height: 44,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1000),
                  color: CustomColor.errorColor.withOpacity(0.1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomImageWidget(
                      imagePath: StaticAssets.blockCard,
                      imageType: 'svg',
                      height: 14,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      'Block Card',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: CustomColor.errorColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  settingsOptions(BuildContext context, DashboardState state) {
    return Column(
      children: [
      /*  if (_isVirtual != "virtual")
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'POS Daily Limit',
                      style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      elevation: 5,
                      isScrollControlled: true,
                      builder: (context) {
                        return const DailyLimitWidget();
                      },
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            symbol,
                            style: GoogleFonts.inter(
                              color: CustomColor.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            state.userCardDetailsModel!.userCardDetails!
                                .cardSetting!.dailyLimit
                                .toString(),
                            style: GoogleFonts.inter(
                              color: CustomColor.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),*/
   /*     Divider(
          color: CustomColor.black.withOpacity(0.3),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Online Payments',
                textAlign: TextAlign.right,
                style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              _onlinePayment == null // Check if data is still loading
                  ? Container() // Show loading indicator if data is loading
                  : _SwitchWidget(
                      initialValue: _onlinePayment == 1,
                      onChanged: (value) {
                        // Update _onlinePayment when the switch is toggled
                        setState(() {
                          _onlinePayment = value ? 1 : 0;
                          print(_onlinePayment.toString());
                        });

                        UserDataManager()
                            .cardOnlineSave(_onlinePayment.toString());
                        _cardSettingBloc.add(CardSettingsEvent());
                      },
                    )
            ],
          ),
        ),
        Divider(
          color: CustomColor.black.withOpacity(0.3),
        ),*/
    /*    if (_isVirtual != "virtual")
         Container(
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Pin Block',
                      style: GoogleFonts.inter(
                          color: CustomColor.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    _pinBlockUnblock == null // Check if data is still loading
                        ? Container() // Show loading indicator if data is loading
                        : _SwitchWidget(
                            initialValue: _pinBlockUnblock == 1,
                            onChanged: (value) {
                              // Update _onlinePayment when the switch is toggled
                              setState(() {
                                _pinBlockUnblock = value ? 1 : 0;
                                print(_pinBlockUnblock.toString());
                              });

                              UserDataManager().pinBlockUnblockSave(
                                  _pinBlockUnblock.toString());
                              _cardSettingBloc.add(CardSettingsEvent());
                            },
                          )
                  ],
                ),
              ),
        if( _isVirtual != "virtual")
        Divider(
          color: CustomColor.black.withOpacity(0.3),
        ),*/
       /* Container(
          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recurring Payments',
                style: GoogleFonts.inter(
                    color: CustomColor.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              _recurringPayments == null // Check if data is still loading
                  ? Container() // Show loading indicator if data is loading
                  : _SwitchWidget(
                      initialValue: _recurringPayments == 1,
                      onChanged: (value) {
                        // Update _onlinePayment when the switch is toggled
                        setState(() {
                          _recurringPayments = value ? 1 : 0;
                          print(_recurringPayments.toString());
                        });

                        UserDataManager()
                            .cardRecurringSave(_recurringPayments.toString());
                        _cardSettingBloc.add(CardSettingsEvent());
                      },
                    )
            ],
          ),
        ),
        Divider(
          color: CustomColor.black.withOpacity(0.3),
        ),*/
      /*  Container(
          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Contactless',
                style: GoogleFonts.inter(
                    color: CustomColor.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              _contactless == null // Check if data is still loading
                  ? Container() // Show loading indicator if data is loading
                  : _SwitchWidget(
                      initialValue: _contactless == 1,
                      onChanged: (value) {
                        // Update _onlinePayment when the switch is toggled
                        setState(() {
                          _contactless = value ? 1 : 0;
                          print(_contactless.toString());
                        });

                        UserDataManager()
                            .cardContactlessSave(_contactless.toString());
                        _cardSettingBloc.add(CardSettingsEvent());
                      },
                    )
            ],
          ),
        ),
        Divider(
          color: CustomColor.black.withOpacity(0.3),
        ),*/
      /*  Container(
          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Contactless limit',
                    style: GoogleFonts.inter(
                        color: CustomColor.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    elevation: 5,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    // makes background transparent
                    builder: (context) {
                      return _isVirtual == "virtual"
                          ? const VirtualDailyLimitWidget()
                          : const DailyLimitWidget();
                    },
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      symbol,
                      style: GoogleFonts.inter(
                          color: CustomColor.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      state.userCardDetailsModel!.userCardDetails!.cardSetting!
                          .contactlessLimit
                          .toString(),
                      style: GoogleFonts.inter(
                          color: CustomColor.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              )
            ],
          ),
        ),*/
      ],
    );
  }
}

class _SwitchWidget extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool> onChanged;

  const _SwitchWidget({
    required this.initialValue,
    required this.onChanged,
  });

  @override
  _SwitchWidgetState createState() => _SwitchWidgetState();
}

class _SwitchWidgetState extends State<_SwitchWidget> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoSwitch(
      value: _value,
      onChanged: (value) {
        setState(() {
          _value = value;
        });
        widget.onChanged(value);
      },
    );
  }
}

class DailyLimitWidget extends StatefulWidget {
  const DailyLimitWidget({super.key});

  @override
  State<DailyLimitWidget> createState() => _DailyLimitWidgetState();
}

class _DailyLimitWidgetState extends State<DailyLimitWidget> {
  final DashboardBloc _cardSettingBloc = DashboardBloc();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _dailyLimitAmountController =
      TextEditingController();
  final TextEditingController _contactlassLimitAmountController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _cardSettingBloc.add(CardDetailsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _cardSettingBloc,
      listener: (context, DashboardState state) {
        if (state.statusModel?.status == 0) {
          CustomToast.showError(context, "Sorry!", state.statusModel!.message!);
        }

        if (state.cardSettingsModel?.status == 1) {
          UserDataManager().cardNumberShowSave("false");
          Navigator.pushNamedAndRemoveUntil(
              context, 'cardSettingsScreen', (route) => true);
        }
      },
      child: BlocBuilder(
          bloc: _cardSettingBloc,
          builder: (context, DashboardState state) {
            _dailyLimitAmountController.text = state
                .userCardDetailsModel!.userCardDetails!.cardSetting!.dailyLimit
                .toString();
            _contactlassLimitAmountController.text = state.userCardDetailsModel!
                .userCardDetails!.cardSetting!.contactlessLimit
                .toString();
            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                color: CustomColor.scaffoldBg,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
              ),
              child: ProgressHUD(
                inAsyncCall: state.isloading,
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: CustomImageWidget(
                                  imagePath: StaticAssets.xClose,
                                  imageType: 'svg',
                                  height: 24,
                                )),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Limits",
                                style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: CustomColor.black),
                              ),
                            ),
                          ),
                          Container(
                            width: 40,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InputTextCustom(
                          controller: _dailyLimitAmountController,
                          hint: 'daily limit',
                          label: 'POS Daily Limit',
                          isEmail: false,
                          isPassword: false,
                          onChanged: () {}),
                      InputTextCustom(
                          controller: _contactlassLimitAmountController,
                          hint: 'contactless limit',
                          label: 'Contactless Limit',
                          isEmail: false,
                          isPassword: false,
                          onChanged: () {}),
                      SizedBox(height: 10,),
                      PrimaryButtonWidget(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // All fields are valid, continue with the action
                            UserDataManager().cardDailyLimitSave(
                                _dailyLimitAmountController.text);
                            UserDataManager().cardContactlessLimitSave(
                                _contactlassLimitAmountController.text);

                            _cardSettingBloc.add(CardSettingsEvent());
                          }
                        },
                        buttonText: 'Continue',
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}

class VirtualDailyLimitWidget extends StatefulWidget {
  const VirtualDailyLimitWidget({super.key});

  @override
  State<VirtualDailyLimitWidget> createState() =>
      _VirtualDailyLimitWidgetState();
}

class _VirtualDailyLimitWidgetState extends State<VirtualDailyLimitWidget> {
  final DashboardBloc _cardSettingBloc = DashboardBloc();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _contactlassLimitAmountController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _cardSettingBloc.add(CardDetailsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _cardSettingBloc,
      listener: (context, DashboardState state) {
        if (state.statusModel?.status == 0) {
          CustomToast.showError(context, "Sorry!", state.statusModel!.message!);
        }

        if (state.cardSettingsModel?.status == 1) {
          UserDataManager().cardNumberShowSave("false");
          Navigator.pushNamedAndRemoveUntil(
              context, 'cardSettingsScreen', (route) => true);
        }
      },
      child: BlocBuilder(
          bloc: _cardSettingBloc,
          builder: (context, DashboardState state) {
            _contactlassLimitAmountController.text = state.userCardDetailsModel!
                .userCardDetails!.cardSetting!.contactlessLimit
                .toString();
            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                color: CustomColor.scaffoldBg,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
              ),
              child: ProgressHUD(
                inAsyncCall: state.isloading,
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: CustomImageWidget(
                                  imagePath: StaticAssets.xClose,
                                  imageType: 'svg',
                                  height: 24,
                                )),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Limits",
                                style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: CustomColor.black),
                              ),
                            ),
                          ),
                          Container(
                            width: 45,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InputTextCustom(
                          controller: _contactlassLimitAmountController,
                          hint: 'contactless limit',
                          label: 'Contactless Limit',
                          isEmail: false,
                          isPassword: false,
                          onChanged: () {}),
                      SizedBox(height: 10,),
                      PrimaryButtonWidget(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // All fields are valid, continue with the action
                            UserDataManager().cardDailyLimitSave("");
                            UserDataManager().cardContactlessLimitSave(
                                _contactlassLimitAmountController.text);

                            _cardSettingBloc.add(CardSettingsEvent());
                          }
                        },
                        buttonText: 'Continue',
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
