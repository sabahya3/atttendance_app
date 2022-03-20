import 'package:attendito/pages/student_or_teacher.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toast/toast.dart';

class AttendClass extends StatefulWidget {
  const AttendClass({Key key}) : super(key: key);

  @override
  _AttendClassState createState() => _AttendClassState();
}

class _AttendClassState extends State<AttendClass> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  int numOfStudents;
  String userName;
  var currentUserEmail = FirebaseAuth.instance.currentUser.email;

  Future<void> scanQr() async {
    try {
      FlutterBarcodeScanner.scanBarcode('#2A99CF', 'cancel', true, ScanMode.QR)
          .then((value) async {
        CollectionReference fire = FirebaseFirestore.instance
            .collection('classCode')
            .doc(value)
            .collection('classStudents');
        fire
            .where("studentEmail", isEqualTo: currentUserEmail)
            .get()
            .then((val) => {
                  if (val.docs.isEmpty)
                    {
                      firestore.collection('classCode').doc(value).get().then(
                          (value) =>
                              {numOfStudents = value['numberOfStudents']}),
                      firestore
                          .collection('users')
                          .where('email',
                              isEqualTo:
                                  FirebaseAuth.instance.currentUser.email)
                          .get()
                          .then((value) {
                        userName = value.docs.first['username'];
                      }),
                      firestore
                          .collection('classCode')
                          .doc(value)
                          .update({"numberOfStudents": ++numOfStudents}),
                      firestore
                          .collection('classCode')
                          .doc(value)
                          .collection('classStudents')
                          .doc()
                          .set({
                        'StudentName': userName,
                        'joinTime': DateTime.now().toString(),
                        'studentEmail': currentUserEmail
                      }),
                      Toast.show('You joined this class successfully!', context,
                          duration: 2, gravity: Toast.BOTTOM),
                    }
                  else
                    {
                      Toast.show('You joined this class before!', context,
                          duration: 2, gravity: Toast.BOTTOM),
                    }
                });
      });
    } catch (e) {
      Toast.show('Please Scan again', context,
          duration: 2, gravity: Toast.BOTTOM);
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
     return   Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => StudentOrTeacher()));
             
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Attendito",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => StudentOrTeacher()));
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 0),
                  child: Text(
                    "Attend new class",
                    style: TextStyle(fontSize: 25, color: Colors.black),
                  ),
                ),
                Container(
                  width: 300,
                  height: 350,
                  child: Image.asset("assets/images/scan.png"),
                ),
                Container(
                  width: 250,
                  height: 90,
                  child: ElevatedButton(
                    onPressed: () async {
                      await scanQr();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          CupertinoIcons.barcode_viewfinder,
                          color: Colors.white,
                          size: 30,
                        ),
                        Text(
                          "Scan to attend class",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        )
                      ],
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      )),
                      backgroundColor: MaterialStateProperty.all(
                          Colors.pinkAccent.withOpacity(0.5)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: CurvedNavigationBar(
          color: Colors.blue,
          backgroundColor: Colors.white,
          buttonBackgroundColor: Colors.blue,
          height: 60,
          index: 0,
          items: [
            Icon(
              Icons.qr_code,
              color: Colors.white,
              size: 30,
            )
          ],
        ),
      ),
    );
  }
}
