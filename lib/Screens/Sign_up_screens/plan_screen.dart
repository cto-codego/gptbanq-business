import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:gptbanqbusiness/Screens/Sign_up_screens/bloc/signup_bloc.dart';
import 'package:gptbanqbusiness/cutom_weidget/select_plan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constant_string/User.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  final SignupBloc _signupBloc = SignupBloc();

  final TextEditingController _plancontroller = TextEditingController();

  bool completed = false;

  @override
  void initState() {
    super.initState();
    _signupBloc.add(GetplanlistEvent());
    _signupBloc.add(PlanLinkEvent());
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
            resizeToAvoidBottomInset: false,
            body: BlocListener(
                bloc: _signupBloc,
                listener: (context, SignupState state) {
                  if (state.statusModel?.status == 1) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, 'setpin', (route) => false);
                  } else if (state.statusModel?.status == 0) {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.rightSlide,
                      desc: state.statusModel?.message,
                      btnCancelText: 'OK',
                      buttonsTextStyle: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'pop',
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                      btnCancelOnPress: () {},
                    ).show();
                  }
                  // TODO: implement listener
                },
                child: BlocBuilder(
                    bloc: _signupBloc,
                    builder: (context, SignupState state) {
                      return SafeArea(
                        child: GestureDetector(
                          onTap: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                          child: Container(
                            width: double.maxFinite,
                            height: double.maxFinite,
                            padding: const EdgeInsets.only(
                                left: 25, right: 25, top: 40),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                User.planpage == 1
                                    ? InkWell(
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
                                      )
                                    : Container(),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 100,
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'Select a plan',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'pop',
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xff2C2C2C)),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 32,
                                      ),
                                      Selectplaninput(
                                        controller: _plancontroller,
                                        label: '',
                                        listitems: state.plansModel!.plan!,
                                        selectString: 'Select a plan',
                                        hint: 'Choose one plan',
                                        changed: () {
                                          setState(() {
                                            completed = true;
                                          });
                                        },
                                      ),
                                      const SizedBox(
                                        height: 72,
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          await launchUrl(Uri.parse(state
                                              .planlinkmodel!
                                              .personPriceLink!));
                                        },
                                        child: Container(
                                            alignment: Alignment.center,
                                            child: const Text(
                                              'click this link to check all the plans.',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Color(0xff2C2C2C),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'pop',
                                                  decoration:
                                                      TextDecoration.underline),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 60,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(11)),
                                  child: ElevatedButton(
                                      onPressed: completed
                                          ? () {
                                              _signupBloc.add(UpgradeplanEvent(
                                                  uniqueid: User.planuniquid));
                                            }
                                          : null,
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xff10245C),
                                          disabledBackgroundColor:
                                              const Color(0xffC4C4C4),
                                          elevation: 0,
                                          shadowColor: Colors.transparent,
                                          minimumSize:
                                              const Size.fromHeight(40),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(11))),
                                      child: const Text(
                                        'Confirm',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontFamily: 'pop',
                                            fontWeight: FontWeight.w500),
                                      )),
                                ),
                                const SizedBox(
                                  height: 30,
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }))));
  }
}
