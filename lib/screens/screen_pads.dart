import 'package:beat_pads/components/buttons_octave.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:beat_pads/state/settings.dart';

import 'package:beat_pads/components/button_lock_screen.dart';
import 'package:beat_pads/components/slider_pitch_bend.dart';
import 'package:beat_pads/components/pads_pads_grid.dart';
import 'package:beat_pads/components/pads_menu.dart';

class PadsScreen extends StatelessWidget {
  const PadsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool inPortrait = MediaQuery.of(context).orientation.name == "portrait";

    return inPortrait
        ?

        // PORTRAIT: SHOW PADS SETTINGS MENU
        Scaffold(
            appBar: AppBar(
              title: Text("Pad Settings"),
              leading: BackButton(
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: SafeArea(child: PadsMenu()),
          )
        :

        // LANDSCAPE: PLAY PADS
        Scaffold(
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
                    if (Provider.of<Settings>(context, listen: true)
                        .octaveButtons)
                      SizedBox(width: 10),
                    if (Provider.of<Settings>(context, listen: true)
                        .octaveButtons)
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
