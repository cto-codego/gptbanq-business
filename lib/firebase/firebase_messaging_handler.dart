import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingHandler {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void initialize() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle foreground messages
      print('Message received: ${message.notification?.title}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle when the app is opened from a notification
      _handleMessage(message);
    });

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        // Handle when the app is launched by a notification
        _handleMessage(message);
      }
    });
  }

  void _handleMessage(RemoteMessage message) {
    // Navigate to a specific screen based on notification data
    if (message.data['screen'] != null) {
      String screen = message.data['screen'];
      // Use a navigator key to navigate to the desired screen
      // navKey.currentState?.pushNamed(screen);
    }
  }
}
