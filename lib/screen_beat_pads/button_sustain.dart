import 'dart:ui';

import 'package:beat_pads/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command_messages.dart';

class SustainButton extends StatelessWidget {
  const SustainButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        CCMessage().send();
      },
      child: Text(
        'S',
        style: TextStyle(fontSize: 30),
      ),
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        padding: EdgeInsets.all(20),
        primary: Palette.yellowGreen.color,
        onPrimary: Palette.darkGrey.color,
      ),
    );
  }
}
