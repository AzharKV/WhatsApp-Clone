import 'package:flutter/material.dart';

class ClipRThread extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var controlPoint = Offset(size.width, 0);
    var endPoint = Offset(size.width / 2, size.height / 2);

    Path path = Path()
      ..lineTo(size.width - 10, 0)
      ..quadraticBezierTo(
          controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy)
      ..lineTo(0, size.height)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
