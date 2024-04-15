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
    required this.relativeMode,
    required this.originXPercentage,
  }) : pitchDeadzoneFraction = pitchDeadzonePercent / 100;

  final bool relativeMode;
  final Size screenSize;
  final Offset origin;
  final Color colorX;
  final Color colorY;
  final Offset change;
  final bool dirty;
  final PadBox padBox;
  final PadBox originPadBox;
  final double pitchDeadzoneFraction;
  final double originXPercentage;

  @override
  void paint(Canvas canvas, Size size) {
    final Radius padRadius =
        Radius.circular(screenSize.width * ThemeConst.padRadiusFactor);

    final double padSpacing = screenSize.width * ThemeConst.padSpacingFactor;

    // final Rect padRectPadded = Rect.fromPoints(
    //   padBox.padPosition + Offset(padSpacing, padSpacing),
    //   padBox.padPosition
    //           .translate(padBox.padSize.width, padBox.padSize.height) -
    //       Offset(padSpacing, padSpacing),
    // );
    final Rect padRect = Rect.fromPoints(
      padBox.padPosition,
      padBox.padPosition + Offset(padBox.padSize.width, padBox.padSize.height),
    );
    final padSpacingPercentage = padSpacing * 2 / padRect.width;

    // canvas.drawRect(padRect, Paint()..color = Palette.cadetBlue);

    // origin to pointer line:
    final Paint stroke1 = Paint()
      ..color = colorX
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.butt;
    // canvas.drawLine(originPadBox.padCenter, change, stroke1);

    // VERTICAL LINE
    if (relativeMode) {
      canvas.drawLine(
          Offset(origin.dx, padRect.top + padSpacing),
          Offset(origin.dx, padRect.bottom - padSpacing),
          stroke1
            ..strokeWidth =
                (padRect.width - 2 * padSpacing) * pitchDeadzoneFraction);
    } else {
      canvas.drawLine(
          padRect.topCenter + Offset(0, padSpacing),
          padRect.bottomCenter - Offset(0, padSpacing),
          stroke1
            ..strokeWidth =
                (padRect.width - 2 * padSpacing) * pitchDeadzoneFraction);
    }

    // HORIZONTAL LINE
    final Paint stroke2 = Paint()
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
    // final Paint brush2 = Paint();
    canvas.drawLine(Offset(padRect.left, change.dy),
        Offset(padRect.right, change.dy), stroke2);

    // Center
    final Paint stroke3 = Paint()
      ..style = PaintingStyle.fill
      ..color = Palette.cadetBlue;
    if (relativeMode) {
      canvas.drawCircle(origin, 10, stroke3);
    } else {
      canvas.drawCircle(padRect.center, 10, stroke3);
    }
  }

  @override
  bool shouldRepaint(CustomPaintPushOverlay oldDelegate) {
    return oldDelegate.change != change;
  }
}
