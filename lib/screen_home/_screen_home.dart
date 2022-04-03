import 'package:beat_pads/screen_beat_pads/_screen_beat_pads.dart';
import 'package:beat_pads/screen_pads_menu/_screen_pads_menu.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:beat_pads/screen_home/model_midi.dart';
import 'package:beat_pads/screen_home/model_settings.dart';
export './model_midi.dart';
export './model_settings.dart';

class PadsScreen extends StatelessWidget {
  const PadsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool inPortrait = MediaQuery.of(context).orientation.name == "portrait";

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Settings()),
        ChangeNotifierProvider(create: (context) => MidiData()),
      ],
      child: inPortrait
          ? PadMenuScreen() // PORTRAIT: SHOW PADS SETTINGS MENU
          : BeatPads(), // LANDSCAPE: PLAY PADS
    );
  }
}
