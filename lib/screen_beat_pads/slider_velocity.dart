import 'package:beat_pads/main.dart';
import 'package:beat_pads/screen_beat_pads/_screen_beat_pads.dart';
import 'package:beat_pads/screen_beat_pads/slider_themed.dart';
import 'package:beat_pads/services/services.dart';
import 'package:beat_pads/theme.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SliderVelocity extends ConsumerStatefulWidget {
  const SliderVelocity(
      {Key? key, required this.channel, required this.randomVelocity})
      : super(key: key);

  final int channel;
  final bool randomVelocity;

  @override
  ConsumerState<SliderVelocity> createState() => _SliderVelocityState();
}

class _SliderVelocityState extends ConsumerState<SliderVelocity> {
  final double fontSizeFactor = 0.3;
  final double paddingFactor = 0.1;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.longestSide;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          flex: 5,
          child: LayoutBuilder(builder: (context, constraints) {
            return Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                "Vel",
                style: TextStyle(
                  fontSize: constraints.maxWidth * fontSizeFactor,
                  color: Palette.darker(Palette.cadetBlue, 0.6),
                ),
              ),
            );
          }),
        ),
        Center(
          child: Divider(
            indent: width * ThemeConst.borderFactor,
            endIndent: width * ThemeConst.borderFactor,
            thickness: width * ThemeConst.borderFactor,
          ),
        ),
        if (!widget.randomVelocity)
          Flexible(
            flex: 30,
            child: ThemedSlider(
              thumbColor: Palette.cadetBlue,
              child: Slider(
                min: 10,
                max: 127,
                value: ref
                    .watch(senderProvider.select((value) =>
                        value.playMode.velocityProvider.velocityFixed))
                    .clamp(10, 127)
                    .toDouble(),
                onChanged: (v) {
                  ref
                      .read(senderProvider.notifier)
                      .playMode
                      .velocityProvider
                      .velocityFixed = v.toInt();
                },
              ),
            ),
          ),
        if (widget.randomVelocity)
          Flexible(
            flex: 30,
            child: ThemedSlider(
              range: ref.watch(senderProvider.select(
                  (value) => value.playMode.velocityProvider.velocityRange)),
              thumbColor: Palette.cadetBlue,
              child: Slider(
                min: 10,
                max: 127,
                value: ref
                    .watch(senderProvider.select((value) =>
                        value.playMode.velocityProvider.velocityRandomCenter))
                    .clamp(10, 127),
                onChanged: (v) {
                  ref
                      .read(senderProvider.notifier)
                      .playMode
                      .velocityProvider
                      .velocityRandomCenter = v;
                },
              ),
            ),
          ),
        Center(
          child: Divider(
            indent: width * ThemeConst.borderFactor,
            endIndent: width * ThemeConst.borderFactor,
            thickness: width * ThemeConst.borderFactor,
          ),
        ),
        Flexible(
          flex: 5,
          child: FractionallySizedBox(
            widthFactor: 0.95,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double padSpacing = width * ThemeConst.padSpacingFactor;
                return Container(
                  margin: EdgeInsets.only(bottom: padSpacing),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        flex: 2,
                        child: Text(
                            ref.watch(settingsProvider
                                    .select((value) => value.randomVelocity))
                                ? "${ref.watch(senderProvider.select((value) => value.playMode.velocityProvider.velocityRandomCenter)).round()}"
                                : "${ref.watch(senderProvider.select((value) => value.playMode.velocityProvider.velocityFixed))}",
                            style: DefaultTextStyle.of(context).style.copyWith(
                                  fontSize:
                                      constraints.maxWidth * fontSizeFactor,
                                  color: Palette.darker(Palette.cadetBlue, 0.6),
                                )),
                      ),
                      Flexible(
                        flex: 1,
                        child: ref.watch(settingsProvider
                                .select((value) => value.randomVelocity))
                            ? Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "${String.fromCharCode(177)}${ref.watch(senderProvider.select((value) => value.playMode.velocityProvider.velocityRange)) ~/ 2}",
                                  style: TextStyle(
                                    fontSize: constraints.maxWidth *
                                        fontSizeFactor *
                                        0.6,
                                    fontWeight: FontWeight.w300,
                                    color:
                                        Palette.darker(Palette.cadetBlue, 0.6),
                                  ),
                                ),
                              )
                            : const SizedBox.expand(),
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
}
