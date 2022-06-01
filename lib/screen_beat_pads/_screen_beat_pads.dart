import 'package:beat_pads/screen_beat_pads/buttons_controls.dart';
import 'package:beat_pads/screen_beat_pads/buttons_menu.dart';
import 'package:beat_pads/screen_beat_pads/slide_pads.dart';
import 'package:beat_pads/screen_beat_pads/slider_mod_wheel.dart';
import 'package:beat_pads/screen_beat_pads/slider_pitch.dart';
import 'package:beat_pads/screen_beat_pads/slider_velocity.dart';
import 'package:beat_pads/screen_midi_devices/_drawer_devices.dart';

import 'package:flutter/material.dart';
import 'package:beat_pads/services/services.dart';
// import 'package:provider/provider.dart';

Future<bool> _doNothing() async => true;

class BeatPadsScreen extends StatelessWidget {
  const BeatPadsScreen({Key? key, this.preview = false}) : super(key: key);

  final bool preview;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: preview ? _doNothing() : DeviceUtils.landscapeOnly(),
        builder: ((context, AsyncSnapshot<bool?> done) {
          if (done.hasData && done.data == true) {
            Size screenSize = MediaQuery.of(context).size;
            return Scaffold(
              body: SafeArea(
                child: MultiProvider(
                    providers: [
                      // proxyproviders, to update all other models, when Settings change:
                      if (!preview)
                        ChangeNotifierProxyProvider<Settings, MidiReceiver>(
                          create: (context) =>
                              MidiReceiver(context.read<Settings>()),
                          update: (_, settings, midiReceiver) =>
                              midiReceiver!.update(settings),
                        ),
                      ChangeNotifierProxyProvider<Settings, MidiSender>(
                        create: (context) => MidiSender(
                            context.read<Settings>(), screenSize,
                            preview: preview),
                        update: (_, settings, midiSender) =>
                            midiSender!.update(settings, screenSize),
                      ),
                    ],
                    builder: (context, _) {
                      return Stack(
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
                              if (context.select((Settings settings) =>
                                      settings.octaveButtons) ||
                                  context.select((Settings settings) =>
                                      settings.sustainButton))
                                const Expanded(
                                  flex: 5,
                                  child: ControlButtonsRect(),
                                ),
                              // PITCH BEND
                              if (context.select(
                                  (Settings settings) => settings.pitchBend))
                                Expanded(
                                  flex: 7,
                                  child: PitchSliderEased(
                                    channel: context.select(
                                        (Settings settings) =>
                                            settings.channel),
                                    resetTime: context.select(
                                        (Settings settings) =>
                                            settings.pitchBendEaseUsable),
                                  ),
                                ),
                              // MOD WHEEL
                              if (context.select(
                                  (Settings settings) => settings.modWheel))
                                Expanded(
                                  flex: 7,
                                  child: ModWheel(
                                    preview: preview,
                                    channel: context.select(
                                        (Settings settings) =>
                                            settings.channel),
                                  ),
                                ),
                              // VELOCITY
                              if (context.select((Settings settings) =>
                                  settings.velocitySlider))
                                Expanded(
                                  flex: 7,
                                  child: SliderVelocity(
                                    channel: context.select(
                                        (Settings settings) =>
                                            settings.channel),
                                    randomVelocity: context.select(
                                        (Settings settings) =>
                                            settings.randomVelocity),
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
                            if (!context.select((Settings settings) =>
                                    settings.sustainButton) &&
                                !context.select((Settings settings) =>
                                    settings.octaveButtons))
                              Builder(builder: (context) {
                                double width =
                                    MediaQuery.of(context).size.width;
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
                          if (context.select((Settings settings) =>
                                  settings.connectedDevices.isEmpty) &&
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
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                child: const Text(
                                  "Select Midi Device",
                                ),
                              ),
                            ),
                        ],
                      );
                    }),
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
