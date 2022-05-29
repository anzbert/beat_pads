import 'package:beat_pads/services/services.dart';

import 'package:beat_pads/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SustainButtonDoubleTap extends StatefulWidget {
  const SustainButtonDoubleTap({Key? key}) : super(key: key);

  @override
  State<SustainButtonDoubleTap> createState() => _SustainButtonDoubleTapState();
}

class _SustainButtonDoubleTapState extends State<SustainButtonDoubleTap> {
  bool sustainState = false;

  @override
  void dispose() {
    int channel = Provider.of<Settings>(context, listen: false).channel;
    if (sustainState == true) {
      MidiUtils.sendSustainMessage(channel, false);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int channel = Provider.of<Settings>(context, listen: true).channel;

    double width = MediaQuery.of(context).size.width;
    double padRadius = width * ThemeConst.padRadiusFactor;
    double padSpacing = width * ThemeConst.padSpacingFactor;
    return Padding(
      padding: EdgeInsets.fromLTRB(0, padSpacing, padSpacing, padSpacing),
      child: GestureDetector(
        onDoubleTap: () => setState(() {
          sustainState = !sustainState;
          MidiUtils.sendSustainMessage(channel, sustainState);
        }),
        onTapDown: (_) {
          if (!sustainState) {
            setState(() {
              sustainState = true;
              MidiUtils.sendSustainMessage(channel, sustainState);
            });
          }
        },
        onTapUp: (_) {
          if (sustainState) {
            setState(() {
              sustainState = false;
              MidiUtils.sendSustainMessage(channel, sustainState);
            });
          }
        },
        // onTapCancel: () {
        //   if (sustainState) {
        //     setState(() {
        //       sustainState = false;
        //       MidiUtils.sendSustainMessage(channel, sustainState);
        //     });
        //   }
        // },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(padRadius * 1)),
            color: sustainState
                ? Palette.lightPink
                : Palette.lightPink.withAlpha(120),
          ),
          child: RotatedBox(
            quarterTurns: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                'Sustain',
                style: TextStyle(
                  fontSize: 100,
                  fontWeight: FontWeight.w500,
                  color: Palette.darkGrey,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
