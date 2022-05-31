import 'package:beat_pads/screen_beat_pads/button_sustain_doubletap.dart';
import 'package:beat_pads/screen_beat_pads/buttons_menu.dart';

import 'package:beat_pads/screen_beat_pads/buttons_octave.dart';
import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ControlButtonsRect extends StatelessWidget {
  const ControlButtonsRect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Settings>(
      builder: (context, settings, child) {
        return Column(
          children: [
            const ReturnToMenuButton(),
            if (settings.octaveButtons)
              const Expanded(
                flex: 1,
                child: OctaveButtons(),
              ),
            if (settings.sustainButton)
              Expanded(
                flex: 1,
                child: SustainButtonDoubleTap(channel: settings.channel),
              ),
          ],
        );
      },
    );
  }
}
