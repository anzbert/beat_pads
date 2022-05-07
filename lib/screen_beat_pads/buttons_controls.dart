import 'package:beat_pads/screen_beat_pads/button_sustain.dart';
import 'package:beat_pads/screen_beat_pads/buttons_menu.dart';
import 'package:beat_pads/screen_beat_pads/buttons_octave.dart';
import 'package:beat_pads/services/_services.dart';
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
            Expanded(
              flex: 2,
              child: ReturnToMenuButton(),
            ),
            Expanded(
              flex: 6,
              child: settings.octaveButtons ? OctaveButtons() : SizedBox(),
            ),
            Expanded(
              flex: 6,
              child: settings.sustainButton ? SustainButtonRect() : SizedBox(),
            ),
          ],
        );
      },
    );
  }
}
