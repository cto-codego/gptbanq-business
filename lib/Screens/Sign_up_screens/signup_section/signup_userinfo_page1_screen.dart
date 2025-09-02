import 'package:gptbanqbusiness/Config/bloc/app_respotary.dart';
import 'package:gptbanqbusiness/Models/country_info_model.dart';
import 'package:gptbanqbusiness/constant_string/User.dart';
import 'package:gptbanqbusiness/cutom_weidget/input_textform.dart';
import 'package:gptbanqbusiness/utils/assets.dart';
import 'package:gptbanqbusiness/utils/input_fields/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../Models/base_model.dart';
import '../../../cutom_weidget/inputtext_select.dart';
import '../../../cutom_weidget/phone_input.dart';
import '../../../utils/custom_style.dart';
import '../../../utils/input_fields/gender_selector_widget.dart';
import '../../../utils/strings.dart';
import '../../../widgets/buttons/default_back_button_widget.dart';
import '../../../widgets/buttons/primary_button_widget.dart';
import '../bloc/signup_bloc.dart';

class SignupUserInfoPage1Screen extends StatefulWidget {
  const SignupUserInfoPage1Screen({super.key});

  @override
  State<SignupUserInfoPage1Screen> createState() =>
      _SignupUserInfoPage1ScreenState();
}

class _SignupUserInfoPage1ScreenState extends State<SignupUserInfoPage1Screen> {
  final _signupUserInfoKey = GlobalKey<FormState>();

  bool? show = false;

  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _nationalityController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool active = false;

  AppRespo appRepo = AppRespo();
  final SignupBloc _signupBloc = SignupBloc();
  List<CountryInfoModel> _countryList = [];

  @override
  void initState() {
    super.initState();
    User.Screen = 'page1';
    _loadCountries();
    _signupBloc.add(incomesourceEvent());
  }

  Future<void> _loadCountries() async {
    await appRepo.GetCountries();

    setState(() {
      _countryList = BaseModel.availableCountriesList;
    });
  }

  void _validateForm() {
    setState(() {
    });
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
                  Text("Step 1/3", style: CustomStyle.loginSubTitleStyle)
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                Strings.signUpTitleStep1,
                style: CustomStyle.loginTitleStyle,
              ),
              Text(Strings.signUpSubTitleStep1,
                  style: CustomStyle.loginSubTitleStyle),
              Form(
                  key: _signupUserInfoKey,
                  child: Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        InputSelect(
                          controller: _nationalityController,
                          hint: 'Select country',
                          label: 'Nationality',
                          nationality: true,
                          listitems: _countryList,
                          selectString: 'Select Country',
                          onCountrySelected: (value) {},
                          appRepo: appRepo,
                        ),
                        CustomPhoneInputFieldWidget(
                          controller: _phoneController,
                          hint: 'White your phone number',
                          label: 'Phone number',
                          onChange: (value) {
                            _validateForm();
                            if (_signupUserInfoKey.currentState!.validate()) {
                              setState(() {
                                active = true;
                              });
                            }
                          },
                          // countryList: _countryList,
                          onCountrySelected: (value) {
                            debugPrint('Selected Country: ${value.countryName}');
                          },
                          appRepo: appRepo,
                        ),
                        InputTextCustom(
                          controller: _dobController,
                          hint: 'dd-mm-yy',
                          label: 'Date of birth',
                          isEmail: false,
                          isPassword: false,
                          readOnly: true,
                          suffixIconPath: StaticAssets.calendar,
                          onTap: () async {
                            active = true;
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1920),
                                initialEntryMode:
                                    DatePickerEntryMode.calendarOnly,
                                lastDate: DateTime.now());

                            if (pickedDate != null) {
                              debugPrint(pickedDate
                                  .toString()); //pickedDate output format => 2021-03-10 00:00:00.000
                              String formattedDate =
                                  DateFormat('dd-MM-yyyy').format(pickedDate);
                              debugPrint(formattedDate
                                  .toString()); //formatted date output using intl package =>  2021-03-16
                              setState(() {
                                _dobController.text =
                                    formattedDate; //set output date to TextField value.
                              });
                            } else {}
                          },
                        ),
                        OptionSelectorWidget(
                          controller: _genderController,
                          label: 'Gender',
                          listItems: const ["Male", "Female"],
                        ),
                      ],
                    ),
                  )),
              PrimaryButtonWidget(
                onPressed: active
                    ? () {
                        if (_signupUserInfoKey.currentState!.validate()) {
                          User.Phonenumber = _phoneController.text;

                          User.Gender = _genderController.text;
                          User.dob = _dobController.text;

                          Navigator.pushNamed(
                              context, 'signUpUserInfoPage2Screen');
                        }
                      }
                    : null,
                buttonText: 'Next',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
