
import 'package:attendito/pages/student_or_teacher.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class CreateNewClass extends StatefulWidget {
  CreateNewClass();

  @override
  _CreateNewClassState createState() => _CreateNewClassState();
}

class _CreateNewClassState extends State<CreateNewClass> {


  TextEditingController classId;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  DateTime _barcodeController;
  @override
  initState(){
    _barcodeController=DateTime.now();
   classId  = TextEditingController();
    super.initState();
}
@override
  void dispose() {

    super.dispose();
     classId.dispose();
  }
  @override
  Widget build(BuildContext context) {
    String _classId = classId.text;

    return WillPopScope(
      onWillPop: (){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>StudentOrTeacher()));
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => StudentOrTeacher()));
            },
          ),
          title: Text("Attendito", style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: Container(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  SizedBox(
                    height: 60,
                  ),
                  BarcodeWidget(
                    data: _barcodeController.toString(),
                    barcode: Barcode.qrCode(),
                    color: Colors.black,
                    backgroundColor: Colors.white,
                    height: 200,
                    width: 200,
                  ),
                  Container(
                    width: 300,
                    margin:
                    EdgeInsets.only(top: 20, right: 30, left: 30, bottom: 0),
                    child: TextFormField(
                      textDirection: TextDirection.ltr,
                      controller: classId,
                      onChanged: (val) {
                        setState(() {
                          _classId = val;
                        });
                      },
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.format_list_numbered,
                            size: 26,
                            color: Colors.teal,
                          ),
                          labelText: "Class Name",
                          hintText: "Enter Class Name",
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.tealAccent,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                              BorderSide(color: Colors.blue, width: 4))),
                    ),
                  ),


                  Container(
                    margin: EdgeInsets.only(top: 30),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(15)),
                    width: 120,
                    height: 60,
                    child: TextButton(
                      child: Text(
                        "Submit",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      onPressed: () async {

                        setState(() {
                          _barcodeController = DateTime.now();
                        });
                        await firestore
                            .collection('classCode')
                            .doc('${_barcodeController.toString()}')
                            .set({
                          "numberOfStudents": 0,
                          "classBarCode": _barcodeController.toString(),
                          "classCreator": FirebaseAuth.instance.currentUser.email,
                          "className": classId.text,
                          "timeCreated": DateTime.now(),
                          "currentMonth":DateTime.now().month
                        });
                        Toast.show('Class created successfully!', context,duration: 2,gravity: Toast.BOTTOM);


                        classId.clear();
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),

      ),
    );
  }
}
