import 'package:beat_pads/screen_beat_pads/slider_themed.dart';
import 'package:beat_pads/services/services.dart';
import 'package:beat_pads/theme.dart';

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

  final double fontSizeFactor = 0.3;
  final double paddingFactor = 0.1;

  @override
  Widget build(BuildContext context) {
    int? receivedMidi = context.watch<MidiReceiver>().modWheelValue;
    if (receivedMidi != null) {
      _mod = receivedMidi;
      context.read<MidiReceiver>().modWheelValue = null;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          flex: 30,
          child: ThemedSlider(
            label: "M",
            thumbColor: Palette.cadetBlue,
            child: RotatedBox(
              quarterTurns: 0,
              child: Slider(
                min: 0,
                max: 127,
                value: _mod.toDouble(),
                onChanged: (v) {
                  setState(() => _mod = v.toInt());
                  MidiUtils.sendModWheelMessage(widget.channel, v.toInt());
                },
              ),
            ),
          ),
        ),
        Flexible(
          flex: 5,
          child: FractionallySizedBox(
            widthFactor: 0.9,
            child: LayoutBuilder(
              builder: (context, constraints) {
                double width = MediaQuery.of(context).size.width;
                double padRadius = width * ThemeConst.padRadiusFactor;
                final double padSpacing = width * ThemeConst.padSpacingFactor;
                return Container(
                  margin: EdgeInsets.symmetric(vertical: padSpacing),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Palette.cadetBlue.withAlpha(120),
                      width: width * ThemeConst.borderFactor,
                    ),
                    borderRadius:
                        BorderRadius.all(Radius.circular(padRadius * 1)),
                  ),
                  padding: EdgeInsets.all(constraints.maxWidth * paddingFactor),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            "$_mod",
                            style: TextStyle(
                              fontSize: constraints.maxWidth * fontSizeFactor,
                              // fontWeight: FontWeight.w800,
                              color: Palette.cadetBlue,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    // MidiUtils.sendModWheelMessage(widget.channel, 0);
    super.dispose();
  }
}
