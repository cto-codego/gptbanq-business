import 'package:gptbanqbusiness/Models/pos/crypto_gateway_currency_list_model.dart';
import 'package:gptbanqbusiness/Screens/Pos_Screen/bloc/pos_bloc.dart';
import 'package:gptbanqbusiness/Screens/Pos_Screen/crypto_gateway/store_screen.dart';
import 'package:gptbanqbusiness/utils/assets.dart';
import 'package:gptbanqbusiness/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gptbanqbusiness/constant_string/User.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import '../../../utils/custom_style.dart';
import '../../../utils/input_fields/custom_color.dart';
import '../../../widgets/buttons/default_back_button_widget.dart';
import '../../../widgets/buttons/primary_button_widget.dart';
import '../../../widgets/input_fields/defult_input_field_with_title_widget.dart';
import '../../../widgets/pos/crypto_gateway_currency_selector_widget.dart';
import '../../../widgets/toast/toast_util.dart';

class MerchantStoreScreen extends StatefulWidget {
  MerchantStoreScreen();

  // String profit;
  // String time;

  @override
  State<MerchantStoreScreen> createState() => _MerchantStoreScreenState();
}

class _MerchantStoreScreenState extends State<MerchantStoreScreen> {
  bool active = false;

  bool shownotification = true;
  final PosBloc _posBloc = PosBloc();

  Future<void> _onRefresh() async {
    debugPrint('_onRefresh');

    _posBloc.add(CryptoPosListEvent());
  }

  @override
  void initState() {
    super.initState();
    User.Screen = 'merchant store screen';
    _posBloc.add(CryptoPosListEvent());
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

            if (state.cryptoGatewayCurrencyListModel?.status == 0) {
              CustomToast.showError(context, "Sorry!",
                  state.cryptoGatewayCurrencyListModel!.message!);
            }

            if (state.cryptoGatewayCurrencyListModel?.status == 1) {
              showBottomSheet(
                context: context,
                elevation: 5,
                builder: (context) {
                  return BottomSheetContentStep1(
                    currencyList:
                        state.cryptoGatewayCurrencyListModel!.currency ?? [],
                  );
                },
              );
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
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                        child: Stack(
                          // Change to Stack
                          alignment: Alignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 85),
                              child: Column(
                                children: [
                                  appBarSection(context, state),
                                  Expanded(
                                    child: ListView.builder(
                                        itemCount: state.cryptoPosListModel!
                                            .cryptopos!.length,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                PageTransition(
                                                  type:
                                                      PageTransitionType.scale,
                                                  alignment: Alignment.center,
                                                  isIos: true,
                                                  duration: const Duration(
                                                      microseconds: 500),
                                                  child: StoreScreen(
                                                    storeId: state
                                                        .cryptoPosListModel!
                                                        .cryptopos![index]
                                                        .id!,
                                                    storeName: state
                                                        .cryptoPosListModel!
                                                        .cryptopos![index]
                                                        .label!,
                                                    storeCurrency: state
                                                        .cryptoPosListModel!
                                                        .cryptopos![index]
                                                        .currency!,
                                                    storeCurrencyImage: state
                                                        .cryptoPosListModel!
                                                        .cryptopos![index]
                                                        .flag!,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 10),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 0,
                                                      vertical: 5),
                                              decoration: BoxDecoration(
                                                  color: CustomColor
                                                      .kycContainerBgColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              child: Row(
                                                children: [
                                                  if (state
                                                      .cryptoPosListModel!
                                                      .cryptopos![index]
                                                      .flag!
                                                      .isNotEmpty)
                                                    Container(
                                                      height: 40,
                                                      width: 40,
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 5),
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                            image: NetworkImage(state
                                                                    .cryptoPosListModel!
                                                                    .cryptopos![
                                                                        index]
                                                                    .flag ??
                                                                ""),
                                                            fit: BoxFit.cover),
                                                      ),
                                                    ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Store Name: ${state.cryptoPosListModel!.cryptopos![index].label!}",
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: GoogleFonts.inter(
                                                              color: CustomColor
                                                                  .black,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              height: 1),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 5),
                                                          child: Text(
                                                            "Store Pin: ${state.cryptoPosListModel!.cryptopos![index].pin!}",
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: GoogleFonts.inter(
                                                                color: CustomColor
                                                                    .black
                                                                    .withOpacity(
                                                                        0.7),
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                height: 1),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              // Keep the Positioned widget here
                              bottom: 0,
                              child: InkWell(
                                onTap: () {
                                  _posBloc
                                      .add(CryptoGatewayCurrencyListEvent());
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                  margin: EdgeInsets.symmetric(vertical: 20),
                                  decoration: BoxDecoration(
                                    color: CustomColor.primaryColor,
                                    borderRadius: BorderRadius.circular(48),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5),
                                        child: Icon(
                                          Icons.add,
                                          size: 20,
                                          color: CustomColor.whiteColor,
                                        ),
                                      ),
                                      Text(
                                        "Create new store",
                                        style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            color: CustomColor.whiteColor),
                                      )
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
              })),
    );
  }

  appBarSection(BuildContext context, state) {
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DefaultBackButtonWidget(
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, 'posDashboardScreen', (route) => false);
            },
          ),
          Text(
            'Merchant Store',
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
    );
  }
}

