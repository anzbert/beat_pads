import 'package:beat_pads/main.dart';
import 'package:beat_pads/screen_beat_pads/buttons_controls.dart';
import 'package:beat_pads/screen_beat_pads/buttons_menu.dart';
import 'package:beat_pads/screen_beat_pads/slide_pads.dart';
import 'package:beat_pads/screen_beat_pads/slider_mod_wheel.dart';
import 'package:beat_pads/screen_beat_pads/slider_pitch.dart';
import 'package:beat_pads/screen_beat_pads/slider_velocity.dart';
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
    preview: ref.watch(previewState),
  );
});
final previewState = StateProvider<bool>((ref) => false);
// //////////////////////

class BeatPadsScreen extends ConsumerStatefulWidget {
  const BeatPadsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<BeatPadsScreen> createState() => _BeatPadsScreenState();
}

class _BeatPadsScreenState extends ConsumerState<BeatPadsScreen> {
  @override
  void initState() {
    ref.read(previewState.notifier).state = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool preview = ref.watch(previewState);
    return FutureBuilder(
        future: preview ? Utils.doNothingAsync() : DeviceUtils.landscapeOnly(),
        builder: ((context, AsyncSnapshot<bool?> done) {
          if (done.hasData && done.data == true) {
            return Scaffold(
              body: SafeArea(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // SKIP laggy edge area. OS uses edges to detect system gestures
                        // and messes with touch detection
                        const Expanded(
                          flex: 1,
                          child: SizedBox(),
                        ),
                        // CONTROL BUTTONS
                        if (ref.watch(settingsProvider.select(
                                (settings) => settings.octaveButtons)) ||
                            ref.watch(settingsProvider
                                .select((settings) => settings.sustainButton)))
                          const Expanded(
                            flex: 5,
                            child: ControlButtonsRect(),
                          ),
                        // PITCH BEND
                        if (ref.watch(settingsProvider
                            .select((settings) => settings.pitchBend)))
                          Expanded(
                            flex: 7,
                            child: PitchSliderEased(
                              channel: ref.watch(settingsProvider).channel,
                              resetTime: ref
                                  .watch(settingsProvider)
                                  .pitchBendEaseUsable,
                            ),
                          ),
                        // MOD WHEEL
                        if (ref.watch(settingsProvider
                            .select((settings) => settings.modWheel)))
                          Expanded(
                            flex: 7,
                            child: ModWheel(
                              preview: preview,
                              channel: ref.watch(settingsProvider
                                  .select((settings) => settings.channel)),
                            ),
                          ),
                        // VELOCITY
                        if (ref.watch(settingsProvider
                            .select((settings) => settings.velocitySlider)))
                          Expanded(
                            flex: 7,
                            child: SliderVelocity(
                              channel: ref.watch(settingsProvider
                                  .select((settings) => settings.channel)),
                              randomVelocity: ref.watch(settingsProvider.select(
                                  (settings) => settings.randomVelocity)),
                            ),
                          ),
                        // PADS
                        Expanded(
                          flex: 60,
                          child: SlidePads(
                            preview: preview,
                          ),
                        ),
                        const Expanded(
                          flex: 1,
                          child: SizedBox(),
                        ),
                      ],
                    ),
                    if (!preview)
                      if (!ref.watch(settingsProvider
                              .select((settings) => settings.sustainButton)) &&
                          !ref.watch(settingsProvider
                              .select((settings) => settings.octaveButtons)))
                        Builder(builder: (context) {
                          double width = MediaQuery.of(context).size.width;
                          return Positioned.directional(
                            top: width * 0.006,
                            start: width * 0.006,
                            textDirection: TextDirection.ltr,
                            child: SizedBox.square(
                              dimension: width * 0.06,
                              child: const ReturnToMenuButton(
                                transparent: true,
                              ),
                            ),
                          );
                        }),
                    if (ref.watch(settingsProvider.select(
                            (settings) => settings.connectedDevices.isEmpty)) &&
                        !preview)
                      Positioned(
                        bottom: 15,
                        right: 15,
                        child: ElevatedButton(
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Palette.lightPink,
                              textStyle:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          child: const Text(
                            "Select Midi Device",
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              drawer: const Drawer(
                child: MidiConfig(),
              ),
            );
          }
          return const SizedBox.expand();
        }));
  }
}
