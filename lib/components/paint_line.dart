import 'package:flutter/material.dart';

class CustomP extends StatelessWidget {
  const CustomP(this.o1, this.o2);
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
  ..color = Colors.green
  ..strokeWidth = 20
  ..strokeCap = StrokeCap.round
  ..blendMode = BlendMode.difference;

class Painter extends CustomPainter {
  const Painter(this.o1, this.o2);
  final Offset o1;
  final Offset o2;

  @override
  void paint(Canvas canvas, Size size) {
//     print("painting");
    canvas.drawLine(o1, o2, brush);
  }

  @override
  bool shouldRepaint(Painter oldDelegate) {
    return oldDelegate.o1 != o1 || oldDelegate.o2 != o2;
  }
}
