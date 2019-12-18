import 'package:flutter/material.dart';
// import 'dart:ui' as ui;
import 'dart:core';
import 'dart:ui';
import 'package:xlive/const/adapt.dart';

class CircularProgresse extends StatefulWidget {
  final Color backgroundColor; //背景色
  final double press; //显示值
  final String date; //显示的时间
  final double value;
  final Color color;
  CircularProgresse(
      {this.backgroundColor, this.press, this.date, this.value, this.color});

  @override
  _CircularProgress createState() => new _CircularProgress();
}

class _CircularProgress extends State<CircularProgresse>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  // Animation animation;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      alignment: Alignment.center,
      children: <Widget>[
        new CustomPaint(
          painter: new CircularCanvas(
              progress: widget.press,
              backgroundColor: widget.backgroundColor,
              color: widget.color),
          size: new Size(54.0, 54.0),
        ),
        new Text(
          widget.date,
          style:
              new TextStyle(color: Color(0xffd6d6d6), fontSize: Adapt.px(90)),
        )
      ],
    );
  }
}

class CircularCanvas extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color color;

  CircularCanvas({this.progress, this.backgroundColor, this.color});
  @override
  void paint(Canvas canvas, Size size) {
    var paint = new Paint();
    paint
      ..color = backgroundColor
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(new Offset(27.0, 27.0), 81.0, paint);
    Rect rect = new Offset(0.0, 0.0) & size;
    paint
      ..shader = new LinearGradient(
              colors: [Color(0xff7dcef3), Color(0xff8ddfc4)],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft)
          .createShader(rect);
    canvas.drawArc(new Offset(-54.0, -54.0) & new Size(162.0, 162.0), -1.5,
        progress, false, paint..color = color);
  }

  @override
  bool shouldRepaint(CircularCanvas oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
