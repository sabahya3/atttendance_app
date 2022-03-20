import 'package:flutter/material.dart';

class CustomPersonView extends StatelessWidget {
   CustomPersonView({@required this.imgUrl, @required this.buttunTxt, @required this.function});

  final String imgUrl;
  final String buttunTxt;
   final Function function;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.only(top: 30, bottom: 10),
            height: 170,
            width: 170,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                    colors: <Color>[Colors.blue, Colors.white, Colors.yellow])),
            child: Image.asset(imgUrl)),
        GestureDetector(
          onTap:function,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient:
                    LinearGradient(colors: <Color>[Colors.blue, Colors.teal])),
            height: 70,
            width: 250,
            child: Text(
              buttunTxt,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }
}
