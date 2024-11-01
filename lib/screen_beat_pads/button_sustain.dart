import 'package:beat_pads/services/services.dart';
import 'package:beat_pads/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _SustainState extends AutoDisposeNotifier<bool> {
  @override
  bool build() {
    ref.onDispose(() {
      state = false;
      MidiUtils.sendSustainMessage(ref.read(channelUsableProv), state: state);
    });
    return false;
  }

  void sustainOn() {
    state = true;
    MidiUtils.sendSustainMessage(ref.read(channelUsableProv), state: state);
  }

  void sustainOff() {
    state = false;
    MidiUtils.sendSustainMessage(ref.read(channelUsableProv), state: state);
  }

  void sustainToggle() {
    state = !state;
    MidiUtils.sendSustainMessage(ref.read(channelUsableProv), state: state);
  }
}

final sustainStateProv =
    AutoDisposeNotifierProvider<_SustainState, bool>(_SustainState.new);

/////

class SustainButtonDoubleTap extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double width = MediaQuery.of(context).size.width;
    final double padRadius = width * ThemeConst.padRadiusFactor;
    final double padSpacing = width * ThemeConst.padSpacingFactor;
    return Padding(
      padding: EdgeInsets.fromLTRB(0, padSpacing, padSpacing, padSpacing),
      child: GestureDetector(
        onDoubleTap: () => ref.read(sustainStateProv.notifier).sustainToggle(),
        onTapDown: (_) {
          if (!ref.read(sustainStateProv)) {
            ref.read(sustainStateProv.notifier).sustainOn();
          }
        },
        onTapUp: (_) {
          if (ref.read(sustainStateProv)) {
            ref.read(sustainStateProv.notifier).sustainOff();
          }
        },
        onPanEnd: (_) {
          if (ref.read(sustainStateProv)) {
            ref.read(sustainStateProv.notifier).sustainOff();
          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(padRadius * 1)),
            color: ref.watch(sustainStateProv)
                ? Palette.lightPink
                : Palette.darkPink,
            boxShadow: kElevationToShadow[6],
          ),
          child: RotatedBox(
            quarterTurns: 1,
            child: FittedBox(
              child: Text(
                'Sustain',
                style: TextStyle(
                  fontSize: 100,
                  fontWeight: FontWeight.w500,
                  color: Palette.darkGrey,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
