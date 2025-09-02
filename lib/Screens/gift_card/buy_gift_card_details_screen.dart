import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:gptbanqbusiness/Models/gift_card/gift_card_get_fee_type_model.dart';
import 'package:gptbanqbusiness/Screens/Dashboard_screen/bloc/dashboard_bloc.dart';
import 'package:gptbanqbusiness/constant_string/User.dart';
import 'package:gptbanqbusiness/utils/assets.dart';
import 'package:gptbanqbusiness/utils/custom_scroll_behavior.dart';
import 'package:gptbanqbusiness/utils/user_data_manager.dart';
import 'package:gptbanqbusiness/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import '../../cutom_weidget/cutom_progress_bar.dart';
import '../../utils/input_fields/custom_color.dart';
import '../../widgets/buttons/default_back_button_widget.dart';
import '../../widgets/buttons/primary_button_widget.dart';
import '../../widgets/input_fields/defult_input_field_with_title_widget.dart';
import '../../widgets/toast/toast_util.dart';
import 'buy_gift_card_confirm_details_screen.dart';

class BuyGiftCardDetailsScreen extends StatefulWidget {
  const BuyGiftCardDetailsScreen({super.key});

  @override
  State<BuyGiftCardDetailsScreen> createState() =>
      _BuyGiftCardDetailsScreenState();
}

class _BuyGiftCardDetailsScreenState extends State<BuyGiftCardDetailsScreen> {
  final DashboardBloc _buyGiftCardGetType = DashboardBloc();

  final TextEditingController _selectCardController = TextEditingController();
  final TextEditingController _selectIbanController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  final FocusNode myFocusNode = FocusNode();

  final bool _detailsScreenPushed = false; // Track if details screen is pushed

  final _formKey = GlobalKey<FormState>();
  bool active = false;

  bool flap = false;

  @override
  void initState() {
    User.Screen = 'Buy gift card confirm';

    super.initState();
    _buyGiftCardGetType.add(GiftCardGetFeeTypeEvent());
    _amountController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _buyGiftCardGetType.close();

    _amountController.removeListener(_updateButtonState);
    _amountController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        active = _formKey.currentState!.validate();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.scaffoldBg,
      body: BlocListener(
        bloc: _buyGiftCardGetType,
        listener: (context, DashboardState state) {
          if (!_detailsScreenPushed &&
              state.giftCardGetFeeDataModel?.status == 1) {
            Navigator.push(
              context,
              PageTransition(
                child: BuyGiftCardConfirmDetailsScreen(
                  amount: _amountController.text,
                ),
                type: PageTransitionType.rightToLeft,
                alignment: Alignment.center,
                duration: const Duration(milliseconds: 300),
                reverseDuration: const Duration(milliseconds: 200),
              ),
            );
          } else if (state.statusModel?.status == 0) {
            CustomToast.showError(
                context, "Sorry!", state.statusModel!.message!);
          }
        },
        child: BlocBuilder(
            bloc: _buyGiftCardGetType,
            builder: (context, DashboardState state) {
              return SafeArea(
                child: ProgressHUD(
                  inAsyncCall: state.isloading,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: ScrollConfiguration(
                      behavior: CustomScrollBehavior(),
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10, top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                DefaultBackButtonWidget(onTap: () {
                                  Navigator.pushNamed(
                                      context, "buyGiftCardScreen");
                                }),
                                Text(
                                  'Buy Gift Card',
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
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Image.network(
                              state.giftCardGetFeeTypeModel!.image!.toString(),
                              width: MediaQuery.of(context).size.width,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) {
                                  // Image has finished loading
                                  return child;
                                } else {
                                  // Image is still loading, show the loading indicator
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                              errorBuilder: (BuildContext context, Object error,
                                  StackTrace? stackTrace) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: _selectCardWidget(
                                        context,
                                        state
                                            .giftCardGetFeeTypeModel!.cardType!,
                                        _selectCardController),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: _selectIBANWidget(
                                        context,
                                        state.giftCardGetFeeTypeModel!.iban!,
                                        _selectIbanController),
                                  ),
                                  DefaultInputFieldWithTitleWidget(
                                      controller: _amountController,
                                      title: 'Amount',
                                      hint: 'Enter Amount',
                                      isEmail: false,
                                      keyboardType: TextInputType.number,
                                      autofocus: false,
                                      isPassword: false,)
                                      // onChanged: (value) {
                                      //   _updateButtonState();
                                      // }),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: PrimaryButtonWidget(
                              onPressed: active
                                  ? () {
                                active = false;
                                UserDataManager()
                                    .giftCardAmountSave(_amountController.text);
                                _buyGiftCardGetType.add(GiftCardGetFeeDataEvent(
                                    amount: _amountController.text));
                              } : null,
                              buttonText: 'Submit',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }

  Widget _selectCardWidget(BuildContext context, List<String> cardTypes,
      TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 5),
          child: Text(
            "Select Card",
            style: GoogleFonts.inter(
              color: CustomColor.inputFieldTitleTextColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        DropdownButtonFormField<String>(
          value: controller.text.isNotEmpty
              ? controller.text
              : (cardTypes.isNotEmpty ? cardTypes[0] : null),
          iconEnabledColor: CustomColor.black,
          icon: CustomImageWidget(
            imagePath: StaticAssets.chevronDown,
            imageType: 'svg',
            height: 24,
          ),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11),
              borderSide: const BorderSide(
                  color: CustomColor.dashboardProfileBorderColor),
            ),
          ),
          onChanged: (newValue) {
            _updateButtonState();
            debugPrint(newValue);
            controller.text = newValue ?? '';
            UserDataManager().giftCardSave(controller.text);
          },
          items: cardTypes.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: CustomColor.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  _selectIBANWidget(BuildContext context, List<Iban> ibanList,
      TextEditingController controller) {
    String? selectedLabel;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 5),
          child: Text(
            "Select IBAN",
            style: GoogleFonts.inter(
              color: CustomColor.inputFieldTitleTextColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        DropdownButtonFormField<String>(
          value: controller.text.isNotEmpty
              ? controller.text
              : ibanList.isNotEmpty
                  ? ibanList.first.ibanId!
                  : null,
          iconEnabledColor: CustomColor.black,
          icon: CustomImageWidget(
            imagePath: StaticAssets.chevronDown,
            imageType: 'svg',
            height: 24,
          ),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11),
              borderSide: const BorderSide(
                  color: CustomColor.dashboardProfileBorderColor),
            ),
          ),
          onChanged: (selectedValue) {
            _updateButtonState();
            if (selectedValue != null) {
              final selectedIban = ibanList.isNotEmpty
                  ? ibanList.firstWhere((iban) => iban.ibanId == selectedValue)
                  : null;
              if (selectedIban != null) {
                controller.text = selectedIban.ibanId!;
                UserDataManager()
                    .giftCardIbanSave(selectedIban.ibanId.toString());
              }
            }
          },
          items: ibanList.map<DropdownMenuItem<String>>((Iban iban) {
            return DropdownMenuItem<String>(
              value: iban.ibanId!,
              child: Text(
                iban.label!,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: CustomColor.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
