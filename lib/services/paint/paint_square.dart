import 'package:beat_pads/services/touch_buffer.dart';
import 'package:flutter/material.dart';

class CustomPaintSquare extends CustomPainter {
  const CustomPaintSquare(
    this.o1,
    this.touchEvent,
    this.color,
  );
  final Offset o1;
  final TouchEvent touchEvent;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint brush = Paint()
      ..color = color
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    Rect rect = Rect.fromCircle(center: o1, radius: touchEvent.maxRadius);

    canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(5)), brush);
  }

  @override
  bool shouldRepaint(CustomPaintSquare oldDelegate) {
    return oldDelegate.o1 != o1 || oldDelegate.color != color;
  }
}
