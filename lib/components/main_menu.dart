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
