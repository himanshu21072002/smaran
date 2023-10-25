import 'dart:developer';
// import 'dart:html';
// import 'dart:io';

import 'package:alzheimersapporig/Screens/Patient/add_memories.dart';
import 'package:alzheimersapporig/Utils/firebasehelper.dart';
import 'package:alzheimersapporig/models/memoriesModel.dart';
import 'package:alzheimersapporig/models/usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../home_page.dart';
import 'package:just_audio/just_audio.dart';

class Memories extends StatefulWidget {
  final UserModel userModel;
  const Memories({Key? key, required this.userModel}) : super(key: key);

  @override
  State<Memories> createState() => _MemoriesState();
}

class _MemoriesState extends State<Memories> {
  final player = AudioPlayer();
  bool isPlaying = false;
  Future<void> playSound(String url) async {
    log('inside playsound');
    log(url);
    player.setUrl(url);
    player.play();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
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
                                    HomePage(userModel: widget.userModel)));
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.blue,
                        size: 30,
                      )),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    "Memories",
                    style: TextStyle(fontSize: 26,
                    fontWeight: FontWeight.bold,color: Colors.blue),
                  )
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("memories")
                    .doc(widget.userModel.uid)
                    .collection("patient memories")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      QuerySnapshot querySnapshot =
                          snapshot.data as QuerySnapshot;
                      var list = querySnapshot.docs;
                      return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            return FutureBuilder(
                                future: FirebaseHelper.getMemoryfromid(
                                    widget.userModel.uid.toString(),
                                    list[index].id),
                                builder: (context, userdata) {
                                  if (userdata.hasData) {
                                    if (userdata.connectionState ==
                                        ConnectionState.done) {
                                      if (userdata.data != null) {
                                        MemoryModel memory =
                                            userdata.data as MemoryModel;
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 50, vertical: 10),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black38),
                                            ),
                                            child: Column(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      top: height * 0.01),
                                                  height: height * 0.25,
                                                  width: width * 0.4,
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                    image: NetworkImage(memory
                                                        .image
                                                        .toString()),
                                                  )),
                                                ),
                                                SizedBox(
                                                  height: height * 0.01,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20),
                                                  child: Text(
                                                    memory.title.toString(),
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(

                                                        fontSize: 20),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                  ),
                                                ),
                                                memory.audio!.isEmpty
                                                    ? Container()
                                                    : Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          IconButton(
                                                              onPressed: () {
                                                                playSound(memory
                                                                    .audio
                                                                    .toString());
                                                              },
                                                              icon: const Icon(
                                                                Icons
                                                                    .play_circle,
                                                                size: 35,
                                                                color: Colors
                                                                    .green,
                                                              )),
                                                          IconButton(
                                                              onPressed: () {
                                                                player.stop();
                                                              },
                                                              icon: const Icon(
                                                                Icons.stop,
                                                                size: 35,
                                                                color:
                                                                    Colors.red,
                                                              )),
                                                        ],
                                                      ),
                                                IconButton(
                                                    onPressed: () {
                                                      showDialog(
                                                        barrierDismissible: false,
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            icon: const Icon(
                                                              Icons.delete,
                                                              color: Colors.green,
                                                            ),
                                                            title: const Text('Do you want to delete memory?'),
                                                            actions: [
                                                              TextButton(
                                                                  onPressed: () async {
                                                                    Navigator.pop(context);
                                                                    FirebaseFirestore.instance
                                                                        .collection("memories")
                                                                        .doc(widget.userModel.uid)
                                                                        .collection("patient memories").doc(list[index].id).delete();
                                                                  },
                                                                  child: const Text('Yes')),
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
                                                    icon: Icon(Icons.delete,color: Colors.red,))
                                              ],
                                            ),
                                          ),
                                        );
                                      } else {
                                        return Container();
                                      }
                                    } else {
                                      return Container();
                                    }
                                  } else {
                                    return Container();
                                  }
                                });
                          });
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    } else {
                      return const Center(
                        child: Text("No Active Patients"),
                      );
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AddMemories(userModel: widget.userModel)));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
