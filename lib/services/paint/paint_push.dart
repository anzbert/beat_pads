import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';

class CustomPaintLine extends CustomPainter {
  CustomPaintLine({
    required this.padBox,
    required this.origin,
    // required this.maxRadius,
    // required this.deadZone,
    required this.change,
    required this.dirty,
    // required this.radialChange,
    // required this.colorBack,
    required this.colorFront,
    // required this.colorDeadZone,
  });

  final Offset origin;
  // final double maxRadius;
  // final double deadZone;
  // final double radialChange;
  final Color colorFront;
  // final Color colorBack;
  // final Color colorDeadZone;
  final Offset change;
  final bool dirty;
  final PadBox padBox;

  // final Offset changeAbsolute;

  @override
  void paint(Canvas canvas, Size size) {
    // FRONT:
    final Paint brush = Paint()
      ..color = colorFront
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    // final Offset touch =
    //     origin.translate(changeAbsolute.dx, -changeAbsolute.dy);

    canvas.drawLine(origin, change, brush); // deadzone
    canvas.drawRect(
        Rect.fromPoints(
            padBox.padPosition,
            padBox.padPosition
                .translate(padBox.padSize.width, padBox.padSize.height)),
        brush);
  }

  @override
  bool shouldRepaint(CustomPaintLine oldDelegate) {
    return oldDelegate.change != change;
  }
}
