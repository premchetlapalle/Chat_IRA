import 'package:chat_apk/Screens/home_screen.dart';
import 'package:chat_apk/Screens/login%20&%20signup%20Screens/login_screen.dart';
import 'package:chat_apk/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Splash_Screen extends StatefulWidget {
  const Splash_Screen({Key? key}) : super(key: key);

  @override
  State<Splash_Screen> createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    _animation = Tween<double>(begin: 0.0, end: 2.0).animate(_animationController);

    _animationController.forward();

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        checkAuthentication();
      }
    });
  }

  Future<void> checkAuthentication() async {
    if (FirebaseAuth.instance.currentUser != null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const Home_Screen()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const Login_Screen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 120, right: 120),
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.scale(
                scale: _animation.value,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.asset('assets/images/ChatIRA.png'),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
