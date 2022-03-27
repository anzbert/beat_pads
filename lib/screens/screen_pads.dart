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

    // PORTRAIT: SHOW PADS SETTINGS MENU
    if (inPortrait) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Pad Settings"),
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(child: PadsMenu()),
      );
    }

    // LANDSCAPE: PLAY PADS
    else {
      return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        floatingActionButton:
            Provider.of<Settings>(context, listen: true).lockScreenButton
                ? LockScreenButton()
                : null,
        body: SafeArea(
            child: Row(
          children: [
            if (Provider.of<Settings>(context, listen: true).pitchBend)
              SizedBox(
                width: 50,
              ),
            if (Provider.of<Settings>(context, listen: true).pitchBend)
              RotatedBox(
                quarterTurns: 1,
                child: PitchBender(),
              ),
            Expanded(
              flex: 1,
              child: VariablePads(),
            )
          ],
        )),
      );
    }
  }
}
