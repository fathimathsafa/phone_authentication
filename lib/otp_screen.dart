import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_study/home_screen.dart';
import 'package:flutter/material.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;

  OtpScreen({super.key, required this.verificationId});
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            TextFormField(
              controller: otpController,
              decoration: InputDecoration(
                  hintText: "otp",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  )
              ),
            ),
            MaterialButton(onPressed: ()async{
              try{
                final cred = PhoneAuthProvider.credential(
                    verificationId:widget.verificationId ,
                    smsCode: otpController.text);

                await FirebaseAuth.instance.signInWithCredential(cred);
                Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeScreen()));
              } catch (e){
                log(e.toString());
              }
            },
              child: Text("Send"),)
          ],
        ),
      ),
    );
  }
}
