import 'package:beat_pads/main.dart';
import 'package:beat_pads/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// LAYOUT
final layoutProv = StateNotifierProvider<SettingEnum<Layout>, Layout>((ref) {
  return ref.watch(sharedPrefProvider).settings.layout;
});

// NOTES AND OCTAVES
final rootProv = StateNotifierProvider<SettingInt, int>((ref) {
  ref.listen(layoutProv, (_, Layout next) {
    if (!next.props.resizable) {
      ref.read(sharedPrefProvider).settings.rootNote.reset();
    }
  });

  return ref.watch(sharedPrefProvider).settings.rootNote;
});

final baseProv = StateNotifierProvider<SettingInt, int>((ref) {
  return ref.watch(sharedPrefProvider).settings.base;
});

final baseNoteProv = Provider<int>(((ref) {
  return (ref.watch(baseOctaveProv) + 2) * 12 + ref.watch(baseProv);
}));

final baseOctaveProv = StateNotifierProvider<SettingInt, int>((ref) {
  return ref.watch(sharedPrefProvider).settings.baseOctave;
});

// GRID SIZE
final widthProv = StateNotifierProvider<SettingInt, int>((ref) {
  ref.listen(layoutProv, (_, Layout next) {
    if (next.props.defaultDimensions?.x != null) {
      ref
          .read(sharedPrefProvider)
          .settings
          .width
          .setAndSave(next.props.defaultDimensions!.x);
    }
  });
  return ref.watch(sharedPrefProvider).settings.width;
});
final heightProv = StateNotifierProvider<SettingInt, int>((ref) {
  ref.listen(layoutProv, (_, Layout next) {
    if (next.props.defaultDimensions?.y != null) {
      ref
          .read(sharedPrefProvider)
          .settings
          .width
          .setAndSave(next.props.defaultDimensions!.y);
    }
  });
  return ref.watch(sharedPrefProvider).settings.height;
});

final rowProv = Provider<List<List<int>>>(((ref) {
  return ref
      .watch(layoutProv)
      .getGrid(
        ref.watch(widthProv),
        ref.watch(heightProv),
        ref.watch(rootProv),
        ref.watch(baseNoteProv),
        ref.watch(scaleProv).intervals,
      )
      .rows;
}));

// LABELS AND COLOR
final padLabelsProv =
    StateNotifierProvider<SettingEnum<PadLabels>, PadLabels>((ref) {
  return ref.watch(sharedPrefProvider).settings.padLabels;
});
final padColorsProv =
    StateNotifierProvider<SettingEnum<PadColors>, PadColors>((ref) {
  return ref.watch(sharedPrefProvider).settings.padColors;
});
final baseHueProv = StateNotifierProvider<SettingInt, int>((ref) {
  return ref.watch(sharedPrefProvider).settings.baseHue;
});

// SCALES
final scaleProv = StateNotifierProvider<SettingEnum<Scale>, Scale>((ref) {
  ref.listen(layoutProv, (_, Layout next) {
    if (!next.props.resizable) {
      ref.read(sharedPrefProvider).settings.scale.reset();
    }
  });

  return ref.watch(sharedPrefProvider).settings.scale;
});

// final scaleListProv = Provider<List<int>>(((ref) {
//   return midiScales[ref.watch(scaleStringProv)] ??
//       const [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
// }));

// BUTTONS AND SLIDERS
final octaveButtonsProv = StateNotifierProvider<SettingBool, bool>((ref) {
  return ref.watch(sharedPrefProvider).settings.octaveButtons;
});
final sustainButtonProv = StateNotifierProvider<SettingBool, bool>((ref) {
  return ref.watch(sharedPrefProvider).settings.sustainButton;
});
final velocitySliderProv = StateNotifierProvider<SettingBool, bool>((ref) {
  return ref.watch(sharedPrefProvider).settings.velocitySlider;
});
final modWheelProv = StateNotifierProvider<SettingBool, bool>((ref) {
  return ref.watch(sharedPrefProvider).settings.modWheel;
});

// PITCHBEND
final pitchBendProv = StateNotifierProvider<SettingBool, bool>((ref) {
  return ref.watch(sharedPrefProvider).settings.pitchBend;
});

final pitchBendEaseStepProv = StateNotifierProvider<SettingInt, int>((ref) {
  return ref.watch(sharedPrefProvider).settings.pitchBendEase;
});

final pitchBendEaseUsable = Provider<int>(
  (ref) {
    if (!ref.watch(pitchBendProv)) return 0;

    return Timing.timingSteps[ref
        .watch(pitchBendEaseStepProv)
        .clamp(0, Timing.timingSteps.length - 1)];
  },
);
