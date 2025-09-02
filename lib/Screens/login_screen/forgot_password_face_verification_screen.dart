import 'dart:convert';
import 'package:gptbanqbusiness/Screens/login_screen/reset_password_screen.dart';
import 'package:gptbanqbusiness/utils/assets.dart';
import 'package:gptbanqbusiness/utils/input_fields/custom_color.dart';
import 'package:gptbanqbusiness/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_face_api/flutter_face_api.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';

import '../../../../cutom_weidget/cutom_progress_bar.dart';
import '../../utils/custom_style.dart';
import '../../utils/user_data_manager.dart';
import '../../widgets/buttons/default_back_button_widget.dart';
import '../../widgets/buttons/primary_button_widget.dart';
import '../../widgets/main_logo_widget.dart';
import '../../widgets/toast/toast_util.dart';
import '../Sign_up_screens/bloc/signup_bloc.dart';

class ForgotPasswordFaceVerificationScreen extends StatefulWidget {
  final String profileImage;
  final String userId;
  final String message;

  const ForgotPasswordFaceVerificationScreen(
      {super.key,
      required this.profileImage,
      required this.userId,
      required this.message});

  @override
  State<ForgotPasswordFaceVerificationScreen> createState() =>
      _ForgotPasswordFaceVerificationScreenState();
}

