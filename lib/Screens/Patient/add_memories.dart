import 'dart:developer';
import 'dart:io';

import 'package:alzheimersapporig/models/memoriesModel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../Utils/uiHelper.dart';
import '../../models/usermodel.dart';
import 'package:uuid/uuid.dart';

class AddMemories extends StatefulWidget {
  final UserModel userModel;
  const AddMemories({Key? key, required this.userModel}) : super(key: key);

  @override
  State<AddMemories> createState() => _AddMemoriesState();
}

class _AddMemoriesState extends State<AddMemories> {
  var uuid = const Uuid();
  File? imageFile;
  TextEditingController titleController = TextEditingController();
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  String urlDownload = "";
  final player = AudioPlayer();
  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowCompression: true,
        allowedExtensions: ['mp3']);
    if (result != null) {
      log("result is not null");
      setState(() {
        pickedFile = result.files.first;
      });
    }
  }

  Future uploadFile() async {
    if (imageFile == null || titleController.text.trim().isEmpty) {
      UIhelper.showAlertDialogue(
            context, "Empty Field", "Please fill required fields *");

    } else {
       UIhelper.showloadingdialogue(context, "uploading");
      UploadTask uploadtask = FirebaseStorage.instance
          .ref()
          .child("memories/image/${uuid.v1()}")
          .putFile(imageFile!);
      TaskSnapshot snapshot = await uploadtask;
      String imageurl = await snapshot.ref.getDownloadURL();
      log("in upload file");
     if(pickedFile!=null){
       String path = 'memories/audio/${pickedFile!.name}';
       var file = File(pickedFile!.path!);
       var ref = FirebaseStorage.instance.ref().child(path);
       setState(() {
         uploadTask = ref.putFile(file);
       });
       log("putfile done");
       final snapshotaudio = await uploadTask!.whenComplete(() {
         log("Uploaded");
       });
       urlDownload = await snapshotaudio.ref.getDownloadURL();
     }
     MemoryModel memoryModel= MemoryModel(
       image: imageurl,
       title: titleController.text.trim(),
       audio: urlDownload
     );
      await FirebaseFirestore.instance
          .collection("memories")
          .doc(widget.userModel.uid)
          .collection("patient memories")
          .doc(uuid.v1())
          .set( memoryModel.toJson()).then((value){
            Navigator.pop(context);
            Navigator.pop(context);
      });
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

  void selectimage(ImageSource source) async {
    try {
      XFile? pickedfile = await ImagePicker().pickImage(source: source);
      if (pickedfile != null) {
        setState(() {
          imageFile = File(pickedfile.path);
        });
      }
    } catch (e) {
      UIhelper.showAlertDialogue(context, "Error", e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListView(
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
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
                    "Memories",
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              if (imageFile != null)
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: Image.file(
                    File(imageFile!.path),
                    fit: BoxFit.cover,
                  ),
                )
              else
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: const Center(
                    child: Text('No image selected'),
                  ),
                ),
              ElevatedButton(
                onPressed: () {
                  showphotooptions();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Select Image"),
                    Text(
                      "*",
                      style: TextStyle(color: Colors.red),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  labelText: "title *",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              pickedFile == null
                  ? Container(
                      height: 20,
                      child: const Text('No file selected'),
                    )
                  : Container(
                      height: 20,
                      child: Text(pickedFile!.name),
                    ),
              ElevatedButton(
                  onPressed: () {
                    pickFile();
                  },
                  child:
                      Text("Select Audio(only mp3) "),
                     ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.3),
        child: ElevatedButton(
            onPressed: () {
              uploadFile();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrangeAccent),
            child: const Text("Submit")),
      ),
    );
  }
}
