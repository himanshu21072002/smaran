import 'dart:developer';

import 'package:alzheimersapporig/Screens/Caretaker/ActivePatientScreen.dart';
import 'package:alzheimersapporig/Screens/Caretaker/AddNewPatientScreen.dart';
import 'package:alzheimersapporig/Screens/Caretaker/CaretakerProfile.dart';
import 'package:alzheimersapporig/Screens/Caretaker/NotActivePatientScreen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/usermodel.dart';

class CaretakerHomePage extends StatefulWidget {
  final UserModel userModel;
  const CaretakerHomePage({Key? key, required this.userModel}) : super(key: key);

  @override
  State<CaretakerHomePage> createState() => _CaretakerHomePageState();
}

class _CaretakerHomePageState extends State<CaretakerHomePage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text('Home Page',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Colors.black),),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>CaretakerProfile(myUser: widget.userModel)));
                log("profile button pressed");
              },
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  widget.userModel.profilepic.toString()
                )),
            ),
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(
                    'https://media.istockphoto.com/id/911633218/vector/abstract-geometric-medical-cross-shape-medicine-and-science-concept-background.jpg?s=612x612&w=0&k=20&c=eYz8qm5xa5wbWCWKgjOpTamavekYv8XqPTA0MC4tHGA='))),
        child: Column(
          children: [
            SizedBox(
              height: height * 0.18,
            ),
            ReusableContainer(
              text: "Active Patient",
              icon: Icons.health_and_safety,
              onpressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ActivePatientScreen(userModel: widget.userModel,)));
              },
            ),
            ReusableContainer(
              text: "Previous Patient",
              icon: Icons.history,
              onpressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>NotActivePatientScreen(userModel: widget.userModel,)));
              },
            ),
            ReusableContainer(
              text: "Emergency",
              icon: Icons.call,
              onpressed: () {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      icon: const Icon(
                        Icons.call,
                        color: Colors.green,
                      ),
                      title: const Text('Emergency'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              launch("tel:102");
                              Navigator.pop(context);
                            },
                            child: const Text('Ambulance')),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Exit')),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>AddNewPatientScreen(myUid: widget.userModel.uid.toString(),userModel: widget.userModel,)));
        },
      ),
    );
  }
}

class ReusableContainer extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function()? onpressed;
  const ReusableContainer({
    super.key,
    required this.text,
    required this.icon,
    this.onpressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MaterialButton(
        elevation: 5,
        onPressed: onpressed,
        child: Container(
            padding: const EdgeInsets.only(left: 10),
            height: 60,
            decoration: BoxDecoration(
                color: Colors.blueGrey[100],
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Colors.deepPurple,
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
