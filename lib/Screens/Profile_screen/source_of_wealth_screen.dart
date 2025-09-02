import 'dart:ui' as ui;
import 'dart:convert';

import 'package:gptbanqbusiness/Screens/Sign_up_screens/bloc/signup_bloc.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:gptbanqbusiness/cutom_weidget/selectsourcefund.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

import '../../cutom_weidget/text_uploadimages.dart';
import '../../utils/custom_style.dart';
import '../../utils/input_fields/custom_color.dart';
import '../../widgets/buttons/default_back_button_widget.dart';
import '../../widgets/buttons/primary_button_widget.dart';
import '../../widgets/input_fields/defult_input_field_with_title_widget.dart';
import '../../widgets/toast/toast_util.dart';

class SourceOfWealthScreen extends StatefulWidget {
  const SourceOfWealthScreen({super.key});

  @override
  State<SourceOfWealthScreen> createState() => _SourceOfWealthScreenState();
}

class _SourceOfWealthScreenState extends State<SourceOfWealthScreen> {
  final _formkey = GlobalKey<FormState>();
  final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();
  String signature = "Tap to add signature";
  String signLabel = "Tap to add signature";
  XFile? image;

  bool? male = true;
  bool? Shipping = true;
  bool active = false;
  final TextEditingController _image = TextEditingController(text: '');
  final TextEditingController _signController = TextEditingController(text: '');
  final picker = ImagePicker();

  final TextEditingController _fund = TextEditingController();
  final TextEditingController _ocupation = TextEditingController();

  final SignupBloc _signupBloc = SignupBloc();

  FocusNode myFocusNode = FocusNode();

  FocusNode passwordFocusNode = FocusNode();

  @override
  void initState() {
    _formkey.currentState?.validate();
    super.initState();

    _signupBloc.add(SourcefundEvent());

    // Request gallery access permission when the widget initializes
    _requestPermission();
  }

  Future<void> _requestPermission() async {
    // Request gallery access permission
    // final status = await Permission.photos.request();
    final status = await Permission.photos.request();
    if (status.isGranted) {
      // Permission granted, you can proceed with image picking
      print('Permission granted');
    } else {
      // Permission denied, handle accordingly (e.g., show a message to the user)
      print('Permission denied');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.scaffoldBg,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: BlocListener(
          bloc: _signupBloc,
          listener: (context, SignupState state) {
            if (state.statusModel?.status == 1) {
              active = true;
              CustomToast.showSuccess(
                  context, "Thank You!", state.statusModel!.message!);
              Navigator.pushNamedAndRemoveUntil(context,
                  'profileScreen', (route) => false);

            } else if (state.statusModel?.status == 0) {
              active = true;
              CustomToast.showError(
                  context, "Sorry!", state.statusModel!.message!);
            }
          },
          child: BlocBuilder(
            bloc: _signupBloc,
            builder: (context, SignupState state) {
              return Container(
                width: double.maxFinite,
                height: double.maxFinite,
                padding: const EdgeInsets.only(left: 16, right: 16, top: 40),
                child: ProgressHUD(
                  inAsyncCall: state.isloading,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DefaultBackButtonWidget(onTap: () {
                              Navigator.pop(context);
                            }),
                            Container(
                              width: 20,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Source Of Wealth Declaration",
                        style: CustomStyle.loginTitleStyle,
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
                                DefaultInputFieldWithTitleWidget(
                                    controller: _ocupation,
                                    title: 'Your occupations ?',
                                    hint: 'Write your occupations',
                                    isEmail: false,
                                    keyboardType: TextInputType.name,
                                    autofocus: true,
                                    isPassword: false,
                                    onChanged: (value) {
                                      if (_formkey.currentState!.validate()) {
                                        setState(() {
                                          active = true;
                                        });
                                      }
                                    }),
                                inputselectsource(
                                  controller: _fund,
                                  hint: 'Source of funds',
                                  label: 'Source of funds',
                                  listItems: state.sourceFund!.soruceFund!,
                                  selectString: 'Source of funds',
                                ),
                                Inputuploadimage(
                                  controller: _image,
                                  hint: 'Upload image',
                                  isEmail: false,
                                  ispassword: false,
                                  label: 'Proof of income',
                                  ontap: () async {
                                    image = await picker.pickImage(
                                        source: ImageSource.gallery);
                                    image != null
                                        ? setState(() {
                                            if (_formkey.currentState!
                                                .validate()) {
                                              setState(() {
                                                active = true;
                                              });
                                            }
                                            _image.text = image!.name;
                                          })
                                        : null;
                                  },
                                ),
                                InkWell(
                                  onTap: () async {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                            'Sign Here',
                                            textAlign: TextAlign.center,
                                          ),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                height: 200,
                                                width: 300,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.grey)),
                                                child: SfSignaturePad(
                                                  key: signatureGlobalKey,
                                                  backgroundColor: Colors.white,
                                                  strokeColor: Colors.black,
                                                  minimumStrokeWidth: 1.0,
                                                  maximumStrokeWidth: 4.0,
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      signatureGlobalKey
                                                          .currentState!
                                                          .clear();
                                                    },
                                                    child: const Padding(
                                                      padding:
                                                          EdgeInsets.all(10.0),
                                                      child: Text('Reset'),
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      print("click");
                                                      final data =
                                                          await signatureGlobalKey
                                                              .currentState!
                                                              .toImage(
                                                                  pixelRatio:
                                                                      3.0);
                                                      final bytes =
                                                          await data.toByteData(
                                                              format: ui
                                                                  .ImageByteFormat
                                                                  .png);
                                                      signature = base64Encode(
                                                          bytes!.buffer
                                                              .asUint8List());

                                                      // Print base64 image
                                                      print(signature);

                                                      Navigator.pop(context);
                                                    },
                                                    child: const Padding(
                                                      padding:
                                                          EdgeInsets.all(10.0),
                                                      child: Text(
                                                        'Submit',
                                                        selectionColor:
                                                            Colors.green,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );

                                    signature != null
                                        ? setState(() {
                                            if (_formkey.currentState!
                                                .validate()) {
                                              setState(() {
                                                active = true;
                                              });
                                            }
                                            signLabel =
                                                "Thanks For adding your Signature";
                                          })
                                        : null;
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Tap to add Signature",
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          color: CustomColor
                                              .inputFieldTitleTextColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        height: 100,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white,
                                        ),
                                        child: Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: CustomColor.black
                                                  .withOpacity(0.1),
                                            ),
                                            child: Text(
                                              signLabel,
                                              style: GoogleFonts.inter(
                                                color: CustomColor.black,
                                                fontSize: 14,
                                              ),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                PrimaryButtonWidget(
                                  onPressed: active
                                      ? () {
                                          if (_formkey.currentState!
                                              .validate()) {
                                            debugPrint(image!.path.toString());
                                            _signupBloc.add(UpdatesourceEvent(
                                                occupation: _ocupation.text,
                                                photo: image!.path,
                                                source: _fund.text,
                                                signature: signature));

                                            active = false;
                                          }
                                        }
                                      : null,
                                  buttonText: 'Continue',
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
