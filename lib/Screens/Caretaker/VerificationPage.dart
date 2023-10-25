// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:alzheimersapporig/Screens/home_page_caretaker.dart';
import 'package:alzheimersapporig/Utils/utilities.dart';
import 'package:alzheimersapporig/models/usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
class VerificationPage extends StatefulWidget {
  final String email;
  final EmailOTP myauth;
  final String targetuid;
  final UserModel myUser;
  const VerificationPage({Key? key, required this.email, required this.myauth, required this.targetuid, required this.myUser}) : super(key: key);

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }
  void addPatient()async{
    
    await FirebaseFirestore.instance.collection("PCrelation").doc(widget.myUser.uid).collection("Patient list").doc(widget.targetuid).set({"status":"Active"});
    await FirebaseFirestore.instance.collection("PCrelationReverse").doc(widget.targetuid).collection("Caretaker list").doc(widget.myUser.uid).set({"status":"Active"});
    log("Patient Added");
    showSnackBar((context), "Successfully added");
    Future.delayed(const Duration(milliseconds: 1000), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>CaretakerHomePage(userModel: widget.myUser)));
    });
  }

  @override
  Widget build(BuildContext context) {
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
              const Text("Ask the otp from patient.",
                style: TextStyle(
                  fontSize: 16
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
                        separatorBuilder: (index) => const SizedBox(width: 8),
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
                  if (await widget.myauth.verifyOTP(otp: pinController.text) == true) {
                    addPatient();
                  } else {
                    showSnackBar((context), "Wrong OTP");
                    log("wrong otp");
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
