import 'dart:math';

import 'package:beat_pads/services/gen_utils.dart';
import 'package:flutter/material.dart';

class PaintXYLines extends StatelessWidget {
  const PaintXYLines(this.o1, this.position, this.maxRadius, this.color,
      {this.stroke = true});
  final Offset o1;
  final Offset position;
  final Color color;
  final bool stroke;
  final double maxRadius;

  @override
  Widget build(context) {
    return CustomPaint(
      painter: Painter(o1, position, maxRadius, color, stroke: stroke),
    );
  }
}

class Painter extends CustomPainter {
  const Painter(this.o1, this.position, this.maxRadius, this.color,
      {this.stroke = true});
  final Offset o1;
  final Offset position;
  final Color color;
  final bool stroke;
  final double maxRadius;

  @override
  void paint(Canvas canvas, Size size) {
    Paint brush = Paint()
      ..color = color
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    if (stroke) brush.style = PaintingStyle.stroke;

    // Y
    Offset originY = o1.translate(position.dx, -maxRadius);
    Offset pointY =
        ((Offset.fromDirection(pi / 2)) + o1).translate(position.dx, maxRadius);
    canvas.drawLine(originY, pointY, brush);

    // X
    Offset originX = o1.translate(-maxRadius, -position.dy);
    Offset pointX = ((Offset.fromDirection(2 * pi)) + o1)
        .translate(maxRadius, -position.dy);
    canvas.drawLine(originX, pointX, brush);

    // origin
    brush.style = PaintingStyle.fill;
    brush.color = color.withOpacity(0.4);
    canvas.drawCircle(o1, 10, brush);
  }

  @override
  bool shouldRepaint(Painter oldDelegate) {
    return oldDelegate.o1 != o1 || oldDelegate.position != position;
  }
}
