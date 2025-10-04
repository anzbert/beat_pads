import 'package:beat_pads/screen_beat_pads/beat_pad_grid.dart';
import 'package:beat_pads/screen_beat_pads/button_presets.dart';
import 'package:beat_pads/screen_beat_pads/buttons_oct_and_sustain.dart';
import 'package:beat_pads/screen_beat_pads/slider_mod_wheel.dart';
import 'package:beat_pads/screen_beat_pads/slider_pitch.dart';
import 'package:beat_pads/screen_beat_pads/slider_velocity.dart';
import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BeatPadsAndControls extends ConsumerWidget {
  const BeatPadsAndControls({required this.preview});
  final bool preview;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(baseOctaveProv, (int? prev, int now) {
      if (prev != null && prev != now && !preview) {
        ref.read(senderProvider.notifier).markEventsDirty();
      }
    });
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: SizedBox(child: ColoredBox(color: Colors.black)),
            ),
            // CONTROL BUTTONS
            if (ref.watch(octaveButtonsProv) || ref.watch(sustainButtonProv))
              const Expanded(
                flex: 5,
                child: RepaintBoundary(child: ControlButtonsRect()),
              ),
            // PITCH BEND
            if (ref.watch(pitchBendProv))
              Expanded(
                flex: 7,
                child: RepaintBoundary(
                  child: PitchSliderEased(
                    channel: ref.watch(channelUsableProv),
                    resetTime: ref.watch(pitchBendEaseUsable),
                  ),
                ),
              ),
            // MOD WHEEL
            if (ref.watch(modWheelProv))
              Expanded(
                flex: 7,
                child: RepaintBoundary(
                  child: ModWheel(
                    preview: preview,
                    channel: ref.watch(channelUsableProv),
                  ),
                ),
              ),
            // VELOCITY
            if (ref.watch(velocitySliderProv))
              Expanded(
                flex: 7,
                child: RepaintBoundary(
                  child: SliderVelocity(
                    channel: ref.watch(channelUsableProv),
                    randomVelocity:
                        ref.watch(velocityModeProv) != VelocityMode.fixed,
                  ),
                ),
              ),
            // PADS
            Expanded(
              flex: 60,
              child: RepaintBoundary(child: SlidePads(preview: preview)),
            ),
            // PRESETS
            if (ref.watch(presetButtonsProv))
              const Expanded(
                flex: 5,
                child: RepaintBoundary(
                  child: PresetButtons(clickType: ClickType.double),
                ),
              ),
            const Expanded(
              child: SizedBox(child: ColoredBox(color: Colors.black)),
            ),
          ],
        ),
        // if (!preview)
        //   if (!ref.watch(sustainButtonProv) && !ref.watch(octaveButtonsProv))
        //     Builder(
        //       builder: (context) {
        //         final double width = MediaQuery.of(context).size.width;
        //         return Positioned.directional(
        //           bottom: width * 0.006,
        //           start: width * 0.006,
        //           textDirection: TextDirection.ltr,
        //           child: SizedBox.square(
        //             dimension: width * 0.06,
        //             child: const RepaintBoundary(
        //               child: ReturnToMenuButton(transparent: true),
        //             ),
        //           ),
        //         );
        //       },
        //     ),
        if (ref.watch(connectedDevicesProv).isEmpty && !preview)
          Positioned(
            bottom: 15,
            right: 15,
            child: RepaintBoundary(
              child: ElevatedButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.lightPink,
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(color: Palette.darkGrey, Icons.cable),
                    Text('Select Midi Device'),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
