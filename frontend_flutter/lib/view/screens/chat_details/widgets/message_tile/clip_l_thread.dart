import 'package:flutter/material.dart';

class ClipLThread extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path()
      ..moveTo(size.width, size.height)
      ..lineTo(0, 3)
      ..quadraticBezierTo(0, 0, 3, 0)
      ..lineTo(size.width, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
