import 'package:beat_pads/screen_beat_pads/button_sustain.dart';
import 'package:beat_pads/screen_beat_pads/buttons_octave.dart';
import 'package:beat_pads/services/_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ControlButtons extends StatelessWidget {
  const ControlButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.01),
      width: size.width * 0.08,
      child: FittedBox(
        child: Consumer<Settings>(
          builder: (context, settings, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (settings.octaveButtons) OctaveButtons(),
                if (settings.octaveButtons && settings.sustainButton)
                  SizedBox(height: 80),
                if (settings.sustainButton) SustainButton(),
              ],
            );
          },
        ),
      ),
    );
  }
}
