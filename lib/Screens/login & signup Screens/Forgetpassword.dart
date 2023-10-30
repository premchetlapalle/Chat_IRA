import 'package:chat_apk/Custom%20Widgets/roundbutton.dart';
import 'package:chat_apk/others/dialogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Forgot Password'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 115,bottom: 10 ,left: 20,right: 20),
                  child: Container(
                    child: Image.asset('assets/images/forget.png'),
                  ),
                ),
                const SizedBox(height: 30,),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Colors.black54),
                    prefixIcon: Icon(Icons.alternate_email_outlined)
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                RoundButton(
                    title: 'Forgot',
                    onTap: () {
                      auth
                          .sendPasswordResetEmail(
                              email: emailController.text.toString())
                          .then((value) {
                        Dialogs.showSnackbar(context,
                            'We have sent you email to recover password, please check email');
                      }).onError((error, stackTrace) {
                        Dialogs.showSnackbar(context , error.toString());
                      });
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
