import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Chatbot_MessagesScreen extends StatefulWidget {
  final List messages;
  const Chatbot_MessagesScreen({super.key, required this.messages});

  @override
  State<Chatbot_MessagesScreen> createState() => _Chatbot_MessagesScreenState();
}

class _Chatbot_MessagesScreenState extends State<Chatbot_MessagesScreen> {
  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;

    return widget.messages.isEmpty

    //if no message is sent
        ? Center(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(
                    25), // Adjust the value to change the amount of curvature
                child: Image.asset('assets/images/IRA1.gif'),
              ),
            ],
          ),
        ),
      ),
    )

    //message sent
        : GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
          child: ListView.separated(
      itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: widget.messages[index]['isUserMessage']
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(
                          widget.messages[index]['isUserMessage'] ? 20 : 0),
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(
                          widget.messages[index]['isUserMessage'] ? 0 : 20),
                    ),
                    color: widget.messages[index]['isUserMessage']
                        ? Colors.red.shade100
                        : Colors.blue.shade100,
                  ),
                  constraints: BoxConstraints(maxWidth: screenWidth * 2 / 3),
                  child: Text(
                    widget.messages[index]['message'].text.text[0],
                  ),
                ),
              ],
            ),
          );
      },
      separatorBuilder: (_, i) => Padding(padding: EdgeInsets.only(top: 10)),
      itemCount: widget.messages.length,
    ),
        );

  }
}