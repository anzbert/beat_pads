import 'package:beat_pads/screen_beat_pads/buttons_controls.dart';
import 'package:beat_pads/screen_beat_pads/buttons_menu.dart';
import 'package:beat_pads/screen_beat_pads/slide_pads.dart';
import 'package:beat_pads/screen_beat_pads/slider_mod_wheel.dart';
import 'package:beat_pads/screen_beat_pads/slider_pitch_eased.dart';

import 'package:flutter/material.dart';
import 'package:beat_pads/services/_services.dart';
import 'package:provider/provider.dart';

class BeatPadsScreen extends StatelessWidget {
  const BeatPadsScreen({Key? key, this.preview = false}) : super(key: key);

  final bool preview;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          preview ? DeviceUtils.enableRotation() : DeviceUtils.landscapeOnly(),
      builder: ((context, AsyncSnapshot<bool?> done) {
        if (done.hasData && done.data == true) {
          return Scaffold(
            body: SafeArea(
              child: Consumer<Settings>(builder: (context, settings, _) {
                return Stack(
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
                        if (settings.octaveButtons || settings.sustainButton)
                          const Expanded(
                            flex: 5,
                            child: ControlButtonsRect(),
                          ),
                        // PITCH BEND
                        if (settings.pitchBend)
                          Expanded(
                            flex: 7,
                            child: PitchSliderEased(
                              channel: settings.channel,
                              resetTime: settings.pitchBendEaseCalculated,
                            ),
                          ),
                        // MOD WHEEL
                        if (settings.modWheel)
                          Expanded(
                            flex: 7,
                            child: ModWheel(
                              channel: settings.channel,
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
                    Builder(builder: (context) {
                      double width = MediaQuery.of(context).size.width;
                      return Positioned.directional(
                        top: width * 0.006,
                        end: width * 0.006,
                        textDirection: TextDirection.ltr,
                        child: SizedBox.square(
                          dimension: width * 0.06,
                          child: const ReturnToMenuButton(),
                        ),
                      );
                    }),
                  ],
                );
              }),
            ),
          );
        }
        return const SizedBox(
          child: Text("rotation error"),
        );
      }),
    );
  }
}
