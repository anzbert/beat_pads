import 'package:beat_pads/screen_beat_pads/button_presets.dart';
import 'package:beat_pads/screen_pads_menu/drop_down_enum.dart';
import 'package:beat_pads/theme.dart';
import 'package:flutter/material.dart';
import 'package:beat_pads/screen_pads_menu/preview_beat_pads.dart';
import 'package:beat_pads/screen_pads_menu/slider_int.dart';
import 'package:beat_pads/services/services.dart';
import 'package:beat_pads/screen_pads_menu/counter_int.dart';
import 'package:beat_pads/screen_pads_menu/slider_non_linear.dart';
import 'package:beat_pads/screen_pads_menu/drop_down_notes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../shared_components/divider_title.dart';

class MenuLayout extends ConsumerWidget {
  const MenuLayout(this._scrollController);

  final ScrollController _scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool resizableGrid = ref
        .watch(layoutProv)
        .props
        .resizable; // Is the layout fixed or resizable?
    final bool isPortrait =
        MediaQuery.of(context).orientation.name == "portrait" ? true : false;
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
            )),
        Expanded(
          flex: 3,
          child: ListView(
            padding:
                const EdgeInsets.only(bottom: ThemeConst.listViewBottomPadding),
            controller: _scrollController,
            children: <Widget>[
              const DividerTitle("Presets"),
              // IconButton(
              //     onPressed: () async {
              //       final bla = await DeviceUtils.enableRotation();
              //       print(bla);
              //     },
              //     icon: const Icon(Icons.place_rounded),
              //     iconSize: 100),
              const PresetButtons(
                clickType: ClickType.tap,
                row: true,
                minimumSize: true,
              ),
              ListTile(
                title: const Text("Show Preset Buttons"),
                subtitle: const Text("DOUBLE TAP buttons to switch Presets"),
                trailing: Switch(
                    value: ref.watch(presetButtonsProv),
                    onChanged: (v) =>
                        ref.read(presetButtonsProv.notifier).setAndSave(v)),
              ),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                      minWidth: ThemeConst.menuButtonMinWidth),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Palette.laserLemon,
                    ),
                    child: const Text(
                      "Reset Preset",
                    ),
                    onPressed: () {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Reset'),
                          content: const Text(
                              'Return current Preset to the default values?'),
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
              const DividerTitle("Layout"),
              ListTile(
                title: const Text("Layout"),
                trailing: DropdownEnum<Layout>(
                  values: Layout.values,
                  readValue: ref.watch<Layout>(layoutProv),
                  setValue: (v) => ref.read(layoutProv.notifier).setAndSave(v),
                ),
              ),
              if (resizableGrid)
                IntCounterTile(
                  label: "Width",
                  setValue: (v) => ref.read(widthProv.notifier).setAndSave(v),
                  readValue: ref.watch(widthProv),
                ),
              if (resizableGrid)
                IntCounterTile(
                  label: "Height",
                  setValue: (v) => ref.read(heightProv.notifier).setAndSave(v),
                  readValue: ref.watch(heightProv),
                ),
              if (resizableGrid) const DividerTitle("Scales"),
              if (resizableGrid)
                ListTile(
                  title: const Text("Scale"),
                  trailing: DropdownEnum<Scale>(
                    values: Scale.values,
                    readValue: ref.watch(scaleProv),
                    setValue: (v) => ref.read(scaleProv.notifier).setAndSave(v),
                  ),
                ),
              if (resizableGrid)
                ListTile(
                  title: const Text("Scale Root Note"),
                  subtitle: const Text("Root Note of the selected scale"),
                  trailing: DropdownRootNote(
                    setValue: (v) {
                      ref.read(rootProv.notifier).setAndSave(v);
                      ref.read(baseProv.notifier).setAndSave(v);
                    },
                    readValue: ref.watch(rootProv),
                  ),
                ),
              if (resizableGrid)
                ListTile(
                  title: const Text("Base Note"),
                  subtitle: const Text(
                      "The lowest Note in the Grid, on the bottom left"),
                  trailing: DropdownRootNote(
                    setValue: (v) => ref.read(baseProv.notifier).setAndSave(v),
                    readValue: ref.watch(baseProv),
                  ),
                ),
              if (resizableGrid)
                IntCounterTile(
                  label: "Base Octave",
                  readValue: ref.watch(baseOctaveProv),
                  setValue: (v) =>
                      ref.read(baseOctaveProv.notifier).setAndSave(v),
                  resetFunction: ref.read(baseOctaveProv.notifier).reset,
                ),
              const DividerTitle("Controls"),
              if (resizableGrid)
                ListTile(
                  title: const Text("Octave Buttons"),
                  subtitle:
                      const Text("Adds Octave control buttons next to pads"),
                  trailing: Switch(
                      value: ref.watch(octaveButtonsProv),
                      onChanged: (v) =>
                          ref.read(octaveButtonsProv.notifier).setAndSave(v)),
                ),
              ListTile(
                title: const Text("Sustain Button"),
                subtitle: const Text(
                    "Adds a Sustain button next to pads. Lock ON by double-tapping"),
                trailing: Switch(
                    value: ref.watch(sustainButtonProv),
                    onChanged: (v) =>
                        ref.read(sustainButtonProv.notifier).setAndSave(v)),
              ),
              ListTile(
                title: const Text("Mod Wheel"),
                subtitle: const Text("Adds Mod Wheel Slider next to pads"),
                trailing: Switch(
                    value: ref.watch<bool>(modWheelProv),
                    onChanged: (v) =>
                        ref.read(modWheelProv.notifier).setAndSave(v)),
              ),
              ListTile(
                title: const Text("Velocity"),
                subtitle: const Text("Adds Velocity Slider next to pads"),
                trailing: Switch(
                    value: ref.watch(velocitySliderProv),
                    onChanged: (v) =>
                        ref.read(velocitySliderProv.notifier).setAndSave(v)),
              ),
              ListTile(
                title: const Text("Pitch Bend"),
                subtitle: const Text("Adds Pitch Bend slider next to pads"),
                trailing: Switch(
                    value: ref.watch(pitchBendProv),
                    onChanged: (v) =>
                        ref.read(pitchBendProv.notifier).setAndSave(v)),
              ),
              NonLinearSliderTile(
                label: "Pitch Bend Return",
                subtitle:
                    "Set time in milliseconds for Pitch Bend Slider to ease back to Zero",
                readValue: ref.watch(pitchBendEaseStepProv),
                setValue: (v) =>
                    ref.read(pitchBendEaseStepProv.notifier).set(v),
                resetFunction: ref.read(pitchBendEaseStepProv.notifier).reset,
                displayValue: ref.watch(pitchBendEaseUsable) == 0
                    ? "Off"
                    : ref.watch(pitchBendEaseUsable) < 1000
                        ? "${ref.watch(pitchBendEaseUsable)} ms"
                        : "${ref.watch(pitchBendEaseUsable) / 1000} s",
                start: 0,
                steps: Timing.releaseDelayTimes.length - 1,
                onChangeEnd: ref.read(pitchBendEaseStepProv.notifier).save,
              ),
              const DividerTitle("Display"),
              ListTile(
                title: const Text("Pad Labels"),
                subtitle:
                    const Text("Choose between Midi values and Note names"),
                trailing: DropdownEnum<PadLabels>(
                  values: PadLabels.values,
                  readValue: ref.watch<PadLabels>(padLabelsProv),
                  setValue: (v) =>
                      ref.read(padLabelsProv.notifier).setAndSave(v),
                ),
              ),
              ListTile(
                title: const Text("Pad Colors"),
                subtitle:
                    const Text("Colorize pads by distance to the root note"),
                trailing: DropdownEnum<PadColors>(
                  values: PadColors.values,
                  readValue: ref.watch(padColorsProv),
                  setValue: (v) =>
                      ref.read(padColorsProv.notifier).setAndSave(v),
                ),
              ),
              IntSliderTile(
                label: "Hue",
                min: 0,
                max: 360,
                subtitle: "Root Note hue on the RGB color wheel",
                trailing: Text(ref.watch(baseHueProv).toString()),
                readValue: ref.watch(baseHueProv),
                setValue: (v) => ref.read(baseHueProv.notifier).set(v),
                resetValue: ref.read(baseHueProv.notifier).reset,
                onChangeEnd: ref.read(baseHueProv.notifier).save,
              ),
              ListTile(
                title: const Text("Show Velocity"),
                subtitle: const Text(
                    "Show visual feedback on the pad indicating the sent Velocity"),
                trailing: Switch(
                    value: ref.watch(velocityVisualProv),
                    onChanged: (v) =>
                        ref.read(velocityVisualProv.notifier).setAndSave(v)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
