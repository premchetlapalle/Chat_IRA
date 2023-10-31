import 'package:chat_apk/chtabot/chatbot_messages.dart';
import 'package:chat_apk/main.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Chat_bot extends StatefulWidget {
  const Chat_bot({super.key});

  @override
  State<Chat_bot> createState() => _Chat_botState();
}

class _Chat_botState extends State<Chat_bot> {
  late DialogFlowtter dialogFlowtter;
  final TextEditingController msg_controller = TextEditingController();
  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    DialogFlowtter.fromFile().then((instance) => dialogFlowtter = instance);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade50,
      appBar: AppBar(
        title: Text(
          'IRA(Intelligent robot assistance)',
          style: TextStyle(fontSize: 19),
        ),
        iconTheme:IconThemeData(color: Colors.white,size: 25) ,
        actions: [Padding(
          padding: const EdgeInsets.only(right: 15),
          child: Icon(Icons.face_2),
        )],
      ),
      
      body: Column(
        children: [
          Expanded(child: Chatbot_MessagesScreen(messages: messages)),

          // search field
          _chatInput(),
        ],
      ),
    );
  }

  sendMessage(String text) async {
    if (text.isEmpty) {
      print('Message is empty');
    } else {
      setState(() {
        addMessage(Message(text: DialogText(text: [text])), true);
      });

      DetectIntentResponse response = await dialogFlowtter.detectIntent(
          queryInput: QueryInput(text: TextInput(text: text)));
      if (response.message == null) return;
      setState(() {
        addMessage(response.message!);
      });
    }
  }

  addMessage(Message message, [bool isUserMessage = false]) {
    messages.add({'message': message, 'isUserMessage': isUserMessage});
  }

  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: mq.width * 0.025, vertical: mq.height * 0.03),
      child: Row(children: [
        Expanded(
          child: Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: TextField(
                  controller: msg_controller,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: "Type Something....",
                    hintStyle: TextStyle(color: Colors.redAccent),
                    border: InputBorder.none,
                  ),
                )),
              ],
            ),
          ),
        ),

        //send message button
        MaterialButton(
          onPressed: () {
            sendMessage(msg_controller.text);
            msg_controller.clear();
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
