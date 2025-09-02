import 'package:gptbanqbusiness/Config/bloc/app_respotary.dart';
import 'package:gptbanqbusiness/constant_string/User.dart';
import 'package:gptbanqbusiness/cutom_weidget/input_textform.dart';
import 'package:flutter/material.dart';

import '../../../Models/base_model.dart';
import '../../../cutom_weidget/inputtext_select.dart';
import '../../../utils/custom_style.dart';
import '../../../utils/input_fields/custom_color.dart';
import '../../../utils/strings.dart';
import '../../../widgets/buttons/default_back_button_widget.dart';
import '../../../widgets/buttons/primary_button_widget.dart';

class SignupUserInfoPage2Screen extends StatefulWidget {
  const SignupUserInfoPage2Screen({super.key});

  @override
  State<SignupUserInfoPage2Screen> createState() =>
      _SignupUserInfoPage2ScreenState();
}

class _SignupUserInfoPage2ScreenState extends State<SignupUserInfoPage2Screen> {
  final _signupUserInfoPage2Key = GlobalKey<FormState>();

  bool? show = false;

  final TextEditingController _residenceAddressController =
      TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();

  bool active = false;

  AppRespo appRespo = AppRespo();

  @override
  void initState() {
    super.initState();
    User.Screen = 'page3';
    appRespo.GetCountries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.scaffoldBg,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Container(
          width: double.maxFinite,
          height: double.maxFinite,
          padding: const EdgeInsets.only(left: 16, right: 16, top: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DefaultBackButtonWidget(onTap: () {
                    Navigator.pop(context);
                  }),
                  Text("Step 2/3", style: CustomStyle.loginSubTitleStyle)
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                Strings.signUpTitleStep2,
                style: CustomStyle.loginTitleStyle,
              ),
              Text(Strings.signUpSubTitleStep2,
                  style: CustomStyle.loginSubTitleStyle),
              Form(
                  key: _signupUserInfoPage2Key,
                  child: Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        InputSelect(
                          controller: _countryController,
                          hint: 'Select country',
                          label: 'Country',
                          nationality: false,
                          listitems: BaseModel.availableCountriesList,
                          selectString: 'Select Country',
                          onCountrySelected: (value) {},
                          appRepo: appRespo,
                        ),
                        InputTextCustom(
                            controller: _residenceAddressController,
                            hint: 'Write your residence address',
                            label: 'Residence Address',
                            isEmail: false,
                            isPassword: false,
                            onChanged: () {
                              if (_signupUserInfoPage2Key.currentState!
                                  .validate()) {
                                setState(() {
                                  active = true;
                                });
                              }
                            }),
                        InputTextCustom(
                            controller: _cityController,
                            hint: 'City',
                            label: 'City',
                            isEmail: false,
                            isPassword: false,
                            onChanged: () {
                              if (_signupUserInfoPage2Key.currentState!
                                  .validate()) {
                                setState(() {
                                  active = true;
                                });
                              }
                            }),
                        InputTextCustom(
                            controller: _postalCodeController,
                            hint: 'Postal code',
                            label:
                                'Postal code (f you don\'t have postal code then type N/A)',
                            isEmail: false,
                            isPassword: false,
                            onChanged: () {
                              if (_signupUserInfoPage2Key.currentState!
                                  .validate()) {
                                setState(() {
                                  active = true;
                                });
                              }
                            }),
                      ],
                    ),
                  )),
              PrimaryButtonWidget(
                onPressed: () {
                  if (_signupUserInfoPage2Key.currentState!.validate()) {
                    User.address = _residenceAddressController.text;
                    User.city = _cityController.text;
                    User.postcode = _postalCodeController.text;

                    Navigator.pushNamed(context, 'signUpUserInfoPage3Screen');
                  }
                },
                buttonText: 'Next',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
