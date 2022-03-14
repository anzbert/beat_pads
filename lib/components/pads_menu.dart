import 'package:beat_pads/components/drop_down_numbers.dart';
import 'package:beat_pads/components/drop_down_scales.dart';
import 'package:beat_pads/state/receiver.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';
import '../state/settings.dart';
import '../services/midi_utils.dart';

class _PadsMenuState extends State<PadsMenu> {
  bool wakeLock = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<Settings>(builder: (context, settings, child) {
      return ListView(
        children: <Widget>[
          Card(
            margin: EdgeInsets.fromLTRB(8, 30, 8, 8),
            elevation: 5,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.rotate_right),
                  Text(
                    " : Beat Pads",
                    style: TextStyle(
                      // height: 1.5,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
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
            title: Text("Scale"),
            trailing: DropdownScales(),
          ),
          ListTile(
            title: Text("Only Scale Notes-not working yet"),
            trailing: Switch(
                value: settings.onlyScaleNotes,
                onChanged: (value) {
                  settings.onlyScaleNotes = !settings.onlyScaleNotes;
                }),
          ),
          ListTile(
            title: Text("Pitch Bender"),
            trailing: Switch(
                value: settings.pitchBend,
                onChanged: (value) {
                  settings.pitchBend = !settings.pitchBend;
                }),
          ),
          ListTile(
            title: Text("Wake Lock"),
            trailing: Switch(
                value: wakeLock,
                onChanged: (value) {
                  setState(() {
                    wakeLock = !wakeLock;
                  });
                  Wakelock.toggle(enable: wakeLock);
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
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Row(
                  children: [
                    Text("Base Note"),
                    TextButton(
                      onPressed: () => settings.resetBaseNote(),
                      child: Text("Reset"),
                    )
                  ],
                ),
                trailing: Text(
                    "${getNoteName(settings.baseNote)}  (${settings.baseNote.toString()})"),
              ),
              Slider(
                min: 0,
                max: (127 - settings.width * settings.height).toDouble(),
                value: settings.baseNote.toDouble(),
                onChanged: (value) {
                  settings.baseNote = value.toInt();
                },
              ),
            ],
          ),
          Consumer<MidiReceiver>(
            builder: (context, receiver, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Row(
                      children: [
                        Text("Channel"),
                        TextButton(
                          onPressed: () => receiver.resetChannel(),
                          child: Text("Reset"),
                        )
                      ],
                    ),
                    trailing: Text("${receiver.channel + 1}"),
                  ),
                  Slider(
                    min: 0,
                    max: 15,
                    value: receiver.channel.toDouble(),
                    onChanged: (value) {
                      receiver.channel = value.toInt();
                    },
                  ),
                ],
              );
            },
          ),
          ListTile(
            title: Text("Randomized Velocity"),
            trailing: Switch(
                value: settings.randomVelocity,
                onChanged: (value) {
                  settings.randomizeVelocity = value;
                }),
          ),
          if (!settings.randomVelocity)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Row(
                    children: [
                      Text("Velocity"),
                      TextButton(
                        onPressed: () => settings.resetVelocity(),
                        child: Text("Reset"),
                      )
                    ],
                  ),
                  trailing: Text(settings.velocity.toString()),
                ),
                Slider(
                  min: 0,
                  max: 127,
                  value: settings.velocity.toDouble(),
                  onChanged: (value) {
                    settings.velocity = value.toInt();
                  },
                ),
              ],
            ),
          if (settings.randomVelocity)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Row(
                    children: [
                      Text("Set Range"),
                      TextButton(
                        onPressed: () => settings.resetVelocity(),
                        child: Text("Reset"),
                      ),
                    ],
                  ),
                  trailing:
                      Text("${settings.velocityMin} - ${settings.velocityMax}"),
                ),
                RangeSlider(
                  values: RangeValues(settings.velocityMin.toDouble(),
                      settings.velocityMax.toDouble()),
                  max: 127,
                  // divisions: 127,
                  labels: RangeLabels(
                    "Min",
                    "Max",
                  ),
                  onChanged: (RangeValues values) {
                    settings.velocityMin = values.start.toInt();
                    settings.velocityMax = values.end.toInt();
                  },
                ),
              ],
            ),
          Card(
            margin: EdgeInsets.fromLTRB(8, 30, 8, 8),
            elevation: 5,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("BeatPads v0.1\n      February 2022\n"),
                  Text("Made by anzbert\n      [anzgraph.com]\n"),
                  Text("Dog Icon by 'catalyststuff'\n      [freepik.com]\n"),
                  Text("Logo Animated with Rive\n      [rive.app]"),
                ],
              ),
            ),
          )
        ],
      );
    });
  }

  @override
  void dispose() {
    Wakelock.disable();
    super.dispose();
  }
}

class PadsMenu extends StatefulWidget {
  const PadsMenu({Key? key}) : super(key: key);

  @override
  State<PadsMenu> createState() => _PadsMenuState();
}
