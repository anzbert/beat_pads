import 'package:beat_pads/screen_beat_pads/button_presets.dart';
import 'package:beat_pads/screen_pads_menu/counter_int.dart';
import 'package:beat_pads/screen_pads_menu/drop_down_enum.dart';
import 'package:beat_pads/screen_pads_menu/drop_down_int.dart';
import 'package:beat_pads/screen_pads_menu/drop_down_notes.dart';
import 'package:beat_pads/screen_pads_menu/preview_beat_pads.dart';
import 'package:beat_pads/screen_pads_menu/slider_int.dart';
import 'package:beat_pads/screen_pads_menu/slider_non_linear.dart';
import 'package:beat_pads/services/services.dart';
import 'package:beat_pads/shared_components/divider_title.dart';
import 'package:beat_pads/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuLayout extends ConsumerWidget {
  const MenuLayout();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool resizableGrid =
        ref.watch(layoutProv).resizable; // Is the layout fixed or resizable?
    final bool isPortrait =
        MediaQuery.of(context).orientation.name == 'portrait';
    return Flex(
      direction: isPortrait ? Axis.vertical : Axis.horizontal,
      crossAxisAlignment:
          isPortrait ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        const Flexible(
          fit: FlexFit.tight,
          flex: 2,
          child: FittedBox(
            child: RepaintBoundary(
              child: Preview(),
            ),
          ),
        ),
        RotatedBox(
          quarterTurns: isPortrait ? 0 : 1,
          child: const Divider(
            height: 0,
            thickness: 3,
          ),
        ),
        Expanded(
          flex: 3,
          child: ListView(
            padding:
                const EdgeInsets.only(bottom: ThemeConst.listViewBottomPadding),
            children: <Widget>[
              const DividerTitle('Presets'),
              const PresetButtons(
                clickType: ClickType.tap,
                row: true,
                minimumSize: true,
              ),
              ListTile(
                title: const Text('Show Preset Buttons'),
                subtitle: const Text('DOUBLE TAP buttons to switch Presets'),
                trailing: Switch(
                  value: ref.watch(presetButtonsProv),
                  onChanged: (v) =>
                      ref.read(presetButtonsProv.notifier).setAndSave(v),
                ),
              ),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: ThemeConst.menuButtonMinWidth,
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Palette.laserLemon,
                    ),
                    child: const Text(
                      'Reset Preset',
                    ),
                    onPressed: () {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Reset'),
                          content: const Text(
                            'Return current Preset to the default values?',
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, 'OK');
                                ref.read(resetAllProv.notifier).resetAll();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              const DividerTitle('Layout'),
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                color: Palette.darkGrey,
                child: ListTile(
                  title: const Text(
                    'Layout',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: DropdownEnum<Layout>(
                      values: Layout.values,
                      readValue: ref.watch<Layout>(layoutProv),
                      setValue: (Layout v) {
                        ref.read(layoutProv.notifier).setAndSave(v);
                      }),
                ),
              ),
              if (ref.watch(layoutProv) == Layout.progrChange)
                ListTile(
                  title: const Text('Base Program'),
                  subtitle: const Text(
                    'Lowest Program on the Grid',
                  ),
                  trailing: DropdownInt(
                    readValue: ref.watch(baseProgramProv) + 1,
                    setValue: (int v) =>
                        ref.read(baseProgramProv.notifier).setAndSave(v - 1),
                    size: 128,
                    start: 1,
                  ),
                ),
              if (resizableGrid && ref.watch(layoutProv).custom)
                IntCounterTile(
                  label: ref.watch(layoutProv) == Layout.scaleNotesCustom
                      ? 'X Scale Steps'
                      : 'X Semitones',
                  setValue: (int v) =>
                      ref.read(customIntervalXProv.notifier).setAndSave(v),
                  readValue: ref.watch(customIntervalXProv),
                ),
              if (resizableGrid && ref.watch(layoutProv).custom)
                IntCounterTile(
                  label: ref.watch(layoutProv) == Layout.scaleNotesCustom
                      ? 'Y Scale Steps'
                      : 'Y Semitones',
                  setValue: (int v) =>
                      ref.read(customIntervalYProv.notifier).setAndSave(v),
                  readValue: ref.watch(customIntervalYProv),
                ),
              if (resizableGrid) const DividerTitle('Size'),
              if (resizableGrid)
                IntCounterTile(
                  label: 'Width',
                  setValue: (int v) =>
                      ref.read(widthProv.notifier).setAndSave(v),
                  readValue: ref.watch(widthProv),
                ),
              if (resizableGrid)
                IntCounterTile(
                  label: 'Height',
                  setValue: (int v) =>
                      ref.read(heightProv.notifier).setAndSave(v),
                  readValue: ref.watch(heightProv),
                ),
              if (resizableGrid && ref.watch(layoutProv) != Layout.progrChange)
                const DividerTitle('Scale'),
              if (resizableGrid && ref.watch(layoutProv) != Layout.progrChange)
                ListTile(
                  title: const Text('Scale'),
                  trailing: DropdownEnum<Scale>(
                    values: Scale.values,
                    readValue: ref.watch(scaleProv),
                    setValue: (Scale v) {
                      ref.read(scaleProv.notifier).setAndSave(v);
                      ref
                          .read(baseProv.notifier)
                          .setAndSave(ref.read(rootProv));
                    },
                  ),
                ),
              if (resizableGrid && ref.watch(layoutProv) != Layout.progrChange)
                ListTile(
                  title: const Text('Root Note'),
                  subtitle: const Text('Root Note of the selected scale'),
                  trailing: DropdownRootNote(
                    setValue: (int v) {
                      ref.read(rootProv.notifier).setAndSave(v);
                      ref.read(baseProv.notifier).setAndSave(v);
                    },
                    readValue: ref.watch(rootProv),
                  ),
                ),
              if (resizableGrid && ref.watch(layoutProv) != Layout.progrChange)
                ListTile(
                  title: const Text('Base Note'),
                  subtitle: const Text(
                    'Lowest Note on the bottom left',
                  ),
                  trailing: DropdownRootNote(
                    enabledList: MidiUtils.absoluteScaleNotes(
                        ref.watch(rootProv), ref.watch(scaleProv).intervals),
                    setValue: (int v) =>
                        ref.read(baseProv.notifier).setAndSave(v),
                    readValue: ref.watch(baseProv),
                  ),
                ),
              if (resizableGrid && ref.watch(layoutProv) != Layout.progrChange)
                IntCounterTile(
                  label: 'Base Octave',
                  modDisplay: (v) => '${v - 2}',
                  readValue: ref.watch(baseOctaveProv),
                  setValue: (int v) =>
                      ref.read(baseOctaveProv.notifier).setAndSave(v),
                  resetFunction: ref.read(baseOctaveProv.notifier).reset,
                ),
              const DividerTitle('Controls'),
              if (resizableGrid)
                ListTile(
                  title: const Text('Octave Buttons'),
                  subtitle:
                      const Text('Adds Octave control buttons next to pads'),
                  trailing: Switch(
                    value: ref.watch(octaveButtonsProv),
                    onChanged: (bool v) =>
                        ref.read(octaveButtonsProv.notifier).setAndSave(v),
                  ),
                ),
              ListTile(
                title: const Text('Sustain Button'),
                subtitle: const Text(
                  'Adds a Sustain button next to pads. Lock ON by double-tapping',
                ),
                trailing: Switch(
                  value: ref.watch(sustainButtonProv),
                  onChanged: (bool v) =>
                      ref.read(sustainButtonProv.notifier).setAndSave(v),
                ),
              ),
              ListTile(
                title: const Text('Velocity'),
                subtitle: const Text('Adds Velocity Slider next to pads'),
                trailing: Switch(
                  value: ref.watch(velocitySliderProv),
                  onChanged: (bool v) =>
                      ref.read(velocitySliderProv.notifier).setAndSave(v),
                ),
              ),
              ListTile(
                title: const Text('Mod Wheel'),
                subtitle: const Text('Adds Mod Wheel Slider next to pads'),
                trailing: Switch(
                  value: ref.watch<bool>(modWheelProv),
                  onChanged: (bool v) =>
                      ref.read(modWheelProv.notifier).setAndSave(v),
                ),
              ),
              ListTile(
                title: const Text('Pitch Bend'),
                subtitle: const Text('Adds Pitch Bend slider next to pads'),
                trailing: Switch(
                  value: ref.watch(pitchBendProv),
                  onChanged: (bool v) =>
                      ref.read(pitchBendProv.notifier).setAndSave(v),
                ),
              ),
              if (ref.watch(pitchBendProv))
                Container(
                  color: Palette.dirtyTranslucent,
                  child: NonLinearSliderTile(
                    label: 'Pitch Bend Return',
                    subtitle:
                        'Set time in milliseconds for Pitch Bend Slider to ease back to Zero',
                    readValue: ref.watch(pitchBendEaseStepProv),
                    setValue: (int v) =>
                        ref.read(pitchBendEaseStepProv.notifier).set(v),
                    resetFunction:
                        ref.read(pitchBendEaseStepProv.notifier).reset,
                    displayValue: ref.watch(pitchBendEaseUsable) == 0
                        ? 'Off'
                        : ref.watch(pitchBendEaseUsable) < 1000
                            ? '${ref.watch(pitchBendEaseUsable)} ms'
                            : '${ref.watch(pitchBendEaseUsable) / 1000} s',
                    steps: Timing.releaseDelayTimes.length - 1,
                    onChangeEnd: ref.read(pitchBendEaseStepProv.notifier).save,
                  ),
                ),
              const DividerTitle('Display'),
              ListTile(
                title: const Text('Pad Labels'),
                subtitle:
                    const Text('Choose between Midi values and Note names'),
                trailing: DropdownEnum<PadLabels>(
                  values: PadLabels.values,
                  readValue: ref.watch<PadLabels>(padLabelsProv),
                  setValue: (PadLabels v) =>
                      ref.read(padLabelsProv.notifier).setAndSave(v),
                ),
              ),
              ListTile(
                title: const Text('Pad Colors'),
                subtitle:
                    const Text('Colorize pads by distance to the root note'),
                trailing: DropdownEnum<PadColors>(
                  values: PadColors.values,
                  readValue: ref.watch(padColorsProv),
                  setValue: (PadColors v) =>
                      ref.read(padColorsProv.notifier).setAndSave(v),
                ),
              ),
              IntSliderTile(
                label: 'Hue',
                max: 360,
                subtitle: 'Root Note hue on the RGB color wheel',
                trailing: ref.watch(baseHueProv).toString(),
                readValue: ref.watch(baseHueProv),
                setValue: (int v) => ref.read(baseHueProv.notifier).set(v),
                resetValue: ref.read(baseHueProv.notifier).reset,
                onChangeEnd: ref.read(baseHueProv.notifier).save,
              ),
              ListTile(
                title: const Text('Show Velocity'),
                subtitle: const Text(
                  'Show visual feedback on the pad indicating the sent Velocity',
                ),
                trailing: Switch(
                  value: ref.watch(velocityVisualProv),
                  onChanged: (bool v) {
                    ref.read(velocityVisualProv.notifier).setAndSave(v);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
