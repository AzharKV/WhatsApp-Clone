import 'package:flutter/material.dart';
import 'package:whatsapp_clone/const_files/my_color.dart';

ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: MyColor.primaryColor,
    scaffoldBackgroundColor: Colors.white,
    backgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(backgroundColor: MyColor.primaryColor));
