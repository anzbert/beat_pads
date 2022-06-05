import 'package:beat_pads/main.dart';
import 'package:beat_pads/screen_beat_pads/pads_and_controls.dart';

import 'package:beat_pads/screen_midi_devices/_drawer_devices.dart';
import 'package:beat_pads/theme.dart';
import 'package:flutter/material.dart';
import 'package:beat_pads/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// PROVIDERS ///////////
final senderProvider = ChangeNotifierProvider.autoDispose<MidiSender>((ref) {
  return MidiSender(
    ref.read(settingsProvider.notifier),
  );
});
// //////////////////////

class BeatPadsScreen extends ConsumerStatefulWidget {
  const BeatPadsScreen();

  @override
  ConsumerState<BeatPadsScreen> createState() => _BeatPadsScreenState();
}

class _BeatPadsScreenState extends ConsumerState<BeatPadsScreen> {
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

  @override
  void dispose() {
    // print("disposing beat screen");

    super.dispose();
  }
}
