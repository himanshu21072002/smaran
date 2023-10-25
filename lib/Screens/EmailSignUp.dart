// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Utils/uiHelper.dart';
import '../models/usermodel.dart';
import 'CompleteProfile.dart';
import 'loginpage.dart';
class EmailSignUpPage extends StatefulWidget {
  final String category;

  const EmailSignUpPage({super.key, required this.category});


  @override
  State<EmailSignUpPage> createState() => _EmailSignUpPageState();
}

class _EmailSignUpPageState extends State<EmailSignUpPage> {
  final TextEditingController _emailController=TextEditingController();
  final TextEditingController _passwordController=TextEditingController();
  final TextEditingController _cpasswordController=TextEditingController();
  bool _passwordVisible=false;
  bool _cpasswordVisible=false;
  void checkvalues(){
    String email=_emailController.text.trim();
    String password=_passwordController.text.trim();
    String cpassword=_cpasswordController.text.trim();
    if(email=="" || password=="" || cpassword==""){

      UIhelper.showAlertDialogue(context, "Incomplete data", "please fill all the fields");
    }else if(password!=cpassword){
      UIhelper.showAlertDialogue(context, "Passwords Mismatch", "The password you entered does not match");

    }else{
      log("sign up successfully");
      signup(email, password);
    }
  }
  void signup(String email,String password) async{
    UserCredential? credential;
    UIhelper.showloadingdialogue(context, "Creating new account...");
    try{
      credential=await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    }on FirebaseAuthException catch(ex){
      Navigator.pop(context);
      UIhelper.showAlertDialogue(context, "An error occured", ex.code.toString());
    }
    if(credential!=null){
      String uid=credential.user!.uid;

      UserModel newuser=UserModel(
        uid: uid,
        email: email,
        category: widget.category,

      );
      await FirebaseFirestore.instance.collection("users").doc(uid).set
        (newuser.toJson()).then((value){
        log("new user created");
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
          return
            CompleteProfilePage(userModel: newuser,status: "email",);
        }));
      });
    }

  }

  @override

  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    double height=MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: height*0.25,
                width: 500,
                decoration: const BoxDecoration(color: Color.fromRGBO(28, 36, 31, 3)),
                alignment: Alignment.bottomLeft,
                child: const Padding(
                  padding: EdgeInsets.all(13),
                  child: Text("Sign up to your Account",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 41,
                      )),
                ),
              ),
              const SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    TextField(

                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600
                        ),

                      ),
                      cursorColor: Colors.grey.shade600,
                      onSubmitted: (val){

                      },
                    ),
                    const SizedBox(height: 10,),
                    TextField(
                      controller: _passwordController,
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 18
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible ?Icons.visibility_rounded:Icons.visibility_off,
                            ),
                            onPressed: (){
                              setState(() {
                                _passwordVisible=!_passwordVisible;
                              });
                            },
                          )
                      ),
                      onSubmitted: (val){

                      },
                    ),
                    const SizedBox(height: 10,),
                    TextField(
                      controller: _cpasswordController,
                      obscureText: !_cpasswordVisible,
                      decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 18
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _cpasswordVisible ?Icons.visibility_rounded:Icons.visibility_off,
                            ),
                            onPressed: (){
                              setState(() {
                                _cpasswordVisible=!_cpasswordVisible;
                              });
                            },
                          )
                      ),
                      onSubmitted: (val){

                      },
                    ),
                    const SizedBox(height: 10,),
                    SizedBox(
                      width: 320,
                      height: 55,
                      child: ElevatedButton(onPressed: (){
                        checkvalues();
                      },

                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(139, 213, 64, 10)),
                        ),
                        child: const Text("Sign Up",
                          style: TextStyle(
                              fontSize: 28,
                              fontFamily: 'Domine'
                          ),),

                      ),
                    ),
                    const SizedBox(height: 50,),

                  ],
                ),
              )

            ],
          ),
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Already have a account ?",style: TextStyle(fontSize: 17),),
          TextButton(child: Text("Sign IN",style: TextStyle(fontSize: 17,color: Colors.grey.shade600),),
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context){
                      return LoginPage(category: widget.category,);
                    }));
              })
        ],
      ),
    );
  }
}

