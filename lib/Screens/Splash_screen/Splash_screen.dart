import 'package:gptbanqbusiness/Config/bloc/app_bloc.dart';
import 'package:gptbanqbusiness/Screens/no_network_connection/Location_denied.dart';
import 'package:gptbanqbusiness/Screens/no_network_connection/no_network_connection.dart';
import 'package:gptbanqbusiness/constant_string/User.dart';
import 'package:gptbanqbusiness/utils/assets.dart';
import 'package:gptbanqbusiness/utils/input_fields/custom_color.dart';
import 'package:gptbanqbusiness/utils/location_serveci.dart';
import 'package:gptbanqbusiness/utils/user_data_manager.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Config/bloc/app_respotary.dart';
import '../../utils/custom_style.dart';
import '../../utils/strings.dart';
import '../../widgets/logo_widget.dart';
import '../../widgets/success/success_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final AppBloc _appBloc = AppBloc();

  Future<void> _launchInWebView(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.inAppWebView)) {
      throw Exception('Could not launch $url');
    }
  }

  AppRespo appRespo = AppRespo();
  CustomColor customColor = CustomColor();

  @override
  void initState() {
    super.initState();
    appRespo.getUserStatus();

    User.Screen = 'Splash';
    firebaseCloudMessaging_Listeners(context);

    Future.delayed(Duration(seconds: 3), () {
      _appBloc.add(UserstatusEvent());
    });
  }

  @override
  void dispose() {
    _appBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener(
        bloc: _appBloc,
        listener: (context, AppState state) async {
          customColor.loadColors();

          if (state is WelcomeScreenState) {
            Navigator.pushNamedAndRemoveUntil(
                context, 'WelcomeScreen', (route) => false);
          } else if (state is SignUpUserInfoPage1ScreenState) {
            Navigator.pushNamedAndRemoveUntil(
                context, 'signUpUserInfoPage1Screen', (route) => false);
          } else if (state is FirstKYCScreenState) {
            Navigator.pushNamedAndRemoveUntil(
                context, 'kycWelcomeScreen', (route) => false);
          } else if (state is Pendingstatus) {
            Navigator.pushNamedAndRemoveUntil(
                context, 'pending', (route) => false);
          } else if (state is SetPinScreenState) {
            Navigator.pushNamedAndRemoveUntil(
                context, 'setpin', (route) => false);
          } else if (state is GetUserPinScreenState) {
            Navigator.pushNamedAndRemoveUntil(
                context, 'getpin', (route) => false);
          } else if (state is UpdateDocScreenState) {
            Navigator.pushNamedAndRemoveUntil(
                context, 'updateDocScreen', (route) => false);
          } else if (state is LockScreenState) {
            String message = await UserDataManager().getStatusMessage();

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => SuccessWidget(
                    imageType: SuccessImageType.warning,
                    title: "Sorry!",
                    subTitle: message,
                    btnText: "Continue",
                    disableButton: true,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                (route) => false);
          } else if (state is OpenScreenstate) {
            _launchInWebView(Uri.parse(User.urlweb!));
          } else if (state is NoNetworkState) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => (NoNetworkConnectionScreen()),
              ),
            ).then((value) {
              _appBloc.add(UserstatusEvent());
            });
          } else if (state is locationdenied) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => (LocationDeniedScreen()),
              ),
            ).then((value) {
              _appBloc.add(UserstatusEvent());
            });
          }
        },
        child: SafeArea(
          child: Stack(
            children: [
              SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Image.asset(
                    StaticAssets.splashBg, // Path to your GIF
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Color overlay on top of the video
              Container(color: CustomColor.splashBgColor),

              // Logo on top of the color overlay
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: LogoWidget(
                    width: double.maxFinite,
                    height: double.maxFinite,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  // if (state. is WelcomeScreenState) {
                  //   Navigator.pushNamedAndRemoveUntil(
                  //       context, 'WelcomeScreen', (route) => false);
                  // }
                },
                child: Container(
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    Strings.tapToStart,
                    style: CustomStyle.splashTextStyle,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void firebaseCloudMessaging_Listeners(BuildContext context) {
    iOS_Permission();
    _firebaseMessaging.getToken().then((token) {
      debugPrint("_123firebaseMessaging.getToken:  ${token!}");
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {}
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      if (message.notification != null) {
        debugPrint("Notification Message  : ${message.notification!.body!}");
      }
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) async {
      if (message != null) {
        print('TERMINATED ');
        if (message.notification != null) {
          if (message.data['category'] == 'current-location') {}
        }
      }
    });

    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
  }

  void iOS_Permission() {
    _firebaseMessaging.requestPermission(alert: true, badge: true, sound: true);
  }
}

Future myBackgroundMessageHandler(RemoteMessage message) async {
  if (message.data != null) {
    // Handle data message
    debugPrint(
        'get splash screen on myBackgroundMessageHandler   ${message.data['category']} ');
    final dynamic data = message.data;

    if (message.data['category'] == 'current-location') {
      debugPrint('object a7a');
      Locationservece().getbgcurruntlocation();
    }
  }

  if (message.notification != null) {
    // Handle notification message
    debugPrint(
        "get splash on myBackgroundMessageHandler   ${message.data['category']}");
    final dynamic notification = message.notification;

    if (message.data['category'] == 'current-location') {
      debugPrint('object a7a 2');

      // if (await Permission.location.isGranted) {
      //   Locationservece().getCurrentLocation();
      // }
    }
  }

  // Or do other work.
}
