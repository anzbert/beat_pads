import 'package:beat_pads/services/services.dart';
import 'package:beat_pads/theme.dart';
import 'package:flutter/gestures.dart';
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

class SustainButtonDoubleTap extends ConsumerStatefulWidget {
  @override
  SustainButtonDoubleTapState createState() => SustainButtonDoubleTapState();
}

class SustainButtonDoubleTapState
    extends ConsumerState<SustainButtonDoubleTap> {
  static const int _doubleTapTime = 230; // in ms
  int _lastTap = DateTime.now().millisecondsSinceEpoch;
  int _consecutiveTaps = 1;

  void on(dynamic _) {
    final int now = DateTime.now().millisecondsSinceEpoch;
    if (now - _lastTap < _doubleTapTime) {
      _consecutiveTaps++;
      if (_consecutiveTaps >= 2) {
        ref.read(sustainStateProv.notifier).sustainOn();
      }
    } else {
      _consecutiveTaps = 1;
      if (!ref.read(sustainStateProv)) {
        ref.read(sustainStateProv.notifier).sustainOn();
      }
    }
    _lastTap = now;
  }

  void off(dynamic _) {
    if (ref.read(sustainStateProv) && _consecutiveTaps < 2) {
      ref.read(sustainStateProv.notifier).sustainOff();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double padRadius = width * ThemeConst.padRadiusFactor;
    final double padSpacing = width * ThemeConst.padSpacingFactor;

    return Padding(
      padding: EdgeInsets.fromLTRB(0, padSpacing, padSpacing, padSpacing),
      child: RawGestureDetector(
        gestures: <Type, GestureRecognizerFactory>{
          TapAndPanGestureRecognizer:
              GestureRecognizerFactoryWithHandlers<TapAndPanGestureRecognizer>(
            () => TapAndPanGestureRecognizer(),
            (TapAndPanGestureRecognizer instance) {
              instance
                ..onTapDown = on
                ..onTapUp = off
                ..onDragEnd = off;
            },
          ),
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(padRadius)),
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
