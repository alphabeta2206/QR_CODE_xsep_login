import 'package:flutter/material.dart';

import 'routes/signin.dart';

import 'routes/signup.dart';
void main() => runApp(ESEP());
class ESEP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "XSEP",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          color: Colors.transparent,
          elevation: 0.0,
        ),
        scaffoldBackgroundColor: Colors.transparent,
      ),
      home: Login(),
    );
  }
}
