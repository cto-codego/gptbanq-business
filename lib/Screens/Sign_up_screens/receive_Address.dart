import 'package:gptbanqbusiness/Config/bloc/app_respotary.dart';
import 'package:gptbanqbusiness/Models/base_model.dart';
import 'package:gptbanqbusiness/Screens/Sign_up_screens/bloc/signup_bloc.dart';
import 'package:gptbanqbusiness/constant_string/User.dart';
import 'package:gptbanqbusiness/cutom_weidget/input_textform.dart';
import 'package:gptbanqbusiness/cutom_weidget/inputtext_select.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShippingAddressScreen extends StatefulWidget {
  const ShippingAddressScreen({super.key});

  @override
  State<ShippingAddressScreen> createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<ShippingAddressScreen> {
  final _formkey = GlobalKey<FormState>();

  bool? male = true;
  bool? Shipping = true;
  bool active = false;

  final TextEditingController _reciveaddress = TextEditingController();
  final TextEditingController _recivecity = TextEditingController();
  final TextEditingController _recivecountry = TextEditingController();
  final TextEditingController _recivepost = TextEditingController();

  final SignupBloc _signupBloc = SignupBloc();

  FocusNode myFocusNode = FocusNode();

  FocusNode passwordFocusNode = FocusNode();

  AppRespo appRespo = AppRespo();

  @override
  void initState() {
    _formkey.currentState?.validate();
    super.initState();

    _signupBloc.add(incomesourceEvent());
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
            statusBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Colors.white),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: BlocBuilder(
                bloc: _signupBloc,
                builder: (context, SignupState state) {
                  return Container(
                    width: double.maxFinite,
                    height: double.maxFinite,
                    padding:
                        const EdgeInsets.only(left: 25, right: 25, top: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 24,
                            height: 24,
                            alignment: Alignment.center,
                            child: Image.asset(
                              'images/backarrow.png',
                              width: 24,
                              height: 24,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          "Enter your shipping address",
                          style: TextStyle(
                              fontSize: 25,
                              fontFamily: 'pop',
                              fontWeight: FontWeight.w500,
                              color: Color(0xff2C2C2C)),
                        ),
                        const SizedBox(
                          height: 22,
                        ),
                        Form(
                            key: _formkey,
                            child: Expanded(
                              child: ListView(
                                shrinkWrap: true,
                                children: [
                                  InputSelect(
                                    controller: _recivecountry,
                                    hint: ' ',
                                    label: 'Country',
                                    listitems: BaseModel.availableCountriesList,
                                    selectString: 'Select Country',
                                    nationality: false,
                                    onCountrySelected: (CountryInfoModel) {},
                                    appRepo: appRespo,
                                  ),
                                  InputTextCustom(
                                      controller: _reciveaddress,
                                      hint: '',
                                      label: 'Shipping address',
                                      isEmail: false,
                                      isPassword: false,
                                      onChanged: () {
                                        if (_formkey.currentState!.validate()) {
                                          setState(() {
                                            active = true;
                                          });
                                        }
                                      }),
                                  InputTextCustom(
                                      controller: _recivecity,
                                      hint: '',
                                      label: 'Shipping city',
                                      isEmail: false,
                                      isPassword: false,
                                      onChanged: () {
                                        if (_formkey.currentState!.validate()) {
                                          setState(() {
                                            active = true;
                                          });
                                        }
                                      }),
                                  InputTextCustom(
                                      controller: _recivepost,
                                      hint: '',
                                      label: 'Shipping Postal code',
                                      isEmail: false,
                                      isPassword: false,
                                      onChanged: () {
                                        if (_formkey.currentState!.validate()) {
                                          setState(() {
                                            active = true;
                                          });
                                        }
                                      }),
                                ],
                              ),
                            )),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          bottomNavigationBar: Container(
            margin: const EdgeInsets.symmetric(horizontal: 25),
            height: 60,
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(11)),
            child: ElevatedButton(
                onPressed: active
                    ? () {
                        if (_formkey.currentState!.validate()) {
                          User.Reciving_card_address = _reciveaddress.text;
                          User.Reciving_card_city = _recivecity.text;
                          User.Reciving_zipcode = _recivepost.text;

                          Navigator.pushNamed(context, 'Step3');
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff10245C),
                    elevation: 0,
                    disabledBackgroundColor: const Color(0xffC4C4C4),
                    shadowColor: Colors.transparent,
                    minimumSize: const Size.fromHeight(40),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11))),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: 'pop',
                      fontWeight: FontWeight.w500),
                )),
          ),
        ));
  }
}
