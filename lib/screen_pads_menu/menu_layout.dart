import 'package:beat_pads/screen_pads_menu/preview_pads.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:beat_pads/services/_services.dart';

import 'package:beat_pads/screen_pads_menu/counter_int.dart';
import 'package:beat_pads/screen_pads_menu/slider_non_linear.dart';
import 'package:beat_pads/screen_pads_menu/drop_down_layout.dart';
import 'package:beat_pads/screen_pads_menu/drop_down_int.dart';
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
          Flexible(
            fit: FlexFit.loose,
            flex: 2,
            child: FittedBox(child: Preview()),
          ),
          Expanded(
            flex: 3,
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: Divider(),
                  trailing: Text(
                    "Layout Settings",
                    style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.headline5!.fontSize),
                  ),
                ),
                ListTile(
                  title: Text("Layout"),
                  subtitle: Text("Row Intervals and other Layouts"),
                  trailing: DropdownLayout(),
                ),
                Divider(),
                if (resizableGrid)
                  ListTile(
                    title: Text("Grid Width"),
                    trailing: DropdownNumbers(
                      setValue: (v) => settings.width = v,
                      readValue: settings.width,
                    ),
                  ),
                if (resizableGrid)
                  ListTile(
                    title: Text("Grid Height"),
                    trailing: DropdownNumbers(
                      setValue: (v) => settings.height = v,
                      readValue: settings.height,
                    ),
                  ),
                if (resizableGrid) Divider(),
                if (resizableGrid)
                  ListTile(
                    title: Text("Scale Root Note"),
                    subtitle:
                        Text("Higlight selected Scale with this Root Note"),
                    trailing: DropdownRootNote(
                        setValue: (v) => settings.rootNote = v,
                        readValue: settings.rootNote),
                  ),
                if (resizableGrid)
                  ListTile(
                    title: Text("Scale"),
                    trailing: DropdownScales(),
                  ),
                ListTile(
                  title: Text("Show Note Names"),
                  subtitle: Text("Switch between Names and Midi Values"),
                  trailing: Switch(
                      value: settings.showNoteNames,
                      onChanged: (value) => settings.showNoteNames = value),
                ),
                if (resizableGrid) Divider(),
                if (resizableGrid)
                  ListTile(
                    title: Text("Base Note"),
                    subtitle:
                        Text("The lowest Note in the Grid on the bottom left"),
                    trailing: DropdownRootNote(
                        setValue: (v) {
                          settings.base = v;
                        },
                        readValue: settings.base),
                  ),
                if (resizableGrid)
                  IntCounter(
                    label: "Base Octave",
                    readValue: settings.baseOctave,
                    setValue: (v) => settings.baseOctave = v,
                    resetFunction: settings.resetBaseOctave,
                  ),
                if (resizableGrid)
                  ListTile(
                    title: Text("Octave Buttons"),
                    subtitle: Text("Adds Base Octave Controls next to Pads"),
                    trailing: Switch(
                        value: settings.octaveButtons,
                        onChanged: (value) => settings.octaveButtons = value),
                  ),
                if (resizableGrid) Divider(),
                ListTile(
                  title: Text("Sustain Button"),
                  subtitle: Text(
                      "Adds Sustain Button next to Pads. LOCK Sustain ON by pushing and sliding away from Button"),
                  trailing: Switch(
                      value: settings.sustainButton,
                      onChanged: (value) =>
                          settings.sustainButton = !settings.sustainButton),
                ),
                ListTile(
                  title: Text("Mod Wheel"),
                  subtitle: Text("Adds Mod Wheel Slider next to Pads"),
                  trailing: Switch(
                      value: settings.modWheel,
                      onChanged: (value) =>
                          settings.modWheel = !settings.modWheel),
                ),
                ListTile(
                  title: Text("Pitch Bender"),
                  subtitle: Text("Adds Pitch Bend Slider next to Pads"),
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
                    resetFunction: () => settings.resetPitchBendEase(),
                    actualValue: "${settings.pitchBendEaseCalculated} ms",
                    start: 0,
                    steps: 25,
                  ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
