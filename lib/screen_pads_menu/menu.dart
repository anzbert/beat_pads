import 'package:beat_pads/screen_beat_pads/_screen_beat_pads.dart';
import 'package:beat_pads/screen_pads_menu/slider_int.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:beat_pads/shared/_shared.dart';
import 'package:beat_pads/services/_services.dart';

import 'package:beat_pads/screen_home/_screen_home.dart';

import 'package:beat_pads/screen_pads_menu/counter_int.dart';
import 'package:beat_pads/screen_pads_menu/slider_non_linear.dart';
import 'package:beat_pads/screen_pads_menu/drop_down_layout.dart';
import 'package:beat_pads/screen_pads_menu/drop_down_int.dart';
import 'package:beat_pads/screen_pads_menu/drop_down_notes.dart';
import 'package:beat_pads/screen_pads_menu/drop_down_scales.dart';
import 'package:beat_pads/screen_pads_menu/label_rotate.dart';
import 'package:beat_pads/screen_pads_menu/slider_int_range.dart';
import 'package:beat_pads/screen_pads_menu/switch_wake_lock.dart';

class PadsMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Settings>(builder: (context, settings, child) {
      final bool variableGrid =
          settings.layout.variable; // Is the layout fixed or variable?

      return ListView(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  RotateLabel(),
                  IgnorePointer(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6.0),
                              child: BeatPadsScreen(),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          width: double.infinity,
                          child: FittedBox(
                            child: Text(
                              "Preview",
                              style: TextStyle(
                                color: Palette.lightGrey.color.withAlpha(175),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            title: Text("Layout"),
            subtitle: Text("Row Intervals and other Layouts"),
            trailing: DropdownLayout(),
          ),
          ListTile(
            title: Text("Show Note Names"),
            subtitle: Text("Switch between Names and Midi Values"),
            trailing: Switch(
                value: settings.showNoteNames,
                onChanged: (value) => settings.showNoteNames = value),
          ),
          Divider(),
          if (variableGrid)
            ListTile(
              title: Text("Grid Width"),
              trailing: DropdownNumbers(
                setValue: (v) => settings.width = v,
                readValue: settings.width,
              ),
            ),
          if (variableGrid)
            ListTile(
              title: Text("Grid Height"),
              trailing: DropdownNumbers(
                setValue: (v) => settings.height = v,
                readValue: settings.height,
              ),
            ),
          if (variableGrid) Divider(),
          if (variableGrid)
            ListTile(
              title: Text("Scale Root Note"),
              subtitle: Text("Higlight selected Scale with this Root Note"),
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
          if (variableGrid) Divider(),
          if (variableGrid)
            ListTile(
              title: Text("Base Note"),
              subtitle: Text("The lowest Note in the Grid on the bottom left"),
              trailing: DropdownRootNote(
                  setValue: (v) {
                    settings.base = v;
                  },
                  readValue: settings.base),
            ),
          if (variableGrid)
            IntCounter(
              label: "Base Octave",
              readValue: settings.baseOctave,
              setValue: (v) => settings.baseOctave = v,
              resetFunction: settings.resetBaseOctave,
            ),
          if (variableGrid)
            ListTile(
              title: Text("Show Octave Buttons"),
              subtitle: Text("Adds Base Octave Controls next to Pads"),
              trailing: Switch(
                  value: settings.octaveButtons,
                  onChanged: (value) => settings.octaveButtons = value),
            ),
          if (variableGrid) Divider(),
          ListTile(
            title: Text("Random Velocity"),
            subtitle: Text("Random Velocity Within a given Range"),
            trailing: Switch(
                value: settings.randomVelocity,
                onChanged: (value) => settings.randomizeVelocity = value),
          ),
          if (!settings.randomVelocity)
            IntSlider(
              label: "Fixed Velocity",
              readValue: settings.velocity,
              setValue: (v) => settings.velocity = v,
              resetValue: settings.resetVelocity,
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
          Divider(),
          NonLinearSlider(
            label: "Sustain",
            subtitle: "Delay before sending NoteOff Message in Milliseconds",
            readValue: settings.sustainTimeStep,
            setValue: (v) => settings.sustainTimeStep = v,
            resetFunction: () => settings.resetSustainTimeStep(),
            actualValue: settings.sustainTimeExp.toString(),
            start: settings.minSustainTimeStep,
            steps: 11,
          ),
          ListTile(
            title: Text("Pitch Bend"),
            subtitle: Text("Adds Pitch Bend Slider next to Pads"),
            trailing: Switch(
                value: settings.pitchBend,
                onChanged: (value) => settings.pitchBend = !settings.pitchBend),
          ),
          ListTile(
            title: Text("Send Control Change"),
            subtitle: Text("Send CC-ON (127) with Pad Note"),
            trailing: Switch(
                value: settings.sendCC,
                onChanged: (value) => settings.sendCC = value),
          ),
          IntSlider(
              min: 1,
              max: 16,
              label: "Midi Channel",
              setValue: (v) {
                Provider.of<MidiData>(context, listen: false).channel = v - 1;
              },
              readValue:
                  Provider.of<MidiData>(context, listen: true).channel + 1),
          Divider(),
          ListTile(
            title: Text("Lock Screen Button"),
            subtitle: Text("Adds Rotation Lock Button. Long Press to Use"),
            trailing: Switch(
                value: settings.lockScreenButton,
                onChanged: (value) =>
                    settings.lockScreenButton = !settings.lockScreenButton),
          ),
          SwitchWakeLock(),
          SnackMessageButton(
            label: "Clear Received Midi Buffer",
            message: "Received Midi Buffer cleared",
            onPressed:
                Provider.of<MidiData>(context, listen: false).rxNotesReset,
          ),
          InfoBox(
            header: "Beat Pads",
            body: [
              "Made by A. Mueller\n      [anzgraph.com]",
              "Dog Icon by 'catalyststuff'\n      [freepik.com]",
              "Logo Animated with Rive\n      [rive.app]",
              "Magic Tone Network / XpressPads by A. Samek\n      [xpresspads.com]",
              "Please send improvement suggestions to anzbert@gmail.com !"
            ],
          )
        ],
      );
    });
  }
}
