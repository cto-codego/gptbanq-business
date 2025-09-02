import 'package:gptbanqbusiness/utils/connectionStatusSingleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NoNetworkConnectionScreen extends StatefulWidget {
  static const id = 'NoNetworkConnectionScreen';
  @override
  _NoNetworkConnectionScreenState createState() =>
      _NoNetworkConnectionScreenState();
}

class _NoNetworkConnectionScreenState extends State<NoNetworkConnectionScreen> {
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
          body: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.signal_wifi_statusbar_connected_no_internet_4_rounded,
                  color: Colors.black,
                ),
                const SizedBox(height: 5),
                const Text(
                  'Poor connection or no network available.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'pop'),
                ),
                const SizedBox(height: 25),
                InkWell(
                  onTap: () async {
                    if (await ConnectionStatusSingleton.getInstance()
                        .isConnectedToInternet()) {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Please check network!'),
                      ));
                    }
                  },
                  child: const Icon(
                    Icons.refresh,
                    size: 50,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
