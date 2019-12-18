import 'package:flutter/material.dart';

class Battery extends StatelessWidget {
  static const double WIDTH = 28.0;
  static const double HEIGHT = 13.0;
  static const double FRAME_WIDTH = 1.8;
  static const double GAP_WIDTH = 2.2;

  final int percent;

  Battery({
    Key key,
    @required this.percent,
  }) : super(key: key);

  Widget build(BuildContext context) {
    double totalLeftWidth = WIDTH - 2 * (FRAME_WIDTH + GAP_WIDTH);
    double powerWidth = percent * totalLeftWidth / 100;
    return Container(
      width: WIDTH,
      height: HEIGHT,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: FRAME_WIDTH,
        ),
        borderRadius: BorderRadius.circular(HEIGHT / 2),
      ),
      child: Container(
        width: WIDTH - 2 * FRAME_WIDTH,
        height: HEIGHT - 2 * FRAME_WIDTH,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.transparent,
            width: GAP_WIDTH,
          ),
          borderRadius: BorderRadius.circular(HEIGHT / 2 - FRAME_WIDTH),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: powerWidth,
              //color: Colors.white,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(HEIGHT / 2 - FRAME_WIDTH - GAP_WIDTH),
              ),
            ),
            Container(
              width: totalLeftWidth - powerWidth,
              color: Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
