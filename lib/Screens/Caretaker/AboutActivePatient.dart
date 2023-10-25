// ignore_for_file: deprecated_member_use

import 'package:alzheimersapporig/Screens/MedicalHistory.dart';
import 'package:alzheimersapporig/models/usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'mymapscreen.dart';

class AboutActivePatientScreen extends StatelessWidget {
  final UserModel userModel;

  const AboutActivePatientScreen({super.key, required this.userModel});
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.teal,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 65,
              backgroundImage: NetworkImage(userModel.profilepic.toString()),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                userModel.name.toString(),
                style: const TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "${userModel.address!.buildingName}, ${userModel.address!.area}, ${userModel.address!.city}, ${userModel.address!.state}",
                style: const TextStyle(
                  fontSize: 25,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 20,
              width: width * 0.4,
              child: Divider(
                color: Colors.teal.shade100,
              ),
            ),
            SizedBox(
              width: width * 0.85,
              height: 50,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                ),
                onPressed: () {
                  launch("tel:${userModel.contact.toString()}");
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.phone,
                      size: 30,
                      color: Colors.green,
                    ),
                    Text(
                      "  ${userModel.contact}",
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  onPressed: () {
                    launch('mailto:${userModel.email}');
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.mail,
                        size: 30,
                        color: Colors.green,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${userModel.email}',
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
            const SizedBox(
              height: 10,
            ),
            // Expanded(
            //     child: StreamBuilder(
            //       stream:
            //       FirebaseFirestore.instance.collection('location').snapshots(),
            //       builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            //         if (!snapshot.hasData) {
            //           return Center(child: CircularProgressIndicator());
            //         }
            //         return ListView.builder(
            //             itemCount: snapshot.data?.docs.length,
            //             itemBuilder: (context, index) {
            //               return ListTile(
            //                 title:
            //                 Text(snapshot.data!.docs[index]['name'].toString()),
            //                 subtitle: Row(
            //                   children: [
            //                     Text(snapshot.data!.docs[index]['latitude']
            //                         .toString()),
            //                     SizedBox(
            //                       width: 20,
            //                     ),
            //                     Text(snapshot.data!.docs[index]['longitude']
            //                         .toString()),
            //                   ],
            //                 ),
            //                 trailing: IconButton(
            //                   icon: Icon(Icons.directions),
            //                   onPressed: () {
            //                     Navigator.of(context).push(MaterialPageRoute(
            //                         builder: (context) =>
            //                             MyMap(snapshot.data!.docs[index].id)));
            //                     print(snapshot.data!.docs[index].id);
            //                   },
            //                 ),
            //               );
            //             });
            //       },
            //     )),
            SizedBox(
              width: width * 0.85,
              height: 50,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) {
                            print(userModel.uid.toString());
                    return MyMap(userModel.uid.toString());

                  }));
                },
                child: const Row(
                  children: [
                    Icon(
                      Icons.location_pin,
                      size: 30,
                      color: Colors.green,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      "Track patient",
                      style: TextStyle(
                          fontSize: 19,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: width * 0.85,
              height: 50,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MedicalHistoryPage(
                                patientUid: userModel.uid!,
                              )));
                },
                child: const Row(
                  children: [
                    Icon(
                      Icons.history,
                      size: 30,
                      color: Colors.green,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      "Medical History",
                      style: TextStyle(
                          fontSize: 19,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
