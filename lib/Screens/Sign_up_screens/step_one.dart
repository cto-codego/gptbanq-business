import 'package:gptbanqbusiness/Config/bloc/app_respotary.dart';
import 'package:gptbanqbusiness/constant_string/User.dart';
import 'package:gptbanqbusiness/cutom_weidget/input_textform.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class SteponeScreen extends StatefulWidget {
  const SteponeScreen({super.key});

  @override
  State<SteponeScreen> createState() => _SteponeScreenState();
}

class _SteponeScreenState extends State<SteponeScreen> {
  final _formkey = GlobalKey<FormState>();

  bool? show = false;

  final TextEditingController _name = TextEditingController();
  final TextEditingController _lastname = TextEditingController();
  final TextEditingController _dob = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _postalcode = TextEditingController();
  final TextEditingController _city = TextEditingController();

  bool active = false;

  AppRespo appRespo = AppRespo();

  @override
  void initState() {
    super.initState();
    User.Screen = 'Signup';
    appRespo.GetCountries();
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
              child: Container(
                width: double.maxFinite,
                height: double.maxFinite,
                padding: const EdgeInsets.only(left: 25, right: 25, top: 40),
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
                      "Let's setup your bank account",
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
                              InputTextCustom(
                                controller: _name,
                                hint: 'First Name',
                                label: 'First Name (as per bank account)',
                                isEmail: false,
                                isPassword: false,
                                onChanged: () {
                                  if (_formkey.currentState!.validate()) {
                                    setState(() {
                                      active = true;
                                    });
                                  }
                                },
                              ),
                              InputTextCustom(
                                  controller: _lastname,
                                  hint: 'Last Name',
                                  label: 'Last Name (as per bank account)',
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
                                  controller: _dob,
                                  hint: 'dd-mm-yy',
                                  label: 'Date of birth',
                                  isEmail: false,
                                  isPassword: false,
                                  readOnly: true,
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1920),
                                        initialEntryMode:
                                            DatePickerEntryMode.calendarOnly,

                                        //DateTime.now() - not to allow to choose before today.
                                        lastDate: DateTime.now());

                                    if (pickedDate != null) {
                                      debugPrint(pickedDate
                                          .toString()); //pickedDate output format => 2021-03-10 00:00:00.000
                                      String formattedDate =
                                          DateFormat('dd-MM-yyyy')
                                              .format(pickedDate);
                                      debugPrint(formattedDate
                                          .toString()); //formatted date output using intl package =>  2021-03-16
                                      setState(() {
                                        _dob.text =
                                            formattedDate; //set output date to TextField value.
                                      });
                                    } else {}
                                  },
                                  onChanged: () {
                                    if (_formkey.currentState!.validate()) {
                                      setState(() {
                                        active = true;
                                      });
                                    }
                                  }),
                              InputTextCustom(
                                  controller: _address,
                                  hint: ' ',
                                  label: 'Address',
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
                                  controller: _city,
                                  hint: ' ',
                                  label: 'City',
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
                                  controller: _postalcode,
                                  hint: ' ',
                                  label: 'Postal code',
                                  isEmail: false,
                                  isPassword: false,
                                  onChanged: () {
                                    if (_formkey.currentState!.validate()) {
                                      setState(() {
                                        active = true;
                                      });
                                    }
                                  }),
                              Container(
                                height: 60,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(11)),
                                child: ElevatedButton(
                                    onPressed: active
                                        ? () {
                                            if (_formkey.currentState!
                                                .validate()) {
                                              User.Name = _name.text;

                                              User.LastName = _lastname.text;

                                              User.dob = _dob.text;
                                              User.address = _address.text;
                                              User.city = _city.text;
                                              User.postcode = _postalcode.text;

                                              Navigator.pushNamed(
                                                  context, 'Step2');
                                            }
                                          }
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xff10245C),
                                        elevation: 0,
                                        disabledBackgroundColor:
                                            const Color(0xffC4C4C4),
                                        shadowColor: Colors.transparent,
                                        minimumSize: const Size.fromHeight(40),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(11))),
                                    child: const Text(
                                      'Continue',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontFamily: 'pop',
                                          fontWeight: FontWeight.w500),
                                    )),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
