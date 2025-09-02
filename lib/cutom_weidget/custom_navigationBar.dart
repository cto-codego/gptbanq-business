
import 'package:gptbanqbusiness/Screens/Dashboard_screen/Dashboard_screen.dart';
import 'package:gptbanqbusiness/Screens/Profile_screen/Profile_screen.dart';
import 'package:gptbanqbusiness/Screens/card_section/card_screen.dart';
import 'package:gptbanqbusiness/Screens/crypto_screen/Crypto_screen.dart';
import 'package:gptbanqbusiness/constant_string/User.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../Screens/investment/investment_screen.dart';

class CustomBottomBar extends StatefulWidget {
  int index = 0;

  CustomBottomBar({super.key, required this.index});

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: double.infinity,
      color: const Color(0xffFAFAFA),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: InkWell(
            onTap: () {
              if (widget.index != 0) {
                //Locationservece().check();

                Navigator.pushReplacement(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    alignment: Alignment.center,
                    isIos: true,
                    duration: const Duration(milliseconds: 200),
                    child: const DashboardScreen(),
                  ),
                );
              }

              setState(() {
                widget.index = 0;
              });
            },
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Image.asset(
                      'images/home.png',
                      height: 24,
                      width: 24,
                      color: widget.index == 0
                          ? const Color(0xff000000)
                          : const Color(0xffC4C4C4),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Home',
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'pop',
                        fontWeight: FontWeight.w500,
                        color: widget.index == 0
                            ? const Color(0xff000000)
                            : const Color(0xffC4C4C4)),
                  )
                ]),
          )),
          User.hidepage == 1
              ? Container()
              : Expanded(
                  child: InkWell(
                  onTap: () {
                    if (widget.index != 1) {
                      //Locationservece().check();

                      Navigator.pushReplacement(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          alignment: Alignment.center,
                          isIos: true,
                          duration: const Duration(milliseconds: 200),
                          child:  CryptoScreen(isCryptoCall: false,),
                        ),
                      );
                    }

                    setState(() {
                      widget.index = 1;
                    });
                  },
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: Image.asset(
                            'images/currency_exchange.png',
                            height: 24,
                            width: 24,
                            color: widget.index == 1
                                ? const Color(0xff000000)
                                : const Color(0xffC4C4C4),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Currency',
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'pop',
                              fontWeight: FontWeight.w500,
                              color: widget.index == 1
                                  ? const Color(0xff000000)
                                  : const Color(0xffC4C4C4)),
                        )
                      ]),
                )),
          User.hidepage == 1
              ? Container()
              : Expanded(
                  child: InkWell(
                  onTap: () {
                    if (widget.index != 2) {
                      Navigator.pushReplacement(
                        context,
                        PageTransition(
                          type: PageTransitionType.scale,
                          alignment: Alignment.center,
                          isIos: true,
                          duration: const Duration(microseconds: 500),
                          child:  InvestmentScreen(isTcInvestmentCall: false,),
                        ),
                      );
                    }

                    setState(() {
                      widget.index = 2;
                    });
                  },
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: Image.asset(
                            'images/investment.png',
                            height: 24,
                            width: 24,
                            color: widget.index == 2
                                ? const Color(0xff000000)
                                : const Color(0xffC4C4C4),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Investment',
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'pop',
                              fontWeight: FontWeight.w500,
                              color: widget.index == 2
                                  ? const Color(0xff000000)
                                  : const Color(0xffC4C4C4)),
                        )
                      ]),
                )),
          Expanded(
              child: InkWell(
            onTap: () {
              if (widget.index != 3) {
                Navigator.pushReplacement(
                  context,
                  PageTransition(
                    type: PageTransitionType.scale,
                    alignment: Alignment.center,
                    isIos: true,
                    duration: const Duration(microseconds: 500),
                    child: const CardScreen(),
                  ),
                );
              }

              setState(() {
                widget.index = 3;
              });
            },
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Image.asset(
                      'images/card.png',
                      height: 24,
                      width: 24,
                      color: widget.index == 3
                          ? const Color(0xff000000)
                          : const Color(0xffC4C4C4),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Card',
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'pop',
                        fontWeight: FontWeight.w500,
                        color: widget.index == 3
                            ? const Color(0xff000000)
                            : const Color(0xffC4C4C4)),
                  )
                ]),
          )),
          Expanded(
              child: InkWell(
            onTap: () {
              if (widget.index != 4) {
                //Locationservece().check();

                Navigator.pushReplacement(
                  context,
                  PageTransition(
                    type: PageTransitionType.scale,
                    alignment: Alignment.center,
                    isIos: true,
                    duration: const Duration(microseconds: 500),
                    child: const ProfileScreen(),
                  ),
                );
              }

              setState(() {
                widget.index = 4;
              });
            },
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Image.asset(
                      'images/profile.png',
                      height: 24,
                      width: 24,
                      color: widget.index == 4
                          ? const Color(0xff000000)
                          : const Color(0xffC4C4C4),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Profile',
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'pop',
                        fontWeight: FontWeight.w500,
                        color: widget.index == 4
                            ? const Color(0xff000000)
                            : const Color(0xffC4C4C4)),
                  )
                ]),
          )),
        ],
      ),
    );
  }
}
