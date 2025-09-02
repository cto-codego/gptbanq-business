import 'package:flutter/material.dart';
import '../constant_string/User.dart';
import '../utils/input_fields/custom_color.dart';

class KeyPad2 extends StatelessWidget {
  final TextEditingController? pinController;
  final Function(String)? onChange;

  KeyPad2({
    this.onChange,
    this.pinController,
  });

  @override
  Widget build(BuildContext context) {
    // Declare buttonContainer function before its usage.
    Widget buttonContainer({required Widget child}) {
      return Container(
        height: 60,
        width: 60,
        padding: const EdgeInsets.all(1),
        alignment: Alignment.center,
        child: child,
      );
    }

    Widget iconButtonWidget(IconData icon, Function function) {
      return buttonContainer(
        child: InkWell(
          onTap: () => function(),
          child: Center(
            child: Icon(
              icon,
              size: 30,
              color: CustomColor.black,
            ),
          ),
        ),
      );
    }

    Widget buttonWidget(String buttonText) {
      return buttonContainer(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            elevation: 0,
            disabledForegroundColor: Colors.transparent.withOpacity(0.38),
            disabledBackgroundColor: Colors.transparent.withOpacity(0.12),
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          onPressed: () {
            pinController!.text = '${pinController!.text + buttonText}';
            if (onChange != null) {
              onChange!(pinController!.text); // Call onChange with the updated text
            }
          },
          child: Center(
            child: Text(
              buttonText,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 25,
              ),
            ),
          ),
        ),
      );
    }

    // Main widget structure
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buttonWidget('1'),
              buttonWidget('2'),
              buttonWidget('3'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buttonWidget('4'),
              buttonWidget('5'),
              buttonWidget('6'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buttonWidget('7'),
              buttonWidget('8'),
              buttonWidget('9'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buttonContainer(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.transparent,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    disabledForegroundColor: Colors.transparent.withOpacity(0.38),
                    disabledBackgroundColor: Colors.transparent.withOpacity(0.12),
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  onPressed: () {
                    if (pinController!.text.contains('.')) {
                      return;
                    }
                    if (pinController!.text.isEmpty) {
                      pinController!.text = pinController!.text + '0.';
                    } else {
                      pinController!.text = pinController!.text + '.';
                    }
                    if (onChange != null) {
                      onChange!(pinController!.text); // Call onChange with the updated text
                    }
                  },
                  child:  Text(
                   User.isEu == 0 ? '.' : ',',
                    textAlign : TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                      fontSize: 25,
                      height: 0,
                    ),
                  ),
                ),
              ),
              buttonWidget('0'),
              iconButtonWidget(Icons.arrow_back_rounded, () {
                if (pinController!.text.isNotEmpty) {
                  pinController!.text = pinController!.text
                      .substring(0, pinController!.text.length - 1);
                }
                if (onChange != null) {
                  onChange!(pinController!.text); // Call onChange with the updated text
                }
              }),
            ],
          ),
        ],
      ),
    );
  }
}