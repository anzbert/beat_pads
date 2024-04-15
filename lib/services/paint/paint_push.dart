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
    required this.yMod,
    required this.xMod,
  }) : pitchDeadzoneFraction = pitchDeadzonePercent / 100;

  final bool yMod;
  final bool xMod;
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
    // final Radius padRadius =
    //     Radius.circular(screenSize.width * ThemeConst.padRadiusFactor);
    // final padSpacingPercentage = padSpacing * 2 / padRect.width;
    final double padSpacing = screenSize.width * ThemeConst.padSpacingFactor;

    final Rect padRect = Rect.fromPoints(
      padBox.padPosition,
      padBox.padPosition + Offset(padBox.padSize.width, padBox.padSize.height),
    );

    // draw whole rect
    // canvas.drawRect(padRect, Paint()..color = Palette.cadetBlue);

    final Paint stroke1 = Paint()
      ..style = PaintingStyle.stroke
      ..color = colorX
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.butt;

    // origin padbox center to pointer line:
    // canvas.drawLine(originPadBox.padCenter, change, stroke1);

    // follow pointer:
    // canvas.drawCircle(change, 20, stroke1);

    // VERTICAL LINE (deadzone)
    if (xMod) {
      canvas.drawLine(
          padRect.topCenter + Offset(0, padSpacing),
          padRect.bottomCenter - Offset(0, padSpacing),
          stroke1
            ..strokeWidth =
                (padRect.width - 2 * padSpacing) * pitchDeadzoneFraction);
    }

    // Draw modulation center
    final Paint fill1 = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.black.withOpacity(0.4);

    final Paint stroke2 = stroke1..strokeWidth = 4;

    if (relativeMode) {
      canvas.drawLine(Offset(padRect.left + padSpacing, origin.dy),
          Offset(padRect.right - padSpacing, origin.dy), fill1);
      canvas.drawLine(Offset(origin.dx, padRect.top + padSpacing),
          Offset(origin.dx, padRect.bottom - padSpacing), stroke1);
      // canvas.drawCircle(origin, 3, fill1);
    } else {
      canvas.drawLine(Offset(padRect.left + padSpacing, padRect.center.dy),
          Offset(padRect.right - padSpacing, padRect.center.dy), fill1);

      // canvas.drawLine(Offset(padRect.center.dx, padRect.top),
      //     Offset(padRect.center.dx, padRect.bottom), stroke3);
      // canvas.drawCircle(padRect.center, 3, fill1);
    }

    // HORIZONTAL LINE (modulation)
    final Paint gradientBrush1 = Paint()
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
    if (yMod) {
      canvas.drawLine(Offset(padRect.left, change.dy),
          Offset(padRect.right, change.dy), gradientBrush1);
    }
  }

  // final Paint stroke3 = Paint()
  //   ..color = Palette.cadetBlue
  //   ..strokeCap = StrokeCap.butt
  //   ..strokeWidth = 4;

  @override
  bool shouldRepaint(CustomPaintPushOverlay oldDelegate) {
    return oldDelegate.change != change;
  }
}
