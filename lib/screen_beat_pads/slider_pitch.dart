import 'package:beat_pads/screen_beat_pads/slider_themed.dart';
import 'package:beat_pads/theme.dart';
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

  final double fontSizeFactor = 0.3;
  final double paddingFactor = 0.1;

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
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          flex: 30,
          child: ThemedSlider(
            label: "P",
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
                  bend: _pitch,
                ).send();
              },
              onChangeEnd: (val) {
                if (widget.resetTime > 0) {
                  _animation =
                      Tween<double>(begin: val, end: 0).animate(_curve);
                  _animation.addListener(() {
                    setState(() => _pitch = _animation.value);

                    PitchBendMessage(
                      channel: widget.channel,
                      bend: _pitch,
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
        ),
        Flexible(
          flex: 5,
          child: FractionallySizedBox(
            widthFactor: 0.9,
            child: LayoutBuilder(
              builder: (context, constraints) {
                double width = MediaQuery.of(context).size.width;
                double padRadius = width * ThemeConst.padRadiusFactor;
                final double padSpacing = width * ThemeConst.padSpacingFactor;
                return Container(
                  margin: EdgeInsets.symmetric(vertical: padSpacing),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Palette.tan.withAlpha(120),
                      width: width * ThemeConst.borderFactor,
                    ),
                    borderRadius:
                        BorderRadius.all(Radius.circular(padRadius * 1)),
                  ),
                  padding: EdgeInsets.all(constraints.maxWidth * paddingFactor),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            "${(_pitch * 12).round()}",
                            style: TextStyle(
                              fontSize: constraints.maxWidth * fontSizeFactor,
                              // fontWeight: FontWeight.w800,
                              color: Palette.tan,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
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
