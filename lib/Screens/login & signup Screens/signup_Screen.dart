// ignore_for_file: non_constant_identifier_names

import 'package:chat_apk/API/api.dart';
import 'package:chat_apk/Custom%20Widgets/roundbutton.dart';
import 'package:chat_apk/Modals/chat_user.dart';
import 'package:chat_apk/Screens/login%20&%20signup%20Screens/login_screen.dart';
import 'package:chat_apk/others/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
  }

  void SignUp() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });

      API.auth
          .createUserWithEmailAndPassword(
        email: emailController.text.toString(),
        password: passwordController.text.toString(),
      )
          .then((userCredential) {
        // User created successfully, send verification email
        userCredential.user!.sendEmailVerification().then((_) {
          // Set the user's display name
          userCredential.user!.updateDisplayName(nameController.text);

          // Create a ChatUser object with the provided name
          ChatUser chatUser = ChatUser(
            id: userCredential.user!.uid,
            name: nameController.text,
            email: emailController.text.toString(),
            about: "Available",
            image: '',
            createdAt: '',
            isOnline: false,
            lastActive: '',
            pushToken: '',
          );

          // Call the API to create the user with the provided data
          API.createUserWithChatUser(chatUser).then((value) {
            Dialogs.showSnackbar(context, 'Verification email sent');
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Login_Screen()),
            );
          }).catchError((error) {
            Dialogs.showSnackbar(context, 'Failed to create user: $error');
          }).whenComplete(() {
            setState(() {
              loading = false;
            });
          });
        }).catchError((error) {
          Dialogs.showSnackbar(
              context, 'Failed to send verification email: $error');
          setState(() {
            loading = false;
          });
        });
      }).catchError((error) {
        Dialogs.showSnackbar(context, error.toString());
        setState(() {
          loading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Sign up",
            // style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 120, bottom: 50),
                child: Container(
                  height: 200,
                  width: 300,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        25), // Adjust the value to change the amount of curvature
                    child: Image.asset('assets/images/ChatIRA.png'),
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 35, right: 35, bottom: 5),
                          child: Column(
                            children: [
                              TextFormField(
                                keyboardType: TextInputType.text,
                                controller: nameController,
                                decoration: const InputDecoration(
                                  hintText: 'Name',
                                  prefixIcon: Icon(Icons.person),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Enter name';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              TextFormField(
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
                                height: 15,
                              ),
                              TextFormField(
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
                            ],
                          ),
                        )),
                    const SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 35, right: 35),
                      child: RoundButton(
                          title: 'Sign up',
                          loading: loading,
                          onTap: () {
                            SignUp();
                          }),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(fontSize: 17),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Login_Screen()));
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                  fontSize: 19, color: Colors.redAccent),
                            ))
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
