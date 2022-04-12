import 'package:flutter/material.dart';

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    // debugPrint(size.width.toString());
    // debugPrint(size.height.toString());
    var path = new Path();
    path.lineTo(0.0, size.height - 50);
    var start1 = Offset(size.width / 5, size.height - 50);
    var end1 = Offset(size.width / 2.5, size.height - 100.0);
    path.quadraticBezierTo(start1.dx, start1.dy, end1.dx, end1.dy);

    var end2 = Offset(size.width, size.height - 60);
    var start2 = Offset(size.width - (size.width / 3.24), size.height - 155.0);
    path.quadraticBezierTo(start2.dx, start2.dy, end2.dx, end2.dy);

    path.lineTo(size.width, 0);

    // path.close();
    //print(path);
    return path;
    //throw UnimplementedError();
    //print("dvkjd");
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
