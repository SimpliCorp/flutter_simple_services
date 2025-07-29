import 'package:example/firebase_options.dart';
import 'package:example/initialization_status_widget.dart';
import 'package:example/log.dart';
import 'package:example/my_home_page_with_stream.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_services/flutter_simple_services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Firebase initialization and create user.
    logWarning(
      "Starting Firebase initialization... ${DateTime.now().toIso8601String()})",
    );
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
        .then((value) {
          logSuccess("Firebase initialized successfully");

          SimpleServicesManager.instance.initialize();

          requestPushNotification();
        })
        .catchError((error) {
          logError("Firebase initialization failed: $error");
        });
  } catch (e) {
    logError(e.toString());
  }
  logWarning("Run appp ... ${DateTime.now().toIso8601String()})");

  MobileAds.instance.initialize();

  runApp(const MyApp());
}

requestPushNotification() async {
  // request notifcation permission
  // You may set the permission requests to "provisional" which allows the user to choose what type
  // of notifications they would like to receive once the user receives a notification.
  final notificationSettings = await FirebaseMessaging.instance
      .requestPermission(provisional: true);

  // For apple platforms, ensure the APNS token is available before making any FCM plugin API calls
  final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
  if (apnsToken != null) {
    // APNS token is available, make FCM plugin API requests...
    logSuccess("APNS token is available, make FCM plugin API requests...");
    logSuccess(apnsToken);
  } else {
    logError("APNS token is not available, make FCM plugin API requests...");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const InitializationStatusWidget(
        child: MyHomePageWithStream(title: 'Simple Services'),
      ),
    );
  }
}
