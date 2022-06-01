import 'dart:math';
import 'package:beat_pads/services/services.dart';

import 'package:flutter/material.dart';

class ThemedSlider extends StatelessWidget {
  ThemedSlider({
    Key? key,
    required this.child,
    this.centerLine = false,
    required this.thumbColor,
    // this.label = "",
    // this.midiVal = false,
    this.showTrack = false,
    this.range,
  }) : super(key: key);

  final Widget child;
  final bool centerLine;
  // final String label;
  // final bool midiVal;
  final bool showTrack;
  final int? range;

  final Color _trackColor = Palette.lightGrey;
  final Color thumbColor;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return RotatedBox(
      quarterTurns: 3,
      child: FractionallySizedBox(
        widthFactor: 0.9,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (centerLine)
              Container(
                decoration: BoxDecoration(
                  color: Palette.darker(_trackColor, 0.8),
                  borderRadius: BorderRadius.all(
                    Radius.circular(width * 0.01),
                  ),
                ),
                height: double.infinity,
                width: width * 0.015,
              ),
            SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: width * 0.015,
                  activeTrackColor: showTrack ? Palette.cadetBlue : _trackColor,
                  inactiveTrackColor: _trackColor,
                  thumbColor: thumbColor,
                  overlayColor: Colors.transparent,
                  thumbShape: range == null
                      // ? CustomSliderThumbCircle(
                      //     thumbRadius: width * 0.04,
                      //     label: label,
                      //     midiVal: midiVal)
                      ? RoundSliderThumbShape(
                          enabledThumbRadius: width * 0.033,
                        )
                      : CustomSliderThumbRect(
                          thumbRadius: width * 0.07,
                          thumbHeight: range!.toDouble()),
                  trackShape: CustomTrackShape(),
                ),
                child: child),
          ],
        ),
      ),
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  void paint(PaintingContext context, Offset offset,
      {required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required Animation<double> enableAnimation,
      required TextDirection textDirection,
      required Offset thumbCenter,
      bool isDiscrete = false,
      bool isEnabled = false,
      double additionalActiveTrackHeight = 2}) {
    super.paint(context, offset,
        parentBox: parentBox,
        sliderTheme: sliderTheme,
        enableAnimation: enableAnimation,
        textDirection: textDirection,
        thumbCenter: thumbCenter,
        isDiscrete: isDiscrete,
        isEnabled: isEnabled,
        additionalActiveTrackHeight: 0);
  }
}

class CustomSliderThumbCircle extends SliderComponentShape {
  final double thumbRadius;
  final int min;
  final int max;
  final String label;
  final bool midiVal;

  const CustomSliderThumbCircle({
    required this.thumbRadius,
    this.label = "#",
    this.midiVal = false,
    this.min = 0,
    this.max = 10,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
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

    final paint = Paint()
      ..color = sliderTheme.thumbColor! // Thumb Background Color
      ..style = PaintingStyle.fill;

    TextSpan span = TextSpan(
      style: TextStyle(
        fontSize: thumbRadius * .66,
        fontWeight: FontWeight.w700,
        color:
            Palette.lightGrey.withOpacity(0.5), // Text Color of Value on Thumb
      ),
      text: midiVal ? getMidiValue(value) : label,
    );

    TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);
    tp.layout();
    Offset textCenter =
        Offset(center.dx - (tp.width / 2), center.dy - (tp.height / 2));

    canvas.drawCircle(center, thumbRadius * .9, paint);

    canvas.save();
    final pivot = tp.size.center(textCenter);
    canvas.translate(pivot.dx, pivot.dy);
    canvas.rotate(1 * pi / 2);
    canvas.translate(-pivot.dx, -pivot.dy);
    tp.paint(canvas, textCenter);
    canvas.restore();
  }

  String getMidiValue(double value) {
    return (value * 127).toInt().toString();
  }
}

class CustomSliderThumbRect extends SliderComponentShape {
  final double thumbRadius;
  final double thumbHeight;

  const CustomSliderThumbRect({
    required this.thumbRadius,
    this.thumbHeight = 20,
  });

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

    var fractionHeight = parentBox.constraints.maxWidth / 127 * thumbHeight;

    final rRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
          center: center, width: fractionHeight, height: thumbRadius),
      Radius.circular(thumbRadius * .1),
    );

    final paint = Paint()
      ..color = sliderTheme.thumbColor! //Thumb Background Color
      ..style = PaintingStyle.fill;

    canvas.drawRRect(rRect, paint);
  }
}
