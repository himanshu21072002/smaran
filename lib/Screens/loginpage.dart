// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:alzheimersapporig/Screens/EmailSignUp.dart';
import 'package:alzheimersapporig/Screens/PhoneVerification.dart';
import 'package:alzheimersapporig/Screens/home_page.dart';
import 'package:alzheimersapporig/Screens/home_page_caretaker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Utils/uiHelper.dart';
import '../models/usermodel.dart';
class LoginPage extends StatefulWidget {
  final String category;

  const LoginPage({super.key, required this.category});


  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController=TextEditingController();
  final TextEditingController _passwordController=TextEditingController();

  bool _passwordVisible=false;
  void checkvalues(){
    String email=_emailController.text.trim();
    String password=_passwordController.text.trim();

    if(email=="" || password==""){
      UIhelper.showAlertDialogue(context, "Incomplete Data", "Please fill all the fields");

    }else{
      login(email,password);
    }
  }

  void login(String email,String password)async{
    UserCredential? credentials;
    UIhelper.showloadingdialogue(context, "Logging IN...");
    try{
      credentials=await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

    }on FirebaseAuthException catch(ex){
      //close the loading dialogue
      Navigator.pop(context);

      //Show alert dialogue
      UIhelper.showAlertDialogue(context, "An error occured", ex.message.toString());
      log(ex.message.toString());
    }

    if(credentials!=null){
      String uid=credentials.user!.uid;

      DocumentSnapshot userData=await FirebaseFirestore.instance.collection('users').doc(uid).get();
      UserModel userModel=UserModel.fromJson(userData.data() as Map<String,dynamic>);
      if(widget.category==userModel.category){
        Navigator.popUntil(context, (route) => route.isFirst);

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
          return (widget.category=="Patient")?HomePage(userModel: userModel,):CaretakerHomePage(userModel: userModel,);
        }));
        log("Log in Successful");
      }else {
        log("Error is there ");
        Navigator.pop(context);
        await FirebaseAuth.instance.signOut();
        UIhelper.showAlertDialogue(context, "Error", "User does not exist");


      }


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
                decoration: const BoxDecoration(color: Color.fromRGBO(28, 36, 31, 3)),
                alignment: Alignment.bottomLeft,
                child: const Padding(
                  padding: EdgeInsets.all(13),
                  child: Text("Login to your Account",
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
                    const SizedBox(height: 45,),
                    SizedBox(
                      width: 320,
                      height: 55,
                      child: ElevatedButton(onPressed: (){
                        checkvalues();
                      },

                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(139, 213, 64, 10)),
                        ),
                        child: const Text("Login",
                          style: TextStyle(
                              fontSize: 28,
                            fontFamily: 'Domine'
                          ),),

                      ),
                    ),
                    const SizedBox(height: 20,),
                    SizedBox(

                      width: 320,
                      height: 55,
                      child: ElevatedButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>PhoneVerification(category: widget.category,)));
                      },

                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.grey),
                        ),
                        child: const Text("Login using phone",
                          style: TextStyle(
                            color: Colors.black,
                              fontSize: 22,
                              fontFamily: 'Domine'
                          ),),

                      ),
                    )
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
          const Text("Do not have a account ?",style: TextStyle(fontSize: 17),),
          TextButton(child: Text("Sign Up",style: TextStyle(fontSize: 17,color: Colors.grey.shade600),),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>EmailSignUpPage(category: widget.category)));
              })
        ],
      ),
    );
  }
}

