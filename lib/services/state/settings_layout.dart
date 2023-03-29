import 'package:beat_pads/main.dart';
import 'package:beat_pads/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// LAYOUT
final layoutProv = NotifierProvider<SettingEnumNotifier<Layout>, Layout>(() {
  return SettingEnumNotifier<Layout>(
    fromName: Layout.fromName,
    key: 'layout',
    defaultValue: Layout.majorThird,
  );
});

// NOTES AND OCTAVES
final rootProv = StateNotifierProvider<SettingIntNotifier, int>((ref) {
  ref.listen(layoutProv, (_, Layout next) {
    if (!next.props.resizable) {
      ref.read(sharedPrefProvider).settings.rootNote.reset();
    }
  });

  return ref.watch(sharedPrefProvider).settings.rootNote;
});

final baseProv = NotifierProvider<SettingIntNotifier, int>(() {
  return SettingIntNotifier(
    key: 'base',
    defaultValue: 0,
    max: 11,
  );
});

final baseNoteProv = Provider<int>(((ref) {
  return (ref.watch(baseOctaveProv) + 2) * 12 + ref.watch(baseProv);
}));

final baseOctaveProv = NotifierProvider<SettingIntNotifier, int>(() {
  return SettingIntNotifier(
    key: 'baseOctave',
    defaultValue: 1,
    min: -2,
    max: 7,
  );
});

// GRID SIZE
final widthProv = StateNotifierProvider<SettingIntNotifier, int>((ref) {
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
final heightProv = StateNotifierProvider<SettingIntNotifier, int>((ref) {
  ref.listen(layoutProv, (_, Layout next) {
    if (next.props.defaultDimensions?.y != null) {
      ref
          .read(sharedPrefProvider)
          .settings
          .height
          .setAndSave(next.props.defaultDimensions!.y);
    }
  });
  return ref.watch(sharedPrefProvider).settings.height;
});

final rowProv = Provider<List<List<CustomPad>>>(((ref) {
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
    NotifierProvider<SettingEnumNotifier<PadLabels>, PadLabels>(() {
  return SettingEnumNotifier<PadLabels>(
    fromName: PadLabels.fromName,
    key: "padLabels",
    defaultValue: PadLabels.note,
  );
});

final padColorsProv =
    NotifierProvider<SettingEnumNotifier<PadColors>, PadColors>(() {
  return SettingEnumNotifier<PadColors>(
    fromName: PadColors.fromName,
    key: "padColors",
    defaultValue: PadColors.highlightRoot,
  );
});

final baseHueProv = NotifierProvider<SettingIntNotifier, int>(() {
  return SettingIntNotifier(
    key: "baseHue",
    defaultValue: 240,
    max: 360,
  );
});

// SCALES
final scaleProv = NotifierProvider<SettingEnumNotifier<Scale>, Scale>((ref) {
  ref.listen(layoutProv, (_, Layout next) {
    if (!next.props.resizable) {
      ref.read(sharedPrefProvider).settings.scale.reset();
    }
  });

  return ref.watch(sharedPrefProvider).settings.scale;
});

// BUTTONS AND SLIDERS
final octaveButtonsProv = NotifierProvider<SettingBoolNotifier, bool>(() {
  return SettingBoolNotifier(
    key: 'octaveButtons',
    defaultValue: false,
  );
});

final sustainButtonProv = NotifierProvider<SettingBoolNotifier, bool>(() {
  return SettingBoolNotifier(
    key: 'sustainButton',
    defaultValue: false,
  );
});

final velocitySliderProv = NotifierProvider<SettingBoolNotifier, bool>(() {
  return SettingBoolNotifier(
    key: 'velocitySlider',
    defaultValue: false,
  );
});

final modWheelProv = NotifierProvider<SettingBoolNotifier, bool>(() {
  return SettingBoolNotifier(
    key: 'modWheel',
    defaultValue: false,
  );
});

// PITCHBEND
final pitchBendProv = NotifierProvider<SettingBoolNotifier, bool>(() {
  return SettingBoolNotifier(
    key: 'pitchBend',
    defaultValue: false,
  );
});

final pitchBendEaseStepProv = NotifierProvider<SettingIntNotifier, int>(() {
  return SettingIntNotifier(
    key: 'pitchBendEase',
    defaultValue: 0,
    max: Timing.releaseDelayTimes.length - 1,
  );
});

final pitchBendEaseUsable = Provider<int>(
  (ref) {
    if (!ref.watch(pitchBendProv)) return 0;

    return Timing.releaseDelayTimes[ref
        .watch(pitchBendEaseStepProv)
        .clamp(0, Timing.releaseDelayTimes.length - 1)];
  },
);

// VELOCITY
final velocityVisualProv = NotifierProvider<SettingBoolNotifier, bool>(() {
  return SettingBoolNotifier(
    key: 'velocityVisual',
    defaultValue: false,
  );
});
