import 'package:beat_pads/screen_pads_menu/drop_down_playmode.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:beat_pads/services/_services.dart';

class MenuInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Settings>(builder: (context, settings, child) {
      // final bool resizableGrid =
      //     settings.layout.props.resizable; // Is the layout fixed or resizable?

      return ListView(
        children: <Widget>[
          ListTile(
            trailing: Text(
              "Input Settings",
              style: TextStyle(
                  fontSize: Theme.of(context).textTheme.headline5!.fontSize),
            ),
          ),
          ListTile(
            title: Text("Slide / Aftertouch"),
            subtitle: Text("Touch Sliding and Polyphonic Aftertouch"),
            trailing: DropdownPlayMode(),
          ),
        ],
      );
    });
  }
}
