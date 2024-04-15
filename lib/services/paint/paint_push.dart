import 'package:beat_pads/services/services.dart';
import 'package:beat_pads/theme.dart';
import 'package:flutter/material.dart';

class CustomPaintPushOverlay extends CustomPainter {
  CustomPaintPushOverlay({
    required int pitchDeadzonePercent,
    required this.padBox,
    required this.screenSize,
    required this.originPadBox,
    required this.origin,
    required this.change,
    required this.dirty,
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
  final Offset change;
  final bool dirty;
  final PadBox padBox;
  final PadBox originPadBox;
  final double pitchDeadzoneFraction;
  final double originXPercentage;

  @override
  void paint(Canvas canvas, Size size) {
    const double minLineWidth = 2;
    const Color color = Colors.black26;
    const MaskFilter filter = MaskFilter.blur(BlurStyle.normal, 0.5);

    // final Radius padRadius =
    //     Radius.circular(screenSize.width * ThemeConst.padRadiusFactor);

    // final double padSpacingFraction = padSpacing * 2 / padRect.width;

    final double padSpacing = screenSize.width * ThemeConst.padSpacingFactor;

    final Rect padRect = Rect.fromPoints(
      padBox.padPosition,
      padBox.padPosition + Offset(padBox.padSize.width, padBox.padSize.height),
    );

    // TROUBLESHOOTING
    // draw whole rect:
    // canvas.drawRect(padRect, Paint()..color = Colors.green);

    // origin padbox center to pointer line:
    // canvas.drawLine(
    //     originPadBox.padCenter, change, Paint()..color = Colors.pink);

    // follow pointer:
    // canvas.drawCircle(change, 20, Paint()..Colors.red);

    // VERTICAL LINE (deadzone)
    if (xMod) {
      final double deadzoneLineWidth =
          ((padRect.width - 2 * padSpacing) * pitchDeadzoneFraction);

      final Paint verticaldeadzoneLineStroke = Paint()
        ..style = PaintingStyle.stroke
        ..color = color
        ..maskFilter = filter
        ..strokeWidth =
            deadzoneLineWidth < minLineWidth ? minLineWidth : deadzoneLineWidth
        ..strokeCap = StrokeCap.butt;

      canvas.drawLine(
          padRect.topCenter + Offset(0, padSpacing),
          padRect.bottomCenter - Offset(0, padSpacing),
          verticaldeadzoneLineStroke);
    }

    final Paint centerIndicatorLinesStroke = Paint()
      ..style = PaintingStyle.stroke
      ..color = color
      ..strokeWidth = minLineWidth
      // ..blendMode = BlendMode.darken
      ..maskFilter = filter
      ..strokeCap = StrokeCap.butt;

    if (relativeMode) {
      // horizontal:
      canvas.drawLine(
          Offset(padRect.left + padSpacing, origin.dy),
          Offset(padRect.right - padSpacing, origin.dy),
          centerIndicatorLinesStroke);

      // vertical:
      canvas.drawLine(
          Offset(origin.dx, padRect.top + padSpacing),
          Offset(origin.dx, padRect.bottom - padSpacing),
          centerIndicatorLinesStroke..color);

      // center:
      // canvas.drawCircle(origin, 3, centerIndicatorLinesStroke);
    } else {
      // horizontal:
      canvas.drawLine(
          Offset(padRect.left + padSpacing, padRect.center.dy),
          Offset(padRect.right - padSpacing, padRect.center.dy),
          centerIndicatorLinesStroke);

      // vertical:
      // canvas.drawLine(Offset(padRect.center.dx, padRect.top + padSpacing),
      //     Offset(padRect.center.dx, padRect.bottom - padSpacing), centerIndicatorLinesStroke);

      // center:
      // canvas.drawCircle(padRect.center, 3, centerIndicatorLinesStroke);
    }

    // HORIZONTAL LINE (modulation)
    if (yMod) {
      final Paint yModIndicatorLine = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..color = Colors.black54
        ..strokeCap = StrokeCap.butt;

      canvas.drawLine(Offset(padRect.left, change.dy),
          Offset(padRect.right, change.dy), yModIndicatorLine);
    }
  }

  @override
  bool shouldRepaint(CustomPaintPushOverlay oldDelegate) {
    return oldDelegate.change != change;
  }
}
