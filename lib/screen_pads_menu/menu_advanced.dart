import 'package:beat_pads/screen_pads_menu/drop_down_enum.dart';
import 'package:beat_pads/screen_pads_menu/drop_down_modulation.dart';
import 'package:beat_pads/screen_pads_menu/slider_int.dart';
import 'package:beat_pads/screen_pads_menu/slider_modulation_size.dart';
import 'package:beat_pads/screen_pads_menu/slider_non_linear.dart';
import 'package:beat_pads/screens_shared_widgets/divider_title.dart';
import 'package:beat_pads/services/services.dart';
import 'package:beat_pads/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final showModPreview = StateProvider<bool>((ref) => false);

class MenuInput extends ConsumerWidget {
  const MenuInput({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Stack(
        children: [
          ListView(
            padding:
                const EdgeInsets.only(bottom: ThemeConst.listViewBottomPadding),
            children: <Widget>[
              const DividerTitle('Input'),
              ListTile(
                title: const Text('Pan Mode'),
                subtitle: const Text(
                  'Choose how the grid reacts to finger X and Y movement',
                ),
                trailing: DropdownEnum(
                  values: PlayMode.values,
                  readValue: ref.watch(playModeProv),
                  setValue: (v) =>
                      ref.read(playModeProv.notifier).setAndSave(v),
                ),
              ),
              if (ref.watch(playModeProv).modulatable)
                ModSizeSliderTile(
                  min: ref.watch(modulationRadiusProv.notifier).min,
                  max: ref.watch(modulationRadiusProv.notifier).max,
                  label: 'Input Size',
                  subtitle:
                      'Modulation field width, relative to the pad screen',
                  trailing:
                      '${(ref.watch(modulationRadiusProv) * 100).toInt()}%',
                  readValue: ref.watch(modulationRadiusProv).clamp(
                        ref.watch(modulationRadiusProv.notifier).min,
                        ref.watch(modulationRadiusProv.notifier).max,
                      ),
                  setValue: (v) =>
                      ref.read(modulationRadiusProv.notifier).set(v),
                  resetValue: ref.read(modulationRadiusProv.notifier).reset,
                  onChangeEnd: ref.read(modulationRadiusProv.notifier).save,
                ),
              if (ref.watch(playModeProv).modulatable)
                ModSizeSliderTile(
                  min: ref.watch(modulationDeadZoneProv.notifier).min,
                  max: ref.watch(modulationDeadZoneProv.notifier).max,
                  label: 'Dead Zone',
                  subtitle:
                      'Size of the non-reactive center of the modulation field',
                  trailing:
                      '${(ref.watch(modulationDeadZoneProv) * 100).toInt()}%',
                  readValue: ref.watch(modulationDeadZoneProv).clamp(
                        ref.watch(modulationDeadZoneProv.notifier).min,
                        ref.watch(modulationDeadZoneProv.notifier).max,
                      ),
                  setValue: (v) =>
                      ref.read(modulationDeadZoneProv.notifier).set(v),
                  resetValue: ref.read(modulationDeadZoneProv.notifier).reset,
                  onChangeEnd: ref.read(modulationDeadZoneProv.notifier).save,
                ),
              if (ref.watch(playModeProv) == PlayMode.mpe)
                const DividerTitle('MPE'),
              if (ref.watch(playModeProv) == PlayMode.mpe)
                ListTile(
                  title: const Text('2-D Modulation'),
                  subtitle: const Text(
                    'Modulate 2 controls on the X and Y axis, or just 1 by Radius [CC in brackets]',
                  ),
                  trailing: Switch(
                    value: ref.watch(modulation2DProv),
                    onChanged: (v) =>
                        ref.read(modulation2DProv.notifier).setAndSave(v),
                  ),
                ),
              if (ref.watch(playModeProv) == PlayMode.mpe &&
                  ref.watch(modulation2DProv))
                ListTile(
                  title: const Text('X-Axis'),
                  trailing: DropdownModulation(
                    readValue: ref.watch(mpe2DXProv),
                    setValue: (v) =>
                        ref.read(mpe2DXProv.notifier).setAndSave(v),
                    otherValue: ref.watch(mpe2DYProv),
                  ),
                ),
              if (ref.watch(playModeProv) == PlayMode.mpe &&
                  ref.watch(modulation2DProv))
                ListTile(
                  title: const Text('Y-Axis'),
                  trailing: DropdownModulation(
                    readValue: ref.watch(mpe2DYProv),
                    setValue: (v) =>
                        ref.read(mpe2DYProv.notifier).setAndSave(v),
                    otherValue: ref.watch(mpe2DXProv),
                  ),
                ),
              if (ref.watch(playModeProv) == PlayMode.mpe &&
                  ref.watch(modulation2DProv) == false)
                ListTile(
                  title: const Text('Radius'),
                  trailing: DropdownModulation(
                    dimensions: Dims.one,
                    readValue: ref.watch(mpe1DRadiusProv),
                    setValue: (v) =>
                        ref.read(mpe1DRadiusProv.notifier).setAndSave(v),
                  ),
                ),
              if (ref.watch(playModeProv) == PlayMode.mpe)
                if (ref.watch(mpe1DRadiusProv).exclusiveGroup == Group.pitch ||
                    ref.watch(mpe2DXProv).exclusiveGroup == Group.pitch ||
                    ref.watch(mpe2DYProv).exclusiveGroup == Group.pitch)
                  IntSliderTile(
                    min: 1,
                    max: 48,
                    label: 'Pitch Bend Range',
                    subtitle: 'Maximum MPE Pitch Bend in semitones',
                    trailing: ref.watch(mpePitchbendRangeProv).toString(),
                    readValue: ref.watch(mpePitchbendRangeProv),
                    setValue: (v) =>
                        ref.read(mpePitchbendRangeProv.notifier).set(v),
                    resetValue: ref.read(mpePitchbendRangeProv.notifier).reset,
                    onChangeEnd: ref.read(mpePitchbendRangeProv.notifier).save,
                  ),
              const DividerTitle('Release'),
              NonLinearSliderTile(
                label: 'Note Release Delay',
                subtitle: 'NoteOff delay after pad release in milliseconds',
                readValue: ref.watch(noteReleaseStepProv),
                setValue: (v) => ref.read(noteReleaseStepProv.notifier).set(v),
                resetFunction: ref.read(noteReleaseStepProv.notifier).reset,
                displayValue: ref.watch(noteReleaseUsable) == 0
                    ? 'Off'
                    : ref.watch(noteReleaseUsable) < 1000
                        ? '${ref.watch(noteReleaseUsable)} ms'
                        : '${ref.watch(noteReleaseUsable) / 1000} s',
                steps: Timing.releaseDelayTimes.length ~/ 1.5,
                onChangeEnd: ref.read(noteReleaseStepProv.notifier).save,
              ),
              if (ref.watch(playModeProv).modulatable)
                NonLinearSliderTile(
                  label: 'Modulation Ease Back',
                  subtitle:
                      'Modulation returning to Zero after pad release in milliseconds',
                  readValue: ref.watch(modReleaseStepProv),
                  setValue: (v) => ref.read(modReleaseStepProv.notifier).set(v),
                  resetFunction: ref.read(modReleaseStepProv.notifier).reset,
                  displayValue: ref.watch(modReleaseUsable) == 0
                      ? 'Off'
                      : ref.watch(modReleaseUsable) < 1000
                          ? '${ref.watch(modReleaseUsable)} ms'
                          : '${ref.watch(modReleaseUsable) / 1000} s',
                  steps: Timing.releaseDelayTimes.length ~/ 1.5,
                  onChangeEnd: ref.read(modReleaseStepProv.notifier).save,
                ),
              if (ref.watch(playModeProv).singleChannel)
                const DividerTitle('Output'),
              if (ref.watch(playModeProv).singleChannel)
                ListTile(
                  title: const Text('Control Change'),
                  subtitle: const Text(
                    'Send CC Message along with Note, one Midi channel higher',
                  ),
                  trailing: Switch(
                    value: ref.watch(sendCCProv),
                    onChanged: (v) =>
                        ref.read(sendCCProv.notifier).setAndSave(v),
                  ),
                ),
            ],
          ),
          if (ref.watch(showModPreview)) const PaintModPreview(),
        ],
      );
}
