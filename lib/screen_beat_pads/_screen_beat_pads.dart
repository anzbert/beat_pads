import 'package:beat_pads/screen_beat_pads/buttons_controls.dart';
import 'package:beat_pads/screen_beat_pads/slide_pads.dart';
import 'package:flutter/material.dart';
import 'package:beat_pads/services/_services.dart';
import 'package:provider/provider.dart';

import 'package:beat_pads/screen_beat_pads/button_lock_screen.dart';

import 'package:beat_pads/screen_beat_pads/slider_pitch_bend.dart';

class BeatPadsScreen extends StatelessWidget {
  const BeatPadsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Settings>(
      builder: (context, settings, child) {
        return Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
          floatingActionButton:
              settings.lockScreenButton ? LockScreenButton() : null,
          body: SafeArea(
            child: Row(
              children: [
                // SKIP laggy edge area. OS uses edges to detect system gestures
                // and messes with touch detection
                Expanded(
                  flex: 2,
                  child: SizedBox(),
                ),
                // CONTROL BUTTONS
                if (settings.octaveButtons || settings.sustainButton)
                  Expanded(
                    flex: 5,
                    child: ControlButtonsRect(),
                  ),
                // PITCH BEND
                if (settings.pitchBend)
                  Expanded(
                    flex: 7,
                    child:
                        PitchBender(), // TODO: restyle sizing of PB, then copy for mod wheel
                  ),
                // PADS
                Expanded(
                  flex: 60,
                  child: SlidePads(),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
