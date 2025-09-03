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

  const ForgotPasswordFaceVerificationScreen({
    super.key,
    required this.profileImage,
    required this.userId,
    required this.message,
  });

  @override
  State<ForgotPasswordFaceVerificationScreen> createState() =>
      _ForgotPasswordFaceVerificationScreenState();
}

class _ForgotPasswordFaceVerificationScreenState
    extends State<ForgotPasswordFaceVerificationScreen> {
  final SignupBloc _signupBloc = SignupBloc();
  final faceSdk = FaceSDK.instance;

  MatchFacesImage? image1; // profile
  MatchFacesImage? image2; // live selfie
  String _similarity = "nil";

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    if (!await _initializeSdk()) return;
    await _loadImageFromUrl(widget.profileImage, 1);
  }

  Future<bool> _initializeSdk() async {
    final lic = await _loadAssetIfExists("assets/regula.license");
    final config = lic != null ? InitConfig(lic) : null;
    final (ok, err) = await faceSdk.initialize(config: config);
    if (!ok) debugPrint("${err?.code}: ${err?.message}");
    return ok;
  }

  Future<ByteData?> _loadAssetIfExists(String path) async {
    try {
      return await rootBundle.load(path);
    } catch (_) {
      return null;
    }
  }

  Future<void> _loadImageFromUrl(String url, int number) async {
    try {
      final r = await http.get(Uri.parse(url));
      if (r.statusCode == 200)
        _setImage(r.bodyBytes, ImageType.PRINTED, number);
    } catch (e) {
      debugPrint('Error loading image from URL: $e');
    }
  }

  void _setImage(Uint8List bytes, ImageType type, int number) {
    setState(() {
      final mf = MatchFacesImage(bytes, type);
      if (number == 1) {
        image1 = mf;
      } else {
        image2 = mf;
      }
    });
  }

  Future<void> _startLiveness() async {
    try {
      setState(() => _similarity = "Processing...");
      final result = await faceSdk.startLiveness(
        config: LivenessConfig(skipStep: [LivenessSkipStep.ONBOARDING_STEP]),
        notificationCompletion: (n) => debugPrint(n.status.toString()),
      );
      if (result.image == null) {
        if (mounted) setState(() => _similarity = "nil");
        return;
      }
      _setImage(result.image!, ImageType.LIVE, 2);
      await _matchFaces();
    } catch (e) {
      if (mounted) setState(() => _similarity = "nil");
      debugPrint("Liveness error: $e");
    }
  }

  Future<void> _matchFaces() async {
    if (image1 == null || image2 == null) {
      UserDataManager().similaritySave("00.00");
      _signupBloc.add(
          ForgotPasswordBiometricEvent(userId: widget.userId, status: "0"));
      setState(() => _similarity = "nil");
      return;
    }
    final req = MatchFacesRequest([image1!, image2!]);
    final resp = await faceSdk.matchFaces(req);
    final split = await faceSdk.splitComparedFaces(resp.results, 0.75);
    final matches = split.matchedFaces;
    final simPct = matches.isNotEmpty ? matches.first.similarity * 100 : 0.0;

    if (!mounted) return;
    if (simPct >= 90.0) {
      UserDataManager().similaritySave(simPct.toStringAsFixed(2));
      _signupBloc.add(
          ForgotPasswordBiometricEvent(userId: widget.userId, status: "1"));
    } else {
      UserDataManager().similaritySave("00.00");
      _signupBloc.add(
          ForgotPasswordBiometricEvent(userId: widget.userId, status: "0"));
    }
    setState(() => _similarity = "nil");
  }

  @override
  void dispose() {
    _signupBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupBloc, SignupState>(
      bloc: _signupBloc,
      listener: (context, state) {
        if (state.statusModel?.status == 0) {
          CustomToast.showError(context, "Sorry!", state.statusModel!.message!);
        } else if (state.statusModel?.status == 1) {
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
          child: BlocBuilder<SignupBloc, SignupState>(
            bloc: _signupBloc,
            builder: (context, state) {
              return ProgressHUD(
                inAsyncCall: state.isloading,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 40),
                  child: Column(
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
                            const MainLogoWidget(height: 100, width: 150),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 40),
                              child: CustomImageWidget(
                                imagePath: StaticAssets.fingerprint,
                                imageType: 'svg',
                              ),
                            ),
                            Text("Let's Verify facial biometric",
                                style: CustomStyle.loginTitleStyle),
                            const SizedBox(height: 20),
                            Text(widget.message,
                                style: CustomStyle.loginSubTitleStyle),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                      if (_similarity == "nil")
                        PrimaryButtonWidget(
                            onPressed: _startLiveness, buttonText: 'Continue'),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _similarity,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            color: _similarity == "Processing?"
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
