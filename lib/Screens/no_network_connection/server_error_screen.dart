import 'package:gptbanqbusiness/utils/connectionStatusSingleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ServerErrorScreen extends StatefulWidget {
  static const id = 'NoNetworkConnectionScreen';
  final String? data;

  const ServerErrorScreen({super.key, this.data});

  @override
  _ServerErrorScreenState createState() => _ServerErrorScreenState();
}

class _ServerErrorScreenState extends State<ServerErrorScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
          statusBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white),
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          // resizeToAvoidBottomPadding: false, // this avoids the overflow error
          body: SafeArea(
            bottom: false,
            child: SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 15),
                    const Text(
                      'Server Error',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () async {
                        if (await ConnectionStatusSingleton.getInstance()
                            .isConnectedToInternet()) {
                          Navigator.popUntil(context, (route) => route.isFirst);
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Please check network!'),
                          ));
                        }
                      },
                      child: const Icon(
                        Icons.refresh,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Try again',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Some thing went wrong on server\nPlease try again later',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      widget.data!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
