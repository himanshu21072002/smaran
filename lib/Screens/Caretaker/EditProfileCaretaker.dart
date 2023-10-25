// ignore_for_file: use_build_context_synchronously

import 'package:alzheimersapporig/Screens/Caretaker/CaretakerProfile.dart';
import 'package:alzheimersapporig/Screens/Patient/patient%20profile.dart';
import 'package:alzheimersapporig/Screens/home_page.dart';
import 'package:alzheimersapporig/models/usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditProfileCaretaker extends StatefulWidget {
  final UserModel userModel;
  final bool isCaretaker;
  const EditProfileCaretaker({Key? key, required this.userModel, required this.isCaretaker})
      : super(key: key);

  @override
  State<EditProfileCaretaker> createState() => _EditProfileCaretakerState();
}

class _EditProfileCaretakerState extends State<EditProfileCaretaker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Edit Profile"),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              "Personal Details",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              onChanged: (value) {
                widget.userModel.name = value;
              },
              initialValue: widget.userModel.name,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
                labelText: "name",
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              "Address",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              onChanged: (value) {
                widget.userModel.address!.state = value;
              },
              initialValue: widget.userModel.address!.state,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
                labelText: "State",
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              onChanged: (value) {
                widget.userModel.address!.city = value;
              },
              initialValue: widget.userModel.address!.city,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
                labelText: "city",
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              onChanged: (value) {
                widget.userModel.address!.area = value;
              },
              initialValue: widget.userModel.address!.area,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
                labelText: "Area",
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              onChanged: (value) {
                widget.userModel.address!.buildingName = value;
              },
              initialValue: widget.userModel.address!.buildingName,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
                labelText: "Building name",
              ),
            ),
            const SizedBox(
              height: 35,
            ),
            SizedBox(
                height: 40,
                child: ElevatedButton(
                    onPressed: () async {
                      {
                        if(widget.isCaretaker){
                          await FirebaseFirestore.instance
                              .collection("users")
                              .doc(widget.userModel.uid)
                              .update(widget.userModel.toJson());
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CaretakerProfile(
                                        myUser: widget.userModel,
                                      )));
                        }else {

                          await FirebaseFirestore.instance
                              .collection("users")
                              .doc(widget.userModel.uid)
                              .update(widget.userModel.toJson());
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage(
                                    userModel: widget.userModel,
                                  )));

                        }
                      }
                    },
                    child: const Text("Submit")))
          ],
        ));
  }
}
