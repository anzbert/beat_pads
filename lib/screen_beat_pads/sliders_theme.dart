import 'package:beat_pads/services/services.dart';

import 'package:flutter/material.dart';

class ThemedSlider extends StatelessWidget {
  ThemedSlider({
    required this.child,
    required this.thumbColor,
    this.centerLine = false,
    this.showTrack = false,
    this.range,
    super.key,
  });

  final Widget child;
  final bool centerLine;

  final bool showTrack;
  final int? range;

  final Color _trackColor = Palette.lightGrey;
  final Color thumbColor;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
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
                    ? RoundSliderThumbShape(
                        enabledThumbRadius: width * 0.033,
                      )
                    : CustomSliderThumbRect(
                        thumbRadius: width * 0.07,
                        thumbHeight: range!.toDouble(),
                      ),
                trackShape: CustomTrackShape(),
              ),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
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
    double additionalActiveTrackHeight = 2,
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
      additionalActiveTrackHeight: 0,
    );
  }
}

class CustomSliderThumbRect extends SliderComponentShape {
  const CustomSliderThumbRect({
    required this.thumbRadius,
    this.thumbHeight = 20,
  });
  final double thumbRadius;
  final double thumbHeight;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      Size.fromRadius(thumbRadius / 2);

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
    final canvas = context.canvas;

    final fractionHeight = parentBox.constraints.maxWidth / 127 * thumbHeight;

    final rRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center,
        width: fractionHeight,
        height: thumbRadius,
      ),
      Radius.circular(thumbRadius * .1),
    );

    final paint = Paint()
      ..color = sliderTheme.thumbColor! //Thumb Background Color
      ..style = PaintingStyle.fill;

    canvas.drawRRect(rRect, paint);
  }
}
