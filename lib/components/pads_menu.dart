import 'package:beat_pads/components/button_reset.dart';
import 'package:beat_pads/components/drop_down_notes.dart';
import 'package:beat_pads/components/label_info_box.dart';
import 'package:beat_pads/components/slider_non_linear.dart';
import 'package:beat_pads/services/pads_layouts.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:beat_pads/state/settings.dart';

import 'package:beat_pads/components/drop_down_layout.dart';
import 'package:beat_pads/components/drop_down_numbers.dart';
import 'package:beat_pads/components/drop_down_root_note.dart';
import 'package:beat_pads/components/drop_down_scales.dart';
import 'package:beat_pads/components/label_rotate.dart';
import 'package:beat_pads/components/slider_channel_selector.dart';
import 'package:beat_pads/components/slider_midi_range.dart';
import 'package:beat_pads/components/slider_midival_selector.dart';
import 'package:beat_pads/components/switch_wake_lock.dart';

class PadsMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Settings>(builder: (context, settings, child) {
      // Is the layout fixed or variable? (in size, base note, etc...):
      final bool variableGrid = settings.layout.variable;

      return ListView(
        children: <Widget>[
          RotateLabel(),
          ListTile(
            title: Text("Layout"),
            subtitle: Text("Row Intervals and other Note Layouts"),
            trailing: DropdownLayout(),
          ),
          ListTile(
            title: Text("Show Note Names"),
            subtitle: Text("Switch between Names and Midi Values"),
            trailing: Switch(
                value: settings.showNoteNames,
                onChanged: (value) => settings.showNoteNames = value),
          ),
          if (variableGrid)
            ListTile(
              title: Text("Grid Width"),
              trailing: DropdownNumbers(Dimension.width),
            ),
          if (variableGrid)
            ListTile(
              title: Text("Grid Height"),
              trailing: DropdownNumbers(Dimension.height),
            ),
          if (variableGrid)
            ListTile(
              title: Text("Root Note"),
              trailing: DropdownRootNote(
                  setValue: (v) {
                    settings.baseNote = v + 36; // TEMP WHILE BASENOTE DISABLED
                    settings.rootNote = v;
                  },
                  readValue: settings.rootNote),
            ),
          if (variableGrid)
            ListTile(
              title: Text("Scale"),
              trailing: DropdownScales(),
            ),
          if (variableGrid)
            ListTile(
              title: Text("Lowest Note"),
              subtitle: Text("The bottom left Note in the Grid"),
              trailing: DropdownScaleNotes(
                setValue: (v) => settings.baseNote = v,
                readValue: settings.baseNote,
                rootNote: settings.rootNote,
                layout: settings.layout,
                scale: settings.scale,
              ),
            ),
          ListTile(
            title: Text("Random Velocity"),
            subtitle: Text("Random Velocity Within a given Range"),
            trailing: Switch(
                value: settings.randomVelocity,
                onChanged: (value) => settings.randomizeVelocity = value),
          ),
          if (!settings.randomVelocity)
            MidiValueSelector(
              label: "Fixed Velocity",
              readValue: settings.velocity,
              setValue: (v) => settings.velocity = v,
              resetFunction: settings.resetVelocity,
            ),
          if (settings.randomVelocity)
            MidiRangeSelector(
              label: "Random Velocity Range",
              readMin: settings.velocityMin,
              readMax: settings.velocityMax,
              setMin: (v) => settings.velocityMin = v,
              setMax: (v) => settings.velocityMax = v,
              resetFunction: settings.resetVelocity,
            ),
          NonLinearSlider(
            label: "Sustain Time",
            subtitle: "How long Notes are Sustained in Milliseconds",
            readValue: settings.sustainTimeStep,
            setValue: (v) => settings.sustainTimeStep = v,
            resetFunction: () => settings.resetSustainTimeStep(),
            actualValue: settings.sustainTimeExp.toString(),
            steps: 11,
          ),
          ListTile(
            title: Text("Send Control Change"),
            subtitle: Text("Send CC-ON (127) with Pad Note"),
            trailing: Switch(
                value: settings.sendCC,
                onChanged: (value) => settings.sendCC = value),
          ),
          ChannelSelector(),
          ListTile(
            title: Text("Pitch Bend"),
            subtitle: Text("Adds Pitch Bend Slider to Pad Screen"),
            trailing: Switch(
                value: settings.pitchBend,
                onChanged: (value) => settings.pitchBend = !settings.pitchBend),
          ),
          ListTile(
            title: Text("Lock Screen Button"),
            subtitle: Text("Adds Rotation Lock Button. Long Press to Use"),
            trailing: Switch(
                value: settings.lockScreenButton,
                onChanged: (value) =>
                    settings.lockScreenButton = !settings.lockScreenButton),
          ),
          SwitchWakeLock(),
          ResetButton(),
          InfoBox(
            [
              "Beat Pads v0.3.2\n",
              "Made by A. Mueller\n      [anzgraph.com]\n",
              "Dog Icon by 'catalyststuff'\n      [freepik.com]\n",
              "Logo Animated with Rive\n      [rive.app]\n",
              "Magic Tone Network / XpressPads by A. Samek\n      [xpresspads.com]\n"
            ],
            header: "Credits",
          )
        ],
      );
    });
  }
}
