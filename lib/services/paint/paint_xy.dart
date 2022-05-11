import 'dart:math';
import 'package:beat_pads/services/touch_buffer.dart';
import 'package:flutter/material.dart';

class CustomPaintXYSquare extends CustomPainter {
  CustomPaintXYSquare(this.origin, this.touchEvent, this.color,
      {this.stroke = true})
      : change = touchEvent.directionalChangeFromCenter(
                curve: Curves.linear, deadZone: true) *
            touchEvent.maxRadius;
  final Offset origin;
  final TouchEvent touchEvent;
  final Color color;
  final bool stroke;
  final Offset change;

  @override
  void paint(Canvas canvas, Size size) {
    Paint brush = Paint()
      ..color = color
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    if (stroke) brush.style = PaintingStyle.stroke;

    // Y
    Offset originY = origin.translate(change.dx, -touchEvent.maxRadius);
    Offset pointY = ((Offset.fromDirection(pi / 2)) + origin)
        .translate(change.dx, touchEvent.maxRadius);
    canvas.drawLine(originY, pointY, brush);

    // X
    Offset originX = origin.translate(-touchEvent.maxRadius, -change.dy);
    Offset pointX = ((Offset.fromDirection(2 * pi)) + origin)
        .translate(touchEvent.maxRadius, -change.dy);
    canvas.drawLine(originX, pointX, brush);

    // origin
    brush.style = PaintingStyle.fill;
    brush.color = color.withOpacity(0.4);
    canvas.drawCircle(
        origin, touchEvent.maxRadius * touchEvent.deadZone, brush);

    // touch
    Offset touch = origin.translate(change.dx, -change.dy);
    canvas.drawCircle(touch, 16, brush);
  }

  @override
  bool shouldRepaint(CustomPaintXYSquare oldDelegate) {
    // return true;
    return oldDelegate.touchEvent.newPosition != touchEvent.newPosition ||
        oldDelegate.change != change;
  }
}
