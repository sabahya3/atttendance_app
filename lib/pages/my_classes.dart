
import 'package:attendito/pages/all_atendance.dart';
import 'package:attendito/pages/professor_service.dart';
import 'package:attendito/pages/student_or_teacher.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
class MyClasses extends StatelessWidget {
  const MyClasses();

  @override
  Widget build(BuildContext context) {
    CollectionReference fire= FirebaseFirestore.instance.collection('classCode');
    var counter=0;


    return WillPopScope(
      onWillPop: (){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>StudentOrTeacher()));
      },
      child: Scaffold(
        appBar: AppBar(title: Text('My Classes'),
        centerTitle: true,
        leading: IconButton(
          color: Colors.white,
          icon: Icon(Icons.arrow_back  ),

          onPressed: (){Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>ProfessorService()));},
        ),),
        body:StreamBuilder(
          stream: fire.where('classCreator',isEqualTo: FirebaseAuth.instance.currentUser.email).snapshots(),
      builder: (context,snapShot) {
        if (snapShot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator(
            color: Colors.blue, backgroundColor: Colors.yellow,));
        if(snapShot.data.docs.length==0){

          return Center(child: Text('Your new classes will appear here 😊',style: TextStyle(fontSize: 20),softWrap: true,));}
        if (snapShot.hasData)
          return Container(
            margin: EdgeInsets.only(top: 50),
            child: ListView.builder(
                itemCount: snapShot.data.docs.length, itemBuilder: (context, i) {
              counter = i;


              return Dismissible(
                background: dismissibleBackground(Alignment.centerRight),
               direction: DismissDirection.endToStart,
                onDismissed: (direction)async{

                  await fire.doc(snapShot.data.docs[i].id).delete();
                  Toast.show('Class deleted successfully',context,gravity: Toast.BOTTOM,duration: 2);
                },
                key: UniqueKey(),
                child: Container(
                  padding: EdgeInsets.only(top: 20),
                  height: 150,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                    color: Colors.teal.withOpacity(0.4),),
                  margin: EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
                  child: ListTile(onTap: () {



                   var bar = snapShot.data.docs[i].data()['classBarCode'];
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (
                        context) => CreatorOrMember( classBarCode: bar,)));
                  }, title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, top: 10),
                        child: Text('Class Name : ${snapShot.data.docs[i]
                            .data()['className']}',style: TextStyle(fontSize: 16,color: Colors.black),),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text('class Creator : ${snapShot.data.docs[i]
                            .data()['classCreator']}',
                          style: TextStyle(fontSize: 15,color: Colors.black),),
                      ),
                    ],
                  ),

                    subtitle: Text(
                        'Time Created : ${ DateFormat('yyyy-MM-dd – kk:mm').format(
                            snapShot.data.docs[i].data()['timeCreated'].toDate())}',style: TextStyle(fontSize: 15,color: Colors.black),),
                    leading: Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: CircleAvatar(maxRadius: 15,child: Text('${++counter}',style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold),),backgroundColor: Colors.white,),
                    ),

                  ),
                ),
              );
            }),
          );
        return Text('Failed');
      })

      ),
    );
  }

  Container dismissibleBackground(var align) {
    return Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                height: 60,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                  color: Colors.red,),
padding: EdgeInsets.symmetric(horizontal: 25),
              alignment: align,

                child: Icon(CupertinoIcons.trash,color: Colors.white,),
              );
  }
}
