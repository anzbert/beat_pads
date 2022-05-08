import 'dart:math';

import 'package:flutter/material.dart';

class PaintXYLines extends StatelessWidget {
  const PaintXYLines(
      this.o1, this.limitedChange, this.maxRadius, this.deadzone, this.color,
      {this.stroke = true});
  final Offset o1;
  final Offset limitedChange;
  final Color color;
  final bool stroke;
  final double maxRadius;
  final double deadzone;

  @override
  Widget build(context) {
    return CustomPaint(
      painter: Painter(o1, limitedChange, maxRadius, deadzone, color,
          stroke: stroke),
    );
  }
}

class Painter extends CustomPainter {
  const Painter(
      this.o1, this.limitedChange, this.maxRadius, this.deadzone, this.color,
      {this.stroke = true});
  final Offset o1;
  final Offset limitedChange;
  final Color color;
  final bool stroke;
  final double maxRadius;
  final double deadzone;

  @override
  void paint(Canvas canvas, Size size) {
    Paint brush = Paint()
      ..color = color
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    if (stroke) brush.style = PaintingStyle.stroke;

    // Y
    Offset originY = o1.translate(limitedChange.dx, -maxRadius);
    Offset pointY = ((Offset.fromDirection(pi / 2)) + o1)
        .translate(limitedChange.dx, maxRadius);
    canvas.drawLine(originY, pointY, brush);

    // X
    Offset originX = o1.translate(-maxRadius, -limitedChange.dy);
    Offset pointX = ((Offset.fromDirection(2 * pi)) + o1)
        .translate(maxRadius, -limitedChange.dy);
    canvas.drawLine(originX, pointX, brush);

    // origin
    brush.style = PaintingStyle.fill;
    brush.color = color.withOpacity(0.4);
    canvas.drawCircle(o1, maxRadius * deadzone, brush);

    // touch
    Offset touch = o1.translate(limitedChange.dx, -limitedChange.dy);
    canvas.drawCircle(touch, 16, brush);
  }

  @override
  bool shouldRepaint(Painter oldDelegate) {
    return oldDelegate.o1 != o1 || oldDelegate.limitedChange != limitedChange;
  }
}
