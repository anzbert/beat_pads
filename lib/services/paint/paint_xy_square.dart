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
    required this.colorDeadZone,
  }) : changeAbsolute = change * maxRadius;

  final Offset origin;
  final double maxRadius;
  final double deadZone;
  final Color colorFront;
  final Color colorBack;
  final Color colorDeadZone;
  final Offset change;

  final Offset changeAbsolute;

  @override
  void paint(Canvas canvas, Size size) {
    // BACK:
    Paint brushRect = Paint()
      ..color = colorBack
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    Rect rect = Rect.fromCircle(center: origin, radius: maxRadius);

    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(12)),
        brushRect); // background

    // FRONT:
    Paint brush = Paint()
      ..color = colorFront
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    Offset originY = origin.translate(changeAbsolute.dx, -maxRadius);
    Offset pointY = ((Offset.fromDirection(pi / 2)) + origin)
        .translate(changeAbsolute.dx, maxRadius);
    canvas.drawLine(originY, pointY, brush); // vertical Y line

    Offset originX = origin.translate(-maxRadius, -changeAbsolute.dy);
    Offset pointX = ((Offset.fromDirection(2 * pi)) + origin)
        .translate(maxRadius, -changeAbsolute.dy);
    canvas.drawLine(originX, pointX, brush); // horizontal X line

    brush.style = PaintingStyle.fill;
    Offset touch = origin.translate(changeAbsolute.dx, -changeAbsolute.dy);
    canvas.drawCircle(touch, 12, brush); // touch tracker

    brush.color = colorDeadZone;
    // if (change.dx.abs() > deadZone || change.dy.abs() > deadZone) {
    canvas.drawCircle(origin, maxRadius * deadZone, brush); // deadzone
    // }
  }

  @override
  bool shouldRepaint(CustomPaintXYSquare oldDelegate) {
    return oldDelegate.change != change ||
        oldDelegate.deadZone != deadZone ||
        oldDelegate.colorDeadZone != colorDeadZone ||
        oldDelegate.maxRadius != maxRadius;
  }
}
