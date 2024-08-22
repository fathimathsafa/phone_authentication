import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_study/presentation/home_screen.dart/view/home_screen.dart';
import 'package:firebase_study/presentation/login_screen.dart/view/login_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyBluUGr3dHo-ViVrDSu7V3wCvwzCE54qoc",
          appId: "1:275915413171:android:e23effc4475deaebf582c6",
          messagingSenderId: "fir-study-f9e6d.appspot.com",
          projectId: "fir-study-f9e6d"));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Reminder App",
      debugShowCheckedModeBanner: false,
      home:_auth.currentUser != null ? HomeScreen1() : LoginScreen() ,
    );
  }
}
