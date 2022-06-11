import 'package:beat_pads/screen_beat_pads/slider_themed.dart';
import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _rxModWheel = StateNotifierProvider<IntState, int>((ref) {
  final midiStream = ref.watch(rxMidiStream.stream);
  final intState = IntState();

  final subscription = midiStream.listen((message) {
    if (message.content.length < 2) return;
    if (message.type != MidiMessageType.cc) return;
    if (message.content[0] != CC.modWheel.value) return;

    intState.set(message.content[1]);
  });
  ref.onDispose(subscription.cancel);

  return intState;
});

class IntState extends StateNotifier<int> {
  IntState() : super(0);
  void set(int newVal) {
    state = newVal;
  }
}

class ModWheel extends ConsumerStatefulWidget {
  const ModWheel({Key? key, required this.channel, required this.preview})
      : super(key: key);

  final bool preview;
  final int channel;

  @override
  ConsumerState<ModWheel> createState() => _ModWheelState();
}

class _ModWheelState extends ConsumerState<ModWheel> {
  final double fontSizeFactor = 0.3;
  final double paddingFactor = 0.1;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          flex: 5,
          child: LayoutBuilder(builder: (context, constraints) {
            return Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                "Mod",
                style: TextStyle(
                  fontSize: constraints.maxWidth * fontSizeFactor,
                  color: Palette.darker(Palette.tan, 0.6),
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
        Flexible(
          flex: 30,
          child: ThemedSlider(
            thumbColor: Palette.tan,
            child: RotatedBox(
              quarterTurns: 0,
              child: Slider(
                min: 0,
                max: 127,
                value: ref.watch(_rxModWheel).toDouble(),
                onChanged: (v) {
                  ref.read(_rxModWheel.notifier).set(v.toInt());
                  MidiUtils.sendModWheelMessage(widget.channel, v.toInt());
                },
              ),
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Text(
                            "${ref.watch(_rxModWheel)}",
                            style: TextStyle(
                              fontSize: constraints.maxWidth * fontSizeFactor,
                              color: Palette.darker(Palette.tan, 0.6),
                            ),
                          ),
                        ),
                      ),
                      const Expanded(
                        flex: 1,
                        child: SizedBox.expand(),
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
