import 'package:flutter/material.dart';

class PaintCircle extends StatelessWidget {
  const PaintCircle(this.o1, this.radius, this.color, {this.stroke = true});
  final Offset o1;
  final double radius;
  final Color color;
  final bool stroke;

  @override
  Widget build(context) {
    return CustomPaint(
      painter: Painter(o1, radius, color, stroke: stroke),
    );
  }
}

class Painter extends CustomPainter {
  const Painter(this.o1, this.radius, this.color, {this.stroke = true});
  final Offset o1;
  final double radius;
  final Color color;
  final bool stroke;

  @override
  void paint(Canvas canvas, Size size) {
    Paint brush = Paint()
      ..color = color
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    if (stroke) brush.style = PaintingStyle.stroke;

    canvas.drawCircle(o1, radius, brush);

    // origin
    brush.style = PaintingStyle.fill;
    brush.color = color.withOpacity(0.4);
    canvas.drawCircle(o1, 7, brush);
  }

  @override
  bool shouldRepaint(Painter oldDelegate) {
    return oldDelegate.o1 != o1 || oldDelegate.radius != radius;
  }
}
