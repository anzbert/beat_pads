import 'package:beat_pads/screen_beat_pads/sliders_theme.dart';
import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _IntNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void set(int newState) => state = newState;
}

final _modWheelProvider = NotifierProvider<_IntNotifier, int>(_IntNotifier.new);

class ModWheel extends ConsumerStatefulWidget {
  const ModWheel({required this.channel, required this.preview, super.key});

  final bool preview;
  final int channel;

  @override
  ConsumerState<ModWheel> createState() => _ModWheelState();
}

class _ModWheelState extends ConsumerState<ModWheel> {
  final double fontSizeFactor = 0.27;
  final double paddingFactor = 0.05;
  final int topAndBottomfield = 2;
  final color = Palette.darker(Palette.tan, 0.6);

  @override
  Widget build(BuildContext context) {
    ref.listen(rxMidiStream,
        (AsyncValue<MidiMessagePacket>? _, AsyncValue<MidiMessagePacket> next) {
      // GUARDS:
      if (next.hasError || next.hasValue == false || next.value == null) return;
      if (next.value!.content.length < 2) return; // message too short
      if (next.value!.type != MidiMessageType.cc) return; // not a CC
      if (next.value!.content[0] != CC.modWheel.value) return; // not modw. msg

      // Set slider value in state provider
      final cc = next.value!.content[1];
      if (ref.read(_modWheelProvider) != cc) {
        ref.read(_modWheelProvider.notifier).set(cc);
      }
    });

    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: topAndBottomfield,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                'Mod',
                style: TextStyle(
                  fontSize: constraints.maxWidth * fontSizeFactor,
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
              width: constraints.maxWidth,
              thumbColor: Palette.tan,
              child: RotatedBox(
                quarterTurns: 0,
                child: Slider(
                  allowedInteraction: ref.watch(sliderTapAndSlideProv)
                      ? SliderInteraction.tapAndSlide
                      : SliderInteraction.slideThumb,
                  max: 127,
                  value: ref.watch(_modWheelProvider).toDouble(),
                  onChanged: (v) {
                    ref.read(_modWheelProvider.notifier).set(v.toInt());
                    MidiUtils.sendModWheelMessage(widget.channel, v.toInt());
                  },
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
            flex: topAndBottomfield,
            child: FractionallySizedBox(
              widthFactor: 0.95,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: '${ref.watch(_modWheelProvider)}',
                      style: TextStyle(
                        fontSize: constraints.maxWidth * fontSizeFactor,
                        color: color,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      );
    });
  }
}
