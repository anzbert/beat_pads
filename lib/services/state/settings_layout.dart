import 'package:beat_pads/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// LAYOUT
final layoutProv = NotifierProvider<SettingEnumNotifier<Layout>, Layout>(() {
  return LayoutSettingNotifier(
    nameMap: Layout.values.asNameMap(),
    key: 'layout',
    defaultValue: Layout.customIntervals,
  );
});

class LayoutSettingNotifier extends SettingEnumNotifier<Layout> {
  LayoutSettingNotifier({
    required super.nameMap,
    required super.key,
    required super.defaultValue,
  });

  @override
  void set(Layout newState) {
    if (!newState.resizable) {
      ref.read(rootProv.notifier).reset();
    }

    if (!newState.resizable) {
      ref.read(scaleProv.notifier).reset();
    }

    if (newState.defaultDimensions?.x != null) {
      ref.read(widthProv.notifier).setAndSave(newState.defaultDimensions!.x!);
    }

    if (newState.defaultDimensions?.y != null) {
      ref.read(heightProv.notifier).setAndSave(newState.defaultDimensions!.y!);
    }
    super.set(newState);
  }
}

// NOTES AND OCTAVES
final rootProv = NotifierProvider<SettingIntNotifier, int>(() {
  return SettingIntNotifier(key: 'rootNote', defaultValue: 0, max: 11);
});

final baseProv = NotifierProvider<SettingIntNotifier, int>(() {
  return SettingIntNotifier(key: 'base', defaultValue: 0, max: 11);
});

final baseNoteProv = Provider<int>((ref) {
  if (ref.watch(layoutProv) == Layout.progrChange) {
    return ref.watch(baseProgramProv);
  } else {
    return (ref.watch(baseOctaveProv)) * 12 + ref.watch(baseProv);
  }
});

final flipLayoutHorizontalProv = NotifierProvider<SettingBoolNotifier, bool>(
  () {
    return SettingBoolNotifier(
      key: 'flipLayoutHorizontal',
      defaultValue: false,
    );
  },
);

final flipLayoutVerticalProv = NotifierProvider<SettingBoolNotifier, bool>(() {
  return SettingBoolNotifier(key: 'flipLayoutVertical', defaultValue: false);
});

final baseOctaveProv = NotifierProvider<SettingIntNotifier, int>(() {
  return SettingIntNotifier(key: 'baseOctave', defaultValue: 3, max: 9);
});

final baseProgramProv = NotifierProvider<SettingIntNotifier, int>(() {
  return SettingIntNotifier(key: 'baseProgram', defaultValue: 0, max: 127);
});

// CUSTOM INTERVALS
final customIntervalXProv = NotifierProvider<SettingIntNotifier, int>(() {
  return SettingIntNotifier(
    key: 'customIntervalX',
    defaultValue: 1,
    min: 1,
    max: 12,
  );
});

final customIntervalYProv = NotifierProvider<SettingIntNotifier, int>(() {
  return SettingIntNotifier(
    key: 'customIntervalY',
    defaultValue: 4,
    min: 1,
    max: 12,
  );
});

// GRID SIZE
final widthProv = NotifierProvider<SettingIntNotifier, int>(() {
  return SettingIntNotifier(key: 'width', defaultValue: 4, min: 1, max: 16);
});
final heightProv = NotifierProvider<SettingIntNotifier, int>(() {
  return SettingIntNotifier(key: 'height', defaultValue: 4, min: 1, max: 16);
});

final rowProv = Provider<List<List<CustomPad>>>((ref) {
  var rows = ref
      .watch(layoutProv)
      .getGrid(
        ref.watch(widthProv),
        ref.watch(heightProv),
        ref.watch(rootProv),
        ref.watch(baseNoteProv),
        ref.watch(scaleProv).intervals,
        ref.watch(customIntervalXProv),
        ref.watch(customIntervalYProv),
      )
      .rows;

  if (ref.watch(flipLayoutHorizontalProv)) {
    // Flip horizontally (reverse each row)
    rows = rows.map((row) => row.reversed.toList()).toList();
  }
  // Flip vertically (reverse the order of rows)
  if (ref.watch(flipLayoutVerticalProv)) {
    rows = rows.reversed.toList();
  }

  return rows;
});

// LABELS AND COLOR
final padLabelsProv =
    NotifierProvider<SettingEnumNotifier<PadLabels>, PadLabels>(() {
      return SettingEnumNotifier<PadLabels>(
        nameMap: PadLabels.values.asNameMap(),
        key: 'padLabels',
        defaultValue: PadLabels.note,
      );
    });

final gmLabelsProv = NotifierProvider<SettingBoolNotifier, bool>(() {
  return SettingBoolNotifier(key: 'gmLabels', defaultValue: false);
});

final padColorsProv =
    NotifierProvider<SettingEnumNotifier<PadColors>, PadColors>(() {
      return SettingEnumNotifier<PadColors>(
        nameMap: PadColors.values.asNameMap(),
        key: 'padColors',
        defaultValue: PadColors.colorWheel,
      );
    });

final baseHueProv = NotifierProvider<SettingIntNotifier, int>(() {
  return SettingIntNotifier(key: 'baseHue', defaultValue: 240, max: 360);
});

// SCALES
final scaleProv = NotifierProvider<SettingEnumNotifier<Scale>, Scale>(() {
  return SettingEnumNotifier<Scale>(
    nameMap: Scale.values.asNameMap(),
    key: 'scaleString',
    defaultValue: Scale.chromatic,
  );
});

// BUTTONS AND SLIDERS
final octaveButtonsProv = NotifierProvider<SettingBoolNotifier, bool>(() {
  return SettingBoolNotifier(key: 'octaveButtons', defaultValue: false);
});

final sustainButtonProv = NotifierProvider<SettingBoolNotifier, bool>(() {
  return SettingBoolNotifier(key: 'sustainButton', defaultValue: false);
});

final velocitySliderProv = NotifierProvider<SettingBoolNotifier, bool>(() {
  return SettingBoolNotifier(key: 'velocitySlider', defaultValue: false);
});

final modWheelProv = NotifierProvider<SettingBoolNotifier, bool>(() {
  return SettingBoolNotifier(key: 'modWheel', defaultValue: false);
});

// PITCHBEND
final pitchBendProv = NotifierProvider<SettingBoolNotifier, bool>(() {
  return SettingBoolNotifier(key: 'pitchBend', defaultValue: false);
});

final pitchBendEaseStepProv = NotifierProvider<SettingIntNotifier, int>(() {
  return SettingIntNotifier(
    key: 'pitchBendEase',
    defaultValue: 0,
    max: Timing.releaseDelayTimes.length - 1,
  );
});

final pitchBendEaseUsable = Provider<int>((ref) {
  if (!ref.watch(pitchBendProv)) return 0;

  return Timing.releaseDelayTimes[ref
      .watch(pitchBendEaseStepProv)
      .clamp(0, Timing.releaseDelayTimes.length - 1)];
});

// VELOCITY
final velocityVisualProv = NotifierProvider<SettingBoolNotifier, bool>(() {
  return SettingBoolNotifier(key: 'velocityVisual', defaultValue: false);
});

// PRESETS
final presetButtonsProv = NotifierProvider<SettingBoolNotifier, bool>(() {
  return SettingBoolNotifier(
    key: 'presetButtons',
    defaultValue: false,
    resettable: false,
    usesPresets: false,
  );
});

// EXPERIMENTAL
final triadCirclesProv = NotifierProvider<SettingBoolNotifier, bool>(() {
  return SettingBoolNotifier(key: 'triadCircles', defaultValue: false);
});
