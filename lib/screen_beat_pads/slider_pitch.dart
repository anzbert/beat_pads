import 'package:beat_pads/screen_beat_pads/sliders_theme.dart';
import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command_messages.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PitchSliderEased extends ConsumerStatefulWidget {
  const PitchSliderEased({
    required this.channel,
    required this.resetTime,
    super.key,
  });

  final int channel;
  final int resetTime;

  @override
  ConsumerState<PitchSliderEased> createState() => _PitchSliderEasedState();
}

class _PitchSliderEasedState extends ConsumerState<PitchSliderEased>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _controller;
  late Animation<double> _curve;

  final double fontSizeFactor = 0.037;
  final double paddingFactor = 0.05;
  final int topAndBottomfield = 2;
  final Color color = Palette.darker(Palette.laserLemon, 0.6);

  double _pitch = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: widget.resetTime),
      vsync: this,
    );
    _curve = CurvedAnimation(parent: _controller, curve: Curves.easeOutExpo);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: topAndBottomfield,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  'Pitch',
                  style: TextStyle(
                    fontSize: constraints.maxHeight * fontSizeFactor,
                    color: color,
                  ),
                ),
              ),
            ),
            Center(
              child: Divider(
                indent: constraints.maxWidth * paddingFactor,
                endIndent: constraints.maxWidth * paddingFactor,
                thickness: constraints.maxWidth * 0.05,
              ),
            ),
            Flexible(
              flex: 30,
              child: ThemedSlider(
                thumbColor: Palette.laserLemon,
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                centerLine: true,
                child: Slider(
                  allowedInteraction: ref.watch(sliderTapAndSlideProv)
                      ? SliderInteraction.tapAndSlide
                      : SliderInteraction.slideThumb,
                  min: -1,
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

                      _controller
                        ..reset()
                        ..forward();
                    } else {
                      setState(() => _pitch = 0);
                      PitchBendMessage(
                        channel: widget.channel,
                      ).send();
                    }
                  },
                  onChangeStart: (_) {
                    _controller.stop();
                  },
                ),
              ),
            ),
            Center(
              child: Divider(
                indent: constraints.maxWidth * paddingFactor,
                endIndent: constraints.maxWidth * paddingFactor,
                thickness: constraints.maxWidth * 0.05,
              ),
            ),
            Flexible(
              flex: topAndBottomfield,
              child: FractionallySizedBox(
                widthFactor: 0.95,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: _pitch == 0 ? '-' : '${(_pitch * 100).round()}',
                    style: TextStyle(
                      fontSize: constraints.maxHeight * fontSizeFactor,
                      color: color,
                    ),
                    children: <TextSpan>[
                      if (_pitch != 0)
                        TextSpan(
                          text: '%',
                          style: TextStyle(
                            fontSize:
                                constraints.maxHeight * fontSizeFactor * 0.6,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    if (_pitch != 0) {
      PitchBendMessage(
        channel: widget.channel,
      ).send();
    }
    super.dispose();
  }
}
