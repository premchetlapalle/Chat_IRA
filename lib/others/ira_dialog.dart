
// ignore_for_file: camel_case_types

import 'package:chat_apk/main.dart';
import 'package:flutter/material.dart';

class IRA_Dialog extends StatelessWidget {
  const IRA_Dialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white.withOpacity(.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SizedBox(
          width: mq.width * .6,
          height: mq.height * .35,
          child: Stack(
            children: [
              //user profile picture
              Positioned(
                top: mq.height * .08,
                left: mq.width * .07,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * 0.3),
                  child: Container(
                    width: mq.height * 0.24,
                    height: mq.height * 0.24,
                    child: CircleAvatar(
                      backgroundColor: const Color(0xffbff4d4d),
                      child: Image.asset(
                        'assets/images/IRA.gif',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),

              //user name
              Positioned(
                left: mq.width * .075,
                top: mq.height * .025,
                width: mq.width * .55,
                child: const Text('Intelligent robot assistance',
                    style: TextStyle(
                      color: Color(0xff263238),
                        fontSize: 18, fontWeight: FontWeight.w500)),
              ),
            ],
          )),
    );
  }
}