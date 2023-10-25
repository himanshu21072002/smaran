import 'package:alzheimersapporig/Screens/choosecategory.dart';
import 'package:alzheimersapporig/Screens/home_page.dart';
import 'package:alzheimersapporig/Screens/home_page_caretaker.dart';
import 'package:alzheimersapporig/models/usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:alzheimersapporig/firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await FirebaseAuth.instance.signOut();
  User? currentuser=FirebaseAuth.instance.currentUser;
  if(currentuser!=null) {
    DocumentSnapshot docSnap=await FirebaseFirestore.instance.collection("users").doc(currentuser.uid).get();

    UserModel? thisusermodel=UserModel.fromJson(docSnap.data() as Map<String,dynamic>);
    if(thisusermodel!=null){
      runApp(MyAppLoggedIn(userModel: thisusermodel));
    }else {
      runApp(const MyApp());
    }
  }else {
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    UserModel userModel=UserModel();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ChooseCategory(),
    );
  }
}


class MyAppLoggedIn extends StatelessWidget {
  final UserModel userModel;
  const MyAppLoggedIn({Key? key, required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: (userModel.category=="Patient")?HomePage(userModel: userModel):CaretakerHomePage(userModel: userModel),
    );
  }
}

