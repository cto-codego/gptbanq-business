import 'dart:convert';

import 'package:gptbanqbusiness/Screens/update_doc_section/bloc/update_doc_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_face_api/flutter_face_api.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../cutom_weidget/cutom_progress_bar.dart';
import '../../../../../utils/assets.dart';
import '../../../../../utils/input_fields/custom_color.dart';
import '../../../../../utils/strings.dart';
import '../../../../../utils/user_data_manager.dart';
import '../../../../../widgets/buttons/default_back_button_widget.dart';
import '../../../../../widgets/buttons/primary_button_widget.dart';
import '../../../../../widgets/custom_image_widget.dart';
import '../../../../../widgets/toast/toast_util.dart';
import 'package:http/http.dart' as http;

import '../../../constant_string/User.dart';

class UpdateFaceProofScreen extends StatefulWidget {
  const UpdateFaceProofScreen({super.key});

  @override
  State<UpdateFaceProofScreen> createState() => _UpdateFaceProofScreenState();
}

class _UpdateFaceProofScreenState extends State<UpdateFaceProofScreen> {
  final UpdateDocBloc _updateDocBloc = UpdateDocBloc();

  var faceSdk = FaceSDK.instance;

  var status = "nil";
  var similarityStatus = "nil";
  var livenessStatus = "nil";

  var uiImage1 = Image.asset('images/portrait.png'); // Placeholder image
  var uiImage2 = Image.asset('images/portrait.png');

  MatchFacesImage? image1;
  MatchFacesImage? image2;

  String _similarity = "00.00";

  // String _liveness = "nil";

  Uint8List? bytes;
  String userimage = '';
  String? kycid;

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

  Future<void> loadImageFromUrl(String url, int number) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setImage(response.bodyBytes, ImageType.GHOST_PORTRAIT, number);
      } else {
        throw Exception('Failed to load image');
      }
    } catch (e) {
      debugPrint('Error loading image from URL: $e');
    }
  }

  Future<void> startLiveness() async {
    try {
      var result = await faceSdk.startLiveness(
        config: LivenessConfig(skipStep: [LivenessSkipStep.ONBOARDING_STEP]),
        notificationCompletion: (notification) {
          debugPrint(notification.status.toString());
        },
      );

      if (result.image == null) return;

      setImage(result.image!, ImageType.LIVE, 2);
      livenessStatus = result.liveness.name.toLowerCase();

      String userImage = base64Encode(result.image!);
      debugPrint(userImage);
      UserDataManager().similarityImageSave(userImage);
      UserDataManager().similaritySave("90.00");

      if (userImage.isNotEmpty) {
        // Dispatch an event to the bloc
        _updateDocBloc.add(KycFaceVerifyEvent(
          image: userImage,
          uniqueId: User.updateUniqueId,
          docTypeStatus: User.updateDocTypeStatus,
        ));
      } else {
        status = "Please set the second image before matching!";
        if (mounted) _showToastError();
      }
    } catch (e) {
      if (mounted) _showToastError();
      debugPrint("Error during liveness check: $e");
    }
  }

// Helper function for displaying the toast
  void _showToastError() {
    CustomToast.showError(
      context,
      "Sorry!",
      "Can't get your Selfie Properly, Please try again",
    );
  }

  matchFaces() async {
    status = "Processing...";
    if (image1 == null || image2 == null) {
      UserDataManager().similaritySave("00.00");
      // _kycFaceVerifyBloc.add(KycFaceVerifyEvent());
    } else {
      // setState(() => _similarity = "Processing...");
      var request = MatchFacesRequest([image1!, image2!]);
      var response = await faceSdk.matchFaces(request);
      var split = await faceSdk.splitComparedFaces(response.results, 0.75);
      var match = split.matchedFaces;
      similarityStatus = "failed";

      if (match.isNotEmpty) {
        similarityStatus = "${(match[0].similarity * 100).toStringAsFixed(2)}%";
        _similarity = (match[0].similarity * 100).toStringAsFixed(2);

        UserDataManager().similaritySave(_similarity);
        // _kycFaceVerifyBloc.add(KycFaceVerifyEvent());
      } else {
        UserDataManager().similaritySave("00.00");
        // _kycFaceVerifyBloc.add(KycFaceVerifyEvent());
      }
      status = "Ready";
    }
  }

  // If 'assets/regula.license' exists, init using license(enables offline match)
  // otherwise init without license.
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

  @override
  void initState() {
    super.initState();
    _updateDocBloc.add(KycGetUserImageEvent(uniqueId: User.updateUniqueId));

    init();
    // initPlatformState();
  }

  void init() async {
    if (!await initialize()) return;
    status = "Ready";
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _updateDocBloc,
      listener: (context, UpdateDocState state) {
        if (state.kycGetUserImageModel?.status == 0) {
          CustomToast.showError(
              context, "Sorry!", state.kycGetUserImageModel!.message!);
        }
        if (state.kycGetUserImageModel?.status == 1) {
          String userImage =
              state.kycGetUserImageModel!.profileimage.toString();
          loadImageFromUrl(userImage, 1);
          UserDataManager().similarityUserImageSave(userImage);
        }

        if (state.kycFaceVerifyModel?.status == 1) {
          Navigator.pushNamedAndRemoveUntil(
              context, 'updateDocScreen', (route) => false);
        } else if (state.kycFaceVerifyModel?.status == 0) {
          CustomToast.showError(
              context, "Sorry!", state.kycFaceVerifyModel!.message!);
        }
      },
      child: Scaffold(
        backgroundColor: CustomColor.scaffoldBg,
        body: SafeArea(
          child: BlocBuilder(
            bloc: _updateDocBloc,
            builder: (context, UpdateDocState state) {
              return ProgressHUD(
                inAsyncCall: state.isloading,
                child: Container(
                  width: double.maxFinite,
                  height: double.maxFinite,
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 40),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // crossAxisAlignment: CrossAxisAlignment.start,
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
                                Container()
                              ],
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            _uploadProofIdentity(context),

                            // :  createButton("Submit", () => matchFaces()),
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

  _uploadProofIdentity(BuildContext context) {
    return Center(
        child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
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
                      color: CustomColor.black),
                ),
                Text(
                  Strings.biometricSubTitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: CustomColor.subtitleTextColor),
                ),
                Text(status,
                    style: GoogleFonts.inter(
                        fontSize: 18,
                        color: status == "Processing..."
                            ? Colors.black
                            : Colors.transparent)),
              ],
            )));
  }
}
