import 'dart:developer';

import 'package:alzheimersapporig/Screens/Caretaker/AboutActivePatient.dart';
import 'package:alzheimersapporig/Utils/firebasehelper.dart';
import 'package:alzheimersapporig/models/usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ActivePatientScreen extends StatefulWidget {
  final UserModel userModel;
  const ActivePatientScreen({Key? key, required this.userModel})
      : super(key: key);

  @override
  State<ActivePatientScreen> createState() => _ActivePatientScreenState();
}

class _ActivePatientScreenState extends State<ActivePatientScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Active Patients"),
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("PCrelation")
              .doc(widget.userModel.uid)
              .collection("Patient list")
              .where("status", isEqualTo: "Active")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                QuerySnapshot querySnapshot = snapshot.data as QuerySnapshot;
                var list = querySnapshot.docs;
                // DocumentSnapshot documentSnapshot=snapshot.data as DocumentSnapshot;
                return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder(
                          future:
                              FirebaseHelper.getusermodelbyid(list[index].id),
                          builder: (context, userdata) {
                            if (userdata.connectionState ==
                                ConnectionState.done) {
                              if (userdata.data != null) {
                                UserModel targetUser =
                                    userdata.data as UserModel;
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AboutActivePatientScreen(
                                                    userModel: targetUser)));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 20),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.black38),
                                      ),
                                      child: Column(
                                        children: [
                                          const SizedBox(height: 5,),
                                          CircleAvatar(
                                            radius: 50,
                                            backgroundImage: NetworkImage(
                                                targetUser.profilepic
                                                    .toString()),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(targetUser.name.toString()),

                                          IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.red.shade800,
                                            ),
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
                                                      title: const Text(
                                                          'Do you want to delete Patient?'),
                                                      actions: [
                                                        TextButton(
                                                            onPressed:
                                                                () async {
                                                                  FirebaseFirestore.instance
                                                                      .collection("PCrelation")
                                                                      .doc(widget.userModel.uid)
                                                                      .collection("Patient list")
                                                                      .doc(targetUser.uid)
                                                                      .set({"status": "Not Active"});
                                                                  FirebaseFirestore.instance
                                                                      .collection("PCrelationReverse")
                                                                      .doc(targetUser.uid)
                                                                      .collection("Caretaker list")
                                                                      .doc(widget.userModel.uid)
                                                                      .set({"status": "Not Active"});
                                                                  log("Patient removed");
                                                                  Navigator.pop(context);
                                                            },
                                                            child: const Text(
                                                                'Yes')),
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                'Cancel')),
                                                      ],
                                                    );
                                                  });
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
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
      ),
    );
  }
}
