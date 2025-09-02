import 'package:gptbanqbusiness/Models/application.dart';
import 'package:gptbanqbusiness/Screens/Sign_up_screens/bloc/signup_bloc.dart';
import 'package:gptbanqbusiness/Screens/Sign_up_screens/touchID_screen.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:gptbanqbusiness/utils/input_fields/custom_color.dart';
import 'package:gptbanqbusiness/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/custom_style.dart';
import '../../utils/input_fields/custom_pincode_input_field_widget.dart';
import '../../utils/strings.dart';
import '../../utils/user_data_manager.dart';
import '../../widgets/buttons/default_back_button_widget.dart';
import '../../widgets/buttons/primary_button_widget.dart';
import '../../widgets/toast/toast_util.dart';

class SetpinScreen extends StatefulWidget {
  const SetpinScreen({super.key});

  @override
  State<SetpinScreen> createState() => _SetpinScreenState();
}

class _SetpinScreenState extends State<SetpinScreen> {
  final _formkey = GlobalKey<FormState>();

  final TextEditingController _pincontrol = TextEditingController();

  bool completed = false;

  final SignupBloc _signupBloc = SignupBloc();

  @override
  void initState() {
    UserDataManager().clearUserIbanData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColor.scaffoldBg,
        resizeToAvoidBottomInset: false,
        body: BlocListener(
            bloc: _signupBloc,
            listener: (context, SignupState state) {
              if (state.setpinModel?.status == 1) {
                Application.isBiometricsSupported
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TouchidScreen(
                            userPin: _pincontrol.text,
                          ),
                        ),
                      )
                    : Navigator.pushNamedAndRemoveUntil(
                        context, 'getpin', (route) => false);
              } else if (state.setpinModel?.status == 0) {
                CustomToast.showError(
                    context, "Sorry!", state.setpinModel!.message!);
              }
            },
            child: BlocBuilder(
                bloc: _signupBloc,
                builder: (context, SignupState state) {
                  return SafeArea(
                    child: ProgressHUD(
                      inAsyncCall: state.isloading,
                      child: Container(
                        width: double.maxFinite,
                        height: double.maxFinite,
                        padding:
                            const EdgeInsets.only(left: 16, right: 16, top: 40),
                        child: Column(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      DefaultBackButtonWidget(onTap: () {
                                        Navigator.pop(context);
                                      }),
                                      Container()
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 50,
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      Strings.setOtpTitle,
                                      style:
                                          CustomStyle.loginVerifyTitleTextStyle,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 32,
                                  ),
                                  Form(
                                      key: _formkey,
                                      child: CustomPinCodeInputFieldWidget(
                                        appContext: context,
                                        controller: _pincontrol,
                                        onCompleted: (value) {
                                          setState(() {
                                            completed = true;
                                          });
                                          debugPrint('Completed: $value');
                                        },
                                        validator: (value) {
                                          return Validator.validateValues(
                                              value:
                                                  value!); // Replace with your validation logic
                                        },
                                      )),
                                  Container(
                                    alignment: Alignment.center,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 30),
                                    child: Text(
                                      Strings.setOtpSubTitle,
                                      textAlign: TextAlign.center,
                                      style:
                                          CustomStyle.setPinSubTitleTextStyle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            PrimaryButtonWidget(
                              onPressed: completed
                                  ? () {
                                      if (_formkey.currentState!.validate()) {
                                        _signupBloc.add(
                                            setPinEvent(pin: _pincontrol.text));
                                      }
                                    }
                                  : null,
                              buttonText: 'Confirm',
                            ),
                            const SizedBox(
                              height: 30,
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                })));
  }
}
