import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:alzheimersapporig/models/memoriesModel.dart';

import '../models/usermodel.dart';

class FirebaseHelper{
  static Future<UserModel?> getusermodelbyid(String uid) async{
    UserModel? usermodel;
    DocumentSnapshot docSnap=await FirebaseFirestore.instance.collection("users").doc(uid).get();
    if(docSnap!=null){
      usermodel=UserModel.fromJson(docSnap.data() as Map<String,dynamic>);
    }
    return usermodel;
  }
  static Future<MemoryModel?> getMemoryfromid(String userId,String uid) async{
    MemoryModel? memoryModel;
    DocumentSnapshot docSnap=await FirebaseFirestore.instance
        .collection("memories")
        .doc(userId)
        .collection("patient memories").doc(uid).get();
    if(docSnap!=null){
      memoryModel=MemoryModel.fromJson(docSnap.data() as Map<String,dynamic>);
    }
    return memoryModel;
  }
}