import 'package:beat_pads/screen_pads_menu/drop_down_colors.dart';
import 'package:beat_pads/screen_pads_menu/drop_down_padlabels.dart';
import 'package:beat_pads/screen_pads_menu/preview_pads.dart';
import 'package:beat_pads/screen_pads_menu/slider_int.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:beat_pads/services/services.dart';

import 'package:beat_pads/screen_pads_menu/counter_int.dart';
import 'package:beat_pads/screen_pads_menu/slider_non_linear.dart';
import 'package:beat_pads/screen_pads_menu/drop_down_layout.dart';
import 'package:beat_pads/screen_pads_menu/drop_down_notes.dart';
import 'package:beat_pads/screen_pads_menu/drop_down_scales.dart';

class MenuLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Settings>(builder: (context, settings, child) {
      final bool resizableGrid =
          settings.layout.props.resizable; // Is the layout fixed or resizable?
      bool isPortrait =
          MediaQuery.of(context).orientation.name == "portrait" ? true : false;

      return Flex(
        direction: isPortrait ? Axis.vertical : Axis.horizontal,
        crossAxisAlignment:
            isPortrait ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          const Flexible(
            fit: FlexFit.tight,
            flex: 2,
            child: FittedBox(child: Preview()),
          ),
          Expanded(
            flex: 3,
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: const Divider(),
                  trailing: Text(
                    "Layout Settings",
                    style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.headline5!.fontSize),
                  ),
                ),
                ListTile(
                  title: const Text("Layout"),
                  trailing: DropdownLayout(),
                ),
                const Divider(),
                if (resizableGrid)
                  IntCounterTile(
                    label: "Width",
                    setValue: (v) => settings.width = v,
                    readValue: settings.width,
                  ),
                if (resizableGrid)
                  IntCounterTile(
                    label: "Height",
                    setValue: (v) => settings.height = v,
                    readValue: settings.height,
                  ),
                if (resizableGrid) const Divider(),
                if (resizableGrid)
                  ListTile(
                    title: const Text("Scale"),
                    trailing: DropdownScales(),
                  ),
                if (resizableGrid)
                  ListTile(
                    title: const Text("Scale Root Note"),
                    subtitle: const Text(
                        "Higlight selected Scale with this Root Note"),
                    trailing: DropdownRootNote(
                        setValue: (v) => settings.rootNote = v,
                        readValue: settings.rootNote),
                  ),
                if (resizableGrid) const Divider(),
                if (resizableGrid)
                  ListTile(
                    title: const Text("Base Note"),
                    subtitle: const Text(
                        "The lowest Note in the Grid on the bottom left"),
                    trailing: DropdownRootNote(
                        setValue: (v) {
                          settings.base = v;
                        },
                        readValue: settings.base),
                  ),
                if (resizableGrid)
                  IntCounterTile(
                    label: "Base Octave",
                    readValue: settings.baseOctave,
                    setValue: (v) => settings.baseOctave = v,
                    resetFunction: settings.resetBaseOctave,
                  ),
                if (resizableGrid)
                  ListTile(
                    title: const Text("Octave Buttons"),
                    subtitle:
                        const Text("Adds Base Octave Controls next to Pads"),
                    trailing: Switch(
                        value: settings.octaveButtons,
                        onChanged: (value) => settings.octaveButtons = value),
                  ),
                if (resizableGrid) const Divider(),
                ListTile(
                  title: const Text("Sustain Button"),
                  subtitle: const Text(
                      "Adds Sustain Button next to Pads. Lock ON by double-tap or sliding off the Button"),
                  trailing: Switch(
                      value: settings.sustainButton,
                      onChanged: (value) =>
                          settings.sustainButton = !settings.sustainButton),
                ),
                ListTile(
                  title: const Text("Pitch Bender"),
                  subtitle: const Text("Adds Pitch Bend Slider next to Pads"),
                  trailing: Switch(
                      value: settings.pitchBend,
                      onChanged: (value) =>
                          settings.pitchBend = !settings.pitchBend),
                ),
                if (settings.pitchBend)
                  NonLinearSliderTile(
                    label: "Pitch Bend Easing",
                    subtitle:
                        "Set time in Milliseconds for Pitch Bend Slider to ease back to Zero",
                    readValue: settings.pitchBendEase,
                    setValue: (v) => settings.pitchBendEase = v,
                    resetFunction: () => settings.resetPitchBendEase,
                    displayValue: settings.pitchBendEaseUsable < 1000
                        ? "${settings.pitchBendEaseUsable} ms"
                        : "${settings.pitchBendEaseUsable / 1000} s",
                    start: 0,
                    steps: Timing.timingSteps.length - 1,
                    onChangeEnd: settings.prefs.settings.pitchBendEase.save,
                  ),
                ListTile(
                  title: const Text("Mod Wheel"),
                  subtitle: const Text("Adds Mod Wheel Slider next to Pads"),
                  trailing: Switch(
                      value: settings.modWheel,
                      onChanged: (value) =>
                          settings.modWheel = !settings.modWheel),
                ),
                ListTile(
                  title: const Text("Velocity"),
                  subtitle: const Text("Adds Velocity Slider next to Pads"),
                  trailing: Switch(
                      value: settings.velocitySlider,
                      onChanged: (value) =>
                          settings.velocitySlider = !settings.velocitySlider),
                ),
                const Divider(),
                ListTile(
                  title: const Text("Pad Labels"),
                  subtitle:
                      const Text("Choose between Midi Values and Note Names"),
                  trailing: DropdownPadLabels(),
                ),
                ListTile(
                  title: const Text("Pad Colors"),
                  subtitle: const Text("Colorize Pads by Distance to the Root"),
                  trailing: DropdownPadColors(),
                ),
                IntSliderTile(
                  label: "Hue",
                  min: 0,
                  max: 360,
                  subtitle: "Root Note Hue on the RGB Color Wheel",
                  trailing: Text(settings.baseHue.toString()),
                  readValue: settings.baseHue,
                  setValue: (v) => settings.baseHue = v,
                  resetValue: settings.resetBaseHue,
                  onChangeEnd: settings.prefs.settings.baseHue.save,
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
