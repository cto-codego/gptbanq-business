import 'dart:async';

import 'package:gptbanqbusiness/Screens/Sign_up_screens/bloc/signup_bloc.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:gptbanqbusiness/utils/assets.dart';
import 'package:gptbanqbusiness/utils/user_data_manager.dart';
import 'package:gptbanqbusiness/widgets/custom_image_widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_idensic_mobile_sdk_plugin/flutter_idensic_mobile_sdk_plugin.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Models/dashboard/refresh_sumsub_token_model.dart';
import '../../utils/input_fields/custom_color.dart';
import '../../widgets/buttons/primary_button_widget.dart';
import '../Sign_up_screens/bloc/Signup_respotary.dart';

class IbanKycScreen extends StatefulWidget {
  const IbanKycScreen({super.key});

  @override
  State<IbanKycScreen> createState() => _IbanKycScreenState();
}

class _IbanKycScreenState extends State<IbanKycScreen> {
  SignupRespo signupRespo = SignupRespo();
  SNSMobileSDK? snsMobileSDK;
  bool completed = false;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final SignupBloc _signupBloc = SignupBloc();

  String token = "";
  String message = "";

  @override
  void initState() {
    super.initState();

    userData();
    firebaseCloudMessaging_Listeners(context);
  }

  Future<void> userData() async {
    String fetchedToken = await UserDataManager().getUserSumSubToken();
    String fetchedMessage = await UserDataManager().getStatusMessage();

    setState(() {
      token = fetchedToken;
      message = fetchedMessage;
    });
  }

  bool _isLoading = false;

  var useDismissTimer = false;
  var useApplicantConf = false;
  var usePreferredDocumentDefinitions = false;
  var useDisableAnalytics = false;
  var useCustomStrings = false;
  var useCustomTheme = false;
  var useDisableAutoCloseOnApprove = false;

  void launchSDK() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (kDebugMode) {
        print(token);
      }
      final String accessToken = token;

      onTokenExpiration() async {
        try {
          final response = await signupRespo.refreshSumSubTokenRequest();
          if (response is RefreshSumSubTokenModel) {
            final newToken = response
                .sumsubtoken; // Ensure this property exists in your model
            print('🐞🐞🐞 New token 🐞🐞🐞: $newToken');

            return Future<String>.delayed(
                const Duration(minutes: 1), () => newToken!);
          } else {
            // Handle unexpected response type
            throw Exception('🐞🐞🐞 Failed to refresh token 🐞🐞🐞');
          }
        } catch (e) {
          if (kDebugMode) {
            print('Error refreshing token: $e');
          }
          rethrow;
        }
      }

      final builder = SNSMobileSDK.init(accessToken, onTokenExpiration);

      setupOptionalHandlers(builder);
      setupTheme(builder);

      snsMobileSDK =
          builder.withLocale(const Locale("en")).withDebug(true).build();

      final result = await snsMobileSDK!.launch();

      print("🐞🐞🐞 Completed with result 🐞🐞🐞: $result");

      Navigator.pushNamed(context, 'dashboard');
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to fetch access token'),
      ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void setupOptionalHandlers(SNSMobileSDKBuilder builder) {
    if (useApplicantConf) {
      builder
          .withApplicantConf({"email": "test@test.com", "phone": "123456789"});
    }

    if (usePreferredDocumentDefinitions) {
      builder.withPreferredDocumentDefinitions({
        "IDENTITY": {"idDocType": "PASSPORT", "country": "USA"},
        "IDENTITY2": {"idDocType": "DRIVERS", "country": "FRA"},
        "ADDRESS": {"idDocType": "UTILITY_BILL", "country": "ALL"}
      });
    }

    if (useDisableAnalytics) {
      builder.withAnalyticsEnabled(false);
    }

    if (useCustomStrings) {
      builder.withStrings({"sns_general_poweredBy": "GPTBANQ Business"});
    }

    if (useDisableAutoCloseOnApprove) {
      builder.withAutoCloseOnApprove(0);
    }

    onStatusChanged(
        SNSMobileSDKStatus newStatus, SNSMobileSDKStatus prevStatus) {
      print("onStatusChanged: $prevStatus -> $newStatus");

      // just to show how dismiss() method works
      if (useDismissTimer && prevStatus == SNSMobileSDKStatus.Ready) {
        Timer(const Duration(seconds: 10), () {
          snsMobileSDK?.dismiss();
        });
      }
    }

    onEvent(SNSMobileSDKEvent event) {
      print("🐞🐞🐞🐞 onEvent 🐞🐞🐞🐞: $event");
    }

    onActionResult(SNSMobileSDKActionResult result) {
      print("🐞🐞🐞🐞 onActionResult 🐞🐞🐞🐞: $result");

      // you must return a `Future` that in turn should be completed with a value of `SNSActionResultHandlerReaction` type
      // you could pass `.Cancel` to force the user interface to close, or `.Continue` to proceed as usual
      return Future.value(SNSActionResultHandlerReaction.Continue);
    }

    builder.withHandlers(
        onStatusChanged: onStatusChanged,
        onActionResult: onActionResult,
        onEvent: onEvent);
  }

