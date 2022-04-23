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
                // CONTROL BUTTONS
                if (settings.octaveButtons || settings.sustainButton)
                  SizedBox(
                    width: 25, // SKIP laggy edge area
                  ),
                if (settings.octaveButtons || settings.sustainButton)
                  Expanded(
                    flex: 2,
                    child: ControlButtonsRect(), // TODO: replaced for testing
                  ),

                // PITCH BEND
                if (settings.pitchBend) PitchBender(), // TODO: restyle this

                // PADS
                Expanded(
                  flex: 30,
                  child: SlidePads(), // TODO: replaced for testing
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
