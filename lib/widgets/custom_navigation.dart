import 'package:flutter/material.dart';

class GO {
    GO({@required this.ctx,@required this.page});
  BuildContext ctx;
  Widget page;

  go() {
    Navigator.of(ctx).pushReplacement(
        PageRouteBuilder(transitionDuration: Duration(seconds: 2),pageBuilder: (context, animation,_) {
          return FadeTransition(opacity: animation,child: page,);
        }));
  }
}
