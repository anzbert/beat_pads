import 'dart:math' as math;

import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';

class ThemedSlider extends StatelessWidget {
  ThemedSlider({
    required this.child,
    required this.thumbColor,
    required this.width,
    required this.height,
    super.key,
    this.centerLine = false,
    this.showTrack = false,
    this.range,
  });

  final Widget child;
  final bool centerLine;

  final bool showTrack;
  final int? range;

  final Color _trackColor = Palette.lightGrey;
  final Color thumbColor;

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 3,
      child: FractionallySizedBox(
        widthFactor: 0.9,
        child: SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: width * 0.08,
            activeTrackColor: showTrack ? Palette.cadetBlue : _trackColor,
            inactiveTrackColor: _trackColor,
            thumbColor: thumbColor,
            overlayColor: Colors.transparent,
            thumbShape: range == null
                ? RoundSliderThumbShape(
                    elevation: 3,
                    enabledThumbRadius: width * 0.4,
                  )
                : CustomSliderThumbRect(
                    enabledThumbRadius: width * 0.4,
                    thumbRadius: width * 0.8,
                    thumbHeight: range!.toDouble(),
                  ),
            trackShape: CustomTrackShape(
              centerLine: centerLine,
              lineWidth: width * 0.05,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class CustomTrackShape extends RectangularSliderTrackShape {
  CustomTrackShape({this.centerLine = false, this.lineWidth = 10});

  final bool centerLine;
  final double lineWidth;

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
    // double additionalActiveTrackHeight = 2,
  }) {
    super.paint(
      context,
      offset,
      parentBox: parentBox,
      sliderTheme: sliderTheme,
      enableAnimation: enableAnimation,
      textDirection: textDirection,
      thumbCenter: thumbCenter,
      isDiscrete: isDiscrete,
      isEnabled: isEnabled,
      // additionalActiveTrackHeight: 0,
    );

    if (centerLine) {
      final paint = Paint()
        ..strokeWidth = lineWidth
        // ..strokeCap = StrokeCap.round
        ..color = Palette.menuHeaders;

      final double thumbWidth =
          sliderTheme.thumbShape!.getPreferredSize(isEnabled, isDiscrete).width;
      final double overlayWidth = sliderTheme.overlayShape!
          .getPreferredSize(isEnabled, isDiscrete)
          .width;

      final double trackLeft =
          offset.dx + math.max(overlayWidth / 2, thumbWidth / 2);
      final double trackRight =
          trackLeft + parentBox.size.width - math.max(thumbWidth, overlayWidth);

      final center = (trackRight + trackLeft) / 2;
      final topCenter = (center + trackRight) / 2;
      final bottomCenter = (center + trackLeft) / 2;

      const double padding = 3;

      context.canvas.drawLine(
        Offset(bottomCenter, padding),
        Offset(bottomCenter, parentBox.size.height - padding),
        paint,
      );
      context.canvas.drawLine(
        Offset(topCenter, padding),
        Offset(topCenter, parentBox.size.height - padding),
        paint,
      );
      context.canvas.drawLine(
        Offset(center, padding),
        Offset(center, parentBox.size.height - padding),
        paint,
      );
      context.canvas.drawLine(
        Offset(trackLeft, padding),
        Offset(trackLeft, parentBox.size.height - padding),
        paint,
      );
      context.canvas.drawLine(
        Offset(trackRight, padding),
        Offset(trackRight, parentBox.size.height - padding),
        paint,
      );
    }
    super.paint(
      context,
      offset,
      parentBox: parentBox,
      sliderTheme: sliderTheme,
      enableAnimation: enableAnimation,
      textDirection: textDirection,
      thumbCenter: thumbCenter,
      isDiscrete: isDiscrete,
      isEnabled: isEnabled,
      // additionalActiveTrackHeight: 0,
    );
  }
}

class CustomSliderThumbRect extends SliderComponentShape {
  const CustomSliderThumbRect({
    required this.thumbRadius,
    required this.enabledThumbRadius,
    this.thumbHeight = 20,
  });
  final double thumbRadius;
  final double enabledThumbRadius;
  final double thumbHeight;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius / 2);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    // Circle with Shadow
    final thumbCirclePath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: enabledThumbRadius));
    canvas
      ..drawShadow(thumbCirclePath, Colors.black, 3, true)
      ..drawPath(thumbCirclePath, Paint()..color = sliderTheme.thumbColor!);

    // Rectangle
    final fractionHeight = parentBox.constraints.maxWidth / 127 * thumbHeight;

    final rRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center,
        width: fractionHeight,
        height: thumbRadius,
      ),
      Radius.circular(thumbRadius * .1),
    );

    final rectPaint = Paint()
      ..color =
          sliderTheme.thumbColor!.withOpacity(0.5) // Thumb Background Color
      ..style = PaintingStyle.fill;

    canvas.drawRRect(rRect, rectPaint);
  }
}
