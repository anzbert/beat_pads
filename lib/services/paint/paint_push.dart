import 'package:beat_pads/services/services.dart';
import 'package:beat_pads/theme.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class CustomPaintPushOverlay extends CustomPainter {
  CustomPaintPushOverlay({
    required int pitchDeadzonePercent,
    required this.padBox,
    required this.screenSize,
    required this.originPadBox,
    required this.origin,
    required this.change,
    required this.dirty,
    required this.colorX,
    required this.colorY,
  }) : halfPitchDeadzoneFraction = pitchDeadzonePercent / 100 / 2;

  final Size screenSize;
  final Offset origin;
  final Color colorX;
  final Color colorY;
  final Offset change;
  final bool dirty;
  final PadBox padBox;
  final PadBox originPadBox;
  final double halfPitchDeadzoneFraction;

  @override
  void paint(Canvas canvas, Size size) {
    final Radius padRadius =
        Radius.circular(screenSize.width * ThemeConst.padRadiusFactor);

    final Rect padRect = Rect.fromPoints(
      padBox.padPosition,
      padBox.padPosition.translate(padBox.padSize.width, padBox.padSize.height),
    );

    // origin to pointer line:
    // final Paint stroke1 = Paint()
    //   ..color = colorFront.withOpacity(0.3)
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 10
    //   ..strokeCap = StrokeCap.round;
    // canvas.drawLine(originPadBox.padCenter, change, stroke1);

    // VERTICAL LINE
    const double deadzoneBorder = 0.01;
    const double deadZoneOpacityBorder = 0.2;

    final Paint gradient = Paint()
      ..shader = ui.Gradient.linear(
        padRect.centerRight,
        padRect.centerLeft,
        [
          colorX.withOpacity(0),
          colorX.withOpacity(1 - deadZoneOpacityBorder),
          colorX,
          colorX,
          colorX.withOpacity(1 - deadZoneOpacityBorder),
          colorX.withOpacity(0),
        ],
        [
          0,
          0.5 - halfPitchDeadzoneFraction - deadzoneBorder,
          0.5 - halfPitchDeadzoneFraction,
          0.5 + halfPitchDeadzoneFraction,
          0.5 + halfPitchDeadzoneFraction + deadzoneBorder,
          1
        ],
      );
    canvas.drawRRect(RRect.fromRectAndRadius(padRect, padRadius), gradient);

    // HORIZONTAL LINE
    final Paint brush1 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..shader = ui.Gradient.linear(
        padRect.centerLeft,
        padRect.centerRight,
        [
          colorY.withOpacity(0),
          colorY.withOpacity(0.9),
          colorY,
          colorY.withOpacity(0.9),
          colorY.withOpacity(0),
        ],
        [0, 0.1, 0.5, 0.9, 1],
      );
    canvas.drawLine(Offset(padRect.left, change.dy),
        Offset(padRect.right, change.dy), brush1);
  }

  @override
  bool shouldRepaint(CustomPaintPushOverlay oldDelegate) {
    return oldDelegate.change != change;
  }
}
