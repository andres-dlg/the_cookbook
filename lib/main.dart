import 'package:flutter/material.dart';
import 'package:the_cookbook/pages/home/home_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'The cookbook',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home()
    );
  }
}
