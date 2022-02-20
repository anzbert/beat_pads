import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './settings.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          Consumer<Settings>(builder: (context, settings, child) {
            return ListTile(
              title: Text("Show Note Names"),
              trailing: Switch(
                value: settings.noteNames,
                onChanged: (value) {
                  settings.showNoteNames(value);
                },
              ),
            );
          })
        ],
      ),
    );
  }
}