  void setupTheme(SNSMobileSDKBuilder builder) {
    if (!useCustomTheme) {
      return;
    }

    // builder.withTheme({
    //   "universal": {
    //     "fonts": {
    //       "assets": [
    //         // refers to the ttf/otf files (ios needs them to register fonts before they could be used)
    //         {"name": "Scriptina", "file": "assets/fonts/SCRIPTIN.ttf"},
    //         {
    //           "name": "Caslon Antique",
    //           "file": "assets/fonts/Caslon Antique.ttf"
    //         },
    //         {"name": "Requiem", "file": "assets/fonts/Requiem.ttf"},
    //         {"name": "DAGGERSQUARE", "file": "assets/fonts/DAGGERSQUARE.otf"},
    //         {"name": "Plasma Drip (BRK)", "file": "assets/fonts/plasdrip.ttf"}
    //       ],
    //       "headline1": {
    //         "name": "Scriptina",
    //         // use ttf's `Full Name` or the name of any system font installed, or omit the key to keep the default font-face
    //         "size": 40
    //         // in points
    //       },
    //       "headline2": {"size": 22},
    //       "subtitle1": {"name": "DAGGERSQUARE", "size": 20},
    //       "subtitle2": {"name": "Plasma Drip (BRK)", "size": 18},
    //       "body": {"name": "Caslon Antique", "size": 16},
    //       "caption": {"name": "Requiem", "size": 12}
    //     },
    //     "images": {
    //       "iconMail": "assets/img/mail-icon.png",
    //       // either an image name or a path to the image (the size in points equals the size in pixels)
    //       "iconClose": {
    //         "image": "assets/img/cross-icon.png",
    //         "scale": 3,
    //         // adjusts the "logical" size (in points), points=pixels/scale
    //         "rendering": "template"
    //         // "template" or "original"
    //       },
    //       "verificationStepIcons": {
    //         "identity": {"image": "assets/img/robot-icon.png", "scale": 3},
    //       }
    //     },
    //     "colors": {
    //       "navigationBarItem": {
    //         "light": "#FF000080", // #RRGGBBAA - white with 50% alpha
    //         "dark": "0x80FF0000" // 0xAARRGGBB - white with 50% alpha
    //       },
    //       "alertTint": "#FF000080",
    //       // sets both light and dark to the same color
    //       "backgroundCommon": {"light": "#FFFFFF", "dark": "#1E232E"},
    //       "backgroundNeutral": {
    //         "light": "#A59A8630" // keeps default `dark`
    //       },
    //       "backgroundInfo": {"light": "#9E95C0"},
    //       "backgroundSuccess": {"light": "#749C6F30"},
    //       "backgroundWarning": {"light": "#F1BE4F30"},
    //       "backgroundCritical": {"light": "#BB362A30"},
    //       "contentLink": {"light": "#DD8B35"},
    //       "contentStrong": {"light": "#4F4945"},
    //       "contentNeutral": {"light": "#7F877B"},
    //       "contentWeak": {"light": "#A59A86"},
    //       "contentInfo": {"light": "#1B1F4E"},
    //       "contentSuccess": {"light": "#749C6F"},
    //       "contentWarning": {"light": "#F1BE4F"},
    //       "contentCritical": {"light": "#BB362A"},
    //       "primaryButtonBackground": {"light": "#558387"},
    //       "primaryButtonBackgroundHighlighted": {"light": "#44696B"},
    //       "primaryButtonBackgroundDisabled": {"light": "#8AA499"},
    //       "primaryButtonContent": {"light": "#fff"},
    //       "primaryButtonContentHighlighted": {"light": "#fff"},
    //       "primaryButtonContentDisabled": {"light": "#fff"},
    //       "secondaryButtonBackground": {},
    //       "secondaryButtonBackgroundHighlighted": {"light": "#8AA499"},
    //       "secondaryButtonBackgroundDisabled": {},
    //       "secondaryButtonContent": {"light": "#558387"},
    //       "secondaryButtonContentHighlighted": {"light": "#fff"},
    //       "secondaryButtonContentDisabled": {"light": "#8AA499"},
    //       "cameraBackground": {"light": "#222"},
    //       "cameraContent": {"light": "#D2C5A5"},
    //       "fieldBackground": {"light": "#F9F1CB80"},
    //       "fieldBorder": {},
    //       "fieldPlaceholder": {"light": "#8F8376"},
    //       "fieldContent": {"light": "#32302F"},
    //       "fieldTint": {"light": "#558387"},
    //       "listSeparator": {"light": "#8F837680"},
    //       "listSelectedItemBackground": {"light": "#D2C5A580"},
    //       "bottomSheetHandle": {"light": "#8AA499"},
    //       "bottomSheetBackground": {"light": "#FFFFFF", "dark": "#4F4945"}
    //     }
    //   },
    //   "ios": {
    //     "metrics": {
    //       "commonStatusBarStyle": "default",
    //       "activityIndicatorStyle": "medium",
    //       "screenHorizontalMargin": 16,
    //       "buttonHeight": 48,
    //       "buttonCornerRadius": 8,
    //       "buttonBorderWidth": 1,
    //       "cameraStatusBarStyle": "default",
    //       "fieldHeight": 48,
    //       "fieldCornerRadius": 0,
    //       "viewportBorderWidth": 8,
    //       "bottomSheetCornerRadius": 16,
    //       "bottomSheetHandleSize": {"width": 36, "height": 4},
    //       "verificationStepCardStyle": "filled",
    //       "supportItemCardStyle": "filled",
    //       "documentTypeCardStyle": "filled",
    //       "selectedCountryCardStyle": "bordered",
    //       "cardCornerRadius": 16,
    //       "cardBorderWidth": 2,
    //       "listSectionTitleAlignment": "natural"
    //     }
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColor.scaffoldBg,
        resizeToAvoidBottomInset: false,
        body: BlocListener(
          bloc: _signupBloc,
          listener: (context, SignupState state) async {},
          child: BlocBuilder(
              bloc: _signupBloc,
              builder: (context, SignupState state) {
                return ProgressHUD(
                  inAsyncCall: state.isloading,
                  child: SafeArea(
                    child: Container(
                      width: double.maxFinite,
                      height: double.maxFinite,
                      padding:
                          const EdgeInsets.only(left: 16, right: 16, top: 30),
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : Column(
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                          height: 34,
                                          alignment: Alignment.center,
                                          child: CustomImageWidget(
                                            imagePath:
                                                StaticAssets.arrowNarrowLeft,
                                            imageType: 'svg',
                                            height: 24,
                                          )),
                                      const SizedBox(
                                        height: 42,
                                      ),
                                      Container(
                                          alignment: Alignment.center,
                                          child: CustomImageWidget(
                                            imagePath: StaticAssets.kycWelcome,
                                            imageType: 'svg',
                                            height: 200,
                                          )),
                                      const SizedBox(
                                        height: 22,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Verify your",
                                            style: GoogleFonts.inter(
                                                color: Color(0xff2C2C2C),
                                                fontSize: 25,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text(
                                            " identity",
                                            style: GoogleFonts.inter(
                                                color: CustomColor.green,
                                                fontSize: 25,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        message,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.inter(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                PrimaryButtonWidget(
                                  onPressed: () => launchSDK(),
                                  buttonText: 'Continue',
                                ),
                                const SizedBox(
                                  height: 30,
                                )
                              ],
                            ),
                    ),
                  ),
                );
              }),
        ));
  }

  void iOS_Permission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true, badge: true, sound: true);

    debugPrint("123Settings registered: ${settings.authorizationStatus}");
  }

