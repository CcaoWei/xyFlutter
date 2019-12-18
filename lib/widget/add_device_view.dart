import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'dart:async';

class AddDeviceView extends StatefulWidget {
  State<StatefulWidget> createState() => _AddDeviceState();
}

class _AddDeviceState extends State<AddDeviceView>
    with TickerProviderStateMixin {
  static const double RADIUS_START = 60.0;
  static const double RADIUS_END = 300.0;

  static const Color COLOR_START = const Color(0xFF7CD0FF);
  static const Color COLOR_END = const Color(0x007CD0FF);

  static const int DURATION = 4;

  AnimationController _controller1;
  AnimationController _controller2;

  Animation<Color> _color1;
  Animation<Color> _color2;

  Animation<double> _radius1;
  Animation<double> _radius2;

  Timer _timer2;

  void initState() {
    super.initState();
    _startAnimation1();
    _timer2 = Timer(const Duration(milliseconds: 2000), () {
      _startAnimation2();
    });
  }

  void dispose() {
    if (_controller1 != null) {
      _controller1.stop();
      _controller1.dispose();
    }
    if (_controller2 != null) {
      _controller2.stop();
      _controller2.dispose();
    }
    if (_timer2 != null) {
      _timer2.cancel();
    }
    super.dispose();
  }

  void _startAnimation1() {
    _controller1 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: DURATION),
    )..addListener(() {
        setState(() {});
      });
    _radius1 = Tween<double>(
      begin: RADIUS_START - 0.0,
      end: RADIUS_END,
    ).animate(_controller1);
    _color1 = ColorTween(
      begin: COLOR_START,
      end: COLOR_END,
    ).animate(_controller1);
    _controller1.repeat();
  }

  void _startAnimation2() {
    _controller2 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: DURATION),
    )..addListener(() {
        setState(() {});
      });
    _radius2 = Tween<double>(
      begin: RADIUS_START - 0.0,
      end: RADIUS_END,
    ).animate(_controller2);
    _color2 = ColorTween(
      begin: COLOR_START,
      end: COLOR_END,
    ).animate(_controller2);
    _controller2.repeat();
  }

  Widget build(BuildContext context) {
    return Container(
      height: 300.0,
      alignment: Alignment.center,
      padding: EdgeInsets.only(),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            width: _radius1 == null ? 0 : _radius1.value,
            height: _radius1 == null ? 0 : _radius1.value,
            decoration: BoxDecoration(
                color: _color1 == null ? Colors.transparent : _color1.value,
                borderRadius: BorderRadius.circular(
                    _radius1 == null ? 0 : _radius1.value / 2)),
          ),
          Container(
            width: _radius2 == null ? 0 : _radius2.value,
            height: _radius2 == null ? 0 : _radius2.value,
            decoration: BoxDecoration(
                color: _color2 == null ? Colors.transparent : _color2.value,
                borderRadius: BorderRadius.circular(
                    _radius2 == null ? 0 : _radius2.value / 2)),
          ),
          Container(
            width: 120.0,
            height: 120.0,
            alignment: Alignment.center,
            child: Image.asset(
              'images/picture_home_center.png',
              width: 120.0,
              height: 120.0,
              gaplessPlayback: true,
            ),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(RADIUS_START / 2),
            ),
          ),
        ],
      ),
    );
  }
}
