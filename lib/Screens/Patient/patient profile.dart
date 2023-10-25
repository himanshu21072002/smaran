// import 'dart:html';
// // import 'dart:developer';
// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
// import 'dart:html';

import 'package:alzheimersapporig/Screens/Caretaker/EditProfileCaretaker.dart';
import 'package:alzheimersapporig/Screens/choosecategory.dart';
import 'package:alzheimersapporig/Screens/home_page.dart';
import 'package:alzheimersapporig/models/usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../Utils/uiHelper.dart';

class PatientProfile extends StatefulWidget {
  final UserModel myUser;
  const PatientProfile({Key? key, required this.myUser}) : super(key: key);

  @override
  State<PatientProfile> createState() => _PatientProfileState();
}

class _PatientProfileState extends State<PatientProfile> {
  File? imageFile;
  // String? profile;
  void selectimage(ImageSource source) async {
    try {
      XFile? pickedfile = await ImagePicker().pickImage(source: source);
      if (pickedfile != null) {
        setState(() {
          imageFile = File(pickedfile.path);
        });
        uploadData();
      }
    } catch (e) {
      UIhelper.showAlertDialogue(context, "Error", e.toString());
    }
  }

  void showphotooptions() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Upload Profile Picture"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    selectimage(ImageSource.gallery);
                  },
                  leading: const Icon(Icons.photo_album),
                  title: const Text("Select from Gallery"),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);

                    selectimage(ImageSource.camera);
                  },
                  leading: const Icon(Icons.camera_alt),
                  title: const Text("Take a picture"),
                ),
              ],
            ),
          );
        });
  }

  void uploadData() async {
    UIhelper.showloadingdialogue(context, "Uploading Image..");
    log(imageFile.toString());
    UploadTask uploadtask = FirebaseStorage.instance
        .ref("Profile pictures")
        .child(widget.myUser.uid.toString())
        .putFile(imageFile!);
    TaskSnapshot snapshot = await uploadtask;
    String imageurl = await snapshot.ref.getDownloadURL();
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.myUser.uid)
        .update({"profilepic": imageurl});
    Navigator.pop(context);
    setState(() {
      widget.myUser.profilepic = imageurl;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    HomePage(userModel: widget.myUser)));
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 30,
                      )),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    "My Profile",
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
              SizedBox(
                height: height * 0.06,
              ),
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 75,
                      backgroundColor: Colors.grey.shade200,
                      child: CircleAvatar(
                        radius: 70,
                        backgroundImage:
                            NetworkImage(widget.myUser.profilepic.toString()),
                      ),
                    ),
                    Positioned(
                      bottom: 1,
                      right: 1,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 3,
                              color: Colors.white,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(
                                50,
                              ),
                            ),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(2, 4),
                                color: Colors.black.withOpacity(
                                  0.3,
                                ),
                                blurRadius: 3,
                              ),
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: IconButton(
                            icon: const Icon(Icons.add_a_photo),
                            color: Colors.black,
                            onPressed: () {
                              showphotooptions();
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Text(
                widget.myUser.name.toString(),
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                widget.myUser.email.toString(),
                style: TextStyle(fontSize: 20, color: Colors.blueGrey.shade800),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                widget.myUser.contact.toString(),
                style: TextStyle(fontSize: 18, color: Colors.blueGrey.shade800),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Address- ${widget.myUser.address!.buildingName} ,${widget.myUser.address!.area} ,${widget.myUser.address!.city} ,${widget.myUser.address!.state}",
                style: TextStyle(fontSize: 18, color: Colors.blueGrey.shade800),
              ),
              CupertinoButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              EditProfileCaretaker(userModel: widget.myUser,isCaretaker: false,)));
                },
                padding: EdgeInsets.zero,
                child: const Text("Edit Profile"),
              ),
              CupertinoButton(
                onPressed: () {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        icon: const Icon(
                          Icons.logout,
                          color: Colors.green,
                        ),
                        title: const Text('Do you want to LogOut?'),
                        actions: [
                          TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                await FirebaseAuth.instance.signOut();
                                Navigator.popUntil(
                                    context, (route) => route.isFirst);
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const ChooseCategory();
                                }));
                              },
                              child: const Text('Logout')),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel')),
                        ],
                      );
                    },
                  );
                },
                padding: EdgeInsets.zero,
                child: const Text("Logout"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
