import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KycVerifyScreen extends StatefulWidget {
  const KycVerifyScreen({super.key});

  @override
  State<KycVerifyScreen> createState() => _KycVerifyScreenState();
}

class _KycVerifyScreenState extends State<KycVerifyScreen> {
  bool completed = false;

  @override
  void initState() {
    super.initState();
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
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Container(
                width: double.maxFinite,
                height: double.maxFinite,
                padding: const EdgeInsets.only(left: 25, right: 25, top: 40),
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 34,
                            alignment: Alignment.center,
                            child: Image.asset(
                              'images/applogo.png',
                              height: 34,
                            ),
                          ),
                          const SizedBox(
                            height: 42,
                          ),
                          Container(
                              alignment: Alignment.center,
                              child: Image.asset('images/happy-emoji.png')),
                          const SizedBox(
                            height: 22,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Your KYC is",
                                  style: TextStyle(
                                      color: Color(0xff2C2C2C),
                                      fontFamily: 'pop',
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500),
                                ),
                                Expanded(
                                  child: Text(
                                    " Verified.",
                                    style: TextStyle(
                                        color: Color(0xff009456),
                                        fontFamily: 'pop',
                                        fontSize: 25,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(11)),
                      child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff10245C),
                              elevation: 0,
                              shadowColor: Colors.transparent,
                              minimumSize: const Size.fromHeight(40),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(11))),
                          child: const Text(
                            'Open your IBAN now!',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'pop',
                                fontWeight: FontWeight.w500),
                          )),
                    ),
                    const SizedBox(
                      height: 30,
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
