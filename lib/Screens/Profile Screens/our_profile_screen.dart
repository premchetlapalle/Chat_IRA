
// ignore_for_file: camel_case_types, use_build_context_synchronously

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_apk/API/api.dart';
import 'package:chat_apk/Modals/chat_user.dart';
import 'package:chat_apk/Screens/login%20&%20signup%20Screens/login_screen.dart';
import 'package:chat_apk/main.dart';
import 'package:chat_apk/others/dialogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';


class Profile_Screen extends StatefulWidget {
  const Profile_Screen({super.key, required this.user});
  final ChatUser user;

  @override
  State<Profile_Screen> createState() => _Profile_ScreenState();
}

class _Profile_ScreenState extends State<Profile_Screen> {
  final formkey = GlobalKey<FormState>();
  String? _image;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),

        //body

        body: Form(
          key: formkey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * 0.05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: mq.width,
                    height: mq.height * .07,
                  ),

                  //Profile Picture

                  Stack(children: [
                    //profile image
                    _image != null
                        ?
                        // local image
                        ClipRRect(
                            borderRadius:
                                BorderRadius.circular(mq.height * 0.1),
                            child: Image.file(
                              File(_image!),
                              width: mq.height * 0.2,
                              height: mq.height * 0.2,
                              fit: BoxFit.cover,
                            ),
                          )
                        :
                        // image from server
                        ClipRRect(
                            borderRadius:
                                BorderRadius.circular(mq.height * 0.1),
                            child: CachedNetworkImage(
                              width: mq.height * 0.2,
                              height: mq.height * 0.2,
                              fit: BoxFit.cover,
                              imageUrl: widget.user.image,
                              // placeholder: (context, url) => CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Container(
                                width: mq.height * 0.2,
                                height: mq.height * 0.2,
                                child: const CircleAvatar(
                                    backgroundColor: Color(0xffbff4d4d),
                                    child: Icon(
                                      CupertinoIcons.person,
                                      size: 120,
                                      color: Colors.white,
                                    )),
                              ),
                            ),
                          ),

                    //edit image button
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: MaterialButton(
                        elevation: 3,
                        onPressed: () {
                          showBottomSheet();
                        },
                        shape: const CircleBorder(),
                        color: Colors.grey.shade800,
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ]),
                  SizedBox(
                    width: mq.width,
                    height: mq.height * .03,
                  ),
                  Text(
                    widget.user.email,
                    style: const TextStyle(color: Colors.black54, fontSize: 20),
                  ),
                  SizedBox(
                    width: mq.width,
                    height: mq.height * .05,
                  ),

                  //name Textfield

                  TextFormField(
                    onSaved: (val) => API.me.name = val ?? '',
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : 'Required Field',
                    initialValue: widget.user.name,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        prefixIcon: const Icon(Icons.person),
                        suffixIcon: const Icon(Icons.edit),
                        hintText: "Name"),
                  ),
                  SizedBox(
                    width: mq.width,
                    height: mq.height * .03,
                  ),

                  //about Textfield

                  TextFormField(
                    onSaved: (val) => API.me.about = val ?? '',
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : 'Required Field',
                    initialValue: widget.user.about,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        prefixIcon: const Icon(Icons.info_outline_rounded),
                        suffixIcon: const Icon(Icons.edit),
                        hintText: "eg: Available"),
                  ),
                  SizedBox(
                    width: mq.width,
                    height: mq.height * .045,
                  ),

                  //update Button

                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        elevation: 1,
                        shape: const StadiumBorder(),
                        backgroundColor: const Color(0xffbff4d4d),
                        minimumSize: Size(mq.width * 0.4, mq.height * 0.055)),
                    onPressed: () {
                      if (formkey.currentState!.validate()) {
                        formkey.currentState!.save();
                        API.UpdateUserInformation().then((value) {
                          Dialogs.showSnackbar(
                              context, 'Profile Updated Successfully!');
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.update,
                      size: 25,
                    ),
                    label: const Text(
                      'Update',
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                  SizedBox(
                    width: mq.width,
                    height: mq.height * .055,
                  ),

                  // logout button

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Click here to",
                        style: TextStyle(fontSize: 23,color: Color(0xffb4E342E)),
                      ),
                      TextButton.icon(
                        onPressed: () async {
                          Dialogs.showProgressBar(context);
                          await API.updateActiveStatus(false);

                          //logout from apk
                          await API.auth.signOut().then((value) async {
                            await GoogleSignIn().signOut().then((value) {
                              //hiding progress dialog
                              Navigator.pop(context);
                              //moving to home screen
                              Navigator.pop(context);

                              API.auth = FirebaseAuth.instance;

                              //replacing with login Screen
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const Login_Screen()));
                            });
                          });
                        },
                        label: const Icon(
                          Icons.logout,
                          color: Colors.redAccent,
                          size: 28,
                        ),
                        icon: const Text(
                          'Logout',
                          style:
                              TextStyle(fontSize: 24, color: Colors.redAccent),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //for image picker
  void showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding:
                EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .05),
            children: [
              //pick profile picture label
              const Text('Pick Profile Picture',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              SizedBox(
                height: mq.height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      //pick from gallery
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: const CircleBorder(),
                          fixedSize: Size(mq.width * 0.21, mq.height * 0.12)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an image.
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.gallery, imageQuality: 75);
                        if (image != null) {
                          setState(() {
                            _image = image.path;
                          });
                          API.updateProfilePicture(File(_image!));
                          Navigator.pop(context);
                        }
                      },
                      child: const Icon(Icons.image_outlined)),
                  //pick from camera
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: const CircleBorder(),
                          fixedSize: Size(mq.width * 0.21, mq.height * 0.12)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an image.
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 75);
                        if (image != null) {
                          setState(() {
                            _image = image.path;
                          });
                          API.updateProfilePicture(File(_image!));
                          Navigator.pop(context);
                        }
                      },
                      child: const Icon(Icons.camera_alt)),
                ],
              )
            ],
          );
        });
  }
}
