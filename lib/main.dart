import 'package:flutter/material.dart';
import 'package:aime/Telas/home.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AIME',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),

    );
  }
}

