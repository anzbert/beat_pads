import 'package:beat_pads/screen_beat_pads/slider_themed.dart';
import 'package:beat_pads/services/services.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ModWheel extends StatefulWidget {
  const ModWheel({Key? key, required this.channel}) : super(key: key);

  final int channel;

  @override
  State<ModWheel> createState() => _ModWheelState();
}

class _ModWheelState extends State<ModWheel> {
  int _mod = 63;

  @override
  Widget build(BuildContext context) {
    int? receivedMidi = context.watch<MidiReceiver>().modWheelValue;
    if (receivedMidi != null) {
      _mod = receivedMidi;
      context.read<MidiReceiver>().modWheelValue = null;
    }

    return RotatedBox(
      quarterTurns: 1,
      child: ThemedSlider(
        midiVal: true,
        thumbColor: Palette.cadetBlue,
        child: Slider(
          min: 0,
          max: 127,
          value: _mod.toDouble(),
          onChanged: (v) {
            setState(() => _mod = v.toInt());
            MidiUtils.sendModWheelMessage(widget.channel, 127 - v.toInt());
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    // MidiUtils.sendModWheelMessage(widget.channel, 0);
    super.dispose();
  }
}
