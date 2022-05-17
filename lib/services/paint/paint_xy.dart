import 'dart:math';
import 'package:flutter/material.dart';

class CustomPaintXYSquare extends CustomPainter {
  CustomPaintXYSquare(
    this.origin,
    this.maxRadius,
    this.deadZone,
    this.change,
    this.color,
  );
  // touchEvent.directionalChangeFromCenter(           curve: Curves.linear, deadZone: true) *      touchEvent.maxRadius;
  final Offset origin;
  final double maxRadius;
  final double deadZone;
  final Color color;
  final Offset change;

  @override
  void paint(Canvas canvas, Size size) {
    Paint brush = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    // Y
    Offset originY = origin.translate(change.dx, -maxRadius);
    Offset pointY = ((Offset.fromDirection(pi / 2)) + origin)
        .translate(change.dx, maxRadius);
    canvas.drawLine(originY, pointY, brush);

    // X
    Offset originX = origin.translate(-maxRadius, -change.dy);
    Offset pointX = ((Offset.fromDirection(2 * pi)) + origin)
        .translate(maxRadius, -change.dy);
    canvas.drawLine(originX, pointX, brush);

    // origin
    brush.style = PaintingStyle.fill;
    brush.color = color.withOpacity(0.4);
    canvas.drawCircle(origin, maxRadius * deadZone, brush);

    // touch
    Offset touch = origin.translate(change.dx, -change.dy);
    canvas.drawCircle(touch, 16, brush);
  }

  @override
  bool shouldRepaint(CustomPaintXYSquare oldDelegate) {
    // return true;
    return oldDelegate.change != change;
  }
}