  void firebaseCloudMessaging_Listeners(BuildContext context) {
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        debugPrint(' kyc terminated');
        try {
          if (message.notification != null) {
            if (message.data['category'] == 'kyc_verified') {
              Navigator.pushNamedAndRemoveUntil(
                  context, 'setpin', (route) => false);
            } else if (message.data['category'] == 'kyc_rejected') {
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            }
          }
        } catch (e) {
          debugPrint(e.toString());
        }
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('A new onmessage event was published!');

      debugPrint('message *** ${message.data}');

      try {
        if (message.notification != null) {
          debugPrint(message.data['category']);

          if (message.data['category'] == 'kyc_verified') {
            Navigator.pushNamedAndRemoveUntil(
                context, 'setpin', (route) => false);
          } else if (message.data['category'] == 'kyc_rejected') {
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          }
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    });

    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('A new onMessageOpenedApp event was published!');

      try {
        if (message.notification != null) {
          if (message.data['category'] == 'kyc_verified') {
            Navigator.pushNamedAndRemoveUntil(
                context, 'setpin', (route) => false);
          } else if (message.data['category'] == 'kyc_rejected') {
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          }
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    });
  }
}

Future myBackgroundMessageHandler(RemoteMessage message) async {
  if (message.data.isNotEmpty) {
    // Handle data message
    debugPrint(
        'dashboard screen on myBackgroundMessageHandler dashboard $message');
    // final dynamic data = message.data;
  }

  if (message.notification != null) {
    // Handle notification message
    debugPrint(
        'dashboard screen on myBackgroundMessageHandler dashboard $message');
    // final dynamic notification = message.notification;
  }
}
