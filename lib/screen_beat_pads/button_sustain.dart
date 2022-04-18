import 'package:beat_pads/screen_home/model_settings.dart';
import 'package:beat_pads/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command_messages.dart';
import 'package:provider/provider.dart';

class SustainButton extends StatefulWidget {
  const SustainButton({Key? key}) : super(key: key);

  @override
  State<SustainButton> createState() => _SustainButtonState();
}

class _SustainButtonState extends State<SustainButton> {
  int? disposeChannel;

  @override
  void dispose() {
    if (disposeChannel != null) {
      CCMessage(
        channel: disposeChannel!,
        controller: 64,
        value: 0,
      ).send();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int channel = Provider.of<Settings>(context, listen: true).channel;
    disposeChannel = channel;

    return Listener(
      onPointerDown: (_) {
        CCMessage(
          channel: channel,
          controller: 64,
          value: 127,
        ).send();
      },
      onPointerUp: (_) {
        CCMessage(
          channel: channel,
          controller: 64,
          value: 0,
        ).send();
      },
      child: ElevatedButton(
        onPressed: () {},
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
      ),
    );
  }
}
