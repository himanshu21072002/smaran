// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:alzheimersapporig/Screens/CompleteProfile.dart';
import 'package:alzheimersapporig/Screens/home_page.dart';
import 'package:alzheimersapporig/Screens/home_page_caretaker.dart';
import 'package:alzheimersapporig/Utils/uiHelper.dart';
import 'package:alzheimersapporig/models/usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
class OTP extends StatefulWidget {
  final String contact;
  final String verificationId;
  final String category;
  const OTP({Key? key, required this.verificationId, required this.category, required this.contact}) : super(key: key);

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();


  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    const borderColor = Color.fromRGBO(23, 171, 144, 0.4);

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: borderColor),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,

      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 35),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'image/verification.jpg',
                height: 200,
              ),
              const SizedBox(height: 20,),
              const Text("OTP Verification",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,

                ),
              ),
              const SizedBox(height: 10,),
              const Text("Enter the otp below.",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10,),
          Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Directionality(
                  // Specify direction if desired
                  textDirection: TextDirection.ltr,
                  child: Pinput(
                    controller: pinController,
                    length: 6,
                    focusNode: focusNode,
                    defaultPinTheme: defaultPinTheme,
                    separatorBuilder: (index) => const SizedBox(width: 8),
                    // onClipboardFound: (value) {
                    //   debugPrint('onClipboardFound: $value');
                    //   pinController.setText(value);
                    // },
                    hapticFeedbackType: HapticFeedbackType.lightImpact,
                    cursor: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 9),
                          width: 22,
                          height: 1,
                          color: focusedBorderColor,
                        ),
                      ],
                    ),
                    focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: focusedBorderColor),
                      ),
                    ),
                    submittedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        color: fillColor,
                        borderRadius: BorderRadius.circular(19),
                        border: Border.all(color: focusedBorderColor),
                      ),
                    ),
                    errorPinTheme: defaultPinTheme.copyBorderWith(
                      border: Border.all(color: Colors.redAccent),
                    ),
                  ),
                ),

              ],
            ),
          ),
              const SizedBox(height: 10,),
              SizedBox(
                height: 45,
                width: double.infinity,
                child: TextButton(onPressed: () async{

                  try{
                    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: widget.verificationId, smsCode: pinController.text);

                    // Sign the user in (or link) with the credential
                    UserCredential userCredential=await auth.signInWithCredential(credential);
                    log(userCredential.user!.uid.toString());
                    String uid=userCredential.user!.uid.toString();
                    var a=await FirebaseFirestore.instance.collection('users').doc(uid).get();
                    if(a.exists){
                      UserModel userModel=UserModel.fromJson(a.data() as Map<String,dynamic>);
                      log("Exists");
                      if(widget.category==userModel.category){
                        log("page is going to change ");
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>
                        (widget.category=="Patient")?HomePage(userModel: userModel,):CaretakerHomePage(userModel: userModel)));

                      }else{
                        UIhelper.showAlertDialogue(context, "Error", "User not found");
                      }
                    }else{
                      UserModel newUser=UserModel(
                          uid: uid,
                          category: widget.category,
                          contact: widget.contact.substring(3)
                      );
                      log("Success");
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>CompleteProfilePage(userModel: newUser, status: "phone")));

                    }

                    // UserModel userModel=UserModel.fromJson(userData.data() as Map<String,dynamic>);
                    // log(userData.toString());
                    // if(userData!=null){
                    //   UserModel userModel=UserModel.fromJson(userData.data() as Map<String,dynamic>);
                    // }else{
                    //   log("userData not found");
                    // }
                    }catch(e){
                    UIhelper.showAlertDialogue(context, "Error", "OTP not verified");
                  }

                },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600
                  ),
                  child: const Text("Validate",style: TextStyle(color: Colors.white),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
