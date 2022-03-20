
import 'package:attendito/pages/create_new_class.dart';
import 'package:attendito/pages/my_classes.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';


class ProfessorService extends StatefulWidget {
  const ProfessorService();

  @override
  _ProfessorServiceState createState() => _ProfessorServiceState();
}

class _ProfessorServiceState extends State<ProfessorService> {
  int _pageIndex=0;
  List<Widget> allClasses=[
    CreateNewClass(),
     MyClasses(),



  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: allClasses[_pageIndex],
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.blue,
        backgroundColor: Colors.white,
        buttonBackgroundColor: Colors.blue,
        height: 60,
        animationDuration: Duration(seconds: 1),

        index:_pageIndex ,
        onTap: (index){
          setState(() {
            _pageIndex=index;
          });
        },

        items: [
          Icon(Icons.qr_code_scanner,color: Colors.white,size: 30,),

          Icon(Icons.people,color: Colors.white,size: 30,),


        ],

      ),
    );
  }
}
