import 'package:beat_pads/services/services.dart';
import 'package:beat_pads/theme.dart';
import 'package:flutter/material.dart';

class CustomPaintPushOverlay extends CustomPainter {
  CustomPaintPushOverlay({
    required this.padBox,
    required this.screenSize,
    required this.originPadBox,
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

  final Size screenSize;
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
  final PadBox originPadBox;

  @override
  void paint(Canvas canvas, Size size) {
    // FRONT:
    final Paint brush = Paint()
      ..color = colorFront
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    final Paint brush2 = Paint()
      ..color = colorFront
      ..style = PaintingStyle.fill
      // ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(originPadBox.padCenter, change, brush); // deadzone

    final Radius padRadius =
        Radius.circular(screenSize.width * ThemeConst.padRadiusFactor);

    Rect rect = Rect.fromPoints(
      padBox.padPosition,
      padBox.padPosition.translate(padBox.padSize.width, padBox.padSize.height),
    );

    canvas.drawRRect(RRect.fromRectAndRadius(rect, padRadius), brush2);
  }

  @override
  bool shouldRepaint(CustomPaintPushOverlay oldDelegate) {
    return oldDelegate.change != change;
  }
}
