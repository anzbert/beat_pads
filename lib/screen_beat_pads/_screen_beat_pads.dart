import 'package:beat_pads/screen_beat_pads/pads_and_controls.dart';
import 'package:beat_pads/screen_midi_devices/_drawer_devices.dart';
import 'package:beat_pads/theme.dart';
import 'package:flutter/material.dart';
import 'package:beat_pads/services/services.dart';

class BeatPadsScreen extends StatelessWidget {
  const BeatPadsScreen();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.delayed(
            Duration(milliseconds: ThemeConst.transitionTime), () async {
          final bool result = await DeviceUtils.landscapeOnly();
          await Future.delayed(
            Duration(milliseconds: ThemeConst.transitionTime),
          );
          return result;
        }),
        builder: ((context, AsyncSnapshot<bool?> done) {
          if (done.hasData && done.data == true) {
            return const Scaffold(
              body: SafeArea(
                child: BeatPadsAndControls(
                  preview: false,
                ),
              ),
              drawer: Drawer(
                child: MidiConfig(),
              ),
            );
          }
          return const Scaffold(body: SizedBox.expand());
        }));
  }
}
