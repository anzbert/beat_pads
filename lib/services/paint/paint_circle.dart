import 'package:flutter/material.dart';

class CustomPaintCircle extends CustomPainter {
  const CustomPaintCircle(this.o1, this.maxRadius, this.color);
  final Offset o1;
  final Color color;

  final double maxRadius;

  @override
  void paint(Canvas canvas, Size size) {
    Paint brush = Paint()
      ..color = color
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(o1, maxRadius, brush);
  }

  @override
  bool shouldRepaint(CustomPaintCircle oldDelegate) {
    return oldDelegate.o1 != o1 || oldDelegate.color != color;
  }
}
