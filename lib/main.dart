import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_study/home_screen.dart';
import 'package:firebase_study/number_screen.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyBluUGr3dHo-ViVrDSu7V3wCvwzCE54qoc",
          appId: "1:275915413171:android:e23effc4475deaebf582c6",
          messagingSenderId: "fir-study-f9e6d.appspot.com",
          projectId: "fir-study-f9e6d"));
  runApp(MyApp());
  initOneSignal();
}

Future<void> initOneSignal() async {
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize("485b09ed-ab26-4b2b-8aa8-124e07f34030");
  await OneSignal.Notifications.requestPermission(true);
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    onClickOneSignal();
    return MaterialApp(
      home: NumberScreen(),
    );
  }

  void onClickOneSignal() {
    OneSignal.Notifications.addClickListener((event) {
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    });
  }
}
