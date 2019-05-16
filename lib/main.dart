import 'package:flutter/material.dart';
import 'package:kumar/pages/login/login.dart';

void main() {
  final secondaryColor = Color(0xffff8a65),
      secondaryLight = Color(0xffffbb93),
      secondaryDark = Color(0xffc75b39);

  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xffff6d00),
        primaryColorLight: Color(0xffff9e40),
        primaryColorDark: Color(0xffc43c00),
        accentColor: secondaryColor,
        backgroundColor: secondaryLight,
        buttonColor: secondaryDark,
      ),
      home: LoginPage()));
}