/*----------------step 1----------------*/

class BottomSheetContentStep1 extends StatefulWidget {
  BottomSheetContentStep1({super.key, required this.currencyList});

  List<CryptoGatewayCurrency> currencyList;

  @override
  State<BottomSheetContentStep1> createState() =>
      _BottomSheetContentStep1State();
}

class _BottomSheetContentStep1State extends State<BottomSheetContentStep1> {
  final PosBloc _posBloc = PosBloc();
  TextEditingController _labelController = TextEditingController();
  final _formkey = new GlobalKey<FormState>();
  bool _isButtonEnabled = false;

  final TextEditingController _currencyController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _validateForm() {
    setState(() {
      _isButtonEnabled = _labelController.text.isNotEmpty &&
          _formkey.currentState?.validate() == true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _posBloc,
      listener: (context, PosState state) {
        if (state.statusModel?.status == 1) {
          CustomToast.showSuccess(context, "Hey!", state.statusModel!.message!);
          Navigator.pushNamedAndRemoveUntil(
              context, 'merchantStoreScreen', (route) => false);
        }

        if (state.statusModel?.status == 0) {
          CustomToast.showError(context, "Sorry!", state.statusModel!.message!);
        }
      },
      child: BlocBuilder(
          bloc: _posBloc,
          builder: (context, PosState state) {
            return Container(
              // height: MediaQuery.of(context).size.height * 0.7,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: CustomColor.scaffoldBg,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(
                      20), // Match the border radius of Material
                ),
                border: Border(
                  top: BorderSide(
                    color: Color(0xff797777),
                    width: 1, // Set the thickness of the top border
                  ),
                ),
              ),
              child: ProgressHUD(
                inAsyncCall: state.isloading,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Container(
                                alignment: Alignment.topLeft,
                                child: CustomImageWidget(
                                  imagePath: StaticAssets.xClose,
                                  imageType: 'svg',
                                  height: 24,
                                ))),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Create Merchant Store",
                          style: CustomStyle.loginTitleStyle,
                        ),
                        const SizedBox(
                          height: 22,
                        ),
                        CryptoGatewayCurrencySelectorWidget(
                          controller: _currencyController,
                          label: 'Select Currency',
                          hint: 'Select Currency',
                          currencies: widget.currencyList,
                          onCurrencySelected: (value) {},
                        ),
                        DefaultInputFieldWithTitleWidget(
                          controller: _labelController,
                          title: 'Store Name',
                          hint: 'Write your store name',
                          isEmail: false,
                          keyboardType: TextInputType.name,
                          autofocus: false,
                          isPassword: false,
                          onChanged: (value) {
                            _validateForm();
                          },
                        ),
                        PrimaryButtonWidget(
                          onPressed: _isButtonEnabled
                              ? () {
                                  if (_formkey.currentState!.validate()) {
                                    _isButtonEnabled = false;
                                    _posBloc.add(CreateCryptoStoreEvent(
                                        label: _labelController.text,
                                        currency: _currencyController.text));
                                  }
                                }
                              : null,
                          buttonText: 'Continue',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
