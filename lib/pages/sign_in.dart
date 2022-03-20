import 'package:attendito/pages/Login.dart';
import 'package:attendito/pages/sign_up.dart';
import 'package:attendito/pages/student_or_teacher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:toast/toast.dart';

class SignIn extends StatefulWidget {
  SignIn();

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController userName;
  TextEditingController password;
  UserCredential userCredential;
  final _formKey = GlobalKey<FormState>();
  bool secure = true;
  @override
  void initState() {
    super.initState();
    userName = TextEditingController();
    password = TextEditingController();
  }

  @override

  void dispose() {
    super.dispose();
   if(userName!=null){
     userName.dispose();
   }
      if(password!=null){
     password.dispose();
   }
  }

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Attendito"),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 25,
          ),
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginPage()));
          },
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
               margin: EdgeInsets.only(left: 10),
                width: w,
                height: h*0.45,
                child:Lottie.asset("assets/zip/signin.zip",width: w*0.65)
              ),
              Container(
                margin:
                    EdgeInsets.only(top: 0, left: 50, right: 50, bottom: 10),
                child: TextFormField(
                  // ignore: missing_return
                  validator: (value) {
                    bool emailValid = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value);
                    if (value.isEmpty || value == null) {
                      return 'Please enter your email address';
                    } else if (emailValid == false) {
                      Toast.show(
                          'Email address must contain @example.com', context,
                          gravity: Toast.BOTTOM);
                      return 'Email  address must contain @example.com';
                    }
                  },
                  controller: userName,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.email,
                        size: 25,
                        color: Colors.teal.shade400,
                      ),
                      hintText: "Enter your email address.",
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                          borderSide: BorderSide(color: Colors.blue, width: 3)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                          borderSide:
                              BorderSide(color: Colors.greenAccent, width: 3))),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10, left: 50, right: 50),
                child: TextFormField(
                  // ignore: missing_return
                  validator: (value) {
                    if (value.isEmpty || value == null)
                      return "Password can't be empty";
                  },
                  controller: password,
                  obscureText: secure,
                  decoration: InputDecoration(
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: IconButton(
                          iconSize: 25,
                          color: Colors.teal.shade400,
                          icon: Icon(secure == true
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              secure == false ? secure = true : secure = false;
                            });
                          },
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.lock,
                        size: 25,
                        color: Colors.teal.shade400,
                      ),
                      hintText: "Enter your password.",
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                          borderSide: BorderSide(color: Colors.blue, width: 3)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                          borderSide:
                              BorderSide(color: Colors.greenAccent, width: 3))),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 15),
                  width: 150,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.teal.shade400,
                  ),
                  child: TextButton(
                    onPressed: () async {
                      var formstate = _formKey.currentState;
                      formstate.validate();
                      try {
                        userCredential = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                          email: userName.text.trim(),
                          password: password.text,
                        );
                        Toast.show(
                            'Welcome back ${userCredential.user.email} 😊',
                            context,
                            duration: 2,
                            gravity: Toast.BOTTOM);

                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => StudentOrTeacher()));
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          Toast.show(
                              'No user found for that email , please sign up',
                              context,
                              duration: 2,
                              gravity: Toast.BOTTOM);
                        } else if (e.code == 'wrong-password') {
                          Toast.show(
                              'Wrong password provided for that user.', context,
                              duration: 2, gravity: Toast.BOTTOM);
                        }
                      }

                      print('done');
                    },
                    child: Text(
                      "Sign In",
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account ?",
                    style: TextStyle(fontSize: 18),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => SignUp()));
                      },
                      child: Text(
                        "sign up",
                        style: TextStyle(fontSize: 20),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
