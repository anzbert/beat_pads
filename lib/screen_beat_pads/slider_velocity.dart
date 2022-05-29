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
              flex: 5,
              child: FractionallySizedBox(
                widthFactor: 0.9,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double width = MediaQuery.of(context).size.width;
                    double padRadius = width * ThemeConst.padRadiusFactor;
                    final double padSpacing =
                        width * ThemeConst.padSpacingFactor;
                    return Container(
                      margin: EdgeInsets.only(top: padSpacing),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Palette.laserLemon.withAlpha(120),
                          width: 4,
                        ),
                        borderRadius:
                            BorderRadius.all(Radius.circular(padRadius * 1)),
                      ),
                      padding:
                          EdgeInsets.all(constraints.maxWidth * paddingFactor),
                      child: Align(
                        alignment: Alignment.center,
                        child: RichText(
                          text: TextSpan(
                            text: context.read<Settings>().randomVelocity
                                ? "${sender.playMode.velocityProvider.velocityRandomCenter.round()}"
                                : "${sender.playMode.velocityProvider.velocityFixed}",
                            style: DefaultTextStyle.of(context).style.copyWith(
                                  fontSize:
                                      constraints.maxWidth * fontSizeFactor,
                                  color: Palette.laserLemon,
                                ),
                            children: <TextSpan>[
                              if (context.watch<Settings>().randomVelocity)
                                TextSpan(
                                  text:
                                      "\n${String.fromCharCode(177)}${sender.playMode.velocityProvider.velocityRange ~/ 2}",
                                  style: TextStyle(
                                    fontSize: constraints.maxWidth *
                                        fontSizeFactor *
                                        0.6,
                                    fontWeight: FontWeight.w300,
                                    color: Palette.laserLemon.withAlpha(180),
                                  ),
                                ),
                            ],
                          ),
                        ),
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
