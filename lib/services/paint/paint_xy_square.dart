import 'dart:math';
import 'package:flutter/material.dart';

class CustomPaintXYSquare extends CustomPainter {
  CustomPaintXYSquare({
    required this.origin,
    required this.maxRadius,
    required this.deadZone,
    required this.change,
    required this.colorBack,
    required this.colorFront,
  });

  final Offset origin;
  final double maxRadius;
  final double deadZone;
  final Color colorFront;
  final Color colorBack;
  final Offset change;

  @override
  void paint(Canvas canvas, Size size) {
    // Background:
    Paint brushRect = Paint()
      ..color = colorBack
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    Rect rect = Rect.fromCircle(center: origin, radius: maxRadius);

    canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(12)), brushRect);

    // Foreground:
    Paint brush = Paint()
      ..color = colorFront
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

    // touch tracker
    Offset touch = origin.translate(change.dx, -change.dy);
    canvas.drawCircle(touch, 12, brush);

    // deadzone
    brush.style = PaintingStyle.fill;
    brush.color = colorFront.withOpacity(0.6);
    canvas.drawCircle(origin, maxRadius * deadZone, brush);
  }

  @override
  bool shouldRepaint(CustomPaintXYSquare oldDelegate) {
    // return true;
    return oldDelegate.change != change ||
        oldDelegate.deadZone != deadZone ||
        oldDelegate.maxRadius != maxRadius;
  }
}
