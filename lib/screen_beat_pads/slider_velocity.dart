import 'package:beat_pads/screen_beat_pads/slider_themed.dart';
import 'package:beat_pads/services/services.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SliderVelocity extends StatefulWidget {
  const SliderVelocity(
      {Key? key, required this.channel, required this.randomVelocity})
      : super(key: key);

  final int channel;
  final bool randomVelocity;

  @override
  State<SliderVelocity> createState() => _SliderVelocityState();
}

class _SliderVelocityState extends State<SliderVelocity> {
  @override
  void initState() {
    super.initState();
    Provider.of<Settings>(context, listen: false).updateCenter();
  }

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 3,
      child: Consumer<Settings>(
        builder: (context, settings, _) {
          if (!widget.randomVelocity) {
            return ThemedSlider(
              thumbColor: Palette.cadetBlue,
              child: Slider(
                min: 10,
                max: 127,
                value: settings.velocity.clamp(10, 127).toDouble(),
                onChanged: (v) {
                  settings.setVelocity(v.toInt(), save: false);
                },
              ),
            );
          } else {
            return ThemedSlider(
              // showTrack: true,
              range: settings.velocityRange,
              thumbColor: Palette.cadetBlue,
              child: Slider(
                min: 10,
                max: 127,
                value: settings.velocityCenter.clamp(10, 127),
                onChanged: (v) {
                  settings.velocityCenter = v;
                },
              ),
            );
          }
        },
      ),
    );
  }
}
