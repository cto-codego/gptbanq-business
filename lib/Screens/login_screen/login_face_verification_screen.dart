import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:flutter_face_api/face_api.dart' hide Image;
import 'package:flutter_face_api/flutter_face_api.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';

import '../../../../cutom_weidget/cutom_progress_bar.dart';
import '../Profile_screen/bloc/profile_bloc.dart';
import '../Sign_up_screens/bloc/signup_bloc.dart';

class LoginFaceVerificationScreen extends StatefulWidget {
  final String profileImage;
  final String token;
  final String userId;
  final String message;

  const LoginFaceVerificationScreen(
      {super.key,
      required this.profileImage,
      required this.token,
      required this.userId,
      required this.message});

  @override
  State<LoginFaceVerificationScreen> createState() =>
      _LoginFaceVerificationScreenState();
}

class _LoginFaceVerificationScreenState
    extends State<LoginFaceVerificationScreen> {
  final SignupBloc _signupBloc = SignupBloc();
  final ProfileBloc _profileBloc = ProfileBloc();

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

  matchFaces() async {
    if (image1 == null || image2 == null) {
      //status == 0
      AwesomeDialog(
        context: context,
        dismissOnTouchOutside: false,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        desc: "Biometric not match",
        btnCancelText: 'ok',
        buttonsTextStyle: const TextStyle(
            fontSize: 14,
            fontFamily: 'pop',
            fontWeight: FontWeight.w600,
            color: Colors.white),
        btnCancelOnPress: () {
          _profileBloc.add(LogoutEvent());
        },
      ).show();
    } else {
      setState(() => _similarity = "Processing...");
      status = "Processing...";
      var request = MatchFacesRequest([image1!, image2!]);
      var response = await faceSdk.matchFaces(request);
      var split = await faceSdk.splitComparedFaces(response.results, 0.75);
      var match = split.matchedFaces;
      similarityStatus = "failed";

      if (match.isNotEmpty) {
        similarityStatus = "${(match[0].similarity * 100).toStringAsFixed(2)}%";

        Navigator.pushNamedAndRemoveUntil(context, 'setpin', (route) => false);
      }
      status = "Ready";
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _profileBloc,
      listener: (context, ProfileState state) {
        if (state.logoutModel?.status == 1) {
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder(
            bloc: _profileBloc,
            builder: (context, ProfileState state) {
              return ProgressHUD(
                inAsyncCall: state.isloading,
                child: Container(
                  width: double.maxFinite,
                  height: double.maxFinite,
                  padding: const EdgeInsets.only(left: 25, right: 25, top: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 15),
                      const Text(
                        "Let's Verify Your Biometric",
                        style: TextStyle(
                          fontSize: 25,
                          fontFamily: 'pop',
                          fontWeight: FontWeight.w500,
                          color: Color(0xff2C2C2C),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        widget.message,
                        style: const TextStyle(
                          fontSize: 15,
                          fontFamily: 'pop',
                          fontWeight: FontWeight.w500,
                          color: Color(0xff2C2C2C),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            const SizedBox(height: 40),
                            _uploadProofIdentity(context),
                            const SizedBox(height: 30),
                            _similarity == "nil"
                                ? Container(
                                    height: 60,
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xff10245C),
                                      borderRadius: BorderRadius.circular(11),
                                    ),
                                    child: ElevatedButton(
                                      onPressed: startLiveness,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                        shadowColor: Colors.transparent,
                                        minimumSize:
                                            const ui.Size.fromHeight(40),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(11),
                                        ),
                                      ),
                                      child: const Text(
                                        'Continue',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontFamily: 'pop',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
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

  Widget _uploadProofIdentity(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset(
              "images/face-id.png",
              height: 250,
            ),
            Text(
              _similarity,
              style: TextStyle(
                fontSize: 18,
                color: _similarity == "Processing..."
                    ? Colors.black
                    : Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
