import 'package:beat_pads/screen_pads_menu/drop_down_playmode.dart';
import 'package:beat_pads/screen_pads_menu/slider_int.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:beat_pads/services/_services.dart';

class MenuInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Settings>(builder: (context, settings, child) {
      return ListView(
        children: <Widget>[
          ListTile(
            title: Divider(),
            trailing: Text(
              "Input Settings",
              style: TextStyle(
                  fontSize: Theme.of(context).textTheme.headline5!.fontSize),
            ),
          ),
          ListTile(
            title: Text("Input Mode"),
            subtitle: Text("Sliding Behaviour, MPE and Aftertouch"),
            trailing: DropdownPlayMode(),
          ),
          if (settings.playMode == PlayMode.mpe ||
              settings.playMode == PlayMode.cc)
            ListTile(
              title: Text("2-D Modulation"),
              subtitle: settings.playMode == PlayMode.mpe
                  ? Text(
                      "Modulate PitchBend (Y Axis) and Slide (X Axis). Turn off to modulate only Aftertouch (Radius)")
                  : Text(
                      "Modulate two CC on the Y and X Axis, on channels above the current one. Turn off to modulate only one CC by Radius"),
              trailing: Switch(
                  value: settings.modulationXandY,
                  onChanged: (value) => settings.modulationXandY = value),
            ),
          if (settings.playMode.afterTouch)
            IntSliderTile(
              min: 5,
              max: 25,
              label: "Modulation Size",
              subtitle:
                  "Size of the modulation field relative to the screen width",
              trailing: Text("${(settings.modulationRadius * 100).toInt()}%"),
              readValue: (settings.modulationRadius * 100).toInt(),
              setValue: (v) => settings.modulationRadius = v / 100,
              resetValue: settings.resetModulationRadius,
            ),
          if (settings.playMode.afterTouch)
            IntSliderTile(
              min: 0,
              max: 30,
              label: "Modulation Deadzone",
              subtitle:
                  "Size of the non-reactive center of the modulation field, relative to the modulation field size",
              trailing: Text("${(settings.modulationDeadZone * 100).toInt()}%"),
              readValue: (settings.modulationDeadZone * 100).toInt(),
              setValue: (v) => settings.modulationDeadZone = v / 100,
              resetValue: settings.resetDeadZone,
            ),
        ],
      );
    });
  }
}
