import 'package:flutter/material.dart';

class ResendTIle extends StatelessWidget {
  const ResendTIle({
    Key? key,
    required this.leadingIcon,
    required this.title,
    required this.trailing,
  }) : super(key: key);

  final IconData leadingIcon;
  final String title;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(leadingIcon, color: Colors.grey),
      title: Text(
        title,
        style: const TextStyle(color: Colors.grey),
      ),
      trailing: Text(
        trailing,
        style: const TextStyle(color: Colors.grey),
      ),
      horizontalTitleGap: 0.0,
      minVerticalPadding: 0.0,
      dense: true,
    );
  }
}
