import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_face_api/flutter_face_api.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../../../../cutom_weidget/cutom_progress_bar.dart';
import '../../../../utils/assets.dart';
import '../../../../utils/input_fields/custom_color.dart';
import '../../../../utils/strings.dart';
import '../../../../utils/user_data_manager.dart';
import '../../../../widgets/buttons/default_back_button_widget.dart';
import '../../../../widgets/buttons/primary_button_widget.dart';
import '../../../../widgets/custom_image_widget.dart';
import '../../../../widgets/toast/toast_util.dart';
import '../../bloc/signup_bloc.dart';

class FaceProofScreen extends StatefulWidget {
  const FaceProofScreen({super.key});

  @override
  State<FaceProofScreen> createState() => _FaceProofScreenState();
}

class _FaceProofScreenState extends State<FaceProofScreen> {
  final SignupBloc _kycFaceVerifyBloc = SignupBloc();
  final faceSdk = FaceSDK.instance;

  String status = "nil";
  String similarityStatus = "nil";
  String livenessStatus = "nil";

  Image uiImage1 = Image.asset('images/portrait.png');
  Image uiImage2 = Image.asset('images/portrait.png');

  MatchFacesImage? image1;
  MatchFacesImage? image2;

  @override
  void initState() {
    super.initState();
    _kycFaceVerifyBloc.add(KycGetUserImageEvent());
    _init();
  }

  Future<void> _init() async {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    if (!await _initializeSdk()) return;
    if (!mounted) return;
    setState(() => status = "Ready");
  }

  Future<bool> _initializeSdk() async {
    setState(() => status = "Initializing...");
    final lic = await _loadAssetIfExists("assets/regula.license");
    final config = lic != null ? InitConfig(lic) : null;
    final (ok, err) = await faceSdk.initialize(config: config);
    if (!ok) {
      if (!mounted) return false;
      setState(() => status = err?.message ?? "Init failed");
      debugPrint("${err?.code}: ${err?.message}");
    }
    return ok;
  }

  Future<ByteData?> _loadAssetIfExists(String path) async {
    try {
      return await rootBundle.load(path);
    } catch (_) {
      return null;
    }
  }

  void setImage(Uint8List bytes, ImageType type, int number) {
    setState(() {
      similarityStatus = "nil";
      final mf = MatchFacesImage(bytes, type);
      if (number == 1) {
        image1 = mf;
        uiImage1 = Image.memory(bytes);
        livenessStatus = "nil";
      } else {
        image2 = mf;
        uiImage2 = Image.memory(bytes);
      }
    });
  }

  Future<void> loadImageFromUrl(String url, int number) async {
    try {
      final r = await http.get(Uri.parse(url));
      if (r.statusCode == 200) {
        setImage(r.bodyBytes, ImageType.PRINTED, number);
      }
    } catch (e) {
      debugPrint('Error loading image from URL: $e');
    }
  }

  Future<void> startLiveness() async {
    try {
      setState(() => status = "Processing...");
      final result = await faceSdk.startLiveness(
        config: LivenessConfig(skipStep: [LivenessSkipStep.ONBOARDING_STEP]),
        notificationCompletion: (n) => debugPrint(n.status.toString()),
      );
      if (result.image == null) {
        if (!mounted) return;
        setState(() => status = "Ready");
        return;
      }
      setImage(result.image!, ImageType.LIVE, 2);
      if (!mounted) return;
      setState(() => livenessStatus = result.liveness.name.toLowerCase());

      final userImageB64 = base64Encode(result.image!);
      UserDataManager().similarityImageSave(userImageB64);
      UserDataManager().similaritySave("90.00");

      if (userImageB64.isNotEmpty) {
        _kycFaceVerifyBloc.add(KycFaceVerifyEvent(image: userImageB64));
      } else {
        setState(() => status = "Please set the second image before matching!");
        if (mounted) _showToastError();
      }
      if (mounted) setState(() => status = "Ready");
    } catch (e) {
      if (mounted) {
        _showToastError();
        setState(() => status = "Ready");
      }
      debugPrint("Error during liveness check: $e");
    }
  }

  void _showToastError() {
    CustomToast.showError(
      context,
      "Sorry!",
      "Can't get your Selfie Properly, Please try again",
    );
  }

  @override
  void dispose() {
    _kycFaceVerifyBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupBloc, SignupState>(
      bloc: _kycFaceVerifyBloc,
      listener: (context, state) {
        if (state.kycGetUserImageModel?.status == 0) {
          CustomToast.showError(
              context, "Sorry!", state.kycGetUserImageModel!.message!);
        }
        if (state.kycGetUserImageModel?.status == 1) {
          final userImageUrl =
          state.kycGetUserImageModel!.profileimage.toString();
          loadImageFromUrl(userImageUrl, 1);
          UserDataManager().similarityUserImageSave(userImageUrl);
        }
        if (state.kycFaceVerifyModel?.status == 1) {
          Navigator.pushNamedAndRemoveUntil(
              context, 'kycStartScreen', (route) => false);
        } else if (state.kycFaceVerifyModel?.status == 0) {
          CustomToast.showError(
              context, "Sorry!", state.kycFaceVerifyModel!.message!);
        }
      },
      child: Scaffold(
        backgroundColor: CustomColor.scaffoldBg,
        body: SafeArea(
          child: BlocBuilder<SignupBloc, SignupState>(
            bloc: _kycFaceVerifyBloc,
            builder: (context, state) {
              return ProgressHUD(
                inAsyncCall: state.isloading,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 40),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                DefaultBackButtonWidget(onTap: () {
                                  Navigator.pushNamedAndRemoveUntil(context,
                                      'kycStartScreen', (route) => false);
                                }),
                                const SizedBox.shrink(),
                              ],
                            ),
                            const SizedBox(height: 40),
                            _uploadProofIdentity(),
                          ],
                        ),
                      ),
                      PrimaryButtonWidget(
                        onPressed: startLiveness,
                        buttonText: 'Start',
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

  Widget _uploadProofIdentity() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomImageWidget(
              imagePath: StaticAssets.biometricImage,
              imageType: "svg",
              height: 250,
            ),
            Text(
              Strings.biometricTitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: CustomColor.black,
              ),
            ),
            Text(
              Strings.biometricSubTitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: CustomColor.subtitleTextColor,
              ),
            ),
            Text(
              status,
              style: GoogleFonts.inter(
                fontSize: 18,
                color: status == "Processing..."
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
