import 'package:beat_pads/services/color_const.dart';
import 'package:flutter/material.dart';

class PaintLine extends StatelessWidget {
  const PaintLine(this.o1, this.o2);
  final Offset o1;
  final Offset o2;

  @override
  Widget build(context) {
    return CustomPaint(
      painter: Painter(o1, o2),
    );
  }
}

final Paint brush = Paint()
  ..color = Palette.lightPink.color
  ..strokeWidth = 16
  ..strokeCap = StrokeCap.round
  ..blendMode = BlendMode.plus;

class Painter extends CustomPainter {
  const Painter(this.o1, this.o2);
  final Offset o1;
  final Offset o2;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(o1, o2, brush);
  }

  @override
  bool shouldRepaint(Painter oldDelegate) {
    return oldDelegate.o1 != o1 || oldDelegate.o2 != o2;
  }
}
