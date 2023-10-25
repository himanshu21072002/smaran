import 'dart:developer';

import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'otp.dart';

class PhoneVerification extends StatefulWidget {
  final String category;
  const PhoneVerification({Key? key, required this.category}) : super(key: key);

  @override
  State<PhoneVerification> createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  TextEditingController phoneController=TextEditingController();
  Country country =Country(
      phoneCode: "+91",
      countryCode: "IN",
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: "India",
      example: "India",
      displayName: "India",
      displayNameNoCountryCode: "IN",
      e164Key: "");
  @override
  Widget build(BuildContext context) {
    phoneController.selection=TextSelection.fromPosition(
      TextPosition(
        offset: phoneController.text.length,
      )
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
              const Text("Phone Verification",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,

                ),
              ),
              const SizedBox(height: 10,),
              const Text("We need to register your phone before getting started",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10,),
              TextFormField(
                onChanged: (value){
                  setState(() {
                    phoneController.text=value;
                  });
                },
                controller: phoneController,
                cursorColor: const Color.fromRGBO(28, 36, 31, 3),
                decoration: InputDecoration(
                  hintText: "Phone ",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black)
                  ),
                  prefixIcon: Container(
                    padding: const EdgeInsets.all(8),
                    child: InkWell(
                      onTap: (){
                        showCountryPicker(
                            context: context,
                            countryListTheme: const CountryListThemeData(bottomSheetHeight: 500),
                            onSelect: (value){
                              setState(() {
                              country=value;
                            });
                        });
                      },
                      child: Text("${country.flagEmoji} ${country.phoneCode}",
                        style: const TextStyle(
                          fontSize: 19,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  suffixIcon: phoneController.text.length>9? Container(
                    height: 25,
                    width: 25,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green
                    ),
                    child: const Icon(
                      Icons.done,
                      color: Colors.white,
                      size: 20,
                    ),
                  ):null
                ),
              ),
              const SizedBox(height: 10,),
              SizedBox(
                height: 45,
                width: double.infinity,
                child: TextButton(onPressed: ()async{
                  await FirebaseAuth.instance.verifyPhoneNumber(
                    phoneNumber: "${country.phoneCode}${phoneController.text}",
                    verificationCompleted: (PhoneAuthCredential credential) {},
                    verificationFailed: (FirebaseAuthException e) {},
                    codeSent: (String verificationId, int? resendToken) {
                      log(verificationId);
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>OTP(verificationId: verificationId,contact: "${country.phoneCode}${phoneController.text}", category: widget.category,)));
                    },
                    codeAutoRetrievalTimeout: (String verificationId) {},
                  );
                },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600
                  ),
                  child: const Text("Send the Code",style: TextStyle(color: Colors.white),),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
