import 'package:beat_pads/main.dart';
import 'package:beat_pads/screen_beat_pads/pads_and_controls.dart';

import 'package:beat_pads/screen_midi_devices/_drawer_devices.dart';
import 'package:flutter/material.dart';
import 'package:beat_pads/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// PROVIDERS ///////////
final receiverProvider =
    ChangeNotifierProvider.autoDispose<MidiReceiver>((ref) {
  return MidiReceiver(ref.watch(settingsProvider));
});
final senderProvider = ChangeNotifierProvider.autoDispose<MidiSender>((ref) {
  return MidiSender(
    ref.watch(settingsProvider),
    ref.watch(screenSizeState),
  );
});
// //////////////////////

class BeatPadsScreen extends ConsumerStatefulWidget {
  final bool preview;
  const BeatPadsScreen({required this.preview});

  @override
  ConsumerState<BeatPadsScreen> createState() => _BeatPadsScreenState();
}

class _BeatPadsScreenState extends ConsumerState<BeatPadsScreen> {
  PlayMode? disposePlayMode;
  bool? disposeUpperZone;

  @override
  void initState() {
    super.initState();
    disposePlayMode = ref.read(settingsProvider.notifier).playMode;
    disposeUpperZone = ref.read(settingsProvider.notifier).upperZone;

    if (disposePlayMode == PlayMode.mpe && !widget.preview) {
      MPEinitMessage(
              memberChannels:
                  ref.read(settingsProvider.notifier).mpeMemberChannels,
              upperZone: disposeUpperZone)
          .send();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.preview
            ? Utils.doNothingAsync()
            : DeviceUtils.landscapeOnly(),
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
    if (disposePlayMode == PlayMode.mpe && !widget.preview) {
      MPEinitMessage(memberChannels: 0, upperZone: disposeUpperZone).send();
    }
    super.dispose();
  }
}
