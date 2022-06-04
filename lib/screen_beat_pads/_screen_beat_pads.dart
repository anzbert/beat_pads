import 'package:beat_pads/main.dart';
import 'package:beat_pads/screen_beat_pads/pads_and_controls.dart';

import 'package:beat_pads/screen_midi_devices/_drawer_devices.dart';
import 'package:flutter/material.dart';
import 'package:beat_pads/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// PROVIDERS ///////////
// final receiverProvider =
//     ChangeNotifierProvider.autoDispose<MidiReceiver>((ref) {
//   return MidiReceiver(ref.watch(settingsProvider));
// });
final senderProvider = ChangeNotifierProvider.autoDispose<MidiSender>((ref) {
  return MidiSender(
    ref.watch(settingsProvider),
  );
});
// //////////////////////

class BeatPadsScreen extends ConsumerStatefulWidget {
  const BeatPadsScreen();

  @override
  ConsumerState<BeatPadsScreen> createState() => _BeatPadsScreenState();
}

class _BeatPadsScreenState extends ConsumerState<BeatPadsScreen> {
  PlayMode? disposePlayMode;
  bool? disposeUpperZone;

  @override
  void initState() {
    super.initState();

    if (ref.read(settingsProvider.notifier).playMode == PlayMode.mpe) {
      MPEinitMessage(
              memberChannels:
                  ref.read(settingsProvider.notifier).mpeMemberChannels,
              upperZone: ref.read(settingsProvider.notifier).upperZone)
          .send();
    }
  }

  @override
  Widget build(BuildContext context) {
    disposePlayMode =
        ref.watch(settingsProvider.select((value) => value.playMode));
    disposeUpperZone =
        ref.watch(settingsProvider.select((value) => value.upperZone));

    return FutureBuilder(
        future: DeviceUtils.landscapeOnly(),
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
          return const SizedBox.expand();
        }));
  }

  @override
  void dispose() {
    if (disposePlayMode == PlayMode.mpe) {
      MPEinitMessage(memberChannels: 0, upperZone: disposeUpperZone).send();
    }
    super.dispose();
  }
}
