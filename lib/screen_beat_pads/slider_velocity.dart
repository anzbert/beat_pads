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
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 3,
      child: Consumer<MidiSender>(
        builder: (context, sender, _) {
          if (!widget.randomVelocity) {
            return ThemedSlider(
              thumbColor: Palette.laserLemon,
              child: Slider(
                min: 10,
                max: 127,
                value: sender.velocityProvider.velocityFixed
                    .clamp(10, 127)
                    .toDouble(),
                onChanged: (v) {
                  sender.velocityProvider.velocityFixed = v.toInt();
                },
              ),
            );
          } else {
            return ThemedSlider(
              range: sender.velocityProvider.velocityRange,
              thumbColor: Palette.laserLemon,
              child: Slider(
                min: 10,
                max: 127,
                value:
                    sender.velocityProvider.velocityRandomCenter.clamp(10, 127),
                onChanged: (v) {
                  sender.velocityProvider.velocityRandomCenter = v;
                },
              ),
            );
          }
        },
      ),
    );
  }
}
