import 'package:beat_pads/screens/var_pads.dart';
import 'package:beat_pads/screens/pads_menu.dart';
import 'package:beat_pads/state/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import '../state/receiver.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool inPortrait = MediaQuery.of(context).orientation.name == "portrait";

    // PORTRAIT
    if (inPortrait) {
      return Scaffold(
        appBar: AppBar(),
        body: PadsMenu(),
      );
    }
    // LANDSCAPE
    else {
      return Scaffold(body: Consumer<Settings>(
        builder: (context, settings, child) {
          return VariablePads(
              // velocity: settings.velocity,
              // baseNote: settings.baseNote,
              // showNoteNames: settings.noteNames,
              // channel: Provider.of<MidiReceiver>(context, listen: true).channel,
              // scale: settings.scale,
              // width:settings.width,
              // height:settings.height,
              );
        },
      ));
    }
  }
}
