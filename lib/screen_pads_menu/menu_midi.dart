import 'package:beat_pads/screen_pads_menu/slider_int.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:beat_pads/services/_services.dart';

import 'package:beat_pads/screen_pads_menu/slider_non_linear.dart';

import 'package:beat_pads/screen_pads_menu/slider_int_range.dart';

class MenuMidi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Settings>(builder: (context, settings, child) {
      return ListView(
        children: <Widget>[
          ListTile(
            title: Divider(),
            trailing: Text(
              "Midi Settings",
              style: TextStyle(
                  fontSize: Theme.of(context).textTheme.headline5!.fontSize),
            ),
          ),
          IntSliderTile(
            resetValue: settings.resetChannel,
            min: 1,
            max: 16,
            label: "Midi Channel",
            subtitle: "Master Channel to send and receive on",
            setValue: (v) => settings.channel = v - 1,
            readValue: settings.channel + 1,
          ),
          Divider(),
          ListTile(
            title: Text("Random Velocity"),
            subtitle: Text("Random Velocity within a given Range"),
            trailing: Switch(
                value: settings.randomVelocity,
                onChanged: (value) => settings.randomizeVelocity = value),
          ),
          if (!settings.randomVelocity)
            IntSliderTile(
              label: "Fixed Velocity",
              subtitle: "Velocity to send when pressing a Pad",
              readValue: settings.velocity,
              setValue: (v) => settings.velocity = v,
              resetValue: settings.resetVelocity,
            ),
          if (settings.randomVelocity)
            MidiRangeSelectorTile(
              label: "Random Velocity Range",
              readMin: settings.velocityMin,
              readMax: settings.velocityMax,
              setMin: (v) => settings.velocityMin = v,
              setMax: (v) => settings.velocityMax = v,
              resetFunction: settings.resetVelocity,
            ),
          Divider(),
          NonLinearSliderTile(
            label: "Auto Sustain",
            subtitle: "Delay in Milliseconds before sending NoteOff Message",
            readValue: settings.sustainTimeStep,
            setValue: (v) => settings.sustainTimeStep = v,
            resetFunction: () => settings.resetSustainTimeStep(),
            actualValue: "${settings.sustainTimeUsable} ms",
            start: 0,
            steps: 25,
          ),
          ListTile(
            title: Text("Send CC"),
            subtitle: Text(
                "Send Control Change Message along with Note, one Midi Channel higher than the Note"),
            trailing: Switch(
                value: settings.sendCC,
                onChanged: (value) => settings.sendCC = value),
          ),
        ],
      );
    });
  }
}
