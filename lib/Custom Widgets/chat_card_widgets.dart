import 'package:chat_apk/API/api.dart';
import 'package:chat_apk/Modals/chat_message.dart';
import 'package:chat_apk/Modals/chat_user.dart';

import 'package:chat_apk/Screens/chat_screen.dart';
import 'package:chat_apk/main.dart';
import 'package:chat_apk/others/date_format.dart';
import 'package:chat_apk/others/profile_dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';


class ChatCard extends StatefulWidget {
  final ChatUser user;
  const ChatCard({super.key, required this.user});

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  Message? _message;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // to navigate to chat screen
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => Chat_Screen(
                      user: widget.user,
                    )));
      },
      child: Card(
          margin:
              EdgeInsets.symmetric(horizontal: mq.width * 0.02, vertical: 4),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: StreamBuilder(
              stream: API.getLastMessages(widget.user),
              builder: (context, snapshot) {
                final data = snapshot.data?.docs;
                final list =
                    data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
                if (list.isNotEmpty) {
                  _message = list[0];
                }
                return ListTile(
                    //user profile picture
                    leading: InkWell(
                      onTap: (){
                        showDialog(
                            context: context,
                            builder: (_) => ProfileDialog(user: widget.user));
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(mq.height * 0.3),
                        child: CachedNetworkImage(
                          width: mq.height * 0.055,
                          height: mq.height * 0.055,
                          imageUrl: widget.user.image,
                          errorWidget: (context, url, error) =>
                              const CircleAvatar(
                                  child: Icon(CupertinoIcons.person)),
                        ),
                      ),
                    ),


                    title: Text(widget.user.name),
                    subtitle: Text(
                      _message != null
                          ? _message!.type == Type.image
                              ? 'image'
                              : _message!.msg
                          : widget.user.about,
                      maxLines: 1,
                    ),

                    //last message time
                    trailing: _message == null
                        ? null //show nothing when no message is sent
                        : _message!.read.isEmpty &&
                                _message!.fromId != API.user.uid
                            ? //show for unread message
                            Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                    color: Colors.green.shade300,
                                    borderRadius: BorderRadius.circular(10)),
                              )
                            :
                            //message sent time
                            Text(
                                DateFormat.getLastMessageTime(
                                    context: context, time: _message!.sent),
                                style: const TextStyle(color: Colors.black54),
                              ));
              })),
    );
  }
}
