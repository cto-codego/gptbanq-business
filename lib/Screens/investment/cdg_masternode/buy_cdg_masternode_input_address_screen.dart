import 'package:gptbanqbusiness/Screens/investment/bloc/investment_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Config/bloc/app_respotary.dart';
import '../../../Models/base_model.dart';
import '../../../constant_string/User.dart';
import '../../../cutom_weidget/input_textform.dart';
import '../../../cutom_weidget/inputtext_select.dart';
import '../../../utils/input_fields/custom_color.dart';
import '../../../widgets/buttons/default_back_button_widget.dart';
import '../../../widgets/buttons/primary_button_widget.dart';
import '../../../widgets/success/success_widget.dart';
import '../../../widgets/toast/toast_util.dart';

class BuyCdgMasternodeInputAddressScreen extends StatefulWidget {
  BuyCdgMasternodeInputAddressScreen(
      {super.key,
      required this.deviceId,
      required this.numberOfNode,
      required this.ibanId});

  String deviceId, numberOfNode, ibanId;

  @override
  State<BuyCdgMasternodeInputAddressScreen> createState() =>
      _BuyCdgMasternodeInputAddressScreenState();
}

class _BuyCdgMasternodeInputAddressScreenState
    extends State<BuyCdgMasternodeInputAddressScreen> {
  final InvestmentBloc _investmentBloc = InvestmentBloc();
  String? countryShortName;

  final _activeNFormKey = GlobalKey<FormState>();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _surnameOrCompanyController =
      TextEditingController();
  bool isButtonEnabled = false;

  Future<void> _onRefresh() async {
    debugPrint('_onRefresh');
  }

  AppRespo appRespo = AppRespo();

  @override
  void initState() {
    super.initState();

    _addressController.addListener(_checkFormValidity);
    _cityController.addListener(_checkFormValidity);
    _stateController.addListener(_checkFormValidity);
    _zipController.addListener(_checkFormValidity);
    _countryController.addListener(_checkFormValidity);
    _phoneNumberController.addListener(_checkFormValidity);
    _surnameOrCompanyController.addListener(_checkFormValidity);
    appRespo.GetCountries();
  }

  void _checkFormValidity() {
    setState(() {
      isButtonEnabled = _addressController.text.isNotEmpty &&
          _zipController.text.isNotEmpty &&
          _cityController.text.isNotEmpty &&
          _countryController.text.isNotEmpty &&
          _phoneNumberController.text.isNotEmpty &&
          _surnameOrCompanyController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.scaffoldBg,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: BlocListener(
          bloc: _investmentBloc,
          listener: (context, InvestmentState state) {
            if (state.statusModel?.status == 1) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => SuccessWidget(
                    imageType: SuccessImageType.success,
                    title: 'Order Success',
                    subTitle: state.statusModel!.message!,
                    btnText: 'Home',
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(context,
                          "cdgMasternodeDashboardScreen", (route) => false);
                    },
                    disableButton: false,
                  ),
                ),
                (route) => false,
              );
            } else if (state.statusModel?.status == 0) {
              CustomToast.showError(
                  context, "Sorry!", state.statusModel!.message!);
            }
          },
          child: BlocBuilder(
              bloc: _investmentBloc,
              builder: (context, InvestmentState state) {
                return SafeArea(
                  child: ProgressHUD(
                    inAsyncCall: state.isloading,
                    child: RefreshIndicator(
                      onRefresh: _onRefresh,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        child: ListView(
                          children: [
                            appBarSection(context, state),
                            Form(
                              key: _activeNFormKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InputTextCustom(
                                      controller: _surnameOrCompanyController,
                                      hint: 'Write your surname/compnay',
                                      label: 'surname/company',
                                      isEmail: false,
                                      isPassword: false,
                                      onChanged: () {
                                        _checkFormValidity();
                                      }),
                                  InputTextCustom(
                                      controller: _phoneNumberController,
                                      hint: 'Mobile Number',
                                      label:
                                          'Mobile Number (Enter your mobile number with country code, e.g., +1 1 XXXX XXXX)',
                                      keyboardType: TextInputType.phone,
                                      isEmail: false,
                                      isPassword: false,
                                      onChanged: () {
                                        _checkFormValidity();
                                      }),
                                  InputTextCustom(
                                      controller: _addressController,
                                      hint: 'Write your address',
                                      label: 'Address',
                                      isEmail: false,
                                      isPassword: false,
                                      onChanged: () {
                                        _checkFormValidity();
                                      }),
                                  InputTextCustom(
                                      controller: _cityController,
                                      hint: 'City',
                                      label: 'City',
                                      isEmail: false,
                                      isPassword: false,
                                      onChanged: () {
                                        _checkFormValidity();
                                      }),
                                  InputTextCustom(
                                      controller: _stateController,
                                      hint: 'State',
                                      label: 'State',
                                      isEmail: false,
                                      isPassword: false,
                                      onChanged: () {
                                        _checkFormValidity();
                                      }),
                                  InputTextCustom(
                                      controller: _zipController,
                                      keyboardType: TextInputType.number,
                                      hint: 'Postal code',
                                      label: 'Postal code',
                                      isEmail: false,
                                      isPassword: false,
                                      onChanged: () {
                                        _checkFormValidity();
                                      }),
                                  InputSelect(
                                    controller: _countryController,
                                    hint: 'Select country',
                                    label: 'Country',
                                    nationality: false,
                                    listitems: BaseModel.availableCountriesList,
                                    selectString: 'Select Country',
                                    onCountrySelected: (value) {
                                      _checkFormValidity();

                                      setState(() {
                                        User.CountryNameValue;
                                      });
                                    },
                                    appRepo: appRespo,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  PrimaryButtonWidget(
                                    onPressed: isButtonEnabled
                                        ? () {
                                            if (_activeNFormKey.currentState!
                                                .validate()) {
                                              _investmentBloc
                                                  .add(CdgMasternodeOrderEvent(
                                                deviceId: widget.deviceId,
                                                numberOfNode:
                                                    widget.numberOfNode,
                                                ibanId: widget.ibanId,
                                                country: User.CountryNameValue!,
                                                address:
                                                    _addressController.text,
                                                city: _cityController.text,
                                                state: _stateController.text,
                                                zipCode: _zipController.text,
                                                surnameOrCompany:
                                                    _surnameOrCompanyController
                                                        .text,
                                                phone:
                                                    _phoneNumberController.text,
                                              ));
                                            }
                                          }
                                        : null,
                                    buttonText: 'Confirm',
                                  ),
                                ],
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 30, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DefaultBackButtonWidget(onTap: () {
            Navigator.pop(context);
          }),
          Text(
            'Address Details',
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
