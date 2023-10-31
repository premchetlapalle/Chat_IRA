// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'dart:developer';

import 'package:chat_apk/API/api.dart';
import 'package:chat_apk/Custom%20Widgets/chat_card_widgets.dart';
import 'package:chat_apk/Modals/chat_user.dart';
import 'package:chat_apk/Screens/Profile%20Screens/our_profile_screen.dart';
import 'package:chat_apk/chtabot/chat_bot_screen.dart';
import 'package:chat_apk/main.dart';
import 'package:chat_apk/others/dialogs.dart';
import 'package:chat_apk/others/ira_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Home_Screen extends StatefulWidget {
  const Home_Screen({super.key});

  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen> {
  List<ChatUser> list = [];
  final List<ChatUser> searchlist = [];
  bool isSearching = false;
  @override
  void initState() {
    super.initState();
    API.getSelfInformation();

    SystemChannels.lifecycle.setMessageHandler((message) {
      log('Message: $message');

      if (API.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          API.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          API.updateActiveStatus(false);
        }
      }

      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //for hiding keyboard when you tap on screen
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          //if search is on and back pressed then close search
          if (isSearching) {
            setState(() {
              isSearching = !isSearching;
            });
            return Future.value(false);
          }
          //if search is off and back pressed then close current screen
          else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            // home icon
            leading: const Icon(CupertinoIcons.home),
            title: isSearching
                ? TextField(
                    decoration: const InputDecoration(
                        border: InputBorder.none, hintText: 'Search'),
                    autofocus: true,
                    style: const TextStyle(fontSize: 15, letterSpacing: 0.5),
                    onChanged: (val) {
                      // search logic
                      searchlist.clear();
                      for (var i in list) {
                        if (i.name.toLowerCase().contains(val.toLowerCase()) ||
                            i.email.toLowerCase().contains(val.toLowerCase())) {
                          searchlist.add(i);
                        }
                        setState(() {
                          searchlist;
                        });
                      }
                    },
                  )
                : const Text('ChatIRA'),
            actions: [
              //search icon
              IconButton(
                  onPressed: () {
                    setState(() {
                      isSearching = !isSearching;
                    });
                  },
                  icon: Icon(isSearching
                      ? CupertinoIcons.clear_circled_solid
                      : CupertinoIcons.search),
                  iconSize: 30),
              //3 dots icon
              IconButton(
                  // onPressed: () {
                  //   Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (_) => Chat_bot()));
                  // },
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => Profile_Screen(
                                  user: API.me,
                                )));
                  },
                  icon: const Icon(Icons.more_vert))
            ],
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 15, right: 3, top: 10),
            child: SizedBox(
              width: 60,
              height: 60,
              child: FloatingActionButton(
                  onPressed: () {
                    addChatUser_Dialog();
                  },
                  backgroundColor: Colors.red,
                  child: const Padding(
                    padding: EdgeInsets.only(top: 3),
                    child: Icon(Icons.insert_comment_rounded, size: 37),
                  )),
            ),
          ),
          body: Column(
            children: [
              SizedBox(height:3,),
              //chatbot screen
              Container(
                height: mq.height * 0.1,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => Chat_bot()));
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(
                        horizontal: mq.width * 0.02, vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                        leading: InkWell(
                          onTap: () {
                            showDialog(
                                context: context, builder: (_) => IRA_Dialog());
                          },
                          child: Container(
                            width: mq.height * 0.056,
                            height: mq.height * 0.056,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(mq.height * 0.3),
                              child: CircleAvatar(
                                backgroundColor: Color(0xffbff4d4d),
                                child: Image.asset(
                                  'assets/images/IRA.gif',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        title: Text('IRA'),
                        subtitle: Text('Intelligent robot assistance'),
                        trailing: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Icon(Icons.face_2,size: 26,),
                        ),
                      ),
                  ),
                ),
              ),

              //users screen
              Expanded(
                child: StreamBuilder(
                  stream: API.getMyUsersId(),

                  //get id of only known user
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      //if data is loading
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return const Center(child: CircularProgressIndicator());

                      //if some or all data is loaded then show it
                      case ConnectionState.active:
                      case ConnectionState.done:
                        return StreamBuilder(
                          stream: API.getAllUsers(
                              snapshot.data?.docs.map((e) => e.id).toList() ??
                                  []),

                          //get only users id is provided
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              //if data is loading
                              case ConnectionState.waiting:
                              case ConnectionState.none:
                                return const Center(
                                    child: CircularProgressIndicator());

                              //if some or all data is loaded then show it
                              case ConnectionState.active:
                              case ConnectionState.done:
                                final data = snapshot.data?.docs;
                                list = data
                                        ?.map(
                                            (e) => ChatUser.fromJson(e.data()))
                                        .toList() ??
                                    [];
                                if (list.isNotEmpty) {
                                  return ListView.builder(
                                      itemCount: isSearching
                                          ? searchlist.length
                                          : list.length,
                                      padding: EdgeInsets.only(
                                          top: mq.height * 0.002),
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return ChatCard(
                                            user: isSearching
                                                ? searchlist[index]
                                                : list[index]);
                                      });
                                } else {
                                  return const Center(
                                      child: Text(
                                    'No User Found!',
                                    style: TextStyle(fontSize: 25),
                                  ));
                                }
                            }
                          },
                        );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // for adding new chat user
  void addChatUser_Dialog() {
    String email = '';

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
                    Icons.person_add,
                    color: Colors.redAccent,
                    size: 28,
                  ),
                  Text('  Add User')
                ],
              ),

              //content
              content: TextFormField(
                maxLines: null,
                onChanged: (value) => email = value,
                decoration: InputDecoration(
                    hintText: 'Email Id',
                    prefixIcon:
                        const Icon(Icons.email, color: Colors.redAccent),
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
                    child: const Text('Cancel',
                        style:
                            TextStyle(color: Colors.redAccent, fontSize: 16))),

                //add button
                MaterialButton(
                    onPressed: () async {
                      //hide alert dialog
                      Navigator.pop(context);
                      if (email.isNotEmpty) {
                        await API.addChatUser(email).then((value) {
                          if (!value) {
                            Dialogs.showSnackbar(
                                context, 'User does not Exist!');
                          }
                        });
                      }
                    },
                    child: const Text(
                      'Add',
                      style: TextStyle(color: Colors.redAccent, fontSize: 16),
                    ))
              ],
            ));
  }
}
