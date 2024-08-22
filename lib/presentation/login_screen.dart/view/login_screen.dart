import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_study/presentation/home_screen.dart/view/home_screen.dart';
import 'package:firebase_study/presentation/signup_screen/view/signup_screen.dart';
import 'package:firebase_study/utils/app_colors.dart';
import 'package:firebase_study/presentation/home_screen.dart/widgets/round_gradient_button.dart';
import 'package:firebase_study/presentation/home_screen.dart/widgets/round_text_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isObscure = true;
  final formKey = GlobalKey<FormState>();

  Future<User?> signIn(
      BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      User? user = userCredential.user;
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen1()));
      return user;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Login Failed, Please check your email and password"),
      ));
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
  }

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
                SizedBox(
                  height: media.height * 0.1,
                ),
                SizedBox(
                  width: media.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: media.width * 0.03,
                      ),
                      Text(
                        "Hey There",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: media.height * 0.01,
                      ),
                      Text(
                        "Welcome Back",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: media.height * 0.01,
                ),
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
                SizedBox(
                  height: media.height * 0.05,
                ),
                RoundTextField(
                  textEditingController: passwordController,
                  hintText: "Password",
                   isObsecureText: isObscure,
                  textInputType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your password";
                    } else if (value.length < 6) {
                      return "Password must be atleast 6 characters long";
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
                          isObscure ?Icons.visibility : Icons.visibility_off,),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "Forgot your password",
                      style: TextStyle(
                          color: AppColors.secondaryColor1,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                SizedBox(
                  height: media.height * 0.1,
                ),
                RoundGradientButton(
                    title: "Login",
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        signIn(context, emailController.text,
                            passwordController.text);
                      }
                    }),
                SizedBox(
                  height: media.height * 0.1,
                ),
                Row(
                  children: [
                    Expanded(
                        child: Container(
                      width: double.maxFinite,
                      height: 1,
                      color: AppColors.greyColor.withOpacity(0.5),
                    )),
                    Text(
                      "or",
                      style: TextStyle(
                          color: AppColors.greyColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                    Expanded(
                        child: Container(
                      width: double.maxFinite,
                      height: 1,
                      color: AppColors.greyColor.withOpacity(0.5),
                    ))
                  ],
                ),
                SizedBox(
                  height: media.height * 0.1,
                ),
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
                                width: 1)),
                        child: FaIcon(FontAwesomeIcons.google),
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
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
                                width: 1)),
                        child: FaIcon(FontAwesomeIcons.facebook),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: media.width * 0.005,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen()));
                    },
                    child: RichText(
                        text: TextSpan(
                            style: TextStyle(
                                color: AppColors.blackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                            children: [
                          TextSpan(text: "Don't have an account? "),
                          TextSpan(
                              text: "Register ",
                              style: TextStyle(
                                  color: AppColors.secondaryColor1,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500))
                        ])))
              ],
            ),
          ),
        ),
      )),
    );
  }
}
