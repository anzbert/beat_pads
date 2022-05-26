import 'package:beat_pads/screen_pads_menu/drop_down_modulation.dart';
import 'package:beat_pads/screen_pads_menu/drop_down_playmode.dart';
import 'package:beat_pads/screen_pads_menu/slider_int.dart';
import 'package:beat_pads/screen_pads_menu/slider_modulation_size.dart';
import 'package:beat_pads/screen_pads_menu/slider_non_linear.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:beat_pads/services/services.dart';

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
                const Text("Slidable Behavious, Polyphonic Aftertouch and MPE"),
            trailing: DropdownPlayMode(),
          ),
          const Divider(),
          if (settings.playMode == PlayMode.mpe)
            ListTile(
              title: const Text("2-D Modulation"),
              subtitle: const Text(
                  "Modulate 2 Values on X and Y or only 1 by Radius"),
              trailing: Switch(
                  value: settings.modulation2D,
                  onChanged: (value) => settings.modulation2D = value),
            ),
          if (settings.playMode == PlayMode.mpe && settings.modulation2D)
            ListTile(
              title: const Text("X-Axis"),
              // subtitle: const Text("Modulate this parameter horizontally"),
              trailing: DropdownModulation(
                readValue: settings.mpe2DX,
                setValue: (v) => settings.mpe2DX = v,
                otherValue: settings.mpe2DY,
              ),
            ),
          if (settings.playMode == PlayMode.mpe && settings.modulation2D)
            ListTile(
              title: const Text("Y-Axis"),
              // subtitle: const Text("Modulate this parameter vertically"),
              trailing: DropdownModulation(
                readValue: settings.mpe2DY,
                setValue: (v) => settings.mpe2DY = v,
                otherValue: settings.mpe2DX,
              ),
            ),
          if (settings.playMode == PlayMode.mpe &&
              settings.modulation2D == false)
            ListTile(
              title: const Text("Radius"),
              // subtitle: const Text(
              //     "Modulate this parameter by the distance from the initial touch position"),
              trailing: DropdownModulation(
                dimensions: Dims.one,
                readValue: settings.mpe1DRadius,
                setValue: (v) => settings.mpe1DRadius = v,
              ),
            ),
          if (settings.playMode == PlayMode.mpe) const Divider(),
          NonLinearSliderTile(
            label: "Release Delay",
            subtitle: settings.playMode.modulatable
                ? "Modulation Easing and NoteOff delay in Milliseconds"
                : "NoteOff delay in Milliseconds",
            readValue: settings.sustainTimeStep,
            setValue: (v) => settings.sustainTimeStep = v,
            resetFunction: () => settings.resetSustainTimeStep(),
            displayValue: settings.sustainTimeUsable < 1000
                ? "${settings.sustainTimeUsable} ms"
                : "${settings.sustainTimeUsable / 1000} s",
            start: 0,
            steps: Timing.timingSteps.length ~/ 1.5,
          ),
          if (settings.playMode == PlayMode.mpe)
            if (settings.mpe1DRadius.exclusiveGroup == Group.pitch ||
                settings.mpe2DX.exclusiveGroup == Group.pitch ||
                settings.mpe2DY.exclusiveGroup == Group.pitch)
              IntSliderTile(
                min: 1,
                max: 48,
                label: "Pitchbend Range",
                subtitle: "Maximum MPE Pitchbend in Semitones",
                trailing: Text("${settings.mpePitchbendRange} st"),
                readValue: settings.mpePitchbendRange,
                setValue: (v) => settings.mpePitchbendRange = v,
                resetValue: settings.resetMPEPitchbendRange,
              ),
          if (settings.playMode.singleChannel)
            ListTile(
              title: const Text("Send CC"),
              subtitle: const Text(
                  "Send CC along with Note one Midi Channel above. Useful for triggering note dependant effects"),
              trailing: Switch(
                  value: settings.sendCC,
                  onChanged: (value) => settings.sendCC = value),
            ),
          if (settings.playMode.modulatable) const Divider(),
          if (settings.playMode.modulatable)
            ModSizeSliderTile(
              min: 5,
              max: 25,
              label: "Modulation Size",
              subtitle:
                  "Modulation field radius, relative to the pad screen width",
              trailing: Text("${(settings.modulationRadius * 100).toInt()}%"),
              readValue: (settings.modulationRadius * 100).toInt(),
              setValue: (v) => settings.modulationRadius = v / 100,
              resetValue: settings.resetModulationRadius,
            ),
          if (settings.playMode.modulatable)
            ModSizeSliderTile(
              min: 10,
              max: 40,
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
