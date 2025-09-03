import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_face_api/flutter_face_api.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../../../../cutom_weidget/cutom_progress_bar.dart';
import '../../utils/assets.dart';
import '../../utils/input_fields/custom_color.dart';
import '../../widgets/buttons/primary_button_widget.dart';
import '../../widgets/custom_image_widget.dart';
import '../../widgets/toast/custom_dialog_widget.dart';
import '../Profile_screen/bloc/profile_bloc.dart';

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
  final ProfileBloc _profileBloc = ProfileBloc();
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

  Future<void> _loadImageFromUrl(String url, int number) async {
    try {
      final r = await http.get(Uri.parse(url));
      if (r.statusCode == 200)
        _setImage(r.bodyBytes, ImageType.PRINTED, number);
    } catch (e) {
      debugPrint('Error loading image from URL: $e');
    }
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
      _showFailAndLogout("Biometric not match");
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
      Navigator.pushNamedAndRemoveUntil(context, 'setpin', (route) => false);
    } else {
      _showFailAndLogout("Biometric not match");
    }
    setState(() => _similarity = "nil");
  }

  void _showFailAndLogout(String msg) {
    CustomDialogWidget.showWarningDialog(
      context: context,
      title: "",
      subTitle: msg,
      btnCancelOnPress: () => _profileBloc.add(LogoutEvent()),
    );
  }

  @override
  void dispose() {
    _profileBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      bloc: _profileBloc,
      listener: (context, state) {
        if (state.logoutModel?.status == 1) {
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        }
      },
      child: Scaffold(
        backgroundColor: CustomColor.scaffoldBg,
        body: SafeArea(
          child: BlocBuilder<ProfileBloc, ProfileState>(
            bloc: _profileBloc,
            builder: (context, state) {
              return ProgressHUD(
                inAsyncCall: state.isloading,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  padding: const EdgeInsets.only(left: 25, right: 25, top: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(height: 15),
                      Text(
                        "Let's Verify Your Biometric",
                        style: GoogleFonts.inter(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          color: CustomColor.black,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        widget.message,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: CustomColor.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            const SizedBox(height: 40),
                            _uploadProofIdentity(),
                          ],
                        ),
                      ),
                      _similarity == "nil"
                          ? PrimaryButtonWidget(
                              onPressed: _startLiveness,
                              buttonText: 'Continue',
                            )
                          : const SizedBox.shrink(),
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

  Widget _uploadProofIdentity() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CustomImageWidget(
              imagePath: StaticAssets.biometricImage,
              imageType: 'svg',
              height: 300,
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
