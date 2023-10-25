
import 'package:flutter/material.dart';

class UIhelper{
  static void showloadingdialogue(BuildContext context,String title){
    AlertDialog loadingdialogue=AlertDialog(
      content: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 30,),
            Text(title)
          ],
        ),
      ),
    );
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return loadingdialogue;
        });

  }
  static void showAlertDialogue(BuildContext context,String title,String content){
    AlertDialog alertDialogue=AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(onPressed: (){
          Navigator.pop(context);
        }, child: const Text("OK"))
      ],
    );

    showDialog(context: context, builder: (context){
      return alertDialogue;
    });
  }
}