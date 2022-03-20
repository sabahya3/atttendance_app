import 'package:attendito/main.dart';
import 'package:attendito/pages/attend_class.dart';
import 'package:attendito/pages/professor_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_teacher_and_student.dart';

class StudentOrTeacher extends StatefulWidget {
  const StudentOrTeacher();

  @override
  _StudentOrTeacherState createState() => _StudentOrTeacherState();
}

class _StudentOrTeacherState extends State<StudentOrTeacher> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: Drawer(
          child: Column(
            children: [
              Container(child: DrawerHeader(
                child: null,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/splash.png',)
                  )
                ),
              )),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30,vertical: 30),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  leading: IconButton(
                    onPressed: null,
                    icon: Icon(
                      Icons.login_outlined,
                      color: Colors.black,
                    ),
                  ),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => MyHomePage()));
                  },
                  title: Text('Sign out'),
                  tileColor: Colors.blue.withOpacity(0.3),
                ),
              )
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.blue.withOpacity(0.9),
          elevation: 3,
          title: Text(
            "Attendito",
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: <Color>[Colors.blue, Colors.white, Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight)),
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                   CustomPersonView(
                    function: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => ProfessorService()));
                    },
                    imgUrl: "assets/images/tea.png",
                    buttunTxt: "Professor",
                  ),
                   CustomPersonView(
                    function: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => AttendClass()));
                    },
                    imgUrl: "assets/images/stu.png",
                    buttunTxt: "Student",
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
