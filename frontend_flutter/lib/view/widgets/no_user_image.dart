import 'package:flutter/material.dart';

class NoUserImage extends StatelessWidget {
  const NoUserImage({
    Key? key,
    this.containerSize = 48.0,
    this.iconSize = 35.0,
  }) : super(key: key);

  final double containerSize;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: containerSize,
      width: containerSize,
      decoration:
          BoxDecoration(color: Colors.grey.shade300, shape: BoxShape.circle),
      child: Icon(Icons.person, size: iconSize, color: Colors.white),
    );
  }
}
