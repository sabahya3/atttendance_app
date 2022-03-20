
import 'package:attendito/pages/my_classes.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class CreatorOrMember extends StatelessWidget {

  String classBarCode;

  int counter=0;
  CreatorOrMember({ @required this.classBarCode});

  @override
  Widget build(BuildContext context) {


   CollectionReference fire= FirebaseFirestore.instance.collection('classCode').doc(
        classBarCode).collection('classStudents');


    return WillPopScope(
      // ignore: missing_return
      onWillPop: (){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>MyClasses()));
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('All Attendance'),
        leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.white,), onPressed:() {
      Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => MyClasses()));  })
          ,
        ),
        body:

        Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20),
                child: Text("Class barcode",style: TextStyle(fontSize: 18),)),
            Container(
              margin: EdgeInsets.only(top: 40),
              padding: EdgeInsets.only(bottom: 30),
              child:  BarcodeWidget(

              data: classBarCode,
              barcode: Barcode.qrCode(),
              color: Colors.black,
              backgroundColor: Colors.white,
              height: 200,
              width: 200,
            ),),

            Expanded(
              child: buildStreamBuilder(fire),
            ),
          ],
        )),
    );

  }

  StreamBuilder<QuerySnapshot> buildStreamBuilder(CollectionReference fire) {

    return StreamBuilder(
              stream:fire.snapshots(),
              builder: (context, snapShot) {
               try{

                 if(snapShot.data.docs.length==0)
                   return Center(child: Text('No one Joined yet  😊',style: TextStyle(fontSize: 20),));
                 if (snapShot.hasError)
                   return Center(child: Text('Error in the Server'));
                 if (snapShot.connectionState == ConnectionState.waiting)
                   return Center(child: CircularProgressIndicator(
                     color: Colors.blue, backgroundColor: Colors.yellow,),);
                 if(snapShot.hasData)
                   return ListView.builder(itemCount: snapShot.data.docs.length,itemBuilder: (context,i){
                     counter=i;

                     return  Container(
                       height: 100,
                       decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                         color: Colors.blue.withOpacity(0.3),),
                       margin: EdgeInsets.only(top: 20,bottom: 20,left:10,right: 10),
                       child: ListTile(title: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         mainAxisSize: MainAxisSize.min,
                         children: [
                           Padding(
                             padding: const EdgeInsets.only(bottom: 10,top: 10),
                             child: Text('StudentName : ${snapShot.data.docs[i]['StudentName']}'),
                           ),
                           Padding(
                             padding: const EdgeInsets.only(bottom: 10),
                             child: Text('Joined class at : ${DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.parse(snapShot.data.docs[i]['joinTime']))}',style: TextStyle(fontSize: 12),),
                           ),
                         ],
                       ),

                         trailing: Padding(
                           padding: const EdgeInsets.only(top: 16),
                           child: CircleAvatar(child: Text('${++counter}'),),
                         ),
                       ),
                     );
                   });

               }catch(e){
                 print(e);
               }
               return Text('restart the app');
              });
  }

}
