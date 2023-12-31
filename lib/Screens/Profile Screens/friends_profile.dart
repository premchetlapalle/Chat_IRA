// ignore_for_file: camel_case_types

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_apk/Modals/chat_user.dart';
import 'package:chat_apk/main.dart';
import 'package:chat_apk/others/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Friend_Profile extends StatefulWidget {
  const Friend_Profile({super.key, required this.user});
  final ChatUser user;

  @override
  State<Friend_Profile> createState() => _Friend_ProfileState();
}

class _Friend_ProfileState extends State<Friend_Profile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: AppBar(
            title: Text(widget.user.name),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Joined On : ',
                    style: TextStyle(
                        color: Color(0xff263238),
                        fontSize: 20,
                        fontWeight: FontWeight.w500)),
                Text(
                  DateFormat.getLastMessageTime(
                      context: context,
                      time: widget.user.createdAt,
                      showYear: true),
                  style:
                      const TextStyle(color: Color(0xff546E7A), fontSize: 20),
                ),
              ],
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * 0.05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: mq.width,
                    height: mq.height * .05,
                  ),
                  //profile image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height * 0.1),
                    child: CachedNetworkImage(
                      width: mq.height * 0.2,
                      height: mq.height * 0.2,
                      fit: BoxFit.cover,
                      imageUrl: widget.user.image,
                      // placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const CircleAvatar(
                          backgroundColor: Color(0xffbff4d4d),
                          child: Icon(
                            CupertinoIcons.person,
                            size: 120,
                            color: CupertinoColors.white,
                          )),
                    ),
                  ),
                  SizedBox(
                    width: mq.width,
                    height: mq.height * .04,
                  ),
                  Text(
                    widget.user.email,
                    style: const TextStyle(
                        color: Color(0xff263238),
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    width: mq.width,
                    height: mq.height * .04,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('About : ',
                          style: TextStyle(
                              color: Color(0xff263238),
                              fontSize: 20,
                              fontWeight: FontWeight.w500)),
                      Text(
                        widget.user.about,
                        style: const TextStyle(
                            color: Color(0xff546E7A), fontSize: 20),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: mq.width,
                    height: mq.height * .04,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Last Active : ',
                          style: TextStyle(
                              color: Color(0xff263238),
                              fontSize: 20,
                              fontWeight: FontWeight.w500)),
                      Text(
                        DateFormat.getLastActiveTime(
                            context: context,
                            lastActive: widget.user.lastActive),
                        style: const TextStyle(
                          color: Color(0xff546E7A),
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
