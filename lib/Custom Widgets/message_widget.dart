// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_apk/API/api.dart';
import 'package:chat_apk/Modals/chat_message.dart';
import 'package:chat_apk/main.dart';
import 'package:chat_apk/others/date_format.dart';
import 'package:chat_apk/others/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';

class Message_Card extends StatefulWidget {
  const Message_Card({super.key, required this.message});
  final Message message;

  @override
  State<Message_Card> createState() => _Message_CardState();
}

class _Message_CardState extends State<Message_Card> {
  @override
  Widget build(BuildContext context) {
    bool isMe = API.user.uid == widget.message.fromId;
    return InkWell(
        onLongPress: () {
          showBottomSheet(isMe);
        },
        child: isMe ? _RedMessage() : _blueMessage());
  }

  //another user message
  Widget _blueMessage() {
    //update last read message if sender and receiver are different
    if (widget.message.read.isEmpty) {
      API.updateMessageReadStatus(widget.message);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //message
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image
                ? mq.width * 0.02
                : mq.width * 0.03),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * 0.04, vertical: mq.height * 0.01),
            decoration: BoxDecoration(
                color: Colors.blue.shade100,
                border: Border.all(color: Colors.blueAccent),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                  topRight: Radius.circular(25),
                )),
            child: widget.message.type == Type.text
                ?
                // to display text
                Text(
                    widget.message.msg,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  )
                :
                // to display image
                ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.image,
                        size: 70,
                      ),
                    ),
                  ),

            // GestureDetector(
            //     onTap: () {
            //       showDialog(
            //         context: context,
            //         builder: (BuildContext context) {
            //           return Dialog(
            //             child: InteractiveViewer(
            //               child: CachedNetworkImage(
            //                 imageUrl: widget.message.msg,
            //                 placeholder: (context, url) => Container(
            //                   width: mq.width * 0.5,
            //                   height: mq.height * 0.3,
            //                   child: const Center(
            //                     child: CircularProgressIndicator(
            //                       strokeWidth: 2,
            //                     ),
            //                   ),
            //                 ),
            //                 errorWidget: (context, url, error) => const Icon(
            //                   Icons.image,
            //                   size: 70,
            //                 ),
            //               ),
            //             ),
            //           );
            //         },
            //       );
            //     },
            //     child: ClipRRect(
            //       borderRadius: BorderRadius.circular(10),
            //       child: CachedNetworkImage(
            //         height: mq.height * 0.3,
            //         width: mq.width * 0.5,
            //         imageUrl: widget.message.msg,
            //         placeholder: (context, url) => const Padding(
            //           padding: EdgeInsets.all(8),
            //           child: CircularProgressIndicator(
            //             strokeWidth: 2,
            //           ),
            //         ),
            //         errorWidget: (context, url, error) => Icon(
            //           Icons.image,
            //           size: 70,
            //         ),
            //       ),
            //     ),
            //   )
          ),
        ),

        //
        Padding(
          padding: EdgeInsets.only(right: mq.width * 0.04),
          child: Text(
            DateFormat.getFormattedTime(
                context: context, time: widget.message.sent),
          ),
        )
      ],
    );
  }

  //our message
  Widget _RedMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //message time
        Row(
          children: [
            SizedBox(
              width: mq.width * 0.04,
            ),
            //double tick blue icon for message read
            if (widget.message.read.isNotEmpty)
              const Icon(
                Icons.done_all_rounded,
                color: Colors.blue,
                size: 20,
              ),
            //for adding some space
            const SizedBox(
              width: 2,
            ),
            //time
            Text(
              DateFormat.getFormattedTime(
                  context: context, time: widget.message.sent),
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
        //message
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image
                ? mq.width * 0.02
                : mq.width * 0.03),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * 0.04, vertical: mq.height * 0.01),
            decoration: BoxDecoration(
                color: Colors.red.shade100,
                border: Border.all(color: Colors.red),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  bottomLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                )),
            child: widget.message.type == Type.text
                ?
                // to display text
                Text(
                    widget.message.msg,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  )
                :
                // to display image
                ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.image,
                        size: 70,
                      ),
                    ),
                  ),

            // GestureDetector(
            //     onTap: () {
            //       showDialog(
            //         context: context,
            //         builder: (BuildContext context) {
            //           return Dialog(
            //             child: InteractiveViewer(
            //               child: CachedNetworkImage(
            //                 imageUrl: widget.message.msg,
            //                 placeholder: (context, url) => Container(
            //                   // width: mq.width * 0.5,
            //                   // height: mq.height * 0.3,
            //                   child: Center(
            //                     child: CircularProgressIndicator(
            //                       strokeWidth: 2,
            //                     ),
            //                   ),
            //                 ),
            //                 errorWidget: (context, url, error) => Icon(
            //                   Icons.image,
            //                   size: 70,
            //                 ),
            //               ),
            //             ),
            //           );
            //         },
            //       );
            //     },
            //     child: ClipRRect(
            //       borderRadius: BorderRadius.circular(10),
            //       child: CachedNetworkImage(
            //         height: mq.height * 0.3,
            //         width: mq.width * 0.5,
            //         imageUrl: widget.message.msg,
            //         placeholder: (context, url) => Padding(
            //           padding: EdgeInsets.all(8),
            //           child: CircularProgressIndicator(
            //             strokeWidth: 2,
            //           ),
            //         ),
            //         errorWidget: (context, url, error) => Icon(
            //           Icons.image,
            //           size: 70,
            //         ),
            //       ),
            //     ),
            //   )
          ),
        ),
      ],
    );
  }

  // bottom sheet for message
  void showBottomSheet(bool isMe) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            children: [
              //black divider
              Container(
                height: 4,
                margin: EdgeInsets.symmetric(
                    vertical: mq.height * 0.015, horizontal: mq.width * 0.4),
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10)),
              ),

              widget.message.type == Type.text
                  ?
                  //copy option
                  Options_Message(
                      icon: const Icon(Icons.copy_rounded,
                          color: Colors.blue, size: 26),
                      name: "Copy Text",
                      onTap: () async {
                        await Clipboard.setData(
                                ClipboardData(text: widget.message.msg))
                            .then((value) {
                          //for hiding bottom sheet
                          Navigator.pop(context);

                          Dialogs.showSnackbar(context, "Text Copied");
                        });
                      })
                  :
                  //save option
                  Options_Message(
                      icon: const Icon(Icons.download_for_offline,
                          color: Colors.blue, size: 26),
                      name: "Save Image",
                      onTap: () async {
                        try {
                          log('Image Url: ${widget.message.msg}');
                          await GallerySaver.saveImage(widget.message.msg,
                                  albumName: 'ChatIRA')
                              .then((success) {
                            //for hiding bottom sheet
                            Navigator.pop(context);
                            if (success != null && success) {
                              Dialogs.showSnackbar(
                                  context, 'Image Successfully Saved!');
                            }
                          });
                        } catch (e) {
                          log('ErrorWhileSavingImg: $e');
                        }
                      }),

              //divider
              if(isMe)
              Divider(
                color: Colors.black54,
                endIndent: mq.width * 0.05,
                indent: mq.width * 0.05,
              ),

              //delete
              if (isMe)
                Options_Message(
                    icon: const Icon(Icons.delete_rounded,
                        color: Colors.redAccent, size: 26),
                    name: "Delete Message",
                    onTap: () async {
                      await API.deleteMessage(widget.message).then((value) {
                        Navigator.pop(context);
                      });
                    }),

              //divider
              Divider(
                color: Colors.black54,
                endIndent: mq.width * 0.05,
                indent: mq.width * 0.05,
              ),

              //send time
              Options_Message(
                  icon: const Icon(Icons.remove_red_eye_rounded,
                      color: Colors.redAccent, size: 26),
                  name:
                      "Sent At: ${DateFormat.getFormattedTime(context: context, time: widget.message.sent)}",
                  onTap: () {}),

              //read time
              Options_Message(
                  icon: const Icon(Icons.remove_red_eye_rounded,
                      color: Colors.blue, size: 26),
                  name: widget.message.read.isEmpty
                      ? 'Read At: Not seen yet!'
                      : "Read At:${DateFormat.getFormattedTime(context: context, time: widget.message.read)}",
                  onTap: () {}),
            ],
          );
        });
  }

  //dialog for updating message content
  void showMessage_Update() {
    String updatedMsg = widget.message.msg;

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 10),

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),

              //title
              title: const Row(
                children: [
                  Icon(
                    Icons.message,
                    color: Colors.blue,
                    size: 28,
                  ),
                  Text(' Update Message')
                ],
              ),

              //content
              content: TextFormField(
                initialValue: updatedMsg,
                maxLines: null,
                onChanged: (value) => updatedMsg = value,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),

              //actions
              actions: [
                //cancel button
                MaterialButton(
                    onPressed: () {
                      //hide alert dialog
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    )),

                //update button
                MaterialButton(
                    onPressed: () {
                      //hide alert dialog
                      Navigator.pop(context);
                      API.updateMessage(widget.message, updatedMsg);
                    },
                    child: const Text(
                      'Update',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ))
              ],
            ));
  }
}

//custom options card (for copy, edit, delete, etc.)
class Options_Message extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;
  const Options_Message(
      {super.key, required this.icon, required this.name, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => onTap(),
        child: Padding(
          padding: EdgeInsets.only(
              left: mq.width * .05,
              top: mq.height * .01,
              bottom: mq.height * .01),
          child: Row(children: [
            icon,
            Flexible(
                child: Text('  $name',
                    style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                        letterSpacing: 0.5)))
          ]),
        ));
  }
}
