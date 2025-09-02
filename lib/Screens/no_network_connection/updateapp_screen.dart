import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateAppScreen extends StatefulWidget {
  static const id = 'UpdateAppScreen';

  @override
  _UpdateAppScreenState createState() => _UpdateAppScreenState();
}

class _UpdateAppScreenState extends State<UpdateAppScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _launchStore() async {
    const String androidAppId = 'com.gptbanq.business';
    const String iOSAppId = '6478826879';

    Uri url;
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      url = Uri.parse('itms-apps://apps.apple.com/app/id$iOSAppId');
    } else {
      url = Uri.parse('market://details?id=$androidAppId');
      if (!await canLaunchUrl(url)) {
        // Fallback to web version if Play Store is not available
        url = Uri.parse('https://play.google.com/store/apps/details?id=$androidAppId');
      }
    }

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
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
          body: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.update,
                  color: Colors.black,
                ),
                const SizedBox(height: 5),
                const Text(
                  'Please, Update the app from the store',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'pop'),
                ),
                const SizedBox(height: 25),
                InkWell(
                  onTap: _launchStore,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.green),
                    child: const Text(
                      'Update App',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'pop',
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
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
