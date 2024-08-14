import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'otp_screen.dart';

class NumberScreen extends StatefulWidget {
  @override
  State<NumberScreen> createState() => _NumberScreenState();
}

class _NumberScreenState extends State<NumberScreen> {
  final phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 150,),
            TextFormField(
              controller: phoneNumberController,
              decoration: InputDecoration(
                hintText: "Phone Number",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            MaterialButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.verifyPhoneNumber(
                    phoneNumber: phoneNumberController.text,
                    verificationCompleted: (phoneAuthCredential) {},
                    verificationFailed: (error) {
                      log('Verification failed: ${error.message}');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Verification failed')),
                      );
                    },
                    codeSent: (verificationId, forceResendingToken) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OtpScreen(verificationId: verificationId),
                        ),
                      );
                    },
                    codeAutoRetrievalTimeout: (verificationId) {
                      log("Auto retrieval timeout");
                    },
                  );
                } catch (e) {
                  log('Error during phone number verification: $e');
                }
              },
              child: Text("Send"),
            ),
          ],
        ),
      ),
    );
  }
}

class OtpScreen extends StatefulWidget {
  final String verificationId;

  OtpScreen({Key? key, required this.verificationId}) : super(key: key);

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
                hintText: "OTP",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            MaterialButton(
              onPressed: () async {
                try {
                  final credential = PhoneAuthProvider.credential(
                    verificationId: widget.verificationId,
                    smsCode: otpController.text,
                  );
                  await FirebaseAuth.instance.signInWithCredential(credential);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                } catch (e) {
                  log('Error during OTP verification: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Invalid OTP')),
                  );
                }
              },
              child: Text("Send"),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'dart:developer';
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_study/otp_screen.dart';
// import 'package:flutter/material.dart';
//
// class NumberScreen extends StatefulWidget {
//   @override
//   State<NumberScreen> createState() => _NumberScreenState();
// }
//
// class _NumberScreenState extends State<NumberScreen> {
// final phoneNumberController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           SizedBox(height: 150,),
//           Center(
//             child: TextFormField(
//               controller: phoneNumberController,
//               decoration: InputDecoration(
//                 hintText: "Phone Number",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 )
//               ),
//             ),
//           ),
//           MaterialButton(onPressed: ()async{
//             FirebaseAuth.instance.verifyPhoneNumber(
//               phoneNumber: phoneNumberController.text,
//                 verificationCompleted: (phoneAuthCredential){},
//                 verificationFailed: (error){
//                 log(error.toString());
//                 },
//                 codeSent: (verificationId, forceRespondingToken){
//                 Navigator.push(context, MaterialPageRoute(builder: (context)=> OtpScreen(verificationId: verificationId,)));
//                 },
//                 codeAutoRetrievalTimeout: (verificationId){
//                 log("Auto Retireval timeout");
//                 },);
//           },
//           child: Text("Send"),)
//         ],
//       ),
//     );
//   }
// }
