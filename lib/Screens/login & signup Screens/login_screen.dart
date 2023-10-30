// ignore_for_file: use_build_context_synchronously, camel_case_types

import 'dart:io';

import 'package:chat_apk/API/api.dart';
import 'package:chat_apk/Custom%20Widgets/roundbutton.dart';
import 'package:chat_apk/Screens/login%20&%20signup%20Screens/Forgetpassword.dart';
import 'package:chat_apk/Screens/home_screen.dart';
import 'package:chat_apk/Screens/login%20&%20signup%20Screens/signup_Screen.dart';
import 'package:chat_apk/main.dart';
import 'package:chat_apk/others/dialogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login_Screen extends StatefulWidget {
  const Login_Screen({super.key});

  @override
  State<Login_Screen> createState() => _Login_ScreenState();
}

class _Login_ScreenState extends State<Login_Screen> {
  _handleGoogleBtnClick() {
    //for showing progress bar
    Dialogs.showProgressBar(context);
    signInWithGoogle().then((user) async {
      //for hiding progress bar
      Navigator.pop(context);
      if (user != null) {
        if (await API.userExists()) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const Home_Screen()));
        } else {
          await API.createUser().then((value) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => const Home_Screen()));
          });
        }
      }
    });
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      Dialogs.showSnackbar(context,
          'Something Went Wrong Please Check Your Internet Connection!');
    }
    return null;
  }

  //---------------------------------------------
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   emailController.dispose();
  //   passwordController.dispose();
  // }

  void login() {
    setState(() {
      loading = true;
    });
    API.auth
        .signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text.toString())
        .then((userCredential) {
      if (userCredential.user != null && userCredential.user!.emailVerified) {
        Dialogs.showSnackbar(context, 'Login Successful');
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Home_Screen()));
      } else {
        Dialogs.showSnackbar(context, 'Email not verified. Please verify your email.');
      }
      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      Dialogs.showSnackbar(context, error.toString());
      setState(() {
        loading = false;
      });
    });
  }

  //----------------------------------------------

  // ---------- to hide google sign in button when pressed on email & password --------
  late FocusNode _emailFocusNode;
  late FocusNode _passwordFocusNode;
  bool showGoogleButton = true;

  @override
  void initState() {
    super.initState();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _emailFocusNode.addListener(updateButtonVisibility);
    _passwordFocusNode.addListener(updateButtonVisibility);
  }

  void updateButtonVisibility() {
    setState(() {
      // Hide Google button if either of the text fields has focus
      showGoogleButton =
          !_emailFocusNode.hasFocus && !_passwordFocusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  //-------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    // mq = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Welcome to ChatIRA'),
        ),
        body: Stack(
          children: [
            Positioned(
              top: mq.height * 0.1,
              left: mq.width * 0.141,
              width: mq.width * 0.72,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                    25), // Adjust the value to change the amount of curvature
                child: Image.asset('assets/images/ChatIRA.png'),
              ),
            ),
            Form(
              key: _formKey,
              child: Positioned(
                top: mq.height * 0.375,
                left: mq.width * 0.1,
                width: mq.width * 0.8,
                child: Column(
                  children: [
                    TextFormField(
                      focusNode: _emailFocusNode,
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      decoration: const InputDecoration(
                          hintText: 'Email',
                          prefixIcon: Icon(Icons.alternate_email)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      focusNode: _passwordFocusNode,
                      keyboardType: TextInputType.text,
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                          hintText: 'Password',
                          prefixIcon: Icon(Icons.lock_open)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    RoundButton(
                      title: 'Login',
                      loading: loading,
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          login();
                        }
                      },
                    ),
                    const SizedBox(height: 7),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgotPasswordScreen()));
                          },
                          child: const Text('Forgot Password?',
                              style: TextStyle(fontSize: 16,color: Colors.redAccent))),
                    ),
                    const SizedBox(
                      height: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?",style: TextStyle(fontSize: 17),),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const SignUpScreen()));
                            },
                            child: const Text(
                              'Sign up',
                              style: TextStyle(fontSize: 17,color: Colors.redAccent),
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: mq.height * 0.105,
              left: mq.width * 0.145,
              width: mq.width * 0.71,
              height: mq.height * 0.055,
              child: Visibility(
                visible: showGoogleButton,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade800,
                    shape: const StadiumBorder(),
                    elevation: 1,
                  ),
                  onPressed: () {
                    _handleGoogleBtnClick();
                  },
                  icon: Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Image.asset('assets/images/google.png'),
                  ),
                  label: const Text(
                    ' Sign In with Google',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
