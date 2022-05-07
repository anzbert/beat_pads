import 'dart:math';

import 'package:beat_pads/services/_services.dart';
import 'package:beat_pads/services/model_variables.dart';
import 'package:beat_pads/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemedSlider extends StatelessWidget {
  ThemedSlider({
    Key? key,
    required this.child,
    this.centerLine = false,
    required this.thumbColor,
    this.label = "#",
    this.midiVal = false,
  }) : super(key: key);

  final Widget child;
  final bool centerLine;
  final String label;
  final bool midiVal;

  final Color _trackColor = Palette.lightGrey.color;
  final Color thumbColor;

  @override
  Widget build(BuildContext context) {
    double width = context.watch<Variables>().padArea.width;

    return FractionallySizedBox(
      widthFactor: 0.8,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (centerLine)
            Container(
              decoration: BoxDecoration(
                color: _trackColor.withAlpha(100),
                borderRadius: BorderRadius.all(
                  Radius.circular(width * 0.010),
                ),
              ),
              height: double.infinity,
              width: width * 0.010,
            ),
          SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: width * 0.015,
                activeTrackColor: _trackColor,
                inactiveTrackColor: _trackColor,
                thumbColor: thumbColor,
                thumbShape: CustomSliderThumbCircle(
                    thumbRadius: width * 0.038, label: label, midiVal: midiVal),
                // RoundSliderThumbShape(
                //   enabledThumbRadius: width * 0.038,
                // ),
                trackShape: CustomTrackShape(),
              ),
              child: child),
        ],
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
      ..color = sliderTheme.thumbColor! //Thumb Background Color
      ..style = PaintingStyle.fill;

    TextSpan span = TextSpan(
      style: TextStyle(
        fontSize: thumbRadius * .66,
        fontWeight: FontWeight.w700,
        color: Palette.darkGrey.color, //Text Color of Value on Thumb
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
    canvas.rotate(3 * pi / 2);
    canvas.translate(-pivot.dx, -pivot.dy);
    tp.paint(canvas, textCenter);
    canvas.restore();
  }

  String getMidiValue(double value) {
    return (127 - value * 127).toInt().toString();
  }
}
