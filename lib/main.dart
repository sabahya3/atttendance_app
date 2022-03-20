import 'dart:async';

import 'package:attendito/pages/Login.dart';
import 'package:attendito/pages/student_or_teacher.dart';
import 'package:attendito/widgets/custom_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Attendito',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage();

  bool loginOrnot() {
    var user = FirebaseAuth.instance.currentUser;
    if (user == null)
      return false;
    else
      return true;
  }

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 2), () {
      loginOrnot() == true
          ? GO(page: StudentOrTeacher(), ctx: context).go()
          : GO(page: LoginPage(), ctx: context).go();
    });
    double w = MediaQuery.of(context).size.width;
      double h = MediaQuery.of(context).size.height;
      
    return Scaffold(
      body: Container(
          width: w,
          height: h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: <Color>[Colors.blue, Colors.white, Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset("assets/zip/on.zip",width: w*0.75,height: h*0.70),
              SizedBox(height: h*0.04,),
            CircularProgressIndicator(color: Colors.black,backgroundColor: Colors.yellow,),
             SizedBox(height: h*0.01,),
             Padding(
               padding: const EdgeInsets.only(left: 10,top: 20),
               child: Text("Loading.......",style: TextStyle(fontSize:18,color: Colors.black)),
             ),
            ],
          ),
         ),
    );
  }
}
