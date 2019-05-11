import 'package:flutter/material.dart';

class Separator extends StatelessWidget {

  final double heigth;
  final double width;
  final Color color;

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

class GradientSeparator extends StatelessWidget {

  final double heigth;
  final double width;
  final Color startColor;
  final Color endColor;

  GradientSeparator({this.heigth, this.width, this.startColor, this.endColor});

  @override
  Widget build(BuildContext context) {
    return new Container(
        height: heigth,
        width: width,
        decoration: BoxDecoration(
          gradient: new LinearGradient(
              colors: [startColor, endColor],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(0.5, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp
          ),
        ),
    );
  }
}