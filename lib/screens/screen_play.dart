import 'package:beat_pads/components/slider_pitch_bend.dart';
import 'package:beat_pads/components/pads_pads.dart';
import 'package:beat_pads/components/pads_menu.dart';
import 'package:beat_pads/state/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool inPortrait = MediaQuery.of(context).orientation.name == "portrait";

    // PORTRAIT: SHOW PADS SETTINGS MENU
    if (inPortrait) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Pad Settings"),
        ),
        body: SafeArea(child: PadsMenu()),
      );
    }
    // LANDSCAPE: PLAY PADS
    else {
      return Scaffold(
        body: SafeArea(
          child: Provider.of<Settings>(context, listen: true).pitchBend
              ? Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: RotatedBox(quarterTurns: 1, child: PitchBender()),
                    ),
                    Expanded(
                      flex: 4,
                      child: VariablePads(),
                    )
                  ],
                )
              : VariablePads(),
        ),
      );
    }
  }
}
