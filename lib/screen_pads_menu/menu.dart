import 'package:beat_pads/screen_beat_pads/_screen_beat_pads.dart';
import 'package:beat_pads/screen_pads_menu/box_credits.dart';
import 'package:beat_pads/screen_pads_menu/slider_int.dart';
import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command_messages.dart';
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
      final bool resizableGrid =
          settings.layout.props.resizable; // Is the layout fixed or resizable?

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
              subtitle: Text("Higlight selected Scale with this Root Note"),
              trailing: DropdownRootNote(
                  setValue: (v) => settings.rootNote = v,
                  readValue: settings.rootNote),
            ),
          if (resizableGrid)
            ListTile(
              title: Text("Scale"),
              trailing: DropdownScales(),
            ),
          if (resizableGrid) Divider(),
          if (resizableGrid)
            ListTile(
              title: Text("Base Note"),
              subtitle: Text("The lowest Note in the Grid on the bottom left"),
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
              title: Text("Show Octave Buttons"),
              subtitle: Text("Adds Base Octave Controls next to Pads"),
              trailing: Switch(
                  value: settings.octaveButtons,
                  onChanged: (value) => settings.octaveButtons = value),
            ),
          if (resizableGrid) Divider(),
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
          ListTile(
            title: Text("Sustain Button"),
            subtitle: Text("Adds Sustain-Pedal Button next to Pads"),
            trailing: Switch(
                value: settings.sustainButton,
                onChanged: (value) =>
                    settings.sustainButton = !settings.sustainButton),
          ),
          ListTile(
            title: Text("Pitch Bender"),
            subtitle: Text("Adds Pitch Bend Slider next to Pads"),
            trailing: Switch(
                value: settings.pitchBend,
                onChanged: (value) => settings.pitchBend = !settings.pitchBend),
          ),
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
                settings.channel = v - 1;
                Provider.of<MidiData>(context, listen: false).channel = v - 1;
              },
              readValue: settings.channel + 1),
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
            onPressed: () {
              Provider.of<MidiData>(context, listen: false).rxNotesReset();
              CCMessage(channel: settings.channel, controller: 123, value: 0)
                  .send(); // 'all notes off' message
            },
          ),
          CreditsBox(),
        ],
      );
    });
  }
}