class _ForgotPasswordFaceVerificationScreenState
    extends State<ForgotPasswordFaceVerificationScreen> {
  final SignupBloc _signupBloc = SignupBloc();
  var faceSdk = FaceSDK.instance;

  MatchFacesImage? image1;
  MatchFacesImage? image2;

  String _similarity = "nil";
  String _liveness = "nil";

  var status = "nil";
  var similarityStatus = "nil";
  var livenessStatus = "nil";

  var uiImage1 = Image.asset('images/portrait.png'); // Placeholder image
  var uiImage2 = Image.asset('images/portrait.png');

  Uint8List? bytes;
  String userimage = '';

  @override
  void initState() {
    super.initState();
    init();
    loadImageFromUrl(widget.profileImage, 1);
  }

  void init() async {
    if (!await initialize()) return;
    status = "Ready";
  }

  Future<bool> initialize() async {
    status = "Initializing...";
    var license = await loadAssetIfExists("assets/regula.license");
    InitConfig? config = license != null ? InitConfig(license) : null;
    var (success, error) = await faceSdk.initialize(config: config);
    if (!success) {
      status = error!.message;
      print("${error.code}: ${error.message}");
    }
    return success;
  }

  Future<ByteData?> loadAssetIfExists(String path) async {
    try {
      return await rootBundle.load(path);
    } catch (_) {
      return null;
    }
  }

  Future<void> loadImageFromUrl(String url, int number) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setImage(response.bodyBytes, ImageType.GHOST_PORTRAIT, number);
      } else {
        throw Exception('Failed to load image');
      }
    } catch (e) {
      print('Error loading image from URL: $e');
    }
  }

  setImage(Uint8List bytes, ImageType type, int number) {
    similarityStatus = "nil";
    var mfImage = MatchFacesImage(bytes, type);
    if (number == 1) {
      image1 = mfImage;
      uiImage1 = Image.memory(bytes);
      livenessStatus = "nil";
    }
    if (number == 2) {
      image2 = mfImage;
      uiImage2 = Image.memory(bytes);
    }
  }

  startLiveness() async {
    var result = await faceSdk.startLiveness(
      config: LivenessConfig(skipStep: [LivenessSkipStep.ONBOARDING_STEP]),
      notificationCompletion: (notification) {
        print(notification.status);
      },
    );
    if (result.image == null) return;
    setImage(result.image!, ImageType.LIVE, 2);
    livenessStatus = result.liveness.name.toLowerCase();

    String userImage = base64Encode(result.image!);
    print(userImage);

    if (image2 != null) {
      // Ensure that the second image is set before calling matchFaces
      matchFaces();
    } else {
      status = "Please set the second image before matching!";
    }
  }

  // void matchFaces() {
  //   if (image1.bitmap == null ||
  //       image1.bitmap == "" ||
  //       image2.bitmap == null ||
  //       image2.bitmap == "") {
  //     //status == 0
  //     AwesomeDialog(
  //       context: context,
  //       dismissOnTouchOutside: true,
  //       dialogType: DialogType.error,
  //       animType: AnimType.rightSlide,
  //       desc: "Biometric not match, try again",
  //       btnCancelText: 'ok',
  //       buttonsTextStyle: const TextStyle(
  //           fontSize: 14,
  //           fontFamily: 'pop',
  //           fontWeight: FontWeight.w600,
  //           color: Colors.white),
  //       btnCancelOnPress: () {},
  //     ).show();
  //   } else {
  //     setState(() => _similarity = "Processing...");
  //     var request = MatchFacesRequest();
  //     request.images = [image1, image2];
  //     FaceSDK.matchFaces(json.encode(request)).then((value) {
  //       var response = MatchFacesResponse.fromJson(json.decode(value));
  //       FaceSDK.matchFacesSimilarityThresholdSplit(
  //               json.encode(response!.results), 0.75)
  //           .then((str) {
  //         var split =
  //             MatchFacesSimilarityThresholdSplit.fromJson(json.decode(str));
  //         setState(() => _similarity = split!.matchedFaces.isNotEmpty
  //             ? ((split.matchedFaces[0]!.similarity! * 100).toStringAsFixed(2))
  //             : "error");
  //         if (_similarity == "error" || _similarity == "nil") {
  //           //status == 0
  //           _signupBloc.add(ForgotPasswordBiometricEvent(
  //               userId: widget.userId, status: "0"));
  //         } else {
  //           //status == 1
  //
  //           _signupBloc.add(ForgotPasswordBiometricEvent(
  //               userId: widget.userId, status: "1"));
  //         }
  //       });
  //     });
  //   }
  // }

  matchFaces() async {
    if (image1 == null || image2 == null) {
      UserDataManager().similaritySave(
          _similarity == "nil" || _similarity == "Error"
              ? "00.00"
              : _similarity);
      _signupBloc.add(
          ForgotPasswordBiometricEvent(userId: widget.userId, status: "0"));
    } else {
      status = "Processing...";
      var request = MatchFacesRequest([image1!, image2!]);
      var response = await faceSdk.matchFaces(request);
      var split = await faceSdk.splitComparedFaces(response.results, 0.75);
      var match = split.matchedFaces;
      similarityStatus = "failed";

      if (match.isNotEmpty) {
        similarityStatus = "${(match[0].similarity * 100).toStringAsFixed(2)}%";

        _signupBloc.add(
            ForgotPasswordBiometricEvent(userId: widget.userId, status: "1"));
      }
      status = "Ready";
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _signupBloc,
      listener: (context, SignupState state) {
        if (state.statusModel?.status == 0) {
          CustomToast.showError(context, "Sorry!", state.statusModel!.message!);
        }

        if (state.statusModel?.status == 1) {
          Navigator.push(
            context,
            PageTransition(
              child: ResetPasswordScreen(
                userId: widget.userId,
                message: state.statusModel!.message!,
              ),
              type: PageTransitionType.fade,
              alignment: Alignment.center,
              duration: const Duration(milliseconds: 300),
              reverseDuration: const Duration(milliseconds: 200),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: CustomColor.scaffoldBg,
        body: SafeArea(
          child: BlocBuilder(
            bloc: _signupBloc,
            builder: (context, SignupState state) {
              return ProgressHUD(
                inAsyncCall: state.isloading,
                child: Container(
                  width: double.maxFinite,
                  height: double.maxFinite,
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 40),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DefaultBackButtonWidget(onTap: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, 'login', (route) => false);
                          }),
                          Container()
                        ],
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            MainLogoWidget(
                              height: 100,
                              width: 150,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 40),
                              child: CustomImageWidget(
                                imagePath: StaticAssets.fingerprint,
                                imageType: 'svg',
                              ),
                            ),
                            Text(
                              "Let's Verify facial biometric",
                              style: CustomStyle.loginTitleStyle,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              widget.message,
                              style: CustomStyle.loginSubTitleStyle,
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                      if (_similarity == "nil")
                        PrimaryButtonWidget(
                          onPressed: startLiveness,
                          buttonText: 'Continue',
                        ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _similarity,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            color: _similarity == "Processing..."
                                ? CustomColor.black
                                : Colors.transparent,
                          ),
                        ),
                      ),
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
