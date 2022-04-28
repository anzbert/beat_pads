import 'package:beat_pads/shared/colors.dart';
import 'package:flutter/material.dart';

class ThemedSlider extends StatelessWidget {
  ThemedSlider({Key? key, required this.child, this.centerLine = false})
      : super(key: key);

  final Widget child;
  final bool centerLine;

  final Color _trackColor = Palette.lightGrey.color;
  final Color _thumbColor = Palette.yellowGreen.color;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Stack(
      alignment: Alignment.center,
      children: [
        if (centerLine)
          Container(
            decoration: BoxDecoration(
              color: _trackColor,
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
              thumbColor: _thumbColor,
              thumbShape: RoundSliderThumbShape(
                enabledThumbRadius: width * 0.038,
              ),
              trackShape: CustomTrackShape(),
            ),
            child: child),
      ],
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
