import 'package:beat_pads/screen_pads_menu/drop_down_modulation.dart';
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
            title: const Divider(),
            trailing: Text(
              "Input Settings",
              style: TextStyle(
                  fontSize: Theme.of(context).textTheme.headline5!.fontSize),
            ),
          ),
          ListTile(
            title: const Text("Input Mode"),
            subtitle:
                const Text("Slidable Input, Polyphonic Aftertouch or MPE"),
            trailing: DropdownPlayMode(),
          ),
          if (settings.playMode == PlayMode.mpe)
            ListTile(
              title: const Text("2-D Modulation"),
              subtitle: const Text(
                  "Modulate 2 Values on the X and Y Axis. Turn off to modulate only 1 Value by Radius"),
              trailing: Switch(
                  value: settings.modulation2d,
                  onChanged: (value) => settings.modulation2d = value),
            ),
          if (settings.playMode == PlayMode.mpe && settings.modulation2d)
            ListTile(
              title: const Text("Modulation X-Axis"),
              subtitle: const Text("Modulate this parameter horizontally"),
              trailing: DropdownModulation(
                readValue: settings.modulation2dX,
                setValue: (v) => settings.modulation2dX = v,
                otherValue: settings.modulation2dY,
              ),
            ),
          if (settings.playMode == PlayMode.mpe && settings.modulation2d)
            ListTile(
              title: const Text("Modulation Y-Axis"),
              subtitle: const Text("Modulate this parameter vertically"),
              trailing: DropdownModulation(
                readValue: settings.modulation2dY,
                setValue: (v) => settings.modulation2dY = v,
                otherValue: settings.modulation2dX,
              ),
            ),
          if (settings.playMode == PlayMode.mpe &&
              settings.modulation2d == false)
            ListTile(
              title: const Text("Modulation by Radius"),
              subtitle: const Text(
                  "Modulate this parameter by the distance from the initial touch position"),
              trailing: DropdownModulation(
                dimensions: Dims.one,
                readValue: settings.modulation1dR,
                setValue: (v) => settings.modulation1dR = v,
              ),
            ),
          if (settings.playMode == PlayMode.mpe)
            IntSliderTile(
              min: 1,
              max: 48,
              label: "Pitchbend Range",
              subtitle:
                  "Semitone Range of MPE Pitchbend. 48 is the MPE default",
              trailing: Text("${settings.mpePitchbendRange}"),
              readValue: settings.mpePitchbendRange,
              setValue: (v) => settings.mpePitchbendRange = v,
              resetValue: settings.resetMPEPitchbendRange,
            ),
          if (settings.playMode.modulatable)
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
          if (settings.playMode.modulatable)
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
