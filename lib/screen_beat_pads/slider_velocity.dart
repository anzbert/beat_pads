import 'package:beat_pads/screen_beat_pads/slider_themed.dart';
import 'package:beat_pads/services/services.dart';
import 'package:beat_pads/theme.dart';

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
  final double fontSizeFactor = 0.3;
  final double paddingFactor = 0.1;

  @override
  Widget build(BuildContext context) {
    return Consumer<MidiSender>(
      builder: (context, sender, _) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              flex: 4,
              child: FractionallySizedBox(
                widthFactor: 0.9,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double width = MediaQuery.of(context).size.width;
                    double padRadius = width * ThemeConst.padRadiusFactor;
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Palette.laserLemon.withAlpha(120),
                          width: 2,
                        ),
                        borderRadius:
                            BorderRadius.all(Radius.circular(padRadius * 1)),
                      ),
                      padding:
                          EdgeInsets.all(constraints.maxWidth * paddingFactor),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                context.read<Settings>().randomVelocity
                                    ? "${sender.playMode.velocityProvider.velocityRandomCenter.round()}"
                                    : "${sender.playMode.velocityProvider.velocityFixed}",
                                style: TextStyle(
                                  fontSize:
                                      constraints.maxWidth * fontSizeFactor,
                                  fontWeight: FontWeight.w800,
                                  color: Palette.laserLemon,
                                ),
                              ),
                            ),
                          ),
                          if (context.watch<Settings>().randomVelocity)
                            Expanded(
                              child: Text(
                                "${String.fromCharCode(177)}${sender.playMode.velocityProvider.velocityRange ~/ 2}"
                                    .toString(),
                                style: TextStyle(
                                  fontSize: constraints.maxWidth *
                                      fontSizeFactor *
                                      0.8,
                                  fontWeight: FontWeight.w300,
                                  color: Palette.laserLemon.withAlpha(180),
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
            if (!widget.randomVelocity)
              Flexible(
                flex: 30,
                child: ThemedSlider(
                  label: "V",
                  thumbColor: Palette.laserLemon,
                  child: Slider(
                    min: 10,
                    max: 127,
                    value: sender.playMode.velocityProvider.velocityFixed
                        .clamp(10, 127)
                        .toDouble(),
                    onChanged: (v) {
                      sender.playMode.velocityProvider.velocityFixed =
                          v.toInt();
                    },
                  ),
                ),
              ),
            if (widget.randomVelocity)
              Flexible(
                flex: 30,
                child: ThemedSlider(
                  range: sender.playMode.velocityProvider.velocityRange,
                  thumbColor: Palette.laserLemon,
                  child: Slider(
                    min: 10,
                    max: 127,
                    value: sender.playMode.velocityProvider.velocityRandomCenter
                        .clamp(10, 127),
                    onChanged: (v) {
                      sender.playMode.velocityProvider.velocityRandomCenter = v;
                    },
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
