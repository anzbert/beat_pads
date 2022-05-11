import 'package:beat_pads/services/touch_buffer.dart';
import 'package:flutter/material.dart';

class CustomPaintRadius extends CustomPainter {
  CustomPaintRadius(this.origin, this.touchEvent, this.color,
      {this.stroke = true})
      : change = touchEvent.radialChange(curve: Curves.linear) *
            touchEvent.maxRadius;
  final Offset origin;
  final TouchEvent touchEvent;
  final Color color;
  final bool stroke;
  final double change;

  @override
  void paint(Canvas canvas, Size size) {
    Paint brush = Paint()
      ..color = color
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    if (stroke) brush.style = PaintingStyle.stroke;

    canvas.drawCircle(origin, change, brush);

    // deadZone
    brush.style = PaintingStyle.fill;
    brush.color = color.withOpacity(0.4);
    canvas.drawCircle(
        origin, touchEvent.maxRadius * touchEvent.deadZone, brush);
  }

  @override
  bool shouldRepaint(CustomPaintRadius oldDelegate) {
    return oldDelegate.touchEvent.newPosition != touchEvent.newPosition ||
        oldDelegate.change != change;
  }
}
