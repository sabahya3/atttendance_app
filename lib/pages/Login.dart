import 'package:attendito/pages/sign_in.dart';
import 'package:lottie/lottie.dart';
import 'sign_up.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage();

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Attendito",
          style: TextStyle(fontSize: 22, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.withOpacity(0.7),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: <Color>[ Colors.white, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
        ),
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
            child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
              ),
              Container(
                  width: w,
                  height: h * 0.50,
                  child:
                      Lottie.asset("assets/zip/sinorl.zip", width: w * 0.50)),
              customButton(
                  "Login In",
                  <Color>[
                    Colors.teal.withOpacity(0.3),
                    Colors.teal.withOpacity(0.2)
                  ],
                  Colors.black,
                  2,
                  Colors.black, () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => SignIn()));
              }),
              SizedBox(
                height: 20,
              ),
              customButton("Sign Up", <Color>[Colors.white, Colors.white],
                  Colors.black, 2, Colors.black, () {
                //    buildCustomBottomSheet(true,Icons.person,"User Name",Icons.visibility,"Password","Dont have account ?",(){},"Sign Up");
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => SignUp()));
              })
            ],
          ),
        )),
      ),
    );
  }

  GestureDetector customButton(String txt, List<Color> color, Color txtColor,
      double borderWidth, Color borderColor, var function) {
    return GestureDetector(
      onTap: function,
      child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(width: borderWidth, color: borderColor),
              gradient: LinearGradient(colors: color)),
          height: 72,
          width: 150,
          child: Text(
            txt,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: txtColor),
            textAlign: TextAlign.center,
          )),
    );
  }
}
