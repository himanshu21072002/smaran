import 'package:alzheimersapporig/Screens/loginpage.dart';
import 'package:flutter/material.dart';

class ChooseCategory extends StatefulWidget {
  const ChooseCategory({Key? key}) : super(key: key);

  @override
  State<ChooseCategory> createState() => _ChooseCategoryState();
}

class _ChooseCategoryState extends State<ChooseCategory> {


  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Choose your category ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 45,
                    fontFamily: "Domine",
                    color: Colors.blue
                  ),
                ),
                const SizedBox(height: 90,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return const LoginPage(category: "Patient",);
                      }));
                    },
                        child: SizedBox(
                          height: height*0.3,
                          width: width*0.4,
                          child: Column(
                            children: [
                              Image(image: AssetImage("image/patient.png")),
                              Text("Patient",style: TextStyle(color: Colors.brown,fontSize: 20))
                            ],
                          ),
                        )
                    ),
                    TextButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return const LoginPage(category: "caretaker",);
                      }));
                    },
                        child: SizedBox(
                          height: height*0.3,
                          width: width*0.4,
                          child: Column(
                            children: [
                              Image(image: AssetImage("image/caretaker.jpg")),
                              Text("Caretaker",style: TextStyle(color: Colors.teal,fontSize: 20),)
                            ],
                          ),
                        )
                    )
                  ],
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
