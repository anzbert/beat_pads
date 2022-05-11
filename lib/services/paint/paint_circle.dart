import 'package:beat_pads/services/touch_buffer.dart';
import 'package:flutter/material.dart';

class CustomPaintCircle extends CustomPainter {
  const CustomPaintCircle(this.o1, this.touchEvent, this.color);
  final Offset o1;
  final Color color;

  final TouchEvent touchEvent;

  @override
  void paint(Canvas canvas, Size size) {
    Paint brush = Paint()
      ..color = color
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(o1, touchEvent.maxRadius, brush);
  }

  @override
  bool shouldRepaint(CustomPaintCircle oldDelegate) {
    return oldDelegate.o1 != o1 || oldDelegate.color != color;
  }
}
