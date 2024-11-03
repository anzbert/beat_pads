import 'package:beat_pads/screen_beat_pads/sliders_theme.dart';
import 'package:beat_pads/services/services.dart';
import 'package:beat_pads/theme.dart';
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
  final double fontSizeFactor = 0.27;
  final double paddingFactor = 0.1;
  final int topAndBottomfield = 2;
  final color = Palette.darker(Palette.cadetBlue, 0.6);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    // final double width = context.findRenderObject()?.parent. ?? 0;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          flex: topAndBottomfield,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Align(
                alignment: Alignment.bottomCenter,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    'Vel',
                    style: TextStyle(
                      fontSize: constraints.maxWidth * fontSizeFactor,
                      color: color,
                    ),
                  ),
                ),
              );
            },
          ),
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
            indent: width * ThemeConst.borderFactor,
            endIndent: width * ThemeConst.borderFactor,
            thickness: width * ThemeConst.borderFactor,
          ),
        ),
        Flexible(
          flex: topAndBottomfield,
          child: FractionallySizedBox(
            widthFactor: 0.95,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return ref.watch(velocityModeProv) == VelocityMode.fixed
                    ? RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text:
                              '${ref.watch(senderProvider.select((value) => value.playModeHandler.velocityProvider.velocityFixed))}',
                          style: TextStyle(
                            fontSize: constraints.maxWidth * fontSizeFactor,
                            color: color,
                          ),
                        ))
                    : RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text:
                              '${ref.watch(senderProvider.select((value) => value.playModeHandler.velocityProvider.velocityRandomCenter)).round()}',
                          style: TextStyle(
                            fontSize: constraints.maxWidth * fontSizeFactor,
                            color: color,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: String.fromCharCode(177), // Plus-Minus Sign
                              style: TextStyle(
                                  fontSize:
                                      constraints.maxWidth * fontSizeFactor),
                            ),
                            TextSpan(
                              text:
                                  '${ref.watch(senderProvider.select((value) => value.playModeHandler.velocityProvider.velocityRange)) ~/ 2}',
                              style: TextStyle(
                                  fontSize: constraints.maxWidth *
                                      fontSizeFactor *
                                      0.7),
                            )
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
