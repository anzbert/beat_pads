import 'package:beat_pads/screen_beat_pads/button_sustain.dart';
import 'package:beat_pads/screen_beat_pads/button_menu.dart';
import 'package:beat_pads/screen_beat_pads/button_octave.dart';
import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ControlButtonsRect extends ConsumerWidget {
  const ControlButtonsRect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const ReturnToMenuButton(
          transparent: false,
        ),
        if (ref.watch(octaveButtonsProv))
          const Expanded(
            flex: 1,
            child: OctaveButtons(),
          ),
        if (ref.watch(sustainButtonProv))
          Expanded(
            flex: 1,
            child:
                SustainButtonDoubleTap(channel: ref.watch(channelUsableProv)),
          ),
      ],
    );
  }
}
