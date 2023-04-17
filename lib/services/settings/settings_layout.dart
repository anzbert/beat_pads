import 'package:beat_pads/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// LAYOUT
final layoutProv = NotifierProvider<SettingEnumNotifier<Layout>, Layout>(
  () => LayoutSettingNotifier(
    nameMap: Layout.values.asNameMap(),
    key: 'layout',
    defaultValue: Layout.majorThird,
  ),
);

class LayoutSettingNotifier extends SettingEnumNotifier<Layout> {
  LayoutSettingNotifier({
    required super.nameMap,
    required super.key,
    required super.defaultValue,
  });

  @override
  void set(Layout newState) {
    if (!newState.props.resizable) {
      ref.read(rootProv.notifier).reset();
    }

    if (!newState.props.resizable) {
      ref.read(scaleProv.notifier).reset();
    }

    if (newState.props.defaultDimensions?.x != null) {
      ref
          .read(widthProv.notifier)
          .setAndSave(newState.props.defaultDimensions!.x);
    }

    if (newState.props.defaultDimensions?.y != null) {
      ref
          .read(heightProv.notifier)
          .setAndSave(newState.props.defaultDimensions!.y);
    }
    super.set(newState);
  }
}

// NOTES AND OCTAVES
final rootProv = NotifierProvider<SettingIntNotifier, int>(
  () => SettingIntNotifier(
    key: 'rootNote',
    defaultValue: 0,
    max: 11,
  ),
);

final baseProv = NotifierProvider<SettingIntNotifier, int>(
  () => SettingIntNotifier(
    key: 'base',
    defaultValue: 0,
    max: 11,
  ),
);

final baseNoteProv = Provider<int>(
  (ref) => (ref.watch(baseOctaveProv) + 2) * 12 + ref.watch(baseProv),
);

final baseOctaveProv = NotifierProvider<SettingIntNotifier, int>(
  () => SettingIntNotifier(
    key: 'baseOctave',
    defaultValue: 1,
    min: -2,
    max: 7,
  ),
);

// GRID SIZE
final widthProv = NotifierProvider<SettingIntNotifier, int>(
  () => SettingIntNotifier(
    key: 'width',
    defaultValue: 4,
    min: 2,
    max: 16,
  ),
);
final heightProv = NotifierProvider<SettingIntNotifier, int>(
  () => SettingIntNotifier(
    key: 'height',
    defaultValue: 4,
    min: 2,
    max: 16,
  ),
);

final rowProv = Provider<List<List<CustomPad>>>(
  (ref) => ref
      .watch(layoutProv)
      .getGrid(
        ref.watch(widthProv),
        ref.watch(heightProv),
        ref.watch(rootProv),
        ref.watch(baseNoteProv),
        ref.watch(scaleProv).intervals,
      )
      .rows,
);

// LABELS AND COLOR
final padLabelsProv =
    NotifierProvider<SettingEnumNotifier<PadLabels>, PadLabels>(
  () => SettingEnumNotifier<PadLabels>(
    nameMap: PadLabels.values.asNameMap(),
    key: 'padLabels',
    defaultValue: PadLabels.note,
  ),
);

final padColorsProv =
    NotifierProvider<SettingEnumNotifier<PadColors>, PadColors>(
  () => SettingEnumNotifier<PadColors>(
    nameMap: PadColors.values.asNameMap(),
    key: 'padColors',
    defaultValue: PadColors.highlightRoot,
  ),
);

final baseHueProv = NotifierProvider<SettingIntNotifier, int>(
  () => SettingIntNotifier(
    key: 'baseHue',
    defaultValue: 240,
    max: 360,
  ),
);

// SCALES
final scaleProv = NotifierProvider<SettingEnumNotifier<Scale>, Scale>(
  () => SettingEnumNotifier<Scale>(
    nameMap: Scale.values.asNameMap(),
    key: 'scaleString',
    defaultValue: Scale.chromatic,
  ),
);

// BUTTONS AND SLIDERS
final octaveButtonsProv = NotifierProvider<SettingBoolNotifier, bool>(
  () => SettingBoolNotifier(
    key: 'octaveButtons',
    defaultValue: false,
  ),
);

final sustainButtonProv = NotifierProvider<SettingBoolNotifier, bool>(
  () => SettingBoolNotifier(
    key: 'sustainButton',
    defaultValue: false,
  ),
);

final velocitySliderProv = NotifierProvider<SettingBoolNotifier, bool>(
  () => SettingBoolNotifier(
    key: 'velocitySlider',
    defaultValue: false,
  ),
);

final modWheelProv = NotifierProvider<SettingBoolNotifier, bool>(
  () => SettingBoolNotifier(
    key: 'modWheel',
    defaultValue: false,
  ),
);

// PITCHBEND
final pitchBendProv = NotifierProvider<SettingBoolNotifier, bool>(
  () => SettingBoolNotifier(
    key: 'pitchBend',
    defaultValue: false,
  ),
);

final pitchBendEaseStepProv = NotifierProvider<SettingIntNotifier, int>(
  () => SettingIntNotifier(
    key: 'pitchBendEase',
    defaultValue: 0,
    max: Timing.releaseDelayTimes.length - 1,
  ),
);

final pitchBendEaseUsable = Provider<int>(
  (ref) {
    if (!ref.watch(pitchBendProv)) return 0;

    return Timing.releaseDelayTimes[ref
        .watch(pitchBendEaseStepProv)
        .clamp(0, Timing.releaseDelayTimes.length - 1)];
  },
);

// VELOCITY
final velocityVisualProv = NotifierProvider<SettingBoolNotifier, bool>(
  () => SettingBoolNotifier(
    key: 'velocityVisual',
    defaultValue: false,
  ),
);

// PRESETS
final presetButtonsProv = NotifierProvider<SettingBoolNotifier, bool>(
  () => SettingBoolNotifier(
    key: 'presetButtons',
    defaultValue: false,
    resettable: false,
    usesPresets: false,
  ),
);
