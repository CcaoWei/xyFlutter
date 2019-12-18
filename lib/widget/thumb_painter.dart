import 'package:flutter/painting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

import 'dart:math' as math;

const double _kDefaultIndicatorRadius = 10.0;
const double _kTwoPI = math.pi * 2.0;
const int _kTickCount = 12;
const int _kHalfTickCount = _kTickCount ~/ 2;
const Color _kTickColor = CupertinoColors.lightBackgroundGray;
const Color _kActiveTickColor = const Color(0xFF000000);

class ThumbPainter {
  ThumbPainter({
    this.color = CupertinoColors.white,
    this.shadowColor = const Color(0x2C000000),
  })  : _shadowPaint = BoxShadow(
          color: shadowColor,
          blurRadius: 1.0,
        ).toPaint(),
        tickFundamentalRRect = RRect.fromLTRBXY(
            -indicatorRadius,
            1.0 * indicatorRadius / _kDefaultIndicatorRadius,
            -indicatorRadius / 2.0,
            -1.0 * indicatorRadius / _kDefaultIndicatorRadius,
            1.0,
            1.0);

  final Color color;
  final Color shadowColor;
  final Paint _shadowPaint;

  static const double indicatorRadius = 8.0;

  static const double radius = 11.0;
  static const double extension = 5.5;

  void paintThumb(Canvas canvas, Rect rect) {
    final RRect rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(rect.shortestSide / 2.0),
    );
    canvas.drawRRect(rrect, _shadowPaint);
    canvas.drawRRect(rrect.shift(const Offset(0.0, 3.0)), _shadowPaint);
    canvas.drawRRect(rrect, Paint()..color = color);
  }

  final RRect tickFundamentalRRect;
  Animation<double> position;

  bool _showIndicator = false;
  set showIndicator(bool value) {
    _showIndicator = value;
  }

  final Paint paint = Paint();

  void paintIndicatoer(Canvas canvas, Offset offset) {
    canvas.save();
    canvas.translate(offset.dx, offset.dy);

    final int activeTick = (_kTickCount * position.value).floor();

    for (int i = 0; i < _kTickCount; ++i) {
      final double t =
          (((i + activeTick) % _kTickCount) / _kHalfTickCount).clamp(0.0, 1.0);
      paint.color = Color.lerp(_kActiveTickColor, _kTickColor, t);
      canvas.drawRRect(tickFundamentalRRect, paint);
      canvas.rotate(-_kTwoPI / _kTickCount);
    }

    canvas.restore();
  }
}
