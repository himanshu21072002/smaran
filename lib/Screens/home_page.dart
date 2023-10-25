import 'dart:developer';
import 'dart:async';

import 'package:alzheimersapporig/Screens/Patient/PreviousCaretaker.dart';
import 'package:alzheimersapporig/Screens/Patient/currentCaretaker.dart';
import 'package:alzheimersapporig/Screens/Patient/medicalHistory.dart';
import 'package:alzheimersapporig/Screens/Patient/memories.dart';
import 'package:alzheimersapporig/Screens/Patient/patient%20profile.dart';
import 'package:alzheimersapporig/models/usermodel.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  final UserModel userModel;
  const HomePage({Key? key, required this.userModel}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;
  void checkPermissionStatus() async{
    var status = await Permission.locationWhenInUse.status;
    if (status != PermissionStatus.granted) {

      _requestPermission();

    }else{
      _getLocation();
    }
  }
  _requestPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      location.enableBackgroundMode(enable: true);
      _getLocation();
      print('done');
    } else if (status.isDenied) {
      _requestPermission();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }
  _getLocation() async {
    try {
      print("get loc");
      final loc.LocationData _locationResult = await loc.Location().getLocation();
      print("check");
      await FirebaseFirestore.instance.collection('location').doc(widget.userModel.uid).set({
        'latitude': _locationResult.latitude,
        'longitude': _locationResult.longitude,
      }, SetOptions(merge: true));
      _listenLocation();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _listenLocation() async {
    print("start listen loc");
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      print(onError);
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((loc.LocationData currentlocation) async {
      print(currentlocation.latitude);
      await FirebaseFirestore.instance.collection('location').doc(widget.userModel.uid).set({
        'latitude': currentlocation.latitude,
        'longitude': currentlocation.longitude,
      }, SetOptions(merge: true));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkPermissionStatus();

  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text('Home Page',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,),),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            PatientProfile(myUser: widget.userModel)));
              },
              child: CircleAvatar(
                backgroundImage:
                    NetworkImage(widget.userModel.profilepic.toString()),
              ),
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
                image: AssetImage('image/bgimage.jpg'))),
        child: Column(
          children: [
            SizedBox(
              height: height * 0.15,
            ),
            ReusableContainer(
              text: "Memories",
              icon: Icons.memory_outlined,
              onpressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Memories(userModel: widget.userModel)));

              },
            ),
            ReusableContainer(
              text: "Way To Home",
              icon: Icons.home,
              onpressed: () {},
            ),
            ReusableContainer(
              text: "My Medical History",
              icon: Icons.medical_information,
              onpressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>PatientMedicalHistoryPage(patientUid: widget.userModel.uid.toString())));
              },
            ),
            ReusableContainer(
              text: "Current Caretaker",
              icon: Icons.document_scanner,
              onpressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>CurrentCaretakerScreen(userModel: widget.userModel,)));

              },
            ),
            ReusableContainer(
              text: "Previous Caretaker",
              icon: Icons.history,
              onpressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>PreviousCaretakerScreen(userModel: widget.userModel,)));

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
                }),
          ],
        ),
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
    required this.onpressed,
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
