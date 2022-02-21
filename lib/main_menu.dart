import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'settings.dart';
import "./services/utils.dart";

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
                  title: Text("Base Note"),
                  trailing: Text(
                      "${getNoteName(settings.baseNote)}  (${settings.baseNote.toString()})"),
                  // dense: true,
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
                child: Text("Reset To Defaults"),
                onPressed: () {
                  settings.reset();
                },
              ),
            ),
            Divider(),
            Card(
              child: Text("3rd Party sources from:\n Blabla.com"),
            )
          ],
        );
      }),
    );
  }
}
