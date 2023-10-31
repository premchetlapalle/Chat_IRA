// ignore_for_file: camel_case_types

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_apk/API/api.dart';
import 'package:chat_apk/Custom%20Widgets/message_widget.dart';
import 'package:chat_apk/Modals/chat_message.dart';
import 'package:chat_apk/Modals/chat_user.dart';
import 'package:chat_apk/Screens/Profile%20Screens/friends_profile.dart';
import 'package:chat_apk/main.dart';
import 'package:chat_apk/others/date_format.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Chat_Screen extends StatefulWidget {
  final ChatUser user;
  const Chat_Screen({super.key, required this.user});

  @override
  State<Chat_Screen> createState() => _Chat_ScreenState();
}

class _Chat_ScreenState extends State<Chat_Screen> {
  //for storing all messages
  List<Message> list = [];
  final textController = TextEditingController();
  bool showEmoji = false, _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () {
            //if emoji is shown and back button is pressed then hide emoji bar
            if (showEmoji) {
              setState(() {
                showEmoji = !showEmoji;
              });
              return Future.value(false);
            }
            //close the current screen
            else {
              return Future.value(true);
            }
          },
          child: Scaffold(
            backgroundColor: const Color(0xffFCECE9),
            appBar: AppBar(
              backgroundColor: Colors.red,
              automaticallyImplyLeading: false,
              flexibleSpace: _appBar(),
            ),
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: API.getAllMessages(widget.user),
                    // stream: API.getAllUser(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        //if data is loading
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return const SizedBox();

                        //if some or all data is loaded then show it
                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;
                          list = data
                                  ?.map((e) => Message.fromJson(e.data()))
                                  .toList() ??
                              [];
                          if (list.isNotEmpty) {
                            return ListView.builder(
                                reverse: true,
                                itemCount: list.length,
                                padding: EdgeInsets.only(top: mq.height * 0.01),
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Message_Card(message: list[index]);
                                });
                          } else {
                            return const Center(
                                child: Text(
                              'Say Hello!👋',
                              style: TextStyle(fontSize: 25),
                            ));
                          }
                      }
                    },
                  ),
                ),
                //circle indicator for showing uploading
                if (_isUploading)
                  const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 22, vertical: 8),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )),

                _chatInput(),

                //to show emoji keyboard
                if (showEmoji)
                  SizedBox(
                    height: mq.height * 0.35,
                    child: EmojiPicker(
                      textEditingController: textController,
                      config: Config(
                        // bgColor: const Color(0xffFCECE9),
                        bgColor: Colors.white,
                        columns: 8,
                        emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  //custom app bar
  Widget _appBar() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => Friend_Profile(user: widget.user)));
      },
      child: StreamBuilder(
          stream: API.getUserInfo(widget.user),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            final list =
                data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
            return Row(
              children: [
                //back button
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 28,
                    )),
                //user profile picture
                ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * 0.03),
                  child: CachedNetworkImage(
                    width: mq.height * 0.05,
                    height: mq.height * 0.05,
                    imageUrl:
                        list.isNotEmpty ? list[0].image : widget.user.image,
                    // placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const CircleAvatar(
                      backgroundColor: Color(0xffb2D65E7),
                        child: Icon(
                      CupertinoIcons.person,
                      color: CupertinoColors.white,
                      size: 28,
                    )),
                  ),
                ),
                const SizedBox(
                  width: 13,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 7),

                    //user name
                    Text(
                      list.isNotEmpty ? list[0].name : widget.user.name,
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 1),

                    //last seen time of user
                    Text(
                      list.isNotEmpty
                          ? list[0].isOnline
                              ? 'Online'
                              : DateFormat.getLastActiveTime(
                                  context: context,
                                  lastActive: list[0].lastActive)
                          : DateFormat.getLastActiveTime(
                              context: context,
                              lastActive: widget.user.lastActive),
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xffbd9d9d9),
                      ),
                    ),
                  ],
                ),

                // //video call button
                // IconButton(
                //     onPressed: () {
                //       Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //               builder: (_) => Call_Screen(
                //                     user: widget.user,
                //                   )));
                //     },
                //     icon: const Icon(
                //       Icons.video_call,
                //       color: Colors.black54,
                //     )),
                //user profile picture
                // ClipRRect(
                //   borderRadius: BorderRadius.circular(mq.height * 0.03),
                //   child: CachedNetworkImage(
                //     width: mq.height * 0.05,
                //     height: mq.height * 0.05,
                //     imageUrl:
                //         list.isNotEmpty ? list[0].image : widget.user.image,
                //     // placeholder: (context, url) => CircularProgressIndicator(),
                //     errorWidget: (context, url, error) =>
                //         const CircleAvatar(child: Icon(CupertinoIcons.person)),
                //   ),
                // ),
              ],
            );
          }),
    );
  }

  //bottom bar to send messages
  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: mq.width * 0.025, vertical: mq.height * 0.01),
      child: Row(children: [
        Expanded(
          child: Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Row(
              children: [
                //emoji button
                IconButton(
                    onPressed: () {
                      setState(() {
                        FocusScope.of(context).unfocus();
                        showEmoji = !showEmoji;
                      });
                    },
                    icon: const Icon(
                      Icons.emoji_emotions,
                      color: Colors.redAccent,
                    )),

                Expanded(
                    child: TextField(
                  controller: textController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onTap: () {
                    if (showEmoji) {
                      setState(() => showEmoji = !showEmoji);
                    }
                  },
                  decoration: const InputDecoration(
                    hintText: "Type Something....",
                    hintStyle: TextStyle(color: Colors.redAccent),
                    border: InputBorder.none,
                  ),
                )),

                //image from gallery
                IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();

                      // Pick an multiple image.
                      final List<XFile> images =
                          await picker.pickMultiImage(imageQuality: 70);

                      //uploading and sending images
                      for (var i in images) {
                        if (images.isNotEmpty) {
                          setState(() => _isUploading = true);
                          await API.sendChatImage(widget.user, File(i.path));
                          setState(() => _isUploading = false);
                        }
                      }
                    },
                    icon: const Icon(
                      Icons.image,
                      color: Colors.redAccent,
                    )),

                //image from camera
                IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      // Pick an image.
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.camera, imageQuality: 70);
                      if (image != null) {
                        setState(() => _isUploading = true);
                        await API.sendChatImage(widget.user, File(image.path));
                        setState(() => _isUploading = false);
                      }
                    },
                    icon: const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.redAccent,
                    )),
                const SizedBox(
                  width: 5,
                )
              ],
            ),
          ),
        ),
        const SizedBox(
          width: 3,
        ),

        //send message button
        MaterialButton(
          onPressed: () {
            if (textController.text.isNotEmpty) {
              if (list.isEmpty) {
                //send first message and add user
                API.sendFirstMessage(
                    widget.user, textController.text, Type.text);
              } else {
                //send a message
                API.sendMessage(widget.user, textController.text, Type.text);
              }

              textController.text = '';
            }
          },
          minWidth: 0,
          padding: const EdgeInsets.all(8),
          shape: const CircleBorder(),
          color: Colors.redAccent,
          child: const Icon(
            Icons.send,
            color: Colors.white,
            size: 26,
          ),
        )
      ]),
    );
  }
}
