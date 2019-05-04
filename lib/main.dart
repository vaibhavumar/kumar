import 'package:flutter/material.dart';
import 'package:kumar/pages/login.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: Colors.deepOrange.shade900,
    ),
    home: LoginPage(),
  ));
}
