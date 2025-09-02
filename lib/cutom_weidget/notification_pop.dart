import 'package:gptbanqbusiness/utils/custom_scroll_behavior.dart';
import 'package:flutter/material.dart';

class ApproveNotfications {
  static approveTransaction({
    String title = '',
    String body = '',
    BuildContext? context,
    final onConfirm,
    final onDecline,
  }) {
    showGeneralDialog(
      context: context!,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Material(
                color: Colors.transparent,
                child: Column(
                  children: [
                    Expanded(
                      child: ScrollConfiguration(
                        behavior: CustomScrollBehavior(),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 18, right: 18),
                          child: ListView(
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 20),
                              Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'pop',
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 40),
                              Image.asset(
                                'images/bell.png',
                                color: const Color(0xff090B78),
                                width: 100,
                                height: 100,
                              ),
                              const SizedBox(height: 40),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 20),
                                    Text(
                                      body,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'pop',
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 100),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    gradient: const LinearGradient(colors: [
                                      Color(0xff090B78),
                                      Color(0xff090B78)
                                    ])),
                                child: ElevatedButton(
                                  onPressed: onConfirm,
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0)),
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                      shadowColor: Colors.transparent,
                                      minimumSize: const Size.fromHeight(50)),
                                  child: const Text(
                                    "Confirm",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'pop',
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 50),
                              InkWell(
                                onTap: onDecline,
                                child: Container(
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  height: 40,
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.7),
                                      fontSize: 16,
                                      decoration: TextDecoration.underline,
                                      fontFamily: 'pop',
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.1),
      transitionDuration: const Duration(milliseconds: 0),
    );
  }
}
