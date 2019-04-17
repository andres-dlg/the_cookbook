import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Separator extends StatelessWidget {

  double heigth;
  double width;
  Color color;

  Separator({this.heigth, this.width, this.color});

  @override
  Widget build(BuildContext context) {
    return new Container(
        margin: new EdgeInsets.symmetric(vertical: 16.0),
        height: heigth,
        width: width,
        color: color
    );
  }
}