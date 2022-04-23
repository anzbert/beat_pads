import 'package:beat_pads/services/_services.dart';
import 'package:beat_pads/shared/colors.dart';
import 'package:flutter/material.dart';
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
      MidiUtils.sustainMessage(disposeChannel!, false);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int channel = Provider.of<Settings>(context, listen: true).channel;
    disposeChannel = channel;

    return Listener(
      onPointerDown: (_) {
        MidiUtils.sustainMessage(channel, true);
      },
      onPointerUp: (_) {
        MidiUtils.sustainMessage(channel, false);
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
