import 'package:flutter/material.dart';

enum ToastType { success, error, warning }

class ToastHelper {
  static void showToast(BuildContext context, String title, String message, ToastType type) {
    final overlay = Overlay.of(context);

    // Declare the overlayEntry variable
    OverlayEntry? overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) {
        Color backgroundColor;
        Icon icon;

        switch (type) {
          case ToastType.success:
            backgroundColor = Colors.green;
            icon = Icon(Icons.check_circle, color: Colors.white);
            break;
          case ToastType.error:
            backgroundColor = Colors.red;
            icon = Icon(Icons.error, color: Colors.white);
            break;
          case ToastType.warning:
            backgroundColor = Colors.orange;
            icon = Icon(Icons.warning, color: Colors.white);
            break;
        }

        return Positioned(
          top: 50.0, // Position the toast at the top
          left: MediaQuery.of(context).size.width * 0.1,
          right: MediaQuery.of(context).size.width * 0.1,
          child: Material(
            color: Colors.transparent,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: Offset(1.0, 0.0), // Start from right
                end: Offset.zero, // End at original position
              ).animate(CurvedAnimation(
                parent: AnimationController(
                  vsync: Overlay.of(context), // Use Overlay for animation
                  duration: Duration(milliseconds: 300),
                )..forward(),
                curve: Curves.easeIn,
              )),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    icon,
                    SizedBox(width: 12), // Spacing between icon and title
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.0),
                          ),
                          Text(
                            message,
                            style: TextStyle(color: Colors.white, fontSize: 14.0),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10), // Spacing between text and close icon
                    GestureDetector(
                      onTap: () {
                        // Animate out
                        overlayEntry!.remove();
                        overlayEntry = null; // Clear the overlayEntry
                      },
                      child: Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    // Show the toast
    overlay.insert(overlayEntry!);

    // Remove the toast after a delay (optional)
    Future.delayed(Duration(seconds: 4), () {
      overlayEntry?.remove();
      overlayEntry = null; // Clear the overlayEntry
    });
  }
}