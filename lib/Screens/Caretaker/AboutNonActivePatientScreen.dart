// ignore_for_file: deprecated_member_use

import 'package:alzheimersapporig/models/usermodel.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class AboutNonActivePatientScreen extends StatelessWidget {
  final UserModel userModel;

  const AboutNonActivePatientScreen({super.key, required this.userModel});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.teal,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Row(
              children: [
                SizedBox(
                  width: 50,
                )
              ],
            ),
            CircleAvatar(
              radius: 75,
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
              width: 150,
              child: Divider(
                color: Colors.teal.shade100,
              ),
            ),
            SizedBox(
              width: 320,
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
                      userModel.contact.toString(),
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
            Flexible(
              child: SizedBox(
                width: 320,
                child: ElevatedButton(
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}