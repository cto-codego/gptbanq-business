import 'dart:async';

import 'package:gptbanqbusiness/Screens/Pos_Screen/bloc/pos_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:gptbanqbusiness/constant_string/User.dart';
import 'package:gptbanqbusiness/cutom_weidget/custom_navigationBar.dart';

class PaymentConfirmationScreen extends StatefulWidget {
  PaymentConfirmationScreen(
      {super.key, required this.message, required this.trxId});

  String message;
  String trxId;

  @override
  State<PaymentConfirmationScreen> createState() =>
      _PaymentConfirmationScreenState();
}

class _PaymentConfirmationScreenState extends State<PaymentConfirmationScreen> {
  final PosBloc _posBloc = PosBloc();
  StreamController<Object> streamController =
      StreamController<Object>.broadcast();

  Future<void> _onRefresh() async {
    debugPrint('_onRefresh');

    // _posBloc.add(GetCryptoTransactionInfoEvent(uniqueId: widget.uniqueId));
  }

  @override
  void initState() {
    super.initState();
    User.Screen = 'payment confirmation screen';

    // _posBloc.add(GetCryptoTransactionInfoEvent(uniqueId: widget.uniqueId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                "images/pos/success.png",
                height: 180,
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black.withOpacity(0.7),
                      fontWeight: FontWeight.w900),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Transaction Id:",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black.withOpacity(0.7),
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      widget.trxId,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.black.withOpacity(0.7),
                          fontWeight: FontWeight.w500),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy,
                          size: 20, color: Colors.blue),
                      onPressed: () {
                        // Copy the transaction ID to clipboard
                        Clipboard.setData(
                            ClipboardData(text: widget.trxId))
                            .then((_) {
                          // Optional: Show a snackbar or toast to inform the user
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Transaction ID copied to clipboard!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, 'posDashboardScreen', (route) => false);
              },
              child: Container(
                alignment: Alignment.center,
                height: 48,
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.symmetric(
                    horizontal: 30, vertical: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius:
                        const BorderRadius.all(Radius.circular(10))),
                child: const Text(
                  "Go back",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.green,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar(index: 1),
    );
  }
}
