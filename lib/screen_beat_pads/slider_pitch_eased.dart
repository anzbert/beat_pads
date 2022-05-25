import 'package:beat_pads/screen_beat_pads/slider_themed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command_messages.dart';
import 'package:beat_pads/services/services.dart';

class PitchSliderEased extends StatefulWidget {
  const PitchSliderEased({
    required this.channel,
    required this.resetTime,
    Key? key,
  }) : super(key: key);

  final int channel;
  final int resetTime;

  @override
  PitchSliderEasedState createState() => PitchSliderEasedState();
}

class PitchSliderEasedState extends State<PitchSliderEased>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _controller;
  late Animation<double> _curve;

  double _pitch = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: Duration(milliseconds: widget.resetTime), vsync: this);
    _curve = CurvedAnimation(parent: _controller, curve: Curves.easeOutExpo);
  }

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 1,
      child: ThemedSlider(
        label: "",
        thumbColor: Palette.tan,
        centerLine: true,
        child: Slider(
          min: -1,
          max: 1,
          value: _pitch,
          onChanged: (val) {
            setState(() => _pitch = val);

            PitchBendMessage(
              channel: widget.channel,
              bend: -_pitch,
            ).send();
          },
          onChangeEnd: (val) {
            if (widget.resetTime > 0) {
              _animation = Tween<double>(begin: val, end: 0).animate(_curve);
              _animation.addListener(() {
                setState(() => _pitch = _animation.value);

                PitchBendMessage(
                  channel: widget.channel,
                  bend: -_pitch,
                ).send();
              });

              _controller.reset();
              _controller.forward();
            } else {
              setState(() => _pitch = 0);
              PitchBendMessage(
                channel: widget.channel,
                bend: 0,
              ).send();
            }
          },
          onChangeStart: (_) {
            _controller.stop();
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    if (_pitch != 0) {
      PitchBendMessage(
        channel: widget.channel,
        bend: 0,
      ).send();
    }
    super.dispose();
  }
}
