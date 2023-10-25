// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:alzheimersapporig/Screens/Caretaker/VerificationPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/usermodel.dart';

class AddNewPatientScreen extends StatefulWidget {
  final UserModel userModel;
  final String myUid;
  const AddNewPatientScreen({Key? key, required this.myUid, required this.userModel}) : super(key: key);

  @override
  State<AddNewPatientScreen> createState() => _AddNewPatientScreenState();
}

class _AddNewPatientScreenState extends State<AddNewPatientScreen> {
  TextEditingController emailController=TextEditingController();
  EmailOTP myAuth=EmailOTP();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20
          ),
          child: Column(
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                    labelText: "Enter email to search"
                ),

              ),
              const SizedBox(height: 20,),
              CupertinoButton(
                  color: Theme.of(context).colorScheme.secondary,
                  onPressed: (){
                    setState(() {

                    });
                  },
                  child: const Text("Search")),
              const SizedBox(height: 20,),
              StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("users").
                  where("email",isEqualTo: emailController.text).where("category", isEqualTo: "Patient").snapshots(),
                  builder: (context,snapshot){
                    if(snapshot.connectionState==ConnectionState.active){
                      if(snapshot.hasData){
                        QuerySnapshot datasnapshot=snapshot.data as QuerySnapshot;
                        if(datasnapshot.docs.isNotEmpty){
                          Map<String,dynamic> userMap=datasnapshot.docs[0].data()
                          as Map<String,dynamic>;
                          UserModel searcheduser=UserModel.fromJson(userMap);
                          return ListTile(
                            onTap: () {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    icon: const Icon(
                                      Icons.call,
                                      color: Colors.green,
                                    ),
                                    title: const Text('Do you want add this patient ?'),
                                    actions: [
                                      TextButton(
                                          onPressed: () async{
                                            myAuth.setConfig(
                                                appEmail: "himanshugangwar484@gmail.com",
                                                appName: "Email OTP",
                                                userEmail: searcheduser.email,
                                                otpLength: 6,
                                                otpType: OTPType.digitsOnly
                                            );
                                            if (await myAuth.sendOTP() == true) {
                                              log("Sent");

                                            } else {
                                              log("Not sent");
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                content: Text("Oops, OTP send failed"),
                                              ));
                                            }
                                            Navigator.push(context, MaterialPageRoute(builder: (context)=>VerificationPage(email: searcheduser.email.toString(),myauth: myAuth,targetuid: searcheduser.uid.toString(),myUser: widget.userModel,)));
                                          },
                                          child: const Text('Yes')),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('No')),
                                    ],
                                  );
                                },
                              );
                            },
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(searcheduser.profilepic.toString()),
                            ),
                            title: Text(searcheduser.name.toString()),
                            subtitle: Text(searcheduser.email.toString()),
                            trailing: const Icon(Icons.keyboard_arrow_right),
                          );
                        }else{
                          return const Text("No results found");
                        }


                      }else if(snapshot.hasError){
                        return const Text("An error occurred");
                      }else{
                        return const Text("No results found");
                      }
                    }
                    else{
                      return const CircularProgressIndicator();
                    }
                  }
              )
              // StreamBuilder(),
            ],

          ),
        ),
      ),
    );
  }
}
