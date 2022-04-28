import 'package:beat_pads/screen_beat_pads/slider_themed.dart';
import 'package:beat_pads/services/_services.dart';
import 'package:beat_pads/shared/colors.dart';
import 'package:flutter/material.dart';

class ModWheel extends StatefulWidget {
  const ModWheel({Key? key, required this.channel}) : super(key: key);

  final int channel;

  @override
  State<ModWheel> createState() => _ModWheelState();
}

class _ModWheelState extends State<ModWheel> {
  int _mod = 0;

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 1,
      child: ThemedSlider(
        midiVal: true,
        thumbColor: Palette.cadetBlue.color,
        child: Slider(
          min: 0,
          max: 127,
          value: _mod.toDouble(),
          onChanged: (v) {
            setState(() => _mod = v.toInt());
            MidiUtils.modWheelMessage(widget.channel, v.toInt());
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    // MidiUtils.modWheelMessage(widget.channel, 0);
    super.dispose();
  }
}
