import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_study/presentation/login_screen.dart/view/login_screen.dart';
import 'package:firebase_study/utils/app_colors.dart';
import 'package:firebase_study/presentation/home_screen.dart/widgets/round_gradient_button.dart';
import 'package:firebase_study/presentation/home_screen.dart/widgets/round_text_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection("users");
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isObscure = true;
  bool isCheck = false;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.WhiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: media.height * 0.1),
                  SizedBox(
                    width: media.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: media.width * 0.03),
                        Text(
                          "Hey There",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: media.height * 0.01),
                        Text(
                          "Create an Account",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: media.height * 0.02),
                  RoundTextField(
                    textEditingController: firstNameController,
                    hintText: "First Name",
                    textInputType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your first name";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: media.height * 0.05),
                  RoundTextField(
                    textEditingController: lastNameController,
                    hintText: "Last Name",
                    textInputType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your last name";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: media.height * 0.05),
                  RoundTextField(
                    textEditingController: emailController,
                    hintText: "Email",
                    textInputType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your email";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: media.height * 0.05),
                  RoundTextField(
                    textEditingController: passwordController,
                    hintText: "Password",
                    isObsecureText: isObscure,
                    textInputType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your password";
                      } else if (value.length < 6) {
                        return "Password must be at least 6 characters long";
                      }
                      return null;
                    },
                    rightIcon: TextButton(
                      onPressed: () {
                        setState(() {
                          isObscure = !isObscure;
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 30,
                        width: 30,
                        child: Icon(
                          isObscure ? Icons.visibility : Icons.visibility_off,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: media.width * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            isCheck = !isCheck;
                          });
                        },
                        icon: Icon(
                          isCheck
                              ? Icons.check_box_outlined
                              : Icons.check_box_outline_blank,
                          color: AppColors.greyColor,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "By continuing you accept our Privacy Policy and terms of use",
                          style: TextStyle(
                            color: AppColors.greyColor,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: media.height * 0.05),
                  RoundGradientButton(
                    title: "Create Account",
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        if (isCheck) {
                          try {
                            UserCredential userCredential =
                                await auth.createUserWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text,
                            );
                            String uid = userCredential.user!.uid;
                            await users.doc(uid).set({
                              'email': emailController.text,
                              'firstName': firstNameController.text,
                              'lastName': lastNameController.text,
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Account Created"),
                              ),
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(e.toString()),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  "Please accept the Privacy Policy and terms of use"),
                            ),
                          );
                        }
                      }
                    },
                  ),
                  SizedBox(height: media.height * 0.1),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: double.maxFinite,
                          height: 1,
                          color: AppColors.greyColor.withOpacity(0.5),
                        ),
                      ),
                      Text(
                        "or",
                        style: TextStyle(
                          color: AppColors.greyColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: double.maxFinite,
                          height: 1,
                          color: AppColors.greyColor.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: media.height * 0.1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 50,
                          width: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: AppColors.PrimaryColor1.withOpacity(0.5),
                              width: 1,
                            ),
                          ),
                          child: FaIcon(FontAwesomeIcons.google),
                        ),
                      ),
                      SizedBox(width: 30),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 50,
                          width: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: AppColors.PrimaryColor1.withOpacity(0.5),
                              width: 1,
                            ),
                          ),
                          child: FaIcon(FontAwesomeIcons.facebook),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: media.width * 0.005),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        children: [
                          TextSpan(text: "Already have an account? "),
                          TextSpan(
                            text: "Login",
                            style: TextStyle(
                              color: AppColors.secondaryColor1,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
