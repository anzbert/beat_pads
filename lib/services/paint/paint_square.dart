import 'package:flutter/material.dart';

class CustomPaintSquare extends CustomPainter {
  const CustomPaintSquare(
    this.o1,
    this.maxRadius,
    this.color,
  );
  final Offset o1;
  final double maxRadius;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint brush = Paint()
      ..color = color
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    Rect rect = Rect.fromCircle(center: o1, radius: maxRadius);

    canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(5)), brush);
  }

  @override
  bool shouldRepaint(CustomPaintSquare oldDelegate) {
    return oldDelegate.o1 != o1 || oldDelegate.color != color;
  }
}
