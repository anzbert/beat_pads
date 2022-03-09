import 'package:beat_pads/services/receiver.dart';
import 'package:flutter/material.dart';
import 'package:beat_pads/screens/config_screen.dart';

import 'package:provider/provider.dart';
import '../state/settings.dart';
import '../services/utils.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Consumer<Settings>(builder: (context, settings, child) {
        return ListView(
          children: <Widget>[
            ListTile(
              title: Text("Show Note Names"),
              trailing: Switch(
                  value: settings.noteNames,
                  onChanged: (value) {
                    settings.showNoteNames(value);
                  }),
            ),
            Divider(),
            ListTile(
              title: Text("Pitch Bender"),
              trailing: Switch(
                  value: settings.pitchBend,
                  onChanged: (value) {
                    settings.pitchBend = !settings.pitchBend;
                  }),
            ),
            Divider(),
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
                  max: 112,
                  value: settings.baseNote.toDouble(),
                  onChanged: (value) {
                    settings.baseNote = value.toInt();
                  },
                ),
              ],
            ),
            Divider(),
            Consumer<MidiReceiver>(
              builder: (context, receiver, child) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: Text("Channel"),
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
            Divider(),
            ListTile(
              title: Text("Randomised Velocity"),
              trailing: Switch(
                  value: settings.randomVelocity,
                  onChanged: (value) {
                    settings.randomizeVelocity(value);
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
                    trailing: Text(
                        "${settings.velocityMin} - ${settings.velocityMax}"),
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
            Divider(),
            Center(
              child: ElevatedButton(
                child: Text("Select Midi Devices"),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ConfigScreen()),
                  );
                },
              ),
            ),
            Divider(),
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
      }),
    );
  }
}
