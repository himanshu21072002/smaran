// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../Utils/uiHelper.dart';
import '../models/usermodel.dart';
import 'home_page.dart';
import 'home_page_caretaker.dart';



class CompleteProfilePage extends StatefulWidget {
  final UserModel userModel;
  final String status;
  const CompleteProfilePage({super.key, required this.userModel, required this.status});


  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  File? imageFile;

  TextEditingController fullnamecontroller=TextEditingController();
  TextEditingController phoneController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController nameController=TextEditingController();
  TextEditingController countryController=TextEditingController();
  TextEditingController stateController=TextEditingController();
  TextEditingController cityController=TextEditingController();
  TextEditingController areaController=TextEditingController();
  TextEditingController buildingController=TextEditingController();

  void selectimage(ImageSource source)async{
    try{
      XFile? pickedfile=await ImagePicker().pickImage(source: source);
      if(pickedfile!=null){
        setState(() {
          imageFile=File(pickedfile.path);
        });
      }}catch(e){
        UIhelper.showAlertDialogue(context, "Error", e.toString());
    }
  }


  void showphotooptions(){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: const Text("Upload Profile Picture"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: (){
                Navigator.pop(context);
                selectimage(ImageSource.gallery);
              },
              leading: const Icon(Icons.photo_album),
              title: const Text("Select from Gallery"),
            ),
            ListTile(

              onTap: (){
                Navigator.pop(context);

                selectimage(ImageSource.camera);
              },
              leading: const Icon(Icons.camera_alt),
              title: const Text("Take a picture"),
            ),

          ],
        ),
      );
    });
  }

  void checkvalues(){
    String fullname=fullnamecontroller.text.trim();
    String phoneno=phoneController.text.trim();
    String country=countryController.text.trim();
    String email=emailController.text.trim();
    String state=stateController.text.trim();
    String city=cityController.text.trim();
    String area=areaController.text.trim();
    String building=buildingController.text.trim();


    if(imageFile==null ){
      UIhelper.showAlertDialogue(context, "Incomplete Data","Please uplaod a profile picture");
    }else{
      if(fullname.isEmpty || (widget.status=="email")?phoneno.isEmpty:email.isEmpty || country.isEmpty||
          state.isEmpty|| city.isEmpty|| area.isEmpty|| building.isEmpty){
        UIhelper.showAlertDialogue(context, "Incomplete Data","Please fill all the details");
      }else{
        log("Uploading data");
        uploaddata();
      }

    }
  }
  void uploaddata() async{

    UIhelper.showloadingdialogue(context, "Uploading Image..");
    UploadTask uploadtask=FirebaseStorage.instance.ref("Profile pictures").
    child(widget.userModel.uid.toString()).putFile(imageFile!);
    TaskSnapshot snapshot=await uploadtask;
    String imageurl=await snapshot.ref.getDownloadURL();
    String fullname=fullnamecontroller.text.trim();
    String phoneno=phoneController.text.trim();
    String country=countryController.text.trim();
    String email=emailController.text.trim();
    String state=stateController.text.trim();
    String city=cityController.text.trim();
    String area=areaController.text.trim();
    String building=buildingController.text.trim();
    Address address=Address(
      country: country,
      state: state,
      city: city,
      area: area,
      buildingName: building
    );
    widget.userModel.name=fullname;
    widget.userModel.profilepic=imageurl;
    widget.userModel.address=address;
    (widget.status=="email")?widget.userModel.contact=phoneno:widget.userModel.email=email;


    await FirebaseFirestore.instance.collection("users").
    doc(widget.userModel.uid).set(widget.userModel.toJson()).then((value) {
      log("data uploaded");
      log("data uploaded");
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
        return (widget.userModel.category=="Patient")?HomePage(userModel: widget.userModel,):CaretakerHomePage(userModel: widget.userModel,);
      }));
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text("Complete Profile"),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: ListView(
            children: [
              const SizedBox(
                height: 20,
              ),
              CupertinoButton(
                onPressed: (){
                  showphotooptions();
                },
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: imageFile==null?null:FileImage(imageFile!),
                  child: imageFile==null? const Icon(Icons.person,size: 60,):null,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: fullnamecontroller,
                decoration: const InputDecoration(
                    labelText: "Full Name"
                ),
              ),
              (widget.status!="email")?TextField(
                controller: emailController,
                decoration: const InputDecoration(
                    labelText: "E-mail"
                ),
              ):TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                    labelText: "Phone Number"
                ),
              ),

              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width*0.3,
                        child: TextField(

                          controller: countryController,
                          decoration: const InputDecoration(
                              labelText: "Country"
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width*0.3,
                        child: TextField(

                          controller: stateController,
                          decoration: const InputDecoration(
                              labelText: "state"
                          ),
                        ),
                      )
                    ],
                  ),Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width*0.3,
                        child: TextField(

                          controller: cityController,
                          decoration: const InputDecoration(
                              labelText: "City"
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width*0.3,
                        child: TextField(

                          controller: areaController,
                          decoration: const InputDecoration(
                              labelText: "Area"
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width*0.3,
                        child: TextField(

                          controller: buildingController,
                          decoration: const InputDecoration(
                              labelText: "Building"
                          ),
                        ),
                      )
                    ],
                  )
                ],

              ),
              SizedBox(height: 20,),
              CupertinoButton(
                  color: Colors.blue,
                  child: const Text("Submit"),
                  onPressed: (){
                    checkvalues();
                  })
            ],
          ),
        ),
      ),
    );
  }
}
