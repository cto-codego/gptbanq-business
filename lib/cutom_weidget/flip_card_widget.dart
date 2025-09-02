import 'package:flutter/material.dart';

class CreditCardDetails {
  final String number;
  final String name;
  final String expiration;
  final double limit;
  final double used;
  final double cardBalance;
  final String cvv;

  CreditCardDetails({
    required this.number,
    required this.name,
    required this.expiration,
    required this.limit,
    required this.used,
    required this.cardBalance,
    required this.cvv,
  });
}

class CreditCardWidget extends StatefulWidget {
  final CreditCardDetails creditCard;
  final bool showDetails;
  final Function(bool) toggleDetails;
  final String cardImage;

  const CreditCardWidget({
    super.key,
    required this.creditCard,
    required this.showDetails,
    required this.toggleDetails,
    required this.cardImage,
  });

  @override
  _CreditCardWidgetState createState() => _CreditCardWidgetState();
}

class _CreditCardWidgetState extends State<CreditCardWidget> {
  bool _isFront = true;

  void _toggleCard() {
    setState(() {
      _isFront = !_isFront;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: _isFront ? _buildFront() : _buildBack(),
    );
  }

  Widget _buildFront() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.network(
            widget.cardImage ?? "",
            fit: BoxFit.cover,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                return child;
              } else {
                return const CircularProgressIndicator(); // Show loading indicator
              }
            },
            errorBuilder:
                (BuildContext context, Object error, StackTrace? stackTrace) {
              return const CircularProgressIndicator(); // Show error icon if image loading fails
            },
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.showDetails
                          ? _formatCardNumber(widget.creditCard.number)
                          : _formatCardNumberHidden(widget.creditCard.number),
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ],
                ),
              ),
              if (widget.showDetails) const SizedBox(height: 10),
              if (widget.showDetails)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Text(
                            widget.creditCard.expiration,
                            style: const TextStyle(
                                fontSize: 15, color: Colors.white),
                          ),
                          const Text(
                            "Expiry Date",
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBack() {
    return RotatedBox(
      quarterTurns: 4,
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color(0xFF5442D0), // Back side color
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              widget.showDetails ? widget.creditCard.cvv : '***',
              // Show CVV if details are shown
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
            const Text(
              'CVV',
              // Show CVV if details are shown
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCardNumber(String cardNumber) {
    String formattedNumber = '';
    for (int i = 0; i < cardNumber.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formattedNumber += ' '; // Insert space every 4 characters
      }
      formattedNumber += cardNumber[i];
    }
    return formattedNumber;
  }

  String _formatCardNumberHidden(String cardNumber) {
    String formattedNumber = '';
    // Determine the length of the portion to be hidden
    int hiddenLength = cardNumber.length - 4;
    for (int i = 0; i < cardNumber.length; i++) {
      if (i > 0 && (i - hiddenLength) % 4 == 0) {
        formattedNumber += ' '; // Insert space every 4 characters
      }
      if (i < hiddenLength) {
        formattedNumber +=
            '*'; // Replace digits with stars for the portion to be hidden
      } else {
        formattedNumber += cardNumber[i]; // Add the last 4 digits as is
      }
    }
    return formattedNumber;
  }
}
