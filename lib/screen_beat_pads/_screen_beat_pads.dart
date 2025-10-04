import 'package:beat_pads/screen_beat_pads/button_menu.dart';
import 'package:beat_pads/screen_beat_pads/pads_and_controls.dart';
import 'package:beat_pads/screen_midi_devices/_drawer_devices.dart';
import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BeatPadsScreen extends ConsumerWidget {
  BeatPadsScreen() {
    DeviceUtils.landscapeOnly();
  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        SafeArea(
          top: false,
          bottom: false,
          child: Scaffold(
            body: BeatPadsAndControls(preview: false),
            drawer: Drawer(child: MidiConfig()),
          ),
        ),

        if (!ref.watch(sustainButtonProv) && !ref.watch(octaveButtonsProv))
          Builder(
            builder: (context) {
              final double width = MediaQuery.of(context).size.width;
              return Positioned.directional(
                bottom: width * 0.006,
                start: width * 0.006,
                textDirection: TextDirection.ltr,
                child: SizedBox.square(
                  dimension: width * 0.06,
                  child: const RepaintBoundary(
                    child: ReturnToMenuButton(transparent: true),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
