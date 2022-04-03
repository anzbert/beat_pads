import 'package:beat_pads/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command_messages.dart';

class _PitchBenderState extends State<PitchBender> {
  double pitch = 0;

  final Color _trackColor = Palette.darkGrey.color;
  final Color _thumbColor = Palette.cadetBlue.color;

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 1,
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          trackHeight: 40,
          activeTrackColor: _trackColor,
          inactiveTrackColor: _trackColor,
          thumbColor: _thumbColor,
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 40.0),
          trackShape: CustomTrackShape(),
        ),
        child: Slider(
          value: pitch,
          min: -1,
          max: 1,
          onChanged: (value) {
            setState(() {
              pitch = value;
            });
            PitchBendMessage(
              channel: widget.channel,
              bend: -pitch,
            ).send();
          },
          onChangeEnd: (details) {
            setState(() {
              pitch = 0;
            });
            PitchBendMessage(
              channel: widget.channel,
              bend: pitch,
            ).send();
          },
        ),
      ),
    );
  }
}

class PitchBender extends StatefulWidget {
  const PitchBender({Key? key, this.channel = 0}) : super(key: key);

  final int channel;

  @override
  State<PitchBender> createState() => _PitchBenderState();
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
