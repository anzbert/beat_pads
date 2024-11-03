import 'package:beat_pads/screen_beat_pads/sliders_theme.dart';
import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SliderVelocity extends ConsumerStatefulWidget {
  const SliderVelocity({
    required this.channel,
    required this.randomVelocity,
    super.key,
  });

  final int channel;
  final bool randomVelocity;

  @override
  ConsumerState<SliderVelocity> createState() => _SliderVelocityState();
}

class _SliderVelocityState extends ConsumerState<SliderVelocity> {
  final double fontSizeFactor = 0.037;
  final double paddingFactor = 0.05;
  final int topAndBottomfield = 2;
  final Color color = Palette.darker(Palette.cadetBlue, 0.6);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: topAndBottomfield,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                'Vel',
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
          if (!widget.randomVelocity)
            Flexible(
              flex: 30,
              child: ThemedSlider(
                height: constraints.maxHeight,
                width: constraints.maxWidth,
                thumbColor: Palette.cadetBlue,
                child: Slider(
                  allowedInteraction: ref.watch(sliderTapAndSlideProv)
                      ? SliderInteraction.tapAndSlide
                      : SliderInteraction.slideThumb,
                  min: 10,
                  max: 127,
                  value: ref
                      .watch(
                        senderProvider.select(
                          (value) => value
                              .playModeHandler.velocityProvider.velocityFixed,
                        ),
                      )
                      .clamp(10, 127)
                      .toDouble(),
                  onChanged: (v) {
                    ref
                        .read(senderProvider.notifier)
                        .playModeHandler
                        .velocityProvider
                        .velocityFixed = v.toInt();
                  },
                  onChangeEnd: (_) {},
                ),
              ),
            ),
          if (widget.randomVelocity)
            Flexible(
              flex: 30,
              child: ThemedSlider(
                height: constraints.maxHeight,
                width: constraints.maxWidth,
                range: ref.watch(
                  senderProvider.select(
                    (value) =>
                        value.playModeHandler.velocityProvider.velocityRange,
                  ),
                ),
                thumbColor: Palette.cadetBlue,
                child: Slider(
                  allowedInteraction: ref.watch(sliderTapAndSlideProv)
                      ? SliderInteraction.tapAndSlide
                      : SliderInteraction.slideThumb,
                  min: 10,
                  max: 127,
                  value: ref
                      .watch(
                        senderProvider.select(
                          (value) => value.playModeHandler.velocityProvider
                              .velocityRandomCenter,
                        ),
                      )
                      .clamp(10, 127),
                  onChanged: (v) {
                    ref
                        .read(senderProvider.notifier)
                        .playModeHandler
                        .velocityProvider
                        .velocityRandomCenter = v;
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
              child: ref.watch(velocityModeProv) == VelocityMode.fixed
                  ? RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text:
                            '${ref.watch(senderProvider.select((value) => value.playModeHandler.velocityProvider.velocityFixed))}',
                        style: TextStyle(
                          fontSize: constraints.maxHeight * fontSizeFactor,
                          color: color,
                        ),
                      ))
                  : RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text:
                            '${ref.watch(senderProvider.select((value) => value.playModeHandler.velocityProvider.velocityRandomCenter)).round()}',
                        style: TextStyle(
                          fontSize: constraints.maxHeight * fontSizeFactor,
                          color: color,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: String.fromCharCode(177), // Plus-Minus Sign
                            style: TextStyle(
                                fontSize:
                                    constraints.maxHeight * fontSizeFactor),
                          ),
                          TextSpan(
                            text:
                                '${ref.watch(senderProvider.select((value) => value.playModeHandler.velocityProvider.velocityRange)) ~/ 2}',
                            style: TextStyle(
                                fontSize: constraints.maxHeight *
                                    fontSizeFactor *
                                    0.7),
                          )
                        ],
                      ),
                    ),
            ),
          ),
        ],
      );
    });
  }
}
