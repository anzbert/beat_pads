import 'package:flutter/material.dart';

class CustomPaintRadius extends CustomPainter {
  CustomPaintRadius(
    this.origin,
    this.maxRadius,
    this.deadZone,
    this.change,
    this.color,
  );
  // : change = touchEvent.radialChange(curve: Curves.linear) *
  //           touchEvent.maxRadius;
  final Offset origin;
  final double maxRadius;
  final double deadZone;
  final Color color;
  final double change;

  @override
  void paint(Canvas canvas, Size size) {
    Paint brush = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    // radius
    canvas.drawCircle(origin, change, brush);

    // deadZone
    brush.style = PaintingStyle.fill;
    brush.color = color.withOpacity(0.4);
    canvas.drawCircle(origin, maxRadius * deadZone, brush);
  }

  @override
  bool shouldRepaint(CustomPaintRadius oldDelegate) {
    return oldDelegate.change != change;
  }
}
