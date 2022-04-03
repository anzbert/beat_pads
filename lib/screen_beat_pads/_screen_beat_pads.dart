import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:beat_pads/screen_home/_screen_home.dart';

import 'package:beat_pads/screen_beat_pads/button_lock_screen.dart';
import 'package:beat_pads/screen_beat_pads/buttons_octave.dart';
import 'package:beat_pads/screen_beat_pads/pads.dart';
import 'package:beat_pads/screen_beat_pads/slider_pitch_bend.dart';

class BeatPads extends StatelessWidget {
  const BeatPads({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton:
          Provider.of<Settings>(context, listen: true).lockScreenButton
              ? LockScreenButton()
              : null,
      body: Hero(
        tag: "toPads",
        child: SafeArea(
          child: Row(
            children: [
              // OCTAVE BUTTONS
              if (Provider.of<Settings>(context, listen: true).octaveButtons)
                SizedBox(width: 10),
              if (Provider.of<Settings>(context, listen: true).octaveButtons)
                OctaveButtons(),

              // PITCH BEND
              if (Provider.of<Settings>(context, listen: true).pitchBend)
                SizedBox(width: 20),
              if (Provider.of<Settings>(context, listen: true).pitchBend)
                PitchBender(),

              // PADS
              Expanded(flex: 1, child: VariablePads())
            ],
          ),
        ),
      ),
    );
  }
}
