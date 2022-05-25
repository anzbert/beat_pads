import 'package:flutter/material.dart';

class CustomPaintRadius extends CustomPainter {
  CustomPaintRadius({
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
  final Color colorBack;
  final Color colorFront;
  final Color colorDeadZone;
  final double change;
  final double changeAbsolute;

  @override
  void paint(Canvas canvas, Size size) {
    // BACK
    Paint brushBack = Paint()
      ..color = colorBack
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(origin, maxRadius, brushBack); // background

    // FRONT
    Paint brush = Paint()
      ..color = colorFront
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(origin, changeAbsolute, brush); // radius

    brush.style = PaintingStyle.fill;
    brush.color = colorDeadZone;
    if (change > deadZone) {
      canvas.drawCircle(origin, maxRadius * deadZone, brush); // deadZone
    }
  }

  @override
  bool shouldRepaint(CustomPaintRadius oldDelegate) {
    return oldDelegate.change != change ||
        oldDelegate.deadZone != deadZone ||
        oldDelegate.colorDeadZone != colorDeadZone ||
        oldDelegate.maxRadius != maxRadius;
  }
}
