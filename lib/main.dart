import 'package:gptbanqbusiness/Config/Custom_route.dart';
import 'package:gptbanqbusiness/Config/bloc/app_bloc.dart';
import 'package:gptbanqbusiness/Models/application.dart';

import 'package:gptbanqbusiness/utils/location_serveci.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:permission_handler/permission_handler.dart';

import 'firebase_options.dart';
import 'utils/strings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (await Permission.location.isGranted) {
    Locationservece().getCurrentLocation();
  }

  geo.Geolocator.getServiceStatusStream().listen((geo.ServiceStatus status) {
    Locationservece().check();
  });

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
    super.initState();

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (mounted) {
        debugPrint('A new onMessageOpenedApp event was published!');
        _handleMessage(message);
      }
    });
  }

  void _handleMessage(RemoteMessage message) {
    if (mounted) {
      Application.navKey.currentState
          ?.pushNamedAndRemoveUntil('dashboard', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(414, 896),
        builder: (_, child) => BlocProvider(
              create: (context) => AppBloc(),
              child: MaterialApp(
                title: Strings.appName,
                debugShowCheckedModeBanner: false,
                onGenerateRoute: generatroutecustomRoute,
                initialRoute: '/',
                navigatorKey: Application.navKey,
                theme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
                  useMaterial3: true,
                ),
              ),
            ));
  }
}
