import 'package:beat_pads/components/drop_down_interval.dart';
import 'package:beat_pads/components/drop_down_notes.dart';
import 'package:beat_pads/components/drop_down_numbers.dart';
import 'package:beat_pads/components/drop_down_root_note.dart';
import 'package:beat_pads/components/drop_down_scales.dart';
import 'package:beat_pads/components/label_credits.dart';
import 'package:beat_pads/components/label_rotate.dart';
import 'package:beat_pads/components/slider_channel_selector.dart';
import 'package:beat_pads/components/slider_midi_range.dart';
import 'package:beat_pads/components/slider_midival_selector.dart';
// import 'package:beat_pads/services/midi_utils.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:beat_pads/components/switch_wake_lock.dart';
import '../state/settings.dart';

class PadsMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Settings>(builder: (context, settings, child) {
      return ListView(
        children: <Widget>[
          RotateLabel(),
          ListTile(
            title: Text("Note Layout"),
            trailing: DropdownLayout(),
          ),
          ListTile(
            title: Text("Show Note Names"),
            trailing: Switch(
                value: settings.showNoteNames,
                onChanged: (value) {
                  settings.showNoteNames = value;
                }),
          ),
          ListTile(
            title: Text("Pad Grid Width"),
            trailing: DropdownNumbers(Dimension.width),
          ),
          ListTile(
            title: Text("Pad Grid Height"),
            trailing: DropdownNumbers(Dimension.height),
          ),
          ListTile(
            title: Text("Scale Root Note"),
            trailing: DropdownRootNote(
                setValue: (v) {
                  settings.baseNote = v + 36; // TEMP WHILE BASENOTE DISABLED
                  settings.rootNote = v;
                },
                readValue: settings.rootNote),
          ),
          ListTile(
            title: Text("Scale"),
            trailing: DropdownScales(),
          ),
          // TODO THIS IS FUCKED + ONLY SCALES MODE TOO
          // ListTile(
          //   title: Text("Base Note"),
          //   trailing: DropdownScaleNotes(
          //     setValue: (v) {
          //       settings.baseNote = v;
          //       // settings.rootNote = v % 12; // set with root note
          //     },
          //     readValue: settings.baseNote,
          //     rootNote: settings.rootNote,
          //     scale: settings.onlyScaleNotes ? settings.scale : null,
          //     showNoteValue: true,
          //   ),
          // ),
          if (settings.layout == Layout.continuous)
            ListTile(
              title: Text("Show Only Scale Notes"),
              trailing: Switch(
                  value: settings.onlyScaleNotes,
                  onChanged: (value) {
                    settings.onlyScaleNotes = !settings.onlyScaleNotes;
                  }),
            ),
          ListTile(
            title: Text("Random Velocity"),
            trailing: Switch(
                value: settings.randomVelocity,
                onChanged: (value) {
                  settings.randomizeVelocity = value;
                }),
          ),
          if (!settings.randomVelocity)
            MidiValueSelector(
              label: "Velocity",
              readValue: settings.velocity,
              setValue: (v) => settings.velocity = v,
              resetFunction: settings.resetVelocity,
            ),
          if (settings.randomVelocity)
            MidiRangeSelector(
              label: "Set Range",
              readMin: settings.velocityMin,
              readMax: settings.velocityMax,
              setMin: (v) => settings.velocityMin = v,
              setMax: (v) => settings.velocityMax = v,
              resetFunction: settings.resetVelocity,
            ),
          ChannelSelector(),
          ListTile(
            title: Text("Pitch Bender"),
            trailing: Switch(
                value: settings.pitchBend,
                onChanged: (value) {
                  settings.pitchBend = !settings.pitchBend;
                }),
          ),
          ListTile(
            title: Text("Lock Screen Button (Long Press)"),
            trailing: Switch(
                value: settings.lockScreenButton,
                onChanged: (value) {
                  settings.lockScreenButton = !settings.lockScreenButton;
                }),
          ),
          SwitchWakeLock(),
          CreditsLabel(),
        ],
      );
    });
  }
}
