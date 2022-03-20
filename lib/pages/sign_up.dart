import 'package:attendito/pages/Login.dart';
import 'package:attendito/pages/student_or_teacher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class SignUp extends StatefulWidget {
  const SignUp();

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController email ;
  TextEditingController username ;
  TextEditingController password ;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  UserCredential userCredential;
  final _formKey = GlobalKey<FormState>();

@override
  void initState() {
    super.initState();
    email= TextEditingController();
       username= TextEditingController();
          password= TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    username.dispose();
    password.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "Attendito",
              style: TextStyle( color: Colors.white),
            ),
            backgroundColor: Colors.blue,
            elevation: 0,
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                icon: Icon(Icons.arrow_back)),
          ),
          body: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: <Color>[Colors.blue, Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 30, right: 30, left: 30),
                    padding: EdgeInsets.only(top: 30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 12,
                          offset: Offset(0, 9), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                margin: EdgeInsets.only(top: 20),
                                child: Text(
                                  "Create an account",
                                  style: TextStyle(
                                      fontSize: 22, color: Colors.black),
                                )),
                            Container(
                              margin: EdgeInsets.only(
                                  top: 20, right: 30, left: 30, bottom: 20),
                              child: TextFormField(
                                // ignore: missing_return
                                validator: (value) {
                                  bool emailValid = RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(value);
                                  if(value.isEmpty|| value==null){

                                    return 'Please enter your email address';
                                  }
                                  else if(emailValid==false){
                                    Toast.show('Email address must contain @example.com', context,gravity: Toast.BOTTOM);
                                    return 'Email  address must contain @example.com';
                                  }


                                },

                                ////

                                controller: email,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.email,
                                      size: 26,
                                      color: Colors.teal,
                                    ),
                                    labelText: "Email address",
                                    hintText: "Enter your email address.",
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.tealAccent,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(10)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: Colors.blue, width: 4))),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: 20, right: 30, left: 30, bottom: 20),
                              child: TextFormField(
                        /////
                                // ignore: missing_return
                                validator: (value) {
                                  if (value.length < 6 && !value.isEmpty)
                                    return 'Password is too short';
                                  else if (value.isEmpty)
                                    return 'password can\'t be empty';
                                },
                                controller: password,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      size: 26,
                                      color: Colors.teal,
                                    ),
                                    labelText: "Password",
                                    hintText: "Enter your password",
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.tealAccent,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(10)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: Colors.blue, width: 4))),
                              ),
                            ),
                            customTextFormField(Icons.person, "Full name",
                                "Enter your full name.", username, validate),
                          ],
                        )),
                  ),
                  GestureDetector(
                      onTap: () async {
                        var formValidator = _formKey.currentState;
                        formValidator.validate();

                        try {
                          userCredential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: email.text, password: password.text);
                          await firestore.collection('users').doc().set({
                            "username": username.text,
                            "email": email.text.trim(),
                            "password": password.text
                          });
                          Toast.show('Welcome! ${username.text} 😊', context,gravity: Toast.BOTTOM,duration: 2);
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            Toast.show(
                                'The password provided is too weak.', context,
                                duration: 1, gravity: Toast.BOTTOM);
                          } else if (e.code == 'email-already-in-use') {
                            Toast.show(
                                'The account already exists for that email.',
                                context,
                                duration: 2,
                                gravity: Toast.BOTTOM);
                          }
                        } catch (e) {
                          print(e);
                        }

                        User user = FirebaseAuth.instance.currentUser;
                        if (userCredential.user.emailVerified == false)
                          await user.sendEmailVerification();

                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => StudentOrTeacher()));
                      },
                      child: Container(
                          width: 150,
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(bottom: 10, top: 22),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 12,
                                  offset:
                                      Offset(0, 9), // changes position of shadow
                                ),
                              ],
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.blue.withOpacity(0.5)),
                          padding: EdgeInsets.all(20),
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ))),
                ],
              ),
            ),
          ),
    );
  }

  String validate(String message) {
    if (message.isEmpty) return 'This field can\'t be empty';
  }

  Container customTextFormField(IconData _icon, String _labelText,
      String _hintText, TextEditingController txt, var validation) {
    return Container(
      margin: EdgeInsets.only(top: 20, right: 30, left: 30, bottom: 20),
      child: TextFormField(
        validator: validate,
        controller: txt,
        decoration: InputDecoration(
            prefixIcon: Icon(
              _icon,
              size: 26,
              color: Colors.teal,
            ),
            labelText: _labelText,
            hintText: _hintText,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.tealAccent,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue, width: 4))),
      ),
    );
  }
}
